# Phân Tích Kiến Trúc Hiện Tại - SmartFarm IoT Project

## 📊 Tổng Quan Kiến Trúc

Project hiện tại đang sử dụng **kiến trúc Hybrid** với **2 phương pháp** tùy theo loại thiết bị:

### 🔄 Luồng Dữ Liệu Tổng Quan

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEVICE LAYER                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐                    ┌──────────────┐           │
│  │ Arduino UNO  │                    │    ESP32     │           │
│  │ (No WiFi)    │                    │  (Has WiFi)  │           │
│  └──────┬───────┘                    └──────┬───────┘           │
│         │ Serial/USB                        │ HTTP POST         │
│         │                                   │                   │
└─────────┼───────────────────────────────────┼───────────────────┘
          │                                   │
          ▼                                   │
┌─────────┴───────────────────────────────────┴───────────────────┐
│                    GATEWAY LAYER                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────┐                          ┌──────────────┐  │
│  │ forwarder.py    │                          │  Direct HTTP │  │
│  │ (Python)        │                          │  Connection  │  │
│  │ - Đọc Serial    │                          │              │  │
│  │ - Parse JSON    │                          │              │  │
│  │ - HTTP POST     │                          │              │  │
│  └────────┬────────┘                          └──────┬───────┘  │
│           │                                           │           │
│           └───────────────────┬───────────────────────┘           │
│                               │                                   │
└───────────────────────────────┼───────────────────────────────────┘
                                │ HTTP POST
                                │ x-api-key: MY_API_KEY
                                ▼
┌───────────────────────────────┴───────────────────────────────────┐
│                    API LAYER (Flask - Python)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Flask API (app.py)                                      │   │
│  │  - Endpoint: POST /api/sensors                           │   │
│  │  - Authentication: API Key (x-api-key header)            │   │
│  │  - Validation: Time, sensor values                      │   │
│  │  - Processing:                                          │   │
│  │    • Parse JSON payload                                 │   │
│  │    • Normalize timestamp                                │   │
│  │    • Insert vào PostgreSQL (4 sensors)                  │   │
│  │    • Tính Keccak256 hash                                │   │
│  │    • Gửi hash đến Oracle Node                           │   │
│  └───────────────┬───────────────────────────┬─────────────┘   │
│                  │                           │                   │
└──────────────────┼───────────────────────────┼───────────────────┘
                   │                           │
                   ▼                           ▼
┌──────────────────┴───────────────┐  ┌───────┴───────────────────┐
│   DATA LAYER                      │  │   BLOCKCHAIN LAYER        │
├───────────────────────────────────┤  ├──────────────────────────┤
│                                   │  │                           │
│  ┌─────────────────────────────┐  │  │  ┌─────────────────────┐ │
│  │  PostgreSQL Database        │  │  │  │  Oracle Node        │ │
│  │  - Table: sensor            │  │  │  │  (Node.js/Express)  │ │
│  │  - Table: sensor_data      │  │  │  │  - Endpoint:         │ │
│  │                             │  │  │  │    POST /oracle/push│ │
│  │  Sensors:                   │  │  │  │  - Gửi hash lên     │ │
│  │  - ID 7: Temperature        │  │  │  │    Smart Contract   │ │
│  │  - ID 8: Humidity           │  │  │  │                      │ │
│  │  - ID 9: Soil Moisture      │  │  │  └──────────┬──────────┘ │
│  │  - ID 10: Light              │  │  │             │            │
│  └─────────────────────────────┘  │  │             ▼            │
│                                    │  │  ┌─────────────────────┐ │
│                                    │  │  │  Smart Contract     │ │
│                                    │  │  │  (SensorOracle.sol) │ │
│                                    │  │  │  - Store hash       │ │
│                                    │  │  │  - Pione Zero       │ │
│                                    │  │  │    Testnet          │ │
│                                    │  │  └─────────────────────┘ │
│                                    │  │                           │
└────────────────────────────────────┘  └───────────────────────────┘
```

---

## 🔍 Chi Tiết Từng Thành Phần

### 1. Device Layer

#### A. Arduino UNO (Không có WiFi)
**Phương pháp**: Serial Gateway Pattern

**Luồng hoạt động**:
1. Arduino đọc sensor (DHT11, soil, light)
2. Tạo JSON payload với dữ liệu
3. Gửi JSON qua Serial/USB (9600 baud)
4. `forwarder.py` đọc Serial và forward đến Flask API

**Code Arduino (giả định)**:
```cpp
// Arduino gửi JSON qua Serial
JsonDocument doc;
doc["sensorId"] = 1;
doc["time"] = millis() / 1000;
doc["temperature"] = temp;
doc["humidity"] = humidity;
doc["soil_pct"] = soil;
doc["light"] = light;

