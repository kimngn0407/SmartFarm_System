# 🌾 SmartFarmSystem - Hệ Thống Nông Nghiệp Thông Minh

> **Hệ thống quản lý nông trại đầy đủ với AI Chatbot, Machine Learning, IoT Sensors, và Blockchain**

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()

---

## 🚀 NHANH! Bạn muốn làm gì?

| Mục đích | File để đọc | Thời gian |
|----------|-------------|-----------|
| 🏃 **Chạy LOCAL (Khuyên dùng!)** | [`START_HERE.txt`](START_HERE.txt) ⭐⭐ | 1 phút |
| 📖 **Hướng dẫn Local chi tiết** | [`HUONG_DAN_LOCAL.md`](HUONG_DAN_LOCAL.md) | 10 phút |
| 💰 **Chọn VPS giá rẻ (Sinh viên)** | [`VPS_CHOICE_GUIDE.md`](VPS_CHOICE_GUIDE.md) ⭐⭐ | 5 phút |
| 🌐 **Deploy lên VPS** | [`DEPLOYMENT_GUIDE.md`](DEPLOYMENT_GUIDE.md) | 30 phút |
| 💾 **Tối ưu VPS RAM thấp** | [`LOW_MEMORY_OPTIMIZATION.md`](LOW_MEMORY_OPTIMIZATION.md) | 10 phút |

---

## 🎯 Tính năng chính

- ✅ **AI Chatbot** - Tư vấn nông nghiệp thông minh
- ✅ **Crop Recommendation** - Gợi ý cây trồng dựa trên điều kiện môi trường
- ✅ **Pest & Disease Detection** - Nhận diện sâu bệnh qua ảnh
- ✅ **Farm Management** - Quản lý đồng ruộng, cây trồng
- ✅ **Sensor Integration** - Theo dõi nhiệt độ, độ ẩm, đất
- ✅ **Harvest Tracking** - Quản lý mùa vụ, doanh thu

---

## 📦 Cấu trúc hệ thống (9 thành phần)

| # | Thành phần | Tech Stack | Port/Network | Folder |
|---|------------|------------|--------------|--------|
| 1 | **Frontend** | React + Material-UI | 3000 | `J2EE_Frontend` |
| 2 | **Backend** | Java Spring Boot + Web3j | 8080 | `demoSmartFarm/demo` |
| 3 | **AI Chatbot** | Next.js + Google Gemini | 9002 | `AI_SmartFarm_CHatbot` |
| 4 | **ML Crop** | Python + Flask + RandomForest | 5000 | `RecommentCrop` |
| 5 | **ML Pest** | Python + Flask + ViT | 5001 | `PestAndDisease` |
| 6 | **Database** | PostgreSQL | 5432 | - |
| 7 | **Smart Contract** | Solidity/Rust | ZeroChain | - |
| 8 | **Arduino IoT** | C++ (ESP8266/ESP32) | WiFi | - |
| 9 | **Blockchain Listener** | Java (integrated) | - | - |

> **🔗 Xem kiến trúc chi tiết:** [`FULL_SYSTEM_ARCHITECTURE.md`](FULL_SYSTEM_ARCHITECTURE.md)

---

## 🏗️ Kiến trúc

```
┌─────────────────┐
│  Frontend React │ ← User Interface
│   (Port 3000)   │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼────┐  ┌▼─────────┐
│ Backend│  │ Chatbot  │
│  Java  │  │ Next.js  │
│ (8080) │  │  (9002)  │
└───┬────┘  └──────────┘
    │
    ├─────────┬─────────┐
    │         │         │
┌───▼──┐  ┌──▼───┐  ┌──▼───┐
│ Crop │  │ Pest │  │ IoT  │
│  ML  │  │  ML  │  │Sensor│
│(5000)│  │(5001)│  │      │
└──────┘  └──────┘  └──────┘
```

---

## 📋 Chi tiết module

