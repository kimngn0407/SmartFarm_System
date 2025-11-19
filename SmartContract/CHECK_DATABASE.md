# 🔍 Kiểm tra Database Sensor Data

## ❌ Lỗi: `psql` not found

Nếu không có `psql` trên VPS, có thể dùng các cách sau:

---

## ✅ Cách 1: Dùng Docker Exec (Khuyến nghị)

Nếu PostgreSQL chạy trong Docker:

```bash
# Kiểm tra container PostgreSQL
docker ps | grep postgres

# Truy cập PostgreSQL qua Docker
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  sensor_id,
  value,
  time
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10) 
ORDER BY time DESC 
LIMIT 10;
"
```

Hoặc truy cập interactive:

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# Sau đó chạy query:
SELECT 
  sensor_id,
  value,
  time
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10) 
ORDER BY time DESC 
LIMIT 10;
```

---

## ✅ Cách 2: Cài PostgreSQL Client

```bash
# Cài PostgreSQL client
sudo apt update
sudo apt install postgresql-client-common postgresql-client-15

# Sau đó dùng như bình thường
psql $DB_URL -c "SELECT sensor_id, value, time FROM sensor_data WHERE sensor_id IN (7,8,9,10) ORDER BY time DESC LIMIT 10;"
```

---

## ✅ Cách 3: Dùng Python Script

Tạo script Python để kiểm tra:

```bash
cd ~/projects/SmartFarm/SmartContract/flask-api

# Kích hoạt venv
source .venv/bin/activate

# Chạy Python
python3 << EOF
import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()
DB_URL = os.getenv("DB_URL")
engine = create_engine(DB_URL)

with engine.connect() as conn:
    result = conn.execute(text("""
        SELECT 
          sensor_id,
          value,
          time
        FROM sensor_data 
        WHERE sensor_id IN (7, 8, 9, 10) 
        ORDER BY time DESC 
        LIMIT 10
    """))
    
    print("\n📊 Latest Sensor Data:")
    print("=" * 60)
    print(f"{'Sensor ID':<12} {'Value':<12} {'Time'}")
    print("-" * 60)
    for row in result:
        print(f"{row.sensor_id:<12} {row.value:<12} {row.time}")
    print("=" * 60)
EOF
```

---

## ✅ Cách 4: Kiểm tra qua Backend API

```bash
# Test endpoint latest data
curl http://localhost:8080/api/sensor-data/latest

# Hoặc từ bên ngoài
curl http://173.249.48.25:8080/api/sensor-data/latest
```

---

## 🎯 Quick Check (Docker)

```bash
# 1. Kiểm tra container
docker ps | grep postgres

# 2. Truy cập và query
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  sensor_id,
  CASE 
    WHEN sensor_id = 7 THEN 'Temperature'
    WHEN sensor_id = 8 THEN 'Humidity'
    WHEN sensor_id = 9 THEN 'Soil'
    WHEN sensor_id = 10 THEN 'Light'
  END as sensor_type,
  value,
  time
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10) 
ORDER BY time DESC 
LIMIT 20;
"
```

---

## 📊 Kết quả mong đợi

Nếu data đã được lưu, bạn sẽ thấy:

```
 sensor_id | sensor_type | value |        time         
-----------+-------------+-------+---------------------
         7 | Temperature |  24.5 | 2025-11-19 10:30:00
         8 | Humidity    |    28 | 2025-11-19 10:30:00
         9 | Soil        |     0 | 2025-11-19 10:30:00  ← soil_pct = 0
        10 | Light       |    12 | 2025-11-19 10:30:00  ← light_pct = 12
```

---

## 🔍 Kiểm tra chi tiết từng sensor

```bash
# Count data points cho mỗi sensor
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  sensor_id,
  COUNT(*) as count,
  MIN(value) as min_value,
  MAX(value) as max_value,
  AVG(value) as avg_value,
  MAX(time) as latest_time
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10)
GROUP BY sensor_id
ORDER BY sensor_id;
"
```

