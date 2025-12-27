# 🏠 Hướng dẫn Setup Local Development

## 📋 Yêu cầu hệ thống

- Docker và Docker Compose (khuyến nghị)
- Hoặc:
  - Node.js 18+
  - Java 17+ và Maven
  - PostgreSQL 15+
  - Python 3.9+

## 🚀 Cách 1: Docker Compose (Khuyến nghị)

### Bước 1: Tạo file `.env`

Tạo file `.env` ở thư mục gốc với nội dung:

```env
# Database Configuration
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=Ngan0407@!

# JWT Configuration
JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRATION=86400000

# Frontend Origins (CORS) - for local development
FRONTEND_ORIGINS=http://localhost:3000,http://localhost:80,http://localhost

# API URLs - for local development
REACT_APP_API_URL=http://localhost:8080
NEXT_PUBLIC_API_URL=http://localhost:8080

# Google GenAI API Key (cho Chatbot)
GOOGLE_GENAI_API_KEY=your-google-genai-api-key-here
```

### Bước 2: Chạy Docker Compose

```bash
# Build và start tất cả services
docker compose up -d --build

# Xem logs
docker compose logs -f

# Xem trạng thái
docker compose ps
```

### Bước 3: Kiểm tra services

```bash
# Backend
curl http://localhost:8080/api/auth/health

# Frontend
# Mở browser: http://localhost

# Chatbot
# Mở browser: http://localhost:9002

# Crop ML
curl http://localhost:5000/health

# Pest ML
curl http://localhost:5001/health
```

### Dừng services

```bash
docker compose down
```

## 🛠️ Cách 2: Chạy từng service thủ công

### Bước 1: Start PostgreSQL

```bash
# Windows PowerShell
docker run -d --name postgres -e POSTGRES_PASSWORD=Ngan0407@! -e POSTGRES_DB=SmartFarm1 -p 5432:5432 postgres:15-alpine

# Hoặc nếu đã cài PostgreSQL, đảm bảo service đang chạy
```

### Bước 2: Start Backend

```bash
cd demoSmartFarm/demo
mvn spring-boot:run
```

Backend chạy tại: http://localhost:8080

### Bước 3: Start Frontend

```bash
cd J2EE_Frontend

# Tạo file .env nếu chưa có
echo REACT_APP_API_URL=http://localhost:8080 > .env

npm install
npm start
```

Frontend chạy tại: http://localhost:3000

### Bước 4: Start AI Chatbot (Tùy chọn)

```bash
cd AI_SmartFarm_CHatbot

# Tạo file .env.local
echo GOOGLE_GENAI_API_KEY=your-api-key-here > .env.local
echo NEXT_PUBLIC_API_URL=http://localhost:8080 >> .env.local

npm install
npm run dev
```

Chatbot chạy tại: http://localhost:9002

### Bước 5: Start ML Services (Tùy chọn)

#### Crop Recommendation Service

```bash
cd RecommentCrop

# Windows
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python crop_recommendation_service.py
```

Service chạy tại: http://localhost:5000

#### Pest & Disease Detection Service

```bash
cd PestAndDisease

# Windows
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python pest_disease_service.py
```

Service chạy tại: http://localhost:5001

## 🔧 Cấu hình

### Backend (Spring Boot)

File: `demoSmartFarm/demo/src/main/resources/application.properties`

Đã được cấu hình sẵn cho local:
- Database: `localhost:5432`
- Port: `8080`
- CORS: Cho phép `localhost:3000`

### Frontend (React)

File: `J2EE_Frontend/.env`

```env
REACT_APP_API_URL=http://localhost:8080
```

File `api.config.js` đã tự động detect localhost khi chạy development mode.

### Chatbot (Next.js)

File: `AI_SmartFarm_CHatbot/.env.local`

```env
GOOGLE_GENAI_API_KEY=your-api-key-here
NEXT_PUBLIC_API_URL=http://localhost:8080
```

## 🐛 Xử lý lỗi

### Lỗi: "Cannot connect to database"

```bash
# Kiểm tra PostgreSQL đang chạy
docker ps | grep postgres

# Hoặc
pg_isready -U postgres
```

