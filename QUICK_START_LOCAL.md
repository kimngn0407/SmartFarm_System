# 🚀 Quick Start - Chạy trên Local

## ✅ Kiểm tra nhanh

Chạy script kiểm tra:
```bash
node test-local-config.js
```

## 📝 Checklist trước khi chạy

### 1. Frontend (React)
- [x] File `.env` đã có với `REACT_APP_API_URL=http://localhost:8080`
- [x] `api.config.js` đã tự động detect localhost
- [x] `SmartFarmChatbot.js` đã tự động detect localhost

### 2. Backend (Spring Boot)
- [x] `application.properties` đã cấu hình localhost:5432 cho database
- [x] `server.port=8080` đã được thêm vào
- [x] CORS đã hỗ trợ localhost:3000 (trong CorsConfig.java)

### 3. Database (PostgreSQL)
- [ ] PostgreSQL đang chạy trên port 5432
- [ ] Database `SmartFarm1` đã được tạo
- [ ] Username: `postgres`, Password: `Ngan0407@!`

## 🎯 Các bước chạy

### Bước 1: Start PostgreSQL
```bash
# Nếu dùng Docker (Windows PowerShell - dùng một dòng)
docker run -d --name postgres -e POSTGRES_PASSWORD=Ngan0407@! -e POSTGRES_DB=SmartFarm1 -p 5432:5432 postgres:15-alpine

# Hoặc nếu dùng CMD/Git Bash (có thể dùng nhiều dòng với \)
docker run -d --name postgres \
  -e POSTGRES_PASSWORD=Ngan0407@! \
  -e POSTGRES_DB=SmartFarm1 \
  -p 5432:5432 \
  postgres:15-alpine

# Hoặc nếu đã cài PostgreSQL
# Đảm bảo service đang chạy
```

### Bước 2: Start Backend
```bash
cd demoSmartFarm/demo
mvn spring-boot:run
```

Kiểm tra: http://localhost:8080/api/auth/health

### Bước 3: Start Frontend
```bash
cd J2EE_Frontend
npm start
```

Frontend sẽ mở tại: http://localhost:3000

### Bước 4: Start AI Chatbot (Tùy chọn)
```bash
cd AI_SmartFarm_CHatbot

# Kiểm tra file .env.local (nếu chưa có thì tạo)
# GOOGLE_GENAI_API_KEY=your-api-key-here
# NEXT_PUBLIC_API_URL=http://localhost:8080

npm install  # Nếu chưa cài
npm run dev
```

Chatbot sẽ mở tại: http://localhost:9002

### Bước 5: Start ML Services (Tùy chọn)

#### 5.1. Crop Recommendation Service (Port 5000)
```bash
cd RecommentCrop

# Tạo virtual environment (nếu chưa có)
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/Mac:
# source venv/bin/activate

# Cài đặt dependencies
pip install -r requirements.txt

# Chạy service
python crop_recommendation_service.py
```

Service chạy tại: http://localhost:5000

#### 5.2. Pest & Disease Detection Service (Port 5001)
```bash
cd PestAndDisease

# Tạo virtual environment (nếu chưa có)
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/Mac:
# source venv/bin/activate

# Cài đặt dependencies (có thể mất vài phút vì cần cài PyTorch)
pip install -r requirements.txt

# Chạy service
python pest_disease_service.py
```

Service chạy tại: http://localhost:5001

## 🔍 Kiểm tra kết nối

### 1. Kiểm tra Backend
```bash
curl http://localhost:8080/api/auth/health
```

### 2. Kiểm tra Frontend
Mở browser: http://localhost:3000
- Kiểm tra console (F12) xem có lỗi CORS không
- Kiểm tra Network tab xem API calls có đúng URL không

### 3. Kiểm tra Database
```bash
psql -U postgres -d SmartFarm1 -c "\dt"
```

## ⚠️ Xử lý lỗi thường gặp

### Lỗi: "Cannot connect to database"
- Kiểm tra PostgreSQL đang chạy: `pg_isready -U postgres`
- Kiểm tra password trong `application.properties`

### Lỗi: "CORS policy"
- Kiểm tra backend đang chạy
- Kiểm tra `CorsConfig.java` có cho phép `localhost:3000`
- Restart backend

### Lỗi: "API call failed"
- Kiểm tra `.env` file có `REACT_APP_API_URL=http://localhost:8080`
- Kiểm tra backend đang chạy trên port 8080
- Xem console browser để kiểm tra URL được gọi

## 📊 Thứ tự khởi động

1. **PostgreSQL** → Port 5432
2. **Backend** → Port 8080
3. **Frontend** → Port 3000
4. **AI Chatbot** (tùy chọn) → Port 9002
5. **ML Services** (tùy chọn):
   - Crop Recommendation → Port 5000
   - Pest Detection → Port 5001

## 🎉 Hoàn tất!

Nếu tất cả đều chạy, bạn sẽ thấy:
- ✅ Backend API: http://localhost:8080
- ✅ Frontend UI: http://localhost:3000
- ✅ AI Chatbot: http://localhost:9002 (nếu có)
- ✅ Crop Recommendation: http://localhost:5000 (nếu có)
- ✅ Pest Detection: http://localhost:5001 (nếu có)

---

**Lưu ý:** Tất cả cấu hình đã được tự động detect localhost khi chạy ở development mode!

