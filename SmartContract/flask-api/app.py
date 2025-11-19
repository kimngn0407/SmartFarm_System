import os, json, time
from flask import Flask, request, jsonify
from sqlalchemy import create_engine, text
from eth_utils import keccak, to_bytes
import requests
from dotenv import load_dotenv

load_dotenv()
DB_URL = os.getenv("DB_URL")
API_KEY = os.getenv("API_KEY", "MY_API_KEY")
ORACLE_URL = os.getenv("ORACLE_URL", "http://localhost:5001/oracle/push")

TEMP_SENSOR_ID  = int(os.getenv("TEMP_SENSOR_ID", 7))
HUMID_SENSOR_ID = int(os.getenv("HUMID_SENSOR_ID", 8))
SOIL_SENSOR_ID  = int(os.getenv("SOIL_SENSOR_ID", 9))
LIGHT_SENSOR_ID = int(os.getenv("LIGHT_SENSOR_ID", 10))

ENGINE = create_engine(DB_URL, future=True)
app = Flask(__name__)

def canonical(obj: dict) -> str:
    # Chuẩn hóa JSON để tính hash (bỏ qua các field debug như light_raw, soil_raw, error)
    # Ưu tiên 'light_pct', fallback 'light'
    payload = {
        "sensorId": int(obj.get("sensorId", 0)),
        "time": int(obj.get("time", int(time.time()))),
        "temperature": obj.get("temperature", None),
        "humidity": obj.get("humidity", None),
        "soil_pct": obj.get("soil_pct", None),
        "light": obj.get("light_pct", obj.get("light", None))  # Ưu tiên light_pct
    }
    return json.dumps(payload, separators=(",", ":"), ensure_ascii=False)

def keccak_hex(s: str) -> str:
    return "0x" + keccak(to_bytes(text=s)).hex()

@app.post("/api/sensors")
def ingest():
    if request.headers.get("x-api-key") != API_KEY:
        return jsonify(error="unauthorized"), 401

    b = request.get_json(force=True)
    
    # Debug: Log received data
    print(f"📥 Received JSON keys: {list(b.keys())}")
    print(f"   - soil_pct: {b.get('soil_pct', 'MISSING')}")
    print(f"   - light_pct: {b.get('light_pct', 'MISSING')}")
    print(f"   - light: {b.get('light', 'MISSING')}")
    
    raw_time = int(b.get("time", time.time()))
    
    # Xử lý time: Nếu time < 1000000000 (trước năm 2001), 
    # có thể là số giây từ khi khởi động Arduino -> chuyển thành Unix timestamp
    if raw_time < 1000000000:
        # Giả sử là số giây từ khi khởi động, dùng thời gian hiện tại
        epoch = int(time.time())
    else:
        # Đã là Unix timestamp
        epoch = raw_time
    
    # Kiểm tra có lỗi đọc DHT11 không
    has_error = b.get("error") is not None
    
    t = b.get("temperature")
    h = b.get("humidity")
    s = b.get("soil_pct")
    # Ưu tiên light_pct (format mới), fallback light (format cũ)
    l = b.get("light_pct", b.get("light"))
    
    # Nếu soil_pct là None (không có), nhưng có soil_raw, tính từ soil_raw
    # Logic: soil_raw cao (1023) = đất khô = soil_pct thấp (0%)
    #        soil_raw thấp (0) = đất ướt = soil_pct cao (100%)
    # LƯU Ý: Không tính lại nếu soil_pct = 0 (vì 0 là giá trị hợp lệ khi đất khô)
    soil_raw = b.get("soil_raw")
    if s is None and soil_raw is not None:
        # Tính soil_pct từ soil_raw: đảo ngược (1023 → 0%, 0 → 100%)
        soil_raw_val = int(soil_raw)
        if 0 <= soil_raw_val <= 1023:
            s = 100 - (soil_raw_val * 100 / 1023)
            print(f"🔄 Calculated soil_pct from soil_raw: {soil_raw_val} → {s:.1f}%")
    
    # Debug: Log extracted values
    print(f"📊 Extracted values:")
    print(f"   - temperature: {t}")
    print(f"   - humidity: {h}")
    print(f"   - soil_pct: {s} (from soil_pct={b.get('soil_pct')}, soil_raw={b.get('soil_raw')})")
    print(f"   - light_pct/light: {l}")

    with ENGINE.begin() as cn:
        # Chỉ lưu temperature/humidity nếu không có lỗi
        if not has_error:
            if t is not None:
                cn.execute(text("""INSERT INTO public.sensor_data (sensor_id,value,"time")
                                   VALUES (:sid,:val,to_timestamp(:ts))"""),
                           {"sid": TEMP_SENSOR_ID, "val": float(t), "ts": epoch})
            if h is not None:
                cn.execute(text("""INSERT INTO public.sensor_data (sensor_id,value,"time")
                                   VALUES (:sid,:val,to_timestamp(:ts))"""),
                           {"sid": HUMID_SENSOR_ID, "val": float(h), "ts": epoch})
        
        # Luôn lưu soil và light (không phụ thuộc DHT11)
        if s is not None:
            print(f"💾 INSERTING soil_pct={s} → sensor_id={SOIL_SENSOR_ID}")
            cn.execute(text("""INSERT INTO public.sensor_data (sensor_id,value,"time")
                               VALUES (:sid,:val,to_timestamp(:ts))"""),
                       {"sid": SOIL_SENSOR_ID, "val": float(s), "ts": epoch})
        else:
            print(f"⚠️  soil_pct is None, skipping INSERT")
        if l is not None:
            print(f"💾 INSERTING light_pct={l} → sensor_id={LIGHT_SENSOR_ID}")
            cn.execute(text("""INSERT INTO public.sensor_data (sensor_id,value,"time")
                               VALUES (:sid,:val,to_timestamp(:ts))"""),
                       {"sid": LIGHT_SENSOR_ID, "val": float(l), "ts": epoch})
        else:
            print(f"⚠️  light_pct/light is None, skipping INSERT")

    # tính hash & đẩy oracle
    c = canonical(b)
    hsh = keccak_hex(c)
    try:
        r = requests.post(ORACLE_URL, json={"time": epoch, "hash": hsh}, timeout=20)
        j = r.json()
    except Exception as e:
        j = {"ok": False, "error": str(e)}
    return jsonify(ok=True, oracle=j, canonical=c, hash=hsh)

@app.get("/api/sensors/latest")
def latest():
    q = """
    WITH ranked AS (
      SELECT sensor_id, value, "time",
             ROW_NUMBER() OVER (PARTITION BY sensor_id ORDER BY "time" DESC) rn
      FROM public.sensor_data
    )
    SELECT s.id, s.sensor_name, s.type, r.value, r."time"
    FROM ranked r
    JOIN public.sensor s ON s.id = r.sensor_id
    WHERE r.rn = 1 AND s.id IN (:t,:h,:s,:l)
    ORDER BY s.id;
    """
    with ENGINE.connect() as cn:
        rows = cn.execute(text(q),
                {"t": TEMP_SENSOR_ID, "h": HUMID_SENSOR_ID, "s": SOIL_SENSOR_ID, "l": LIGHT_SENSOR_ID}).mappings().all()
    return jsonify([dict(r) for r in rows])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