### Lỗi: "Port already in use"

```bash
# Windows
netstat -ano | findstr :8080

# Dừng process đang dùng port
taskkill /PID <PID> /F
```

### Lỗi: "CORS policy"

- Kiểm tra backend đang chạy
- Kiểm tra `CorsConfig.java` có cho phép `localhost:3000`
- Restart backend

### Lỗi: "API call failed"

- Kiểm tra `.env` file có `REACT_APP_API_URL=http://localhost:8080`
- Kiểm tra backend đang chạy trên port 8080
- Xem console browser để kiểm tra URL được gọi

## 📊 Ports sử dụng

| Service | Port | URL |
|---------|------|-----|
| Frontend | 80 (Docker) / 3000 (Dev) | http://localhost / http://localhost:3000 |
| Backend | 8080 | http://localhost:8080 |
| Chatbot | 9002 | http://localhost:9002 |
| Crop ML | 5000 | http://localhost:5000 |
| Pest ML | 5001 | http://localhost:5001 |
| PostgreSQL | 5432 | localhost:5432 |

## ✅ Checklist

- [ ] Docker và Docker Compose đã cài đặt (hoặc các tools cần thiết)
- [ ] File `.env` đã được tạo với cấu hình đúng
- [ ] PostgreSQL đang chạy
- [ ] Backend đang chạy và trả lời tại http://localhost:8080/api/auth/health
- [ ] Frontend đang chạy và hiển thị tại http://localhost:3000 (hoặc http://localhost nếu dùng Docker)
- [ ] Không có lỗi CORS trong browser console
- [ ] API calls hoạt động bình thường

## 🎉 Hoàn tất!

Nếu tất cả đều chạy, bạn có thể:
- ✅ Truy cập Frontend: http://localhost (Docker) hoặc http://localhost:3000 (Dev)
- ✅ Truy cập Backend API: http://localhost:8080
- ✅ Truy cập Chatbot: http://localhost:9002
- ✅ Sử dụng ML Services: http://localhost:5000 và http://localhost:5001






# 🏠 Hướng dẫn Setup Local Development

## 📋 Yêu cầu hệ thống

- Docker và Docker Compose (khuyến nghị)
- Hoặc:
  - Node.js 18+
  - Java 17+ và Maven
  - PostgreSQL 15+
  - Python 3.9+

## 🚀 Cách 1: Docker Compose (Khuyến nghị)

### Bước 1: Tạo file `.env`

Tạo file `.env` ở thư mục gốc với nội dung:

```env
# Database Configuration
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=Ngan0407@!

# JWT Configuration
JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRATION=86400000

# Frontend Origins (CORS) - for local development
FRONTEND_ORIGINS=http://localhost:3000,http://localhost:80,http://localhost

# API URLs - for local development
REACT_APP_API_URL=http://localhost:8080
NEXT_PUBLIC_API_URL=http://localhost:8080

# Google GenAI API Key (cho Chatbot)
GOOGLE_GENAI_API_KEY=your-google-genai-api-key-here
```

### Bước 2: Chạy Docker Compose

```bash
# Build và start tất cả services
docker compose up -d --build

# Xem logs
docker compose logs -f

# Xem trạng thái
docker compose ps
```

### Bước 3: Kiểm tra services

```bash
# Backend
curl http://localhost:8080/api/auth/health

# Frontend
# Mở browser: http://localhost

# Chatbot
# Mở browser: http://localhost:9002

# Crop ML
curl http://localhost:5000/health

# Pest ML
curl http://localhost:5001/health
```

### Dừng services

```bash
docker compose down
```

## 🛠️ Cách 2: Chạy từng service thủ công

### Bước 1: Start PostgreSQL

```bash
# Windows PowerShell
docker run -d --name postgres -e POSTGRES_PASSWORD=Ngan0407@! -e POSTGRES_DB=SmartFarm1 -p 5432:5432 postgres:15-alpine

# Hoặc nếu đã cài PostgreSQL, đảm bảo service đang chạy
```

### Bước 2: Start Backend

```bash
cd demoSmartFarm/demo
mvn spring-boot:run
```

