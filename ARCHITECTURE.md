# 🏗️ KIẾN TRÚC HỆ THỐNG SMARTFARM

> **Tài liệu mô tả kiến trúc, luồng xử lý và thiết kế của hệ thống SmartFarm**

---

## 📋 MỤC LỤC

1. [Tổng quan Kiến trúc](#1-tổng-quan-kiến-trúc)
2. [Luồng Dữ liệu Chính](#2-luồng-dữ-liệu-chính)
3. [Kiến trúc Backend](#3-kiến-trúc-backend)
4. [Kiến trúc Frontend](#4-kiến-trúc-frontend)
5. [Luồng Xử lý Chi tiết](#5-luồng-xử-lý-chi-tiết)
6. [Công nghệ Sử dụng](#6-công-nghệ-sử-dụng)

---

## 1. TỔNG QUAN KIẾN TRÚC

### 1.1. Kiến trúc Tổng thể

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────┤
│  React Frontend (Port 80)  │  Next.js Chatbot (Port 9002)  │
└──────────────┬───────────────────────┬───────────────────────┘
                │                       │
                │ HTTP/REST             │ HTTP/REST
                │ WebSocket              │
                │                       │
┌───────────────▼───────────────────────▼───────────────────────┐
│              APPLICATION LAYER                               │
│              Spring Boot Backend API (Port 8080)             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Auth    │  │  Farm    │  │  Sensor  │  │  Alert   │   │
│  │  Service │  │  Service │  │  Service │  │  Service │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└──────┬──────────────┬──────────────┬──────────────┬───────────┘
       │              │              │              │
       │              │              │              │
┌──────▼──────┐  ┌───▼────┐  ┌──────▼─────┐  ┌────▼──────────┐
│ PostgreSQL  │  │  Crop  │  │   Pest     │  │  WebSocket    │
│  Database   │  │   ML   │  │    ML      │  │  (Realtime)   │
│  (Port 5432)│  │(Port   │  │ (Port      │  │               │
│             │  │ 5000)  │  │  5001)     │  │               │
└─────────────┘  └────────┘  └────────────┘  └───────────────┘
       │
       │
┌──────▼──────────────────────────────────────────────────────┐
│                    IoT LAYER                                 │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │  Arduino     │  │  Flask API   │                         │
│  │  Sensors     │  │  (Port 8000) │                         │
│  │  (ESP8266)   │  │              │                         │
│  └──────────────┘  └──────────────┘                         │
│         │                  │                                  │
│         │                  │                                  │
│         └──────────────────┘                                  │
└──────────────────────────────────────────────────────────────┘
```

### 1.2. Đặc điểm Kiến trúc

- **Microservices Architecture**: Tách biệt các service độc lập
- **Event-Driven**: Sử dụng WebSocket cho realtime updates
- **Database-Centric**: Lưu trữ dữ liệu sensor trong PostgreSQL
- **RESTful API**: Standard REST API cho tất cả services
- **Docker Containerization**: Tất cả services chạy trong Docker

---

## 2. LUỒNG DỮ LIỆU CHÍNH

### 2.1. Luồng Dữ liệu Sensor (IoT → Database)

```
┌─────────────┐
│ IoT Sensors │ (DHT22, Soil, Light)
│  Arduino    │
└──────┬──────┘
       │ HTTP POST (JSON)
       │
       ▼
┌─────────────┐
│ Flask API   │ (Port 8000)
│ - Validate  │
│ - Format    │
│ - Process   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ PostgreSQL  │
│ Database    │
│             │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Spring Boot │ (Port 8080)
│ Backend     │
│ - Read DB   │
│ - Process   │
│ - Alert     │
└──────┬──────┘
       │ WebSocket
       │
       ▼
┌─────────────┐
│ React       │ (Port 80)
│ Frontend    │
│ - Display   │
│ - Charts    │
└─────────────┘
```

### 2.2. Chi tiết từng Bước

#### **Bước 1: Thu thập Dữ liệu (IoT Layer)**
- **Thiết bị**: Arduino/ESP8266/ESP32
- **Cảm biến**: DHT22 (nhiệt độ, độ ẩm), Soil Moisture, Light Sensor
- **Định dạng**: JSON payload
- **Giao thức**: HTTP POST qua WiFi/USB Serial

**Ví dụ Payload:**
```json
{
  "sensorId": 1,
  "time": 1735123456,
  "temperature": 28.5,
  "humidity": 75.2,
  "soil_raw": 512,
  "light_pct": 65.0
}
```

#### **Bước 2: Tiếp nhận và Xử lý (Flask API)**
- **Endpoint**: `POST /api/sensors`
- **Validation**: Kiểm tra API key, format dữ liệu
- **Processing**:
  - Tính `soil_pct` từ `soil_raw` (đảo ngược: 1023 → 0%, 0 → 100%)
  - Xử lý timestamp (nếu < 1000000000 thì dùng thời gian hiện tại)
  - Lưu vào PostgreSQL (4 bản ghi: temp, humid, soil, light)

#### **Bước 3: Lưu trữ Database (PostgreSQL)**
- **Bảng**: `sensor_data`
- **Cấu trúc**: `(sensor_id, value, time)`
- **4 Sensors**: ID 7 (temp), 8 (humid), 9 (soil), 10 (light)

#### **Bước 4: Xử lý Nghiệp vụ (Spring Boot)**
- **Đọc từ DB**: Query sensor data mới nhất
- **Alert System**: So sánh với ngưỡng, tạo alerts
- **Email Notification**: Gửi email nếu có alert
- **WebSocket Push**: Push dữ liệu realtime lên frontend

#### **Bước 5: Hiển thị (React Frontend)**
- **WebSocket**: Nhận realtime updates
- **Charts**: Hiển thị biểu đồ nhiệt độ, độ ẩm, đất, ánh sáng
- **Alerts**: Hiển thị cảnh báo

---

## 3. KIẾN TRÚC BACKEND

### 3.1. Cấu trúc Package (Domain-Driven Design)

```
com.example.demo/
├── domain/
│   ├── farm/
│   │   ├── controller/FarmController.java
│   │   ├── service/FarmService.java
│   │   ├── repository/FarmRepository.java
│   │   ├── entity/FarmEntity.java
│   │   └── dto/FarmDTO.java
│   │
│   ├── sensor/
│   │   ├── controller/SensorController.java
│   │   ├── service/SensorService.java
│   │   └── ...
│   │
│   └── alert/
│       └── ...
│
├── infrastructure/
│   ├── config/
│   │   ├── SecurityConfig.java
│   │   ├── WebSocketConfig.java
│   │   └── SwaggerConfig.java
│   ├── exception/
│   │   └── GlobalExceptionHandler.java
│   └── logging/
│       └── LoggingAspect.java
│
└── shared/
    ├── constants/
    ├── utils/
    └── enums/
```

### 3.2. Luồng Xử lý Request

```
Client Request
    │
    ▼
┌──────────────┐
│  Controller  │ (REST Endpoint)
│  - Validate  │
│  - Parse     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Service    │ (Business Logic)
│  - Process   │
│  - Validate  │
│  - Transform │
└──────┬───────┘
       │
       ├─────────────────┐
       │                 │
       ▼                 ▼
┌──────────────┐   ┌──────────────┐
│  Repository  │   │ External API │
│  (Database)  │   │ (ML Services)│
└──────┬───────┘   └──────────────┘
       │
       ▼
┌──────────────┐
│   Response   │ (DTO)
└──────────────┘
```

### 3.3. Security Flow

```
Request
  │
  ▼
JwtAuthenticationFilter
  │
  ├─ Extract Token
  ├─ Validate Token
  └─ Load User Details
      │
      ▼
SecurityConfig
  │
  ├─ Check Role
  ├─ Check Permissions
  └─ Allow/Deny
      │
      ▼
Controller
```

---

## 4. KIẾN TRÚC FRONTEND

### 4.1. Cấu trúc Thư mục

```
src/
├── api/                    # API calls
│   ├── alertApi.js
│   ├── farmApi.js
│   └── sensorApi.js
│
├── components/
│   ├── common/            # Shared components
│   ├── layout/            # Layout components
│   └── features/          # Feature-specific
│       ├── farm/
│       ├── sensor/
│       └── alert/
│
├── hooks/                 # Custom React hooks
│   ├── useSensorData.js
│   └── useWebSocket.js
│
├── pages/                 # Page components
│   ├── dashboard/
│   ├── farm/
│   └── sensor/
│
├── services/              # Business logic
│   ├── websocketService.js
│   └── ...
│
├── utils/                 # Utilities
│   ├── apiClient.js
│   ├── errorHandler.js
│   └── validators.js
│
└── config/                # Configuration
    └── api.config.js
```

### 4.2. Data Flow trong Frontend

```
User Action
    │
    ▼
Component
    │
    ├─→ Hook (useSensorData)
    │       │
    │       ▼
    │   API Service
    │       │
    │       ▼
    │   HTTP Request
    │
    └─→ WebSocket Service
            │
            ▼
        Real-time Update
            │
            ▼
        Component Re-render
```

---

## 5. LUỒNG XỬ LÝ CHI TIẾT

### 5.1. Luồng Alert System

```
Sensor Data
    │
    ▼
AlertSchedulerService (Cron Job)
    │
    ├─ Read Sensor Data
    ├─ Compare with Thresholds
    ├─ Check Alert Rules
    └─ Create Alert if needed
        │
        ├─→ Save to Database
        │
        └─→ Send Email (if enabled)
            │
            └─→ Push via WebSocket
                │
                ▼
            Frontend Display
```

### 5.2. Luồng Crop Recommendation

```
User Input (N, P, K, pH, etc.)
    │
    ▼
Frontend
    │
    │ HTTP POST
    ▼
Backend (CropRecommendationController)
    │
    │ HTTP POST
    ▼
Crop ML Service (Flask)
    │
    ├─ Load Model (RandomForest)
    ├─ Preprocess Input
    ├─ Predict
    └─ Return Result
        │
        ▼
Backend
    │
    ▼
Frontend (Display Recommendation)
```

### 5.3. Luồng Pest Detection

```
User Upload Image
    │
    ▼
Frontend
    │
    │ FormData
    ▼
Backend (PestDiseaseController)
    │
    │ HTTP POST
    ▼
Pest ML Service (Flask)
    │
    ├─ Load Model (ViT)
    ├─ Preprocess Image
    ├─ Predict
    └─ Return (class, confidence)
        │
        ▼
Backend
    │
    ▼
Frontend (Display Result + Treatment)
```

---

## 6. CÔNG NGHỆ SỬ DỤNG

### 6.1. Backend Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Framework | Spring Boot | 3.4.4 |
| Language | Java | 17+ |
| Database | PostgreSQL | 15+ |
| ORM | Hibernate/JPA | - |
| Security | Spring Security + JWT | - |
| WebSocket | Spring WebSocket | - |
| Build Tool | Maven | 3.8+ |

### 6.2. Frontend Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Framework | React | 18.2.0 |
| UI Library | Material-UI | 5.17.1 |
| Routing | React Router | 6.22.1 |
| HTTP Client | Axios | 1.6.7 |
| Charts | Chart.js | 4.4.9 |
| Build Tool | npm | 8+ |

### 6.3. ML Services Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Framework | Flask | 3.0.0 |
| Language | Python | 3.10+ |
| Crop ML | scikit-learn | 0.24.2 |
| Pest ML | PyTorch | 2.0.1 |
| Model | Vision Transformer | - |

### 6.4. DevOps Stack

| Component | Technology |
|-----------|-----------|
| Containerization | Docker |
| Orchestration | Docker Compose |
| Reverse Proxy | Nginx |
| Web Server | Nginx (Frontend) |

---

## 📝 GHI CHÚ

- Tài liệu này sẽ được cập nhật khi có thay đổi trong kiến trúc
- Để xem chi tiết implementation, tham khảo code trong từng module
- Để deploy, xem `INSTALLATION.md` và `DEPLOY_GUIDE.md`

---

**Version:** 1.0  
**Last Updated:** 2025-01-20  
**Author:** SmartFarm Development Team





