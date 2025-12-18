# 🎮 ĐỀ XUẤT HỆ THỐNG ĐIỀU KHIỂN TỪ XA CHO SMARTFARM

> **Ngày đề xuất:** 2025-01-20  
> **Mục tiêu:** Thêm tính năng điều khiển thiết bị IoT từ xa qua Web Dashboard

---

## 📋 MỤC LỤC

1. [Tổng quan](#1-tổng-quan)
2. [Các Thiết bị Có thể Điều khiển](#2-các-thiết-bị-có-thể-điều-khiển)
3. [Kiến trúc Hệ thống](#3-kiến-trúc-hệ-thống)
4. [Công nghệ và Giao thức](#4-công-nghệ-và-giao-thức)
5. [Database Schema](#5-database-schema)
6. [API Design](#6-api-design)
7. [Frontend UI/UX](#7-frontend-uiux)
8. [Implementation Plan](#8-implementation-plan)
9. [Bảo mật và An toàn](#9-bảo-mật-và-an-toàn)
10. [Lợi ích và Tác động](#10-lợi-ích-và-tác-động)

---

## 1. TỔNG QUAN

### 1.1. Mục tiêu
Thêm tính năng **điều khiển từ xa** cho các thiết bị IoT trong nông trại, cho phép người dùng:
- ✅ Điều khiển hệ thống tưới tiêu tự động
- ✅ Điều khiển hệ thống bón phân
- ✅ Điều khiển nhà kính (quạt, máy sưởi, cửa sổ)
- ✅ Điều khiển đèn chiếu sáng
- ✅ Điều khiển hệ thống phun thuốc
- ✅ Lập lịch tự động cho các thiết bị
- ✅ Xem trạng thái thiết bị real-time

### 1.2. Tình trạng Hiện tại
- ✅ Đã có **Irrigation History** - chỉ lưu lịch sử
- ✅ Đã có **Fertilization History** - chỉ lưu lịch sử
- ❌ **Chưa có** điều khiển thực tế thiết bị
- ❌ **Chưa có** kết nối với thiết bị IoT để điều khiển

---

## 2. CÁC THIẾT BỊ CÓ THỂ ĐIỀU KHIỂN

### 2.1. Hệ thống Tưới tiêu (Irrigation System)
- **Van nước tự động** (Solenoid Valve)
- **Máy bơm nước** (Water Pump)
- **Hệ thống phun sương** (Sprinkler System)
- **Hệ thống nhỏ giọt** (Drip Irrigation)

**Thiết bị điều khiển:**
- Relay Module (ESP8266/ESP32)
- Solenoid Valve 12V/24V
- Water Pump Controller

### 2.2. Hệ thống Bón phân (Fertilization System)
- **Máy bơm phân** (Fertilizer Pump)
- **Van phân** (Fertilizer Valve)
- **Hệ thống pha trộn** (Mixing System)

**Thiết bị điều khiển:**
- Peristaltic Pump
- Solenoid Valve
- Mixing Tank Controller

### 2.3. Nhà kính (Greenhouse Control)
- **Quạt thông gió** (Ventilation Fans)
- **Máy sưởi** (Heaters)
- **Cửa sổ tự động** (Automatic Windows)
- **Màn che nắng** (Shade Screens)
- **Hệ thống làm mát** (Cooling System)

**Thiết bị điều khiển:**
- Relay Module
- Servo Motor (cho cửa sổ)
- Stepper Motor (cho màn che)

### 2.4. Hệ thống Chiếu sáng (Lighting System)
- **Đèn LED nông nghiệp** (Grow Lights)
- **Đèn báo hiệu** (Indicator Lights)
- **Điều chỉnh cường độ ánh sáng** (Dimmer)

**Thiết bị điều khiển:**
- Relay Module
- PWM Controller (cho dimmer)
- Smart LED Controller

### 2.5. Hệ thống Phun thuốc (Spraying System)
- **Máy phun thuốc** (Sprayer Pump)
- **Van phun** (Spray Valve)
- **Hệ thống phun tự động** (Auto Spray System)

**Thiết bị điều khiển:**
- Relay Module
- Solenoid Valve
- Pump Controller

---

## 3. KIẾN TRÚC HỆ THỐNG

### 3.1. Kiến trúc Tổng thể

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  React Frontend (Port 80)                                    │
│  - Device Control Panel                                      │
│  - Schedule Management                                       │
│  - Real-time Status                                          │
└──────────────┬───────────────────────────────────────────────┘
               │ HTTP/REST + WebSocket
               │
┌──────────────▼───────────────────────────────────────────────┐
│              APPLICATION LAYER                               │
│              Spring Boot Backend API (Port 8080)             │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Device Control Service                            │    │
│  │  - Command Queue                                   │    │
│  │  - Device Status Manager                          │    │
│  │  - Schedule Service                              │    │
│  └────────────────────────────────────────────────────┘    │
└──────┬──────────────┬──────────────┬──────────────┬───────────┘
       │              │              │              │
       │              │              │              │
┌──────▼──────┐  ┌───▼────┐  ┌──────▼─────┐  ┌────▼──────────┐
│ PostgreSQL  │  │ MQTT   │  │  WebSocket │  │  Command      │
│  Database   │  │ Broker │  │  (Status)  │  │  Queue        │
│             │  │        │  │            │  │                │
└─────────────┘  └────────┘  └────────────┘  └───────────────┘
       │
       │
┌──────▼──────────────────────────────────────────────────────┐
│                    IoT CONTROL LAYER                         │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │  MQTT Client │  │  HTTP API    │                         │
│  │  (ESP8266)   │  │  (ESP32)     │                         │
│  └──────────────┘  └──────────────┘                         │
│         │                  │                                  │
│         │                  │                                  │
│         └──────────────────┘                                  │
│                    │                                          │
│                    ▼                                          │
│         ┌──────────────────────┐                             │
│         │  Device Controllers   │                             │
│         │  - Relay Modules     │                             │
│         │  - Servo Motors       │                             │
│         │  - Pump Controllers   │                             │
│         └──────────────────────┘                             │
└──────────────────────────────────────────────────────────────┘
```

### 3.2. Luồng Điều khiển

```
User Action (Frontend)
    ↓
POST /api/devices/{deviceId}/control
    ↓
Device Control Service
    ├─→ Validate Command
    ├─→ Check Permissions
    ├─→ Save to Database
    └─→ Send to MQTT Broker
        ↓
MQTT Topic: devices/{deviceId}/command
        ↓
ESP8266/ESP32 (MQTT Client)
    ├─→ Receive Command
    ├─→ Execute (Relay ON/OFF, etc.)
    └─→ Publish Status
        ↓
MQTT Topic: devices/{deviceId}/status
        ↓
Backend (MQTT Subscriber)
    ├─→ Update Database
    └─→ Push via WebSocket
        ↓
Frontend (Real-time Update)
```

### 3.3. Luồng Lập lịch

```
User Creates Schedule (Frontend)
    ↓
POST /api/schedules
    ↓
Schedule Service
    ├─→ Validate Schedule
    ├─→ Save to Database
    └─→ Register with Scheduler
        ↓
Cron Job / Scheduled Task
    ├─→ Check Active Schedules
    ├─→ Execute Commands
    └─→ Log Results
```

---

## 4. CÔNG NGHỆ VÀ GIAO THỨC

### 4.1. Giao thức Truyền thông

#### Option 1: MQTT (Khuyến nghị) ⭐
**Ưu điểm:**
- ✅ Lightweight, phù hợp IoT
- ✅ Publish/Subscribe model
- ✅ QoS levels (0, 1, 2)
- ✅ Retained messages
- ✅ Last Will and Testament

**Cấu trúc Topics:**
```
devices/{deviceId}/command      # Gửi lệnh điều khiển
devices/{deviceId}/status       # Nhận trạng thái
devices/{deviceId}/sensor       # Dữ liệu sensor (nếu có)
farms/{farmId}/devices           # Tất cả devices trong farm
```

**Message Format (JSON):**
```json
{
  "command": "ON" | "OFF" | "SET_VALUE",
  "value": 0-100,
  "timestamp": "2025-01-20T10:30:00Z",
  "userId": 1,
  "deviceId": 5
}
```

#### Option 2: HTTP REST API
**Ưu điểm:**
- ✅ Đơn giản, dễ implement
- ✅ Không cần broker
- ✅ Stateless

**Nhược điểm:**
- ❌ ESP8266 phải poll thường xuyên
- ❌ Không real-time tốt như MQTT

**Endpoint:**
```
POST http://esp8266-ip/api/control
GET  http://esp8266-ip/api/status
```

#### Option 3: WebSocket
**Ưu điểm:**
- ✅ Real-time bidirectional
- ✅ Persistent connection

**Nhược điểm:**
- ❌ Phức tạp hơn cho ESP8266
- ❌ Cần maintain connection

### 4.2. Công nghệ Backend

| Component | Technology | Mô tả |
|-----------|-----------|-------|
| **MQTT Broker** | Eclipse Mosquitto / HiveMQ | MQTT message broker |
| **MQTT Client** | Paho MQTT Client (Java) | Subscribe/Publish messages |
| **Scheduler** | Spring @Scheduled | Lập lịch tự động |
| **WebSocket** | Spring WebSocket | Real-time status updates |
| **Command Queue** | In-memory Queue / Redis | Queue commands |

### 4.3. Công nghệ IoT Device

| Component | Technology | Mô tả |
|-----------|-----------|-------|
| **Microcontroller** | ESP8266 / ESP32 | WiFi-enabled MCU |
| **MQTT Library** | PubSubClient (Arduino) | MQTT client cho ESP |
| **Relay Module** | 4-Channel Relay | Điều khiển thiết bị |
| **Power Supply** | 5V/12V Adapter | Nguồn điện |

---

## 5. DATABASE SCHEMA

### 5.1. Bảng Mới

#### `device` - Thiết bị điều khiển
```sql
CREATE TABLE device (
    id BIGSERIAL PRIMARY KEY,
    device_name VARCHAR(100) NOT NULL,
    device_type VARCHAR(50) NOT NULL, -- 'IRRIGATION', 'FERTILIZATION', 'GREENHOUSE', 'LIGHTING', 'SPRAYING'
    field_id BIGINT REFERENCES field(id),
    farm_id BIGINT REFERENCES farm(id),
    mqtt_topic VARCHAR(255) UNIQUE NOT NULL,
    ip_address VARCHAR(50),
    mac_address VARCHAR(50),
    status VARCHAR(20) DEFAULT 'OFFLINE', -- 'ONLINE', 'OFFLINE', 'ERROR'
    last_seen TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### `device_command` - Lệnh điều khiển
```sql
CREATE TABLE device_command (
    id BIGSERIAL PRIMARY KEY,
    device_id BIGINT REFERENCES device(id),
    command VARCHAR(50) NOT NULL, -- 'ON', 'OFF', 'SET_VALUE'
    value INTEGER, -- 0-100 for dimmer, etc.
    status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'SENT', 'EXECUTED', 'FAILED'
    executed_at TIMESTAMP,
    created_by BIGINT REFERENCES account(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT
);
```

#### `device_status` - Trạng thái thiết bị
```sql
CREATE TABLE device_status (
    id BIGSERIAL PRIMARY KEY,
    device_id BIGINT REFERENCES device(id),
    status VARCHAR(20) NOT NULL, -- 'ON', 'OFF', 'RUNNING', 'ERROR'
    value INTEGER, -- Current value (0-100)
    power_consumption DECIMAL(10,2), -- Watts
    temperature DECIMAL(5,2), -- Device temperature
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### `device_schedule` - Lập lịch thiết bị
```sql
CREATE TABLE device_schedule (
    id BIGSERIAL PRIMARY KEY,
    device_id BIGINT REFERENCES device(id),
    schedule_name VARCHAR(100) NOT NULL,
    command VARCHAR(50) NOT NULL,
    value INTEGER,
    cron_expression VARCHAR(100) NOT NULL, -- '0 8 * * *' = 8:00 AM daily
    enabled BOOLEAN DEFAULT TRUE,
    created_by BIGINT REFERENCES account(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### `device_schedule_log` - Lịch sử thực thi lịch
```sql
CREATE TABLE device_schedule_log (
    id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT REFERENCES device_schedule(id),
    device_id BIGINT REFERENCES device(id),
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20), -- 'SUCCESS', 'FAILED'
    error_message TEXT
);
```

### 5.2. Cập nhật Bảng Hiện có

#### `irrigation_history` - Thêm device_id
```sql
ALTER TABLE irrigation_history 
ADD COLUMN device_id BIGINT REFERENCES device(id);
```

#### `fertilization_history` - Thêm device_id
```sql
ALTER TABLE fertilization_history 
ADD COLUMN device_id BIGINT REFERENCES device(id);
```

---

## 6. API DESIGN

### 6.1. Device Management

#### `GET /api/devices`
Lấy danh sách thiết bị
```json
Response: [
  {
    "id": 1,
    "deviceName": "Irrigation Pump 1",
    "deviceType": "IRRIGATION",
    "fieldId": 1,
    "farmId": 1,
    "status": "ONLINE",
    "currentStatus": "ON",
    "lastSeen": "2025-01-20T10:30:00Z"
  }
]
```

#### `POST /api/devices`
Tạo thiết bị mới
```json
Request: {
  "deviceName": "Irrigation Pump 1",
  "deviceType": "IRRIGATION",
  "fieldId": 1,
  "farmId": 1,
  "mqttTopic": "devices/1/command"
}
```

#### `GET /api/devices/{id}`
Lấy chi tiết thiết bị

#### `PUT /api/devices/{id}`
Cập nhật thiết bị

#### `DELETE /api/devices/{id}`
Xóa thiết bị

### 6.2. Device Control

#### `POST /api/devices/{deviceId}/control`
Điều khiển thiết bị
```json
Request: {
  "command": "ON",  // hoặc "OFF", "SET_VALUE"
  "value": 75       // Optional, cho dimmer, etc.
}

Response: {
  "commandId": 123,
  "status": "SENT",
  "message": "Command sent successfully"
}
```

#### `GET /api/devices/{deviceId}/status`
Lấy trạng thái hiện tại
```json
Response: {
  "deviceId": 1,
  "status": "ON",
  "value": 75,
  "powerConsumption": 120.5,
  "temperature": 35.2,
  "lastUpdate": "2025-01-20T10:30:00Z"
}
```

#### `GET /api/devices/{deviceId}/commands`
Lấy lịch sử lệnh
```json
Response: [
  {
    "id": 123,
    "command": "ON",
    "value": null,
    "status": "EXECUTED",
    "createdAt": "2025-01-20T10:30:00Z",
    "executedAt": "2025-01-20T10:30:05Z",
    "createdBy": {
      "id": 1,
      "fullName": "John Doe"
    }
  }
]
```

### 6.3. Schedule Management

#### `GET /api/devices/{deviceId}/schedules`
Lấy lịch trình của thiết bị

#### `POST /api/devices/{deviceId}/schedules`
Tạo lịch trình mới
```json
Request: {
  "scheduleName": "Morning Irrigation",
  "command": "ON",
  "value": null,
  "cronExpression": "0 8 * * *",  // 8:00 AM daily
  "enabled": true
}
```

#### `PUT /api/devices/{deviceId}/schedules/{scheduleId}`
Cập nhật lịch trình

#### `DELETE /api/devices/{deviceId}/schedules/{scheduleId}`
Xóa lịch trình

#### `PUT /api/devices/{deviceId}/schedules/{scheduleId}/toggle`
Bật/tắt lịch trình

### 6.4. Real-time Status (WebSocket)

#### Topic: `/topic/devices/{deviceId}/status`
```json
{
  "deviceId": 1,
  "status": "ON",
  "value": 75,
  "timestamp": "2025-01-20T10:30:00Z"
}
```

---

## 7. FRONTEND UI/UX

### 7.1. Device Control Panel

**Component:** `DeviceControlPanel.js`

**Features:**
- ✅ Danh sách thiết bị theo field/farm
- ✅ Nút ON/OFF cho mỗi thiết bị
- ✅ Slider cho điều chỉnh giá trị (dimmer, etc.)
- ✅ Hiển thị trạng thái real-time
- ✅ Indicator màu (xanh = ON, đỏ = OFF, vàng = ERROR)
- ✅ Last seen timestamp

**UI Mockup:**
```
┌─────────────────────────────────────────┐
│  Device Control Panel                  │
├─────────────────────────────────────────┤
│  [Farm: Farm 1 ▼]  [Field: Field 1 ▼]  │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐  │
│  │ Irrigation Pump 1               │  │
│  │ Status: 🟢 ONLINE                │  │
│  │ Current: ON                     │  │
│  │ [  OFF  ] [  ON  ]              │  │
│  │ Last seen: 2 min ago           │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ Grow Light 1                    │  │
│  │ Status: 🟢 ONLINE                │  │
│  │ Current: 75%                    │  │
│  │ [  OFF  ] [  ON  ]              │  │
│  │ Brightness: [━━━━━━━━━━] 75%   │  │
│  └─────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

### 7.2. Schedule Management

**Component:** `DeviceScheduleManager.js`

**Features:**
- ✅ Danh sách lịch trình
- ✅ Tạo lịch trình mới (cron expression builder)
- ✅ Enable/Disable lịch trình
- ✅ Xem lịch sử thực thi
- ✅ Edit/Delete lịch trình

**UI Mockup:**
```
┌─────────────────────────────────────────┐
│  Schedule Management                     │
├─────────────────────────────────────────┤
│  [+ New Schedule]                        │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐  │
│  │ Morning Irrigation               │  │
│  │ Device: Irrigation Pump 1        │  │
│  │ Schedule: Daily at 8:00 AM       │  │
│  │ Command: ON                       │  │
│  │ Status: ✅ Enabled                │  │
│  │ [Edit] [Disable] [Delete]         │  │
│  └─────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

### 7.3. Device Status Dashboard

**Component:** `DeviceStatusDashboard.js`

**Features:**
- ✅ Tổng quan tất cả thiết bị
- ✅ Biểu đồ trạng thái
- ✅ Thống kê sử dụng
- ✅ Cảnh báo thiết bị offline

---

## 8. IMPLEMENTATION PLAN

### 8.1. Phase 1: Backend Foundation (1-2 tuần)

**Tasks:**
1. ✅ Tạo database schema (device, device_command, device_status, device_schedule)
2. ✅ Tạo Entities và Repositories
3. ✅ Tạo DeviceService, DeviceControlService
4. ✅ Setup MQTT Broker (Mosquitto)
5. ✅ Tạo MQTT Client Service
6. ✅ Tạo ScheduleService với Spring @Scheduled
7. ✅ Tạo REST API endpoints
8. ✅ Tạo WebSocket cho real-time status

**Deliverables:**
- Database schema
- Backend APIs
- MQTT integration
- Basic scheduling

### 8.2. Phase 2: IoT Device Firmware (1 tuần)

**Tasks:**
1. ✅ Viết firmware cho ESP8266/ESP32
2. ✅ MQTT client implementation
3. ✅ Relay control logic
4. ✅ Status reporting
5. ✅ WiFi connection handling
6. ✅ OTA update support (optional)

**Deliverables:**
- Arduino firmware code
- Device documentation
- Wiring diagram

### 8.3. Phase 3: Frontend Integration (1-2 tuần)

**Tasks:**
1. ✅ Device Control Panel component
2. ✅ Schedule Management component
3. ✅ Device Status Dashboard
4. ✅ WebSocket integration
5. ✅ Real-time updates
6. ✅ Error handling

**Deliverables:**
- React components
- UI/UX improvements
- Real-time status display

### 8.4. Phase 4: Testing & Optimization (1 tuần)

**Tasks:**
1. ✅ Unit tests
2. ✅ Integration tests
3. ✅ End-to-end tests
4. ✅ Performance optimization
5. ✅ Security audit
6. ✅ Documentation

**Deliverables:**
- Test suite
- Performance report
- Security report
- User documentation

---

## 9. BẢO MẬT VÀ AN TOÀN

### 9.1. Authentication & Authorization
- ✅ JWT token cho API calls
- ✅ Role-based access (chỉ ADMIN/FARM_OWNER mới điều khiển)
- ✅ Device ownership validation

### 9.2. MQTT Security
- ✅ MQTT username/password
- ✅ TLS/SSL encryption
- ✅ Topic access control
- ✅ Device authentication

### 9.3. Command Validation
- ✅ Validate command format
- ✅ Rate limiting (tránh spam commands)
- ✅ Command queue (xử lý tuần tự)
- ✅ Timeout handling

### 9.4. Safety Features
- ✅ Emergency stop button
- ✅ Maximum runtime limits
- ✅ Override protection
- ✅ Manual override mode
- ✅ Device health monitoring

---

## 10. LỢI ÍCH VÀ TÁC ĐỘNG

### 10.1. Lợi ích

**Cho Người dùng:**
- ✅ Điều khiển từ xa, không cần đến nông trại
- ✅ Tiết kiệm thời gian và công sức
- ✅ Lập lịch tự động, không cần can thiệp
- ✅ Phản ứng nhanh với thay đổi môi trường
- ✅ Giảm chi phí vận hành

**Cho Hệ thống:**
- ✅ Tăng giá trị sản phẩm
- ✅ Phân biệt với competitors
- ✅ Mở rộng tính năng
- ✅ Tăng user engagement

### 10.2. Tác động đến Đánh giá Dự án

**Cải thiện:**
- ✅ **Tính năng**: +2 điểm (từ 8/10 → 10/10)
- ✅ **Innovation**: +1 điểm
- ✅ **User Experience**: +1 điểm
- ✅ **Competitive Advantage**: +2 điểm

**Tổng điểm mới: ~8.5/10** (từ 7.3/10)

### 10.3. Phù hợp với Cuộc thi

**BẢNG E: MẠNG MÁY TÍNH & IoT**
- ✅ **Tăng điểm mạnh**: Remote control là tính năng IoT quan trọng
- ✅ **Network Architecture**: MQTT, WebSocket, REST API
- ✅ **Real-time Communication**: WebSocket + MQTT
- ✅ **Device Integration**: ESP8266/ESP32

**BẢNG C: ỨNG DỤNG WEBSITE**
- ✅ **Tăng điểm mạnh**: Control panel là tính năng web app quan trọng
- ✅ **User Interface**: Device control UI
- ✅ **Real-time Updates**: WebSocket integration

---

## 📝 KẾT LUẬN

Tính năng **Điều khiển từ xa** sẽ:
- ✅ **Tăng giá trị** sản phẩm đáng kể
- ✅ **Phân biệt** SmartFarm với các giải pháp khác
- ✅ **Phù hợp** với kiến trúc hiện tại
- ✅ **Khả thi** về mặt kỹ thuật
- ✅ **Tăng điểm** trong cuộc thi

**Khuyến nghị:** Nên implement tính năng này để hoàn thiện hệ thống SmartFarm.

---

**Version:** 1.0  
**Last Updated:** 2025-01-20  
**Author:** AI Assistant