serializeJson(doc, Serial);
Serial.println();
```

#### B. ESP32 (Có WiFi)
**Phương pháp**: HTTP REST API trực tiếp

**Luồng hoạt động**:
1. ESP32 kết nối WiFi
2. Đọc sensor
3. Gửi HTTP POST trực tiếp đến Flask API
4. Không cần gateway trung gian

**Code ESP32 (theo README)**:
```cpp
// ESP32 gửi HTTP POST trực tiếp
HTTPClient http;
http.begin("http://173.249.48.25:8000/api/sensors");
http.addHeader("Content-Type", "application/json");
http.addHeader("x-api-key", "MY_API_KEY");
http.POST(jsonPayload);
```

---

### 2. Gateway Layer

#### forwarder.py (Serial Gateway)
**Vị trí**: `device/forwarder.py`

**Chức năng**:
- Đọc dữ liệu từ Serial Port (COM4, 9600 baud)
- Parse JSON từ Arduino
- Xử lý lỗi JSON (thiếu ký tự, thiếu dấu đóng)
- Gửi HTTP POST đến Flask API với retry mechanism
- Timeout: 30 giây, max retries: 3

**Đặc điểm**:
- Chạy trên máy tính (Windows/Linux)
- Cần kết nối USB giữa Arduino và máy tính
- Xử lý lỗi JSON một cách thông minh (sửa lỗi thiếu ký tự)

**Code chính**:
```python
# Đọc Serial
line = ser.readline().decode(errors="ignore").strip()

# Sửa lỗi JSON
if not line.startswith("{"):
    if line.startswith('ime":'):
        line = '{"time":' + line[5:]

# Parse và gửi
payload = json.loads(line)
response = requests.post(FLASK_URL, json=payload, headers=headers)
```

---

### 3. API Layer (Flask - Python)

#### Flask API (`flask-api/app.py`)
**Technology Stack**:
- **Framework**: Flask (Python)
- **Database**: SQLAlchemy (ORM) → PostgreSQL
- **Authentication**: API Key (x-api-key header)
- **Blockchain**: Keccak256 hash → Oracle Node

**Endpoints**:
1. `POST /api/sensors` - Nhận dữ liệu từ device
2. `GET /api/sensors/latest` - Lấy dữ liệu mới nhất

**Xử lý dữ liệu**:
1. **Authentication**: Kiểm tra `x-api-key` header
2. **Parse JSON**: Nhận payload từ device
3. **Normalize Time**: 
   - Nếu `time < 1000000000` → Dùng thời gian hiện tại (Unix timestamp)
   - Nếu `time >= 1000000000` → Dùng timestamp từ device
4. **Insert Database**: Lưu 4 sensors riêng biệt
   - Temperature (sensor_id = 7)
   - Humidity (sensor_id = 8)
   - Soil Moisture (sensor_id = 9)
   - Light (sensor_id = 10)
5. **Tính Hash**: Keccak256 hash của canonical JSON
6. **Gửi Oracle**: POST hash đến Oracle Node

**Code chính**:
```python
@app.post("/api/sensors")
def ingest():
    # Authentication
    if request.headers.get("x-api-key") != API_KEY:
        return jsonify(error="unauthorized"), 401
    
    # Parse và normalize
    b = request.get_json(force=True)
    epoch = normalize_timestamp(b.get("time"))
    
    # Insert vào database (4 sensors)
    with ENGINE.begin() as cn:
        if t is not None:
            cn.execute(text("INSERT INTO sensor_data..."), 
                      {"sid": TEMP_SENSOR_ID, "val": float(t), "ts": epoch})
        # ... tương tự cho humidity, soil, light
    
    # Tính hash và gửi oracle
    c = canonical(b)
    hsh = keccak_hex(c)
    requests.post(ORACLE_URL, json={"time": epoch, "hash": hsh})
