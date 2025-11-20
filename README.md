# 🌾 SmartFarm - Hệ Thống Nông Nghiệp Thông Minh

> **Hệ thống quản lý nông trại đầy đủ với AI Chatbot, Machine Learning, IoT Sensors, và Blockchain**

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()
[![Java](https://img.shields.io/badge/Java-17-orange.svg)]()
[![Node](https://img.shields.io/badge/Node.js-18+-green.svg)]()
[![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)]()

---

## 📋 Mục lục

- [Tổng quan](#-tổng-quan)
- [Tính năng](#-tính-năng-chính)
- [Kiến trúc hệ thống](#-kiến-trúc-hệ-thống)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [Yêu cầu hệ thống](#-yêu-cầu-hệ-thống)
- [Hướng dẫn cài đặt](#-hướng-dẫn-cài-đặt)
- [Cấu hình](#-cấu-hình)
- [Chạy dự án](#-chạy-dự-án)
- [Deployment](#-deployment)
- [Tài liệu](#-tài-liệu)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 Tổng quan

SmartFarm là hệ thống quản lý nông trại thông minh tích hợp:
- **AI Chatbot** - Tư vấn nông nghiệp thông minh với Google Gemini
- **Machine Learning** - Gợi ý cây trồng và nhận diện sâu bệnh
- **IoT Sensors** - Thu thập dữ liệu realtime từ cảm biến
- **Blockchain** - Lưu trữ dữ liệu sensor trên ZeroChain
- **Web Dashboard** - Quản lý và theo dõi nông trại

---

## ✨ Tính năng chính

### 🤖 AI Chatbot
- Tư vấn nông nghiệp thông minh
- Phân tích dữ liệu Excel
- Widget có thể embed
- Markdown rendering với syntax highlighting

### 🌱 Crop Recommendation
- Gợi ý cây trồng dựa trên điều kiện môi trường
- Machine Learning: RandomForest Classifier
- Hỗ trợ 22 loại cây trồng
- Batch prediction

### 🐛 Pest & Disease Detection
- Nhận diện sâu bệnh qua ảnh
- Vision Transformer (ViT-B/16)
- 4 loại: Aphid, Blast, Septoria, Smut
- Confidence score + khuyến nghị xử lý

### 📊 Farm Management
- Quản lý nông trại, khu vực, cây trồng
- Theo dõi sensor data (nhiệt độ, độ ẩm, đất, ánh sáng)
- Quản lý mùa vụ và thu hoạch
- Phân tích doanh thu

### 🔔 Alert System
- Cảnh báo tự động khi sensor vượt ngưỡng
- Email notifications
- WebSocket realtime updates
- Phân loại: Critical, Warning, Good

### 🔗 IoT Integration
- Kết nối Arduino/ESP8266/ESP32
- Thu thập dữ liệu realtime
- Lưu trữ trên Blockchain
- Forwarder service tự động

---

## 🏗️ Kiến trúc hệ thống

```
┌─────────────────────────────────────────────────────────────┐
│                      USER INTERFACE                          │
├─────────────────────────────────────────────────────────────┤
│  React Frontend (Port 3000)  │  Next.js Chatbot (Port 9002) │
└──────────────┬───────────────────────┬───────────────────────┘
               │                       │
               │ HTTP/REST             │ HTTP/REST
               │                       │
┌──────────────▼───────────────────────▼───────────────────────┐
│              Spring Boot Backend API (Port 8080)             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │  Auth    │  │  Farm    │  │  Sensor  │  │  Alert   │     │
│  │  Service │  │  Service │  │  Service │  │  Service │     │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘     │
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
│              IoT & Blockchain Layer                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Arduino     │  │  Flask API   │  │  ZeroChain   │      │
│  │  Sensors     │  │  (Port 8000) │  │  Blockchain  │      │
│  │  (ESP8266)   │  │              │  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└──────────────────────────────────────────────────────────────┘
```

---

## 📁 Cấu trúc dự án

```
SmartFarm/
├── 📱 Frontend Applications
│   ├── J2EE_Frontend/              # React Frontend (Material-UI)
│   └── AI_SmartFarm_CHatbot/       # Next.js AI Chatbot
│
├── 🔧 Backend Services
│   ├── demoSmartFarm/demo/         # Spring Boot Backend API
│   ├── RecommentCrop/              # Crop Recommendation ML Service
│   └── PestAndDisease/             # Pest Detection ML Service
│
├── 🔗 IoT & Blockchain
│   └── SmartContract/              # Smart Contracts & IoT Integration
│       ├── flask-api/              # Flask API for sensor data
│       ├── device/                 # Arduino forwarder
│       ├── oracle-node/            # Blockchain oracle
│       └── contracts/              # Solidity smart contracts
│
├── 🐳 Docker & Deployment
│   ├── docker-compose.yml          # Docker Compose configuration
│   ├── deploy.sh                   # Deployment script
│   └── nginx/                      # Nginx configuration
│
├── 📚 Documentation
│   ├── README.md                   # This file
│   ├── INSTALLATION.md             # Detailed installation guide
│   ├── PROJECT_STRUCTURE.md        # Project structure explanation
│   ├── DEPLOY_GUIDE.md             # Deployment guide
│   ├── EMAIL_SETUP_GUIDE.md        # Email configuration
│   └── ...                         # Other documentation files
│
├── 🗄️ Database
│   ├── DB_SM_ver1.sql              # Database schema
│   └── add_alert_columns.sql       # Migration scripts
│
└── 🔧 Configuration & Scripts
    ├── .gitignore                  # Git ignore rules
    └── ...                         # Other utility scripts
```

> **📖 Xem chi tiết:** [`PROJECT_STRUCTURE.md`](PROJECT_STRUCTURE.md)

---

## 💻 Yêu cầu hệ thống

### Minimum Requirements

| Component | Requirement | Version |
|-----------|-------------|---------|
| **Java** | JDK | 17+ |
| **Node.js** | Runtime | 18+ |
| **Python** | Runtime | 3.10+ |
| **PostgreSQL** | Database | 15+ |
| **Docker** | Container | 20.10+ |
| **Docker Compose** | Orchestration | 2.0+ |
| **Maven** | Build Tool | 3.8+ |
| **npm** | Package Manager | 8+ |

### Recommended Specifications

- **CPU**: 4 cores+
- **RAM**: 8GB+ (4GB minimum)
- **Storage**: 20GB+ free space
- **OS**: Linux (Ubuntu 20.04+), Windows 10+, macOS 12+

---

## 🚀 Hướng dẫn cài đặt

### Quick Start (Docker - Khuyến nghị)

```bash
# 1. Clone repository
git clone https://github.com/kimngn0407/SmartFarmSystem.git
cd SmartFarm

# 2. Cấu hình environment (nếu cần)
cp .env.example .env
# Chỉnh sửa .env với thông tin của bạn

# 3. Build và chạy tất cả services
docker-compose up -d --build

# 4. Kiểm tra services
docker-compose ps
```

**Truy cập:**
- Frontend: http://localhost:80
- Backend API: http://localhost:8080
- Chatbot: http://localhost:9002
- Crop ML: http://localhost:5000
- Pest ML: http://localhost:5001

### Manual Installation

> **📖 Xem hướng dẫn chi tiết:** [`INSTALLATION.md`](INSTALLATION.md)

#### 1. Backend (Spring Boot)

```bash
cd demoSmartFarm/demo

# Cài đặt dependencies
mvn clean install

# Chạy application
mvn spring-boot:run
```

**Dependencies chính:**
- Spring Boot 3.4.4
- Spring Data JPA
- Spring Security
- PostgreSQL Driver
- JWT (jjwt)
- Thymeleaf (Email templates)
- WebSocket

#### 2. Frontend (React)

```bash
cd J2EE_Frontend

# Cài đặt dependencies
npm install

# Chạy development server
npm start
```

**Dependencies chính:**
- React 18.2.0
- Material-UI 5.17.1
- React Router 6.22.1
- Axios 1.6.7
- Chart.js 4.4.9
- React Chart.js 2 5.3.0

#### 3. AI Chatbot (Next.js)

```bash
cd AI_SmartFarm_CHatbot

# Cài đặt dependencies
npm install

# Chạy development server
npm run dev
```

**Dependencies chính:**
- Next.js 15.3.3
- React 18.3.1
- Google Genkit 1.14.1
- Tailwind CSS 3.4.1
- Radix UI Components

#### 4. Crop Recommendation ML Service

```bash
cd RecommentCrop

# Tạo virtual environment
python -m venv .venv

# Activate (Windows)
.venv\Scripts\activate
# Activate (Linux/Mac)
source .venv/bin/activate

# Cài đặt dependencies
pip install -r requirements.txt

# Chạy service
python crop_recommendation_service.py
```

**Dependencies:**
- Flask 3.0.0
- Flask-CORS 4.0.0
- scikit-learn 0.24.2
- NumPy 1.24.3
- Joblib 1.0.1

#### 5. Pest Detection ML Service

```bash
cd PestAndDisease

# Tạo virtual environment
python -m venv .venv

# Activate
.venv\Scripts\activate  # Windows
source .venv/bin/activate  # Linux/Mac

# Cài đặt dependencies
pip install -r requirements.txt

# Chạy service
python pest_disease_service.py
```

**Dependencies:**
- Flask 2.3.3
- Flask-CORS 4.0.0
- PyTorch 2.0.1
- Torchvision 0.15.2
- timm 0.9.7
- Pillow 10.0.0
- NumPy 1.24.3

#### 6. Database Setup

```bash
# Tạo database
createdb SmartFarm1

# Import schema
psql -U postgres -d SmartFarm1 -f DB_SM_ver1.sql

# Chạy migrations (nếu có)
psql -U postgres -d SmartFarm1 -f add_alert_columns.sql
```

---

## ⚙️ Cấu hình

### Environment Variables

#### Backend (Spring Boot)

Tạo file `demoSmartFarm/demo/src/main/resources/application.properties`:

```properties
# Database
spring.datasource.url=jdbc:postgresql://localhost:5432/SmartFarm1
spring.datasource.username=postgres
spring.datasource.password=your_password

# JWT
jwt.secret=your-secret-key
jwt.expiration=86400000

# External Services
crop.recommendation.url=http://localhost:5000
pest.disease.url=http://localhost:5001

# Email (Optional)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password
app.mail.from=your-email@gmail.com
```

#### Frontend

Tạo file `J2EE_Frontend/.env`:

```env
REACT_APP_API_URL=http://localhost:8080
REACT_APP_RENDER_API_BASE=http://localhost:8080
REACT_APP_GOOGLE_MAPS_API_KEY=your-google-maps-api-key
```

#### AI Chatbot

Tạo file `AI_SmartFarm_CHatbot/.env.local`:

```env
GOOGLE_GENAI_API_KEY=your-google-genai-api-key
NEXT_PUBLIC_API_URL=http://localhost:8080
```

#### IoT & Blockchain

Tạo file `SmartContract/flask-api/.env`:

```env
DB_URL=postgresql://postgres:password@localhost:5432/SmartFarm1
API_KEY=MY_API_KEY
ORACLE_URL=http://localhost:5001/oracle/push
TEMP_SENSOR_ID=7
HUMID_SENSOR_ID=8
SOIL_SENSOR_ID=9
LIGHT_SENSOR_ID=10
```

> **📖 Xem chi tiết:** [`INSTALLATION.md`](INSTALLATION.md)

---

## 🏃 Chạy dự án

### Development Mode

#### Option 1: Docker Compose (Khuyến nghị)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

#### Option 2: Manual (Từng service)

```bash
# Terminal 1: Backend
cd demoSmartFarm/demo
mvn spring-boot:run

# Terminal 2: Frontend
cd J2EE_Frontend
npm start

# Terminal 3: Chatbot
cd AI_SmartFarm_CHatbot
npm run dev

# Terminal 4: Crop ML
cd RecommentCrop
.venv\Scripts\activate
python crop_recommendation_service.py

# Terminal 5: Pest ML
cd PestAndDisease
.venv\Scripts\activate
python pest_disease_service.py
```

### Production Mode

```bash
# Build và deploy
./deploy.sh

# Hoặc manual
docker-compose -f docker-compose.yml up -d --build
```

---

## 🌐 Deployment

### VPS Deployment

> **📖 Xem hướng dẫn chi tiết:** [`DEPLOY_GUIDE.md`](DEPLOY_GUIDE.md)

```bash
# 1. SSH vào VPS
ssh root@your-vps-ip

# 2. Clone repository
cd ~/projects
git clone https://github.com/kimngn0407/SmartFarmSystem.git SmartFarm
cd SmartFarm

# 3. Cấu hình environment
nano docker-compose.yml
# Cập nhật các biến môi trường

# 4. Deploy
./deploy.sh
```

### Email Configuration

> **📖 Xem hướng dẫn:** [`EMAIL_SETUP_GUIDE.md`](EMAIL_SETUP_GUIDE.md)

### Database Migration

> **📖 Xem hướng dẫn:** [`ALERT_MIGRATION_GUIDE.md`](ALERT_MIGRATION_GUIDE.md)

---

## 📚 Tài liệu

### Core Documentation

| File | Mô tả |
|------|-------|
| [`INSTALLATION.md`](INSTALLATION.md) | Hướng dẫn cài đặt chi tiết |
| [`PROJECT_STRUCTURE.md`](PROJECT_STRUCTURE.md) | Giải thích cấu trúc dự án |
| [`DEPLOY_GUIDE.md`](DEPLOY_GUIDE.md) | Hướng dẫn deployment |

### Feature Documentation

| File | Mô tả |
|------|-------|
| [`EMAIL_SETUP_GUIDE.md`](EMAIL_SETUP_GUIDE.md) | Cấu hình email alerts |
| [`ALERT_MIGRATION_GUIDE.md`](ALERT_MIGRATION_GUIDE.md) | Database migration cho alerts |

### Quick References

| File | Mô tả |
|------|-------|
| [`QUICK_EMAIL_UPDATE.md`](QUICK_EMAIL_UPDATE.md) | Cập nhật email nhanh |

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Port already in use

```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:8080 | xargs kill -9
```

#### 2. Database connection error

- Kiểm tra PostgreSQL đang chạy
- Kiểm tra credentials trong `application.properties`
- Kiểm tra firewall/network

#### 3. Python dependencies error

```bash
# Rebuild virtual environment
cd RecommentCrop  # hoặc PestAndDisease
rm -rf .venv
python -m venv .venv
source .venv/bin/activate  # hoặc .venv\Scripts\activate trên Windows
pip install -r requirements.txt
```

#### 4. Docker build fails

```bash
# Clean và rebuild
docker-compose down
docker system prune -a
docker-compose build --no-cache
docker-compose up -d
```

#### 5. Email không gửi được

> **📖 Xem:** [`EMAIL_SETUP_GUIDE.md`](EMAIL_SETUP_GUIDE.md)

---

## 🛠️ Development

### Code Structure

- **Backend**: MVC pattern với Services, Repositories, Controllers
- **Frontend**: Component-based với hooks và services
- **ML Services**: RESTful API với Flask
- **IoT**: Event-driven architecture

### Testing

```bash
# Backend tests
cd demoSmartFarm/demo
mvn test

# Frontend tests
cd J2EE_Frontend
npm test
```

### Code Style

- **Java**: Follow Spring Boot conventions
- **JavaScript/TypeScript**: ESLint + Prettier
- **Python**: PEP 8

---

## 📊 API Endpoints

### Backend API (Port 8080)

| Endpoint | Method | Mô tả |
|----------|--------|-------|
| `/api/auth/login` | POST | Đăng nhập |
| `/api/auth/register` | POST | Đăng ký |
| `/api/farms` | GET/POST | Quản lý nông trại |
| `/api/fields` | GET/POST | Quản lý khu vực |
| `/api/sensors` | GET/POST | Quản lý cảm biến |
| `/api/alerts` | GET | Lấy danh sách cảnh báo |
| `/api/alerts/generate/now` | POST | Tạo alerts ngay |

### ML Services

| Service | Endpoint | Method | Mô tả |
|---------|----------|--------|-------|
| Crop ML | `/api/recommend-crop` | POST | Gợi ý cây trồng |
| Pest ML | `/api/detect` | POST | Nhận diện sâu bệnh |

> **📖 Xem đầy đủ:** API documentation trong từng service

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 👥 Team

SmartFarm Development Team

---

## 🙏 Acknowledgments

- Spring Boot Community
- React & Material-UI
- scikit-learn & PyTorch
- Google Gemini AI

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/kimngn0407/SmartFarmSystem/issues)
- **Documentation**: Xem các file `.md` trong repository

---

**Happy Farming! 🌾🚜**