### 1. 🤖 **AI SmartFarm Chatbot** (`AI_SmartFarm_CHatbot/`)
- **Tech:** Next.js 15, TypeScript, Google Gemini AI
- **Features:**
  - Tư vấn nông nghiệp thông minh
  - Phân tích dữ liệu Excel
  - Widget có thể embed
  - Markdown rendering với syntax highlighting
- **Run:** `start_chatbot.bat` hoặc `npm run dev`

### 2. 🌱 **Crop Recommendation** (`RecommentCrop/`)
- **Tech:** Python 3.10, Flask, scikit-learn (RandomForest)
- **Features:**
  - Gợi ý cây trồng dựa trên: Temperature, Humidity, Soil Moisture
  - REST API với health check
  - Batch prediction support
- **Run:** `CAI_LAI_SKLEARN.bat` hoặc `python crop_recommendation_service.py`

### 3. 🐛 **Pest & Disease Detection** (`PestAndDisease/`)
- **Tech:** Python 3.10, Flask, PyTorch, Vision Transformer (ViT-B/16)
- **Features:**
  - Nhận diện 4 loại sâu bệnh: Aphid, Blast, Septoria, Smut
  - Upload ảnh để phân tích
  - Confidence score + khuyến nghị xử lý
- **Run:** `MANUAL_RUN.bat` hoặc `python pest_disease_service.py`

### 4. ☕ **Backend API** (`demoSmartFarm/demo`)
- **Tech:** Java 17, Spring Boot 3, PostgreSQL, JWT Auth
- **Features:**
  - User authentication & authorization
  - Farm, Field, Crop management
  - Sensor data management
  - Harvest & Revenue tracking
  - Integration với ML services
- **Run:** `mvn spring-boot:run`

### 5. ⚛️ **Frontend** (`J2EE_Frontend`)
- **Tech:** React 18, Material-UI, React Router
- **Features:**
  - Responsive dashboard
  - Crop recommendation UI
  - Pest detection UI
  - Farm/Field management
  - Sensor data visualization
  - Revenue analytics
- **Run:** `npm start`

## 🚀 Quick Start - Local Development

### **Cách 1: Khởi động tất cả (Recommended)**

```bash
start_all_services.bat
```

Sau đó truy cập:
- Frontend: `http://localhost:3000`
- Chatbot: `http://localhost:9002`
- Backend: `http://localhost:8080`
- Crop ML: `http://localhost:5000`
- Pest ML: `http://localhost:5001`

### **Cách 2: Khởi động từng service**

```bash
# 1. Backend Java
cd demoSmartFarm/demo
mvn spring-boot:run

# 2. Frontend React
cd J2EE_Frontend
npm start

# 3. AI Chatbot
cd AI_SmartFarm_CHatbot
npm run dev

# 4. Crop Recommendation
cd RecommentCrop
CAI_LAI_SKLEARN.bat

# 5. Pest Detection
cd PestAndDisease
MANUAL_RUN.bat
```

---

## 🌐 Deploy lên Production

### **📖 Hướng dẫn đầy đủ:**

| Loại | File | Khi nào dùng |
|------|------|--------------|
| 🎓 **CHO NGƯỜI MỚI** | [`STEP_BY_STEP_DEPLOYMENT.md`](STEP_BY_STEP_DEPLOYMENT.md) | **BẮT ĐẦU TỪ ĐÂY!** Hướng dẫn từng click chuột, chưa làm bao giờ |
| ✅ **Checklist Đơn Giản** | [`DEPLOYMENT_CHECKLIST_SIMPLE.md`](DEPLOYMENT_CHECKLIST_SIMPLE.md) | In ra và tick từng bước |
| 🏗️ **Kiến trúc** | [`FULL_SYSTEM_ARCHITECTURE.md`](FULL_SYSTEM_ARCHITECTURE.md) | Hiểu cách hệ thống hoạt động (9 thành phần) |
| 🚀 **Deploy Hoàn Chỉnh** | [`COMPLETE_DEPLOYMENT_GUIDE.md`](COMPLETE_DEPLOYMENT_GUIDE.md) | Deploy Database, Blockchain, IoT (nâng cao) |
| ⚡ **Quick Reference** | [`QUICK_REFERENCE.md`](QUICK_REFERENCE.md) | Commands, endpoints, troubleshooting |
| 🔒 **CORS Setup** | [`CORS_SETUP.md`](CORS_SETUP.md) | ⭐ **MỚI!** Cấu hình CORS giữa Vercel ↔ Render ↔ Hugging Face |
| 🇻🇳 **CORS Hướng Dẫn Tiếng Việt** | [`HUONG_DAN_CORS.md`](HUONG_DAN_CORS.md) | ⭐ **MỚI!** Hướng dẫn chi tiết bằng tiếng Việt |