Backend chạy tại: http://localhost:8080

### Bước 3: Start Frontend

```bash
cd J2EE_Frontend

# Tạo file .env nếu chưa có
echo REACT_APP_API_URL=http://localhost:8080 > .env

npm install
npm start
```

Frontend chạy tại: http://localhost:3000

### Bước 4: Start AI Chatbot (Tùy chọn)

```bash
cd AI_SmartFarm_CHatbot

# Tạo file .env.local
echo GOOGLE_GENAI_API_KEY=your-api-key-here > .env.local
echo NEXT_PUBLIC_API_URL=http://localhost:8080 >> .env.local

npm install
npm run dev
```

Chatbot chạy tại: http://localhost:9002

### Bước 5: Start ML Services (Tùy chọn)

#### Crop Recommendation Service

```bash
cd RecommentCrop

# Windows
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python crop_recommendation_service.py
```

Service chạy tại: http://localhost:5000

#### Pest & Disease Detection Service

```bash
cd PestAndDisease

# Windows
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python pest_disease_service.py
```

Service chạy tại: http://localhost:5001

## 🔧 Cấu hình

### Backend (Spring Boot)

File: `demoSmartFarm/demo/src/main/resources/application.properties`

Đã được cấu hình sẵn cho local:
- Database: `localhost:5432`
- Port: `8080`
- CORS: Cho phép `localhost:3000`

### Frontend (React)

File: `J2EE_Frontend/.env`

```env
REACT_APP_API_URL=http://localhost:8080
```

File `api.config.js` đã tự động detect localhost khi chạy development mode.

### Chatbot (Next.js)

File: `AI_SmartFarm_CHatbot/.env.local`

```env
GOOGLE_GENAI_API_KEY=your-api-key-here
NEXT_PUBLIC_API_URL=http://localhost:8080
```

## 🐛 Xử lý lỗi

### Lỗi: "Cannot connect to database"

```bash
# Kiểm tra PostgreSQL đang chạy
docker ps | grep postgres

# Hoặc
pg_isready -U postgres
```

### Lỗi: "Port already in use"

```bash
# Windows
netstat -ano | findstr :8080

# Dừng process đang dùng port
taskkill /PID <PID> /F
```

### Lỗi: "CORS policy"

- Kiểm tra backend đang chạy
- Kiểm tra `CorsConfig.java` có cho phép `localhost:3000`
- Restart backend

### Lỗi: "API call failed"

- Kiểm tra `.env` file có `REACT_APP_API_URL=http://localhost:8080`
- Kiểm tra backend đang chạy trên port 8080
- Xem console browser để kiểm tra URL được gọi

## 📊 Ports sử dụng

| Service | Port | URL |
|---------|------|-----|
| Frontend | 80 (Docker) / 3000 (Dev) | http://localhost / http://localhost:3000 |
| Backend | 8080 | http://localhost:8080 |
| Chatbot | 9002 | http://localhost:9002 |
| Crop ML | 5000 | http://localhost:5000 |
| Pest ML | 5001 | http://localhost:5001 |
| PostgreSQL | 5432 | localhost:5432 |

## ✅ Checklist

- [ ] Docker và Docker Compose đã cài đặt (hoặc các tools cần thiết)
- [ ] File `.env` đã được tạo với cấu hình đúng
- [ ] PostgreSQL đang chạy
- [ ] Backend đang chạy và trả lời tại http://localhost:8080/api/auth/health
- [ ] Frontend đang chạy và hiển thị tại http://localhost:3000 (hoặc http://localhost nếu dùng Docker)
- [ ] Không có lỗi CORS trong browser console
- [ ] API calls hoạt động bình thường

## 🎉 Hoàn tất!

Nếu tất cả đều chạy, bạn có thể:
- ✅ Truy cập Frontend: http://localhost (Docker) hoặc http://localhost:3000 (Dev)
- ✅ Truy cập Backend API: http://localhost:8080
- ✅ Truy cập Chatbot: http://localhost:9002
- ✅ Sử dụng ML Services: http://localhost:5000 và http://localhost:5001