```

**Đặc điểm**:
- Xử lý lỗi DHT11 (chỉ lưu temp/humidity nếu không có lỗi)
- Luôn lưu soil và light (không phụ thuộc DHT11)
- Tính hash canonical (bỏ qua các field debug)

---

### 4. Data Layer

#### PostgreSQL Database
**Schema**:
- `public.sensor`: Thông tin sensors (id, name, type)
- `public.sensor_data`: Dữ liệu sensor (sensor_id, value, time)

**Sensors được sử dụng**:
- ID 7: Temperature
- ID 8: Humidity
- ID 9: Soil Moisture (soil_pct)
- ID 10: Light

**Query pattern**:
```sql
INSERT INTO public.sensor_data (sensor_id, value, "time")
VALUES (:sid, :val, to_timestamp(:ts))
```

---

### 5. Blockchain Layer

#### Oracle Node (`oracle-node/server.js`)
**Technology**: Node.js + Express + Ethers.js

**Chức năng**:
- Nhận hash từ Flask API
- Gửi hash lên Smart Contract trên Pione Zero testnet
- Trả về transaction hash

**Endpoints**:
- `GET /oracle/health` - Health check
- `POST /oracle/push` - Nhận hash và gửi lên blockchain

**Code**:
```javascript
app.post("/oracle/push", async (req, res) => {
  const { time, hash } = req.body;
  const tx = await contract.storeHash(Number(time), String(hash));
  const receipt = await tx.wait();
  return res.json({ ok: true, txHash: receipt.hash });
});
```

#### Smart Contract (`contracts/SensorOracle.sol`)
- Lưu hash của sensor data lên blockchain
- Đảm bảo tính toàn vẹn dữ liệu (immutability)
- Network: Pione Zero testnet

---

## 📋 So Sánh với Lý Thuyết

| Khía Cạnh | Project Hiện Tại | Lý Thuyết (Spring Boot) |
|-----------|------------------|-------------------------|
| **Backend Framework** | Flask (Python) | Spring Boot (Java) |
| **Database ORM** | SQLAlchemy | Spring Data JPA |
| **Authentication** | API Key (simple) | JWT/API Key (Spring Security) |
| **Gateway** | Không có (direct) | Spring Cloud Gateway |
| **Message Queue** | Không có | RabbitMQ/Kafka (optional) |
| **Microservices** | Monolithic (Flask) | Microservices architecture |
| **Circuit Breaker** | Không có | Resilience4j |
| **Monitoring** | Không có | Actuator + Prometheus |
| **Serial Gateway** | Python script | Java service |
| **Blockchain** | ✅ Có (Oracle Node) | ❌ Không có trong lý thuyết |

---

## ✅ Điểm Mạnh của Kiến Trúc Hiện Tại

1. **Đơn giản**: Kiến trúc đơn giản, dễ hiểu
2. **Hybrid Approach**: Hỗ trợ cả Arduino UNO và ESP32
3. **Blockchain Integration**: Tích hợp blockchain để đảm bảo tính toàn vẹn dữ liệu
4. **Error Handling**: Xử lý lỗi JSON thông minh trong forwarder.py
5. **Retry Mechanism**: Có retry khi gửi HTTP request
6. **Flexible Time**: Xử lý timestamp linh hoạt (Unix timestamp hoặc seconds from boot)

---

## ⚠️ Điểm Yếu / Hạn Chế

1. **Không phải Spring Boot**: Không tuân theo user rules (yêu cầu Spring Boot)
2. **Monolithic**: Flask API là monolithic, không phải microservices
3. **Thiếu Gateway**: Không có API Gateway (Spring Cloud Gateway)
4. **Thiếu Security**: API Key đơn giản, không có JWT
5. **Thiếu Monitoring**: Không có Actuator, Prometheus, Grafana
6. **Thiếu Circuit Breaker**: Không có xử lý lỗi nâng cao
7. **Thiếu Message Queue**: Không có RabbitMQ/Kafka cho async processing
8. **Thiếu Rate Limiting**: Không giới hạn số lượng request
9. **Thiếu Containerization**: Không có Docker setup
10. **Thiếu Testing**: Không có unit test, integration test

---

## 🎯 Kết Luận

**Project hiện tại đang sử dụng**:
- **Kiến trúc Hybrid**: Serial Gateway (Arduino UNO) + HTTP REST (ESP32)
- **Backend**: Flask (Python) - **KHÔNG phải Spring Boot**
- **Database**: PostgreSQL với SQLAlchemy
- **Blockchain**: Oracle Node + Smart Contract (điểm đặc biệt)

**Khác biệt so với yêu cầu**:
- ❌ Không dùng Spring Boot (đang dùng Flask)
- ❌ Không phải microservices (đang là monolithic)
- ❌ Không có Spring Cloud components
- ✅ Có blockchain integration (điểm mạnh)

**Khuyến nghị**:
- Nếu muốn tuân theo user rules → Cần migrate sang Spring Boot
- Giữ lại blockchain integration (điểm mạnh)
- Chuyển sang microservices architecture
- Thêm monitoring, security, testing

---

## 📝 Tóm Tắt

**Kiến trúc hiện tại**: **Hybrid Serial Gateway + HTTP REST với Flask (Python)**

**Luồng dữ liệu**:
1. Arduino UNO → Serial → `forwarder.py` → Flask API → PostgreSQL + Blockchain
2. ESP32 → HTTP POST → Flask API → PostgreSQL + Blockchain

**Technology Stack**:
- Python (Flask, forwarder.py)
- Node.js (Oracle Node)
- PostgreSQL
- Solidity (Smart Contract)
- Pione Zero Testnet