---

### **⚡ Quick Overview - Deployment Stack:**

```
┌─────────────────────────────────────────────┐
│           CLOUD INFRASTRUCTURE               │
├─────────────────────────────────────────────┤
│                                             │
│  Vercel (Free)                              │
│  ├─ Frontend React                          │
│  └─ AI Chatbot Next.js                      │
│                                             │
│  Railway ($5/month)                         │
│  ├─ Backend Java API                        │
│  ├─ PostgreSQL Database                     │
│  └─ Blockchain Listener                     │
│                                             │
│  Render (Free)                              │
│  ├─ ML Crop Recommendation                  │
│  └─ ML Pest Detection                       │
│                                             │
│  Pioneer ZeroChain (Blockchain)             │
│  └─ Smart Contract (Sensor Data)            │
│                                             │
│  On-Premise                                 │
│  └─ Arduino IoT Sensors (ESP8266/ESP32)     │
│                                             │
└─────────────────────────────────────────────┘
```

**Tổng chi phí: $0-5/tháng** ✅

**Kết quả:**
- ✅ Frontend: `https://smartfarm.vercel.app`
- ✅ Chatbot: `https://chatbot.vercel.app`
- ✅ Backend API: `https://api.up.railway.app`
- ✅ Database: Railway PostgreSQL
- ✅ Smart Contract: Deployed on ZeroChain
- ✅ Arduino: Gửi data realtime qua WiFi

## 📋 Requirements

### Crop Recommendation System
- **Python 3.8+** với virtual environment
- **Java 11+** và Maven
- **Node.js 14+** và npm

### AI Chatbot
- **Node.js 18+**
- **Next.js 14+**

## 🎯 Ports

| Service | Port | URL |
|---------|------|-----|
| Python ML API | 5000 | http://localhost:5000 |
| Spring Boot Backend | 8080 | http://localhost:8080 |
| React Frontend | 3000 | http://localhost:3000 |

## 📚 Documentation

### Crop Recommendation
- [Quick Start Guide](QUICK_START.md) - Bắt đầu trong 3 bước
- [Integration Guide](INTEGRATION_GUIDE.md) - Tích hợp chi tiết
- [Summary](CROP_RECOMMENDATION_SUMMARY.md) - Tổng quan toàn bộ
- [Python ML Service README](RecommentCrop/README.md) - Chi tiết ML service

### Backend
- [Completed Features](demoSmartFarm/SUMMARY_COMPLETED.md)

### Chatbot
- [Integration Guide](AI_SmartFarm_CHatbot/INTEGRATION_GUIDE.md)

## 🧪 Testing

### Test Model
```bash
cd RecommentCrop
.venv\Scripts\activate
python test_model.py
```

### Test API
```bash
cd RecommentCrop
.venv\Scripts\activate
python test_api.py
```

### Test Full Stack
1. Start all services: `start_all_services.bat`
2. Open browser: `http://localhost:3000/crop-recommendation`
3. Click "Điền dữ liệu mẫu"
4. Click "Gợi ý cây trồng"

## 🌱 Crop Recommendation Features

### Input Parameters
- **N, P, K**: Nitrogen, Phosphorus, Potassium (ppm)
- **Temperature**: Nhiệt độ (°C)
- **Humidity**: Độ ẩm (%)
- **pH**: Độ pH đất
- **Rainfall**: Lượng mưa (mm)

