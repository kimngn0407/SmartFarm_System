# 📁 Cấu trúc Dự án - SmartFarm

Tài liệu này giải thích chi tiết cấu trúc thư mục và tổ chức mã nguồn của SmartFarm System.

---

## 📋 Mục lục

- [Tổng quan cấu trúc](#-tổng-quan-cấu-trúc)
- [Frontend Applications](#-frontend-applications)
- [Backend Services](#-backend-services)
- [IoT & Blockchain](#-iot--blockchain)
- [Docker & Deployment](#-docker--deployment)
- [Documentation](#-documentation)
- [Configuration Files](#-configuration-files)

---

## 🗂️ Tổng quan cấu trúc

```
SmartFarm/
│
├── 📱 Frontend Applications/
│   ├── J2EE_Frontend/              # React Web Application
│   └── AI_SmartFarm_CHatbot/       # Next.js AI Chatbot
│
├── 🔧 Backend Services/
│   ├── demoSmartFarm/demo/         # Spring Boot REST API
│   ├── RecommentCrop/              # Crop Recommendation ML
│   └── PestAndDisease/             # Pest Detection ML
│
├── 🔗 IoT & Blockchain/
│   └── SmartContract/              # Smart Contracts & IoT
│
├── 🐳 Docker & Deployment/
│   ├── docker-compose.yml
│   ├── deploy.sh
│   └── nginx/
│
├── 📚 Documentation/
│   ├── README.md
│   ├── INSTALLATION.md
│   └── ...
│
└── 🗄️ Database/
    ├── DB_SM_ver1.sql
    └── add_alert_columns.sql
```

---

## 📱 Frontend Applications

### 1. J2EE_Frontend/ (React Web Application)

**Tech Stack:** React 18, Material-UI, Chart.js

```
J2EE_Frontend/
├── public/                         # Static files
│   ├── index.html
│   └── favicon.ico
│
├── src/
│   ├── components/                 # Reusable components
│   │   ├── MenuBar.js             # Sidebar navigation
│   │   ├── ApiStatusIndicator.js  # API status
│   │   └── ...
│   │
│   ├── pages/                      # Page components
│   │   ├── dashboard/             # Dashboard page
│   │   ├── alert/                 # Alert management
│   │   ├── farm/                  # Farm management
│   │   ├── field/                 # Field management
│   │   ├── sensor/                # Sensor management
│   │   ├── crop/                  # Crop features
│   │   │   ├── CropRecommendation.js
│   │   │   └── PestDetection.js
│   │   └── ...
│   │
│   ├── services/                   # API services
│   │   ├── alertService.js
│   │   ├── farmService.js
│   │   ├── sensorService.js
│   │   └── ...
│   │
│   ├── config/                     # Configuration
│   │   └── api.config.js          # API endpoints
│   │
│   ├── utils/                      # Utility functions
│   │   └── formatters.js          # Data formatters
│   │
│   ├── App.js                      # Main app component
│   └── index.js                    # Entry point
│
├── package.json                    # Dependencies
├── Dockerfile                      # Docker build
└── nginx.conf                      # Nginx config
```

**Key Files:**
- `src/App.js` - Main application router
- `src/config/api.config.js` - API configuration
- `src/services/*.js` - API service layer
- `src/pages/*/` - Page components

### 2. AI_SmartFarm_CHatbot/ (Next.js AI Chatbot)

**Tech Stack:** Next.js 15, TypeScript, Google Gemini AI

```
AI_SmartFarm_CHatbot/
├── src/
│   ├── app/                        # Next.js app directory
│   │   ├── page.tsx               # Main page
│   │   ├── embed/                 # Embed page
│   │   └── layout.tsx             # Root layout
│   │
│   ├── components/                 # React components
│   │   ├── ui/                    # UI components (Radix UI)
│   │   ├── chatbot-widget.tsx     # Chatbot widget
│   │   └── ...
│   │
│   ├── ai/                         # AI integration
│   │   ├── genkit.ts              # Genkit config
│   │   └── flows/                 # AI flows
│   │
│   ├── lib/                        # Utilities
│   └── types/                      # TypeScript types
│
├── public/                         # Static assets
├── package.json
└── Dockerfile
```

**Key Files:**
- `src/app/page.tsx` - Main chatbot page
- `src/ai/genkit.ts` - Google Genkit configuration
- `src/components/chatbot-widget.tsx` - Reusable widget

---

## 🔧 Backend Services

### 1. demoSmartFarm/demo/ (Spring Boot Backend)

**Tech Stack:** Java 17, Spring Boot 3.4.4, PostgreSQL, JWT

```
demoSmartFarm/demo/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── Controllers/       # REST Controllers
│   │   │   │   ├── AlertController.java
│   │   │   │   ├── FarmController.java
│   │   │   │   ├── FieldController.java
│   │   │   │   └── ...
│   │   │   │
│   │   │   ├── Services/           # Business Logic
│   │   │   │   ├── AlertService.java
│   │   │   │   ├── AlertSchedulerService.java
│   │   │   │   ├── EmailService.java
│   │   │   │   └── ...
│   │   │   │
│   │   │   ├── Repositories/      # Data Access
│   │   │   │   ├── AlertRepository.java
│   │   │   │   ├── SensorRepository.java
│   │   │   │   └── ...
│   │   │   │
│   │   │   ├── Entities/           # JPA Entities
│   │   │   │   ├── AlertEntity.java
│   │   │   │   ├── SensorEntity.java
│   │   │   │   └── ...
│   │   │   │
│   │   │   ├── DTO/               # Data Transfer Objects
│   │   │   │   ├── AlertResponseDTO.java
│   │   │   │   └── ...
│   │   │   │
│   │   │   ├── Config/             # Configuration
│   │   │   │   ├── SecurityConfig.java
│   │   │   │   └── WebSocketConfig.java
│   │   │   │
│   │   │   └── DemoSmartFarm.java  # Main class
│   │   │
│   │   └── resources/
│   │       ├── application.properties      # Dev config
│   │       ├── application-prod.properties # Prod config
│   │       ├── templates/                  # Email templates
│   │       │   └── alert-email.html
│   │       └── db/migration/              # DB migrations
│   │
│   └── test/                      # Unit tests
│
├── pom.xml                        # Maven dependencies
└── Dockerfile
```

**Key Packages:**
- `Controllers/` - REST API endpoints
- `Services/` - Business logic layer
- `Repositories/` - Data access layer
- `Entities/` - Database entities
- `DTO/` - Data transfer objects

### 2. RecommentCrop/ (Crop Recommendation ML)

**Tech Stack:** Python 3.10, Flask, scikit-learn

```
RecommentCrop/
├── crop_recommendation_service.py  # Main Flask app
├── RandomForest_RecomentTree.pkl   # Trained model (2.3MB)
├── requirements.txt                 # Python dependencies
└── Dockerfile
```

**Key Features:**
- REST API với Flask
- RandomForest Classifier
- 22 loại cây trồng
- Health check endpoint

### 3. PestAndDisease/ (Pest Detection ML)

**Tech Stack:** Python 3.10, Flask, PyTorch, Vision Transformer

```
PestAndDisease/
├── pest_disease_service.py         # Main Flask app
├── best_vit_wheat_model_4classes.pth  # Trained model (343MB)
├── requirements.txt                 # Python dependencies
└── Dockerfile
```

**Key Features:**
- REST API với Flask
- Vision Transformer (ViT-B/16)
- 4 loại sâu bệnh
- Image upload & processing

---

## 🔗 IoT & Blockchain

### SmartContract/

```
SmartContract/
├── flask-api/                      # Flask API for sensor data
│   ├── app.py                      # Main API
│   ├── requirements.txt
│   └── schema-extra.sql
│
├── device/                         # Arduino forwarder
│   ├── forwarder.py               # Serial forwarder
│   ├── forwarder_auto.py          # Auto forwarder
│   └── venv/                      # Python venv
│
├── oracle-node/                    # Blockchain oracle
│   ├── server.js
│   └── package.json
│
├── contracts/                      # Smart contracts
│   └── SensorOracle.sol
│
├── scripts/                        # Deployment scripts
│   ├── deploy.js
│   └── check-balance.js
│
└── README.md
```

**Key Components:**
- `flask-api/` - REST API nhận data từ Arduino
- `device/` - Forwarder gửi data từ Arduino lên API
- `oracle-node/` - Oracle node cho blockchain
- `contracts/` - Solidity smart contracts

---

## 🐳 Docker & Deployment

### docker-compose.yml

Định nghĩa tất cả services:
- PostgreSQL database
- Spring Boot backend
- React frontend
- Next.js chatbot
- Crop ML service
- Pest ML service
- Nginx reverse proxy

### deploy.sh

Script tự động deploy:
- Build Docker images
- Start services
- Health checks

### rebuild.sh

Script rebuild tất cả:
- Rebuild Docker images
- Rebuild Python venv
- Restart services

---

## 📚 Documentation

### Core Documentation

| File | Mô tả |
|------|-------|
| `README.md` | Tổng quan dự án |
| `INSTALLATION.md` | Hướng dẫn cài đặt chi tiết |
| `PROJECT_STRUCTURE.md` | File này - Cấu trúc dự án |
| `DEPLOY_GUIDE.md` | Hướng dẫn deployment |

### Feature Documentation

| File | Mô tả |
|------|-------|
| `EMAIL_SETUP_GUIDE.md` | Cấu hình email |
| `ALERT_MIGRATION_GUIDE.md` | Database migration |
| `REBUILD_INSTRUCTIONS.md` | Hướng dẫn rebuild |

### Quick References

| File | Mô tả |
|------|-------|
| `QUICK_EMAIL_UPDATE.md` | Cập nhật email nhanh |
| `VPS_EMAIL_SETUP_STEP_BY_STEP.md` | Setup email trên VPS |

---

## ⚙️ Configuration Files

### Backend Configuration

**application.properties** (Development)
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/SmartFarm1
spring.jpa.hibernate.ddl-auto=update
```

**application-prod.properties** (Production)
```properties
spring.datasource.url=jdbc:postgresql://postgres:5432/SmartFarm1
spring.jpa.show-sql=false
```

### Frontend Configuration

**.env**
```env
REACT_APP_API_URL=http://localhost:8080
REACT_APP_GOOGLE_MAPS_API_KEY=...
```

### Docker Configuration

**docker-compose.yml**
- Environment variables
- Port mappings
- Volume mounts
- Network configuration

---

## 📦 Module Organization

### Separation of Concerns

1. **Frontend** - UI/UX layer
2. **Backend** - Business logic & API
3. **ML Services** - Machine Learning models
4. **IoT** - Sensor data collection
5. **Blockchain** - Data verification

### Communication Flow

```
Frontend → Backend API → Database
                ↓
         ML Services (Crop/Pest)
                ↓
         IoT Sensors → Blockchain
```

---

## 🔍 File Naming Conventions

### Java (Backend)
- **Controllers**: `*Controller.java`
- **Services**: `*Service.java`
- **Repositories**: `*Repository.java`
- **Entities**: `*Entity.java`
- **DTOs**: `*DTO.java`

### JavaScript/TypeScript (Frontend)
- **Components**: `PascalCase.js` / `PascalCase.tsx`
- **Services**: `camelCaseService.js`
- **Utils**: `camelCase.js`

### Python (ML Services)
- **Main files**: `snake_case_service.py`
- **Config files**: `snake_case.py`

---

## 📝 Best Practices

### 1. Code Organization
- Mỗi module trong thư mục riêng
- Services tách biệt concerns
- Reusable components trong `components/`

### 2. Configuration
- Environment variables cho sensitive data
- Separate configs cho dev/prod
- `.env.example` files cho reference

### 3. Documentation
- README trong mỗi module
- Code comments cho complex logic
- API documentation

### 4. Version Control
- `.gitignore` đầy đủ
- Không commit secrets
- Meaningful commit messages

---

## 🎯 Quick Navigation

| Mục đích | Đi đến |
|----------|--------|
| Cài đặt | [`INSTALLATION.md`](INSTALLATION.md) |
| Deploy | [`DEPLOY_GUIDE.md`](DEPLOY_GUIDE.md) |
| Cấu hình Email | [`EMAIL_SETUP_GUIDE.md`](EMAIL_SETUP_GUIDE.md) |
| Rebuild | [`REBUILD_INSTRUCTIONS.md`](REBUILD_INSTRUCTIONS.md) |

---

**Cấu trúc này giúp dự án dễ maintain và scale! 🚀**