### Output
- **Recommended Crop**: Tên cây trồng được gợi ý
- **Confidence**: Độ tin cậy của dự đoán (0-100%)
- **Crop Code**: Mã số cây trồng

### Supported Crops (22 loại)
Lúa, Ngô, Đậu, Khoai tây, Cà chua, Dưa hấu, Đậu đỗ, Cà phê, Bông, Mía, Khoai lang, Lạc, Dứa, Chuối, Cam, Chanh, Táo, Xoài, Nho, Ớt, Gừng, Tỏi

## 📁 Project Structure

```
DoAnJ2EE/
├── AI_SmartFarm_CHatbot/        # Next.js Chatbot
├── RecommentCrop/               # Python ML Service
│   ├── RandomForest_RecomentTree.pkl
│   ├── crop_recommendation_service.py
│   ├── test_model.py
│   └── ...
├── demoSmartFarm/               # Spring Boot Backend
│   └── demo/src/main/java/...
├── J2EE_Frontend/               # React Frontend
│   └── src/
│       ├── services/cropRecommendationService.js
│       └── pages/crop/CropRecommendation.js
├── start_all_services.bat       # Auto start script
├── QUICK_START.md               # Quick start guide
└── README.md                    # This file
```

## 🔧 Development

### Setup Virtual Environment (Python)
```bash
cd RecommentCrop
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

### Setup Frontend
```bash
cd J2EE_Frontend
npm install
```

### Run Individually

**Python ML Service:**
```bash
cd RecommentCrop
.venv\Scripts\activate
python crop_recommendation_service.py
```

**Spring Boot:**
```bash
cd demoSmartFarm\demo
mvn spring-boot:run
```

**React:**
```bash
cd J2EE_Frontend
npm start
```

## 🐛 Troubleshooting

### Python ML Service không chạy
```bash
cd RecommentCrop
.venv\Scripts\activate
pip install -r requirements.txt --force-reinstall
python crop_recommendation_service.py
```

### Port bị chiếm
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F
```

### CORS Error
- ✅ **Đã cấu hình CORS tự động**: Xem [`CORS_SETUP.md`](CORS_SETUP.md) để biết chi tiết
- Set biến môi trường `FRONTEND_ORIGINS` trên Railway/Render/Vercel
- Test CORS: Chạy `test-cors.sh` (Linux/Mac) hoặc `test-cors.bat` (Windows)
- Kiểm tra browser console để xem lỗi cụ thể

## 🎓 Technologies Used

### Crop Recommendation
- **Machine Learning**: scikit-learn, RandomForest
- **Python API**: Flask, Flask-CORS
- **Backend**: Spring Boot, RestTemplate
- **Frontend**: React, Fetch API

### SmartFarm System
- **Backend**: Spring Boot, JPA, MySQL
- **Frontend**: React, Material UI
- **AI**: Next.js, Genkit

## 👥 Contributors

DoAnJ2EE Team

## 📄 License

MIT License

---

## 🎉 Getting Started

**Để bắt đầu với Crop Recommendation:**

```bash
# 1. Clone repository (nếu chưa có)
git clone <repository-url>
cd DoAnJ2EE

# 2. Setup Python environment
cd RecommentCrop
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
cd ..

# 3. Setup Frontend (nếu chưa)
cd J2EE_Frontend
npm install
cd ..

# 4. Start all services
start_all_services.bat

# 5. Open browser
# http://localhost:3000/crop-recommendation
```

**Đọc thêm:**
- [QUICK_START.md](QUICK_START.md) - Hướng dẫn nhanh
- [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) - Hướng dẫn tích hợp
- [TOM_TAT_CORS.md](TOM_TAT_CORS.md) - Cấu hình CORS 3 bước ⭐
- [HUONG_DAN_CORS.md](HUONG_DAN_CORS.md) - Hướng dẫn CORS chi tiết ⭐

**Happy Farming! 🌾🚜**
