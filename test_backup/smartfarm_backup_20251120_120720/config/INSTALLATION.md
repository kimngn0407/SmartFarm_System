# 📦 Hướng dẫn Cài đặt Chi tiết - SmartFarm

Hướng dẫn từng bước để cài đặt và cấu hình SmartFarm System.

---

## 📋 Mục lục

- [Yêu cầu hệ thống](#-yêu-cầu-hệ-thống)
- [Cài đặt Dependencies](#-cài-đặt-dependencies)
- [Cài đặt Backend](#-cài-đặt-backend)
- [Cài đặt Frontend](#-cài-đặt-frontend)
- [Cài đặt AI Chatbot](#-cài-đặt-ai-chatbot)
- [Cài đặt ML Services](#-cài-đặt-ml-services)
- [Cài đặt Database](#-cài-đặt-database)
- [Cấu hình IoT & Blockchain](#-cấu-hình-iot--blockchain)
- [Kiểm tra cài đặt](#-kiểm-tra-cài-đặt)

---

## 💻 Yêu cầu hệ thống

### Minimum Requirements

| Component | Version | Download |
|-----------|---------|----------|
| **Java JDK** | 17+ | [Oracle](https://www.oracle.com/java/technologies/downloads/) / [OpenJDK](https://adoptium.net/) |
| **Node.js** | 18+ | [Node.js](https://nodejs.org/) |
| **Python** | 3.10+ | [Python](https://www.python.org/downloads/) |
| **PostgreSQL** | 15+ | [PostgreSQL](https://www.postgresql.org/download/) |
| **Maven** | 3.8+ | [Maven](https://maven.apache.org/download.cgi) |
| **Git** | Latest | [Git](https://git-scm.com/downloads) |

### Recommended Tools

- **Docker** 20.10+ & **Docker Compose** 2.0+ (Khuyến nghị)
- **IDE**: IntelliJ IDEA / VS Code / Eclipse
- **Postman** / **Insomnia** (API testing)

---

## 🔧 Cài đặt Dependencies

### 1. Java JDK 17

#### Windows
```bash
# Download từ Oracle hoặc OpenJDK
# Cài đặt và thêm vào PATH

# Kiểm tra
java -version
javac -version
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install openjdk-17-jdk
java -version
```

#### macOS
```bash
brew install openjdk@17
java -version
```

### 2. Node.js & npm

#### Windows
- Download từ [nodejs.org](https://nodejs.org/)
- Cài đặt và chọn "Add to PATH"

#### Linux
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### macOS
```bash
brew install node@18
```

**Kiểm tra:**
```bash
node -v  # v18.x.x
npm -v   # 8.x.x
```

### 3. Python 3.10+

#### Windows
- Download từ [python.org](https://www.python.org/downloads/)
- Chọn "Add Python to PATH" khi cài đặt

#### Linux
```bash
sudo apt update
sudo apt install python3.10 python3-pip python3-venv
```

#### macOS
```bash
brew install python@3.10
```

**Kiểm tra:**
```bash
python --version  # Python 3.10.x
pip --version
```

### 4. PostgreSQL

#### Windows
- Download từ [postgresql.org](https://www.postgresql.org/download/windows/)
- Cài đặt và ghi nhớ password cho user `postgres`

#### Linux
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### macOS
```bash
brew install postgresql@15
brew services start postgresql@15
```

**Kiểm tra:**
```bash
psql --version
```

### 5. Maven

#### Windows
- Download từ [maven.apache.org](https://maven.apache.org/download.cgi)
- Giải nén và thêm `bin` folder vào PATH

#### Linux
```bash
sudo apt install maven
```

#### macOS
```bash
brew install maven
```

**Kiểm tra:**
```bash
mvn -version
```

### 6. Docker & Docker Compose (Khuyến nghị)

#### Windows
- Download [Docker Desktop](https://www.docker.com/products/docker-desktop)

#### Linux
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### macOS
```bash
brew install docker docker-compose
```

**Kiểm tra:**
```bash
docker --version
docker-compose --version
```

---

## 🗄️ Cài đặt Database

### 1. Tạo Database

```bash
# Kết nối PostgreSQL
psql -U postgres

# Tạo database
CREATE DATABASE SmartFarm1;

# Tạo user (optional)
CREATE USER smartfarm_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE SmartFarm1 TO smartfarm_user;

# Thoát
\q
```

### 2. Import Schema

```bash
# Import schema chính
psql -U postgres -d SmartFarm1 -f DB_SM_ver1.sql

# Chạy migrations (nếu có)
psql -U postgres -d SmartFarm1 -f add_alert_columns.sql
```

### 3. Kiểm tra

```bash
psql -U postgres -d SmartFarm1 -c "\dt"
# Sẽ hiển thị danh sách các bảng
```

---

## ☕ Cài đặt Backend (Spring Boot)

### 1. Clone và di chuyển

```bash
cd demoSmartFarm/demo
```

### 2. Cấu hình Database

Tạo file `src/main/resources/application.properties`:

```properties
# Database Configuration
spring.datasource.url=jdbc:postgresql://localhost:5432/SmartFarm1
spring.datasource.username=postgres
spring.datasource.password=your_password
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA Settings
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# JWT Configuration
jwt.secret=your-secret-key-change-in-production
jwt.expiration=86400000

# External Services
crop.recommendation.url=http://localhost:5000
pest.disease.url=http://localhost:5001

# CORS
cors.allowed-origins=http://localhost:3000,http://localhost:80

# Email (Optional)
# spring.mail.host=smtp.gmail.com
# spring.mail.port=587
# spring.mail.username=your-email@gmail.com
# spring.mail.password=your-app-password
# app.mail.from=your-email@gmail.com
```

### 3. Cài đặt Dependencies

```bash
mvn clean install
```

**Dependencies chính được cài đặt:**
- Spring Boot 3.4.4
- Spring Data JPA
- Spring Security
- PostgreSQL Driver
- JWT (jjwt 0.11.5)
- Thymeleaf (Email templates)
- WebSocket

### 4. Chạy Backend

```bash
mvn spring-boot:run
```

**Kiểm tra:**
- API: http://localhost:8080/actuator/health
- Swagger (nếu có): http://localhost:8080/swagger-ui.html

---

## ⚛️ Cài đặt Frontend (React)

### 1. Di chuyển đến thư mục

```bash
cd J2EE_Frontend
```

### 2. Cài đặt Dependencies

```bash
npm install
```

**Dependencies chính:**
- React 18.2.0
- Material-UI 5.17.1
- React Router 6.22.1
- Axios 1.6.7
- Chart.js 4.4.9
- React Chart.js 2 5.3.0

### 3. Cấu hình Environment

Tạo file `.env`:

```env
REACT_APP_API_URL=http://localhost:8080
REACT_APP_RENDER_API_BASE=http://localhost:8080
REACT_APP_GOOGLE_MAPS_API_KEY=your-google-maps-api-key
```

### 4. Chạy Frontend

```bash
npm start
```

**Truy cập:** http://localhost:3000

---

## 🤖 Cài đặt AI Chatbot (Next.js)

### 1. Di chuyển đến thư mục

```bash
cd AI_SmartFarm_CHatbot
```

### 2. Cài đặt Dependencies

```bash
npm install
```

**Dependencies chính:**
- Next.js 15.3.3
- React 18.3.1
- Google Genkit 1.14.1
- Tailwind CSS 3.4.1
- Radix UI Components

### 3. Cấu hình Environment

Tạo file `.env.local`:

```env
GOOGLE_GENAI_API_KEY=your-google-genai-api-key
NEXT_PUBLIC_API_URL=http://localhost:8080
```

**Lấy Google GenAI API Key:**
1. Vào [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Tạo API key mới
3. Copy vào `.env.local`

### 4. Chạy Chatbot

```bash
npm run dev
```

**Truy cập:** http://localhost:9002

---

## 🌱 Cài đặt Crop Recommendation ML Service

### 1. Di chuyển đến thư mục

```bash
cd RecommentCrop
```

### 2. Tạo Virtual Environment

```bash
# Windows
python -m venv .venv
.venv\Scripts\activate

# Linux/Mac
python3 -m venv .venv
source .venv/bin/activate
```

### 3. Cài đặt Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

**Dependencies:**
- Flask 3.0.0
- Flask-CORS 4.0.0
- scikit-learn 0.24.2
- NumPy 1.24.3
- Joblib 1.0.1

### 4. Kiểm tra Model File

Đảm bảo có file `RandomForest_RecomentTree.pkl` trong thư mục.

### 5. Chạy Service

```bash
python crop_recommendation_service.py
```

**Kiểm tra:**
- Health: http://localhost:5000/health
- API: http://localhost:5000/api/recommend-crop

---

## 🐛 Cài đặt Pest Detection ML Service

### 1. Di chuyển đến thư mục

```bash
cd PestAndDisease
```

### 2. Tạo Virtual Environment

```bash
# Windows
python -m venv .venv
.venv\Scripts\activate

# Linux/Mac
python3 -m venv .venv
source .venv/bin/activate
```

### 3. Cài đặt Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

**Lưu ý:** PyTorch có thể mất thời gian cài đặt (khoảng 2-3GB).

**Dependencies:**
- Flask 2.3.3
- Flask-CORS 4.0.0
- PyTorch 2.0.1
- Torchvision 0.15.2
- timm 0.9.7
- Pillow 10.0.0
- NumPy 1.24.3

### 4. Kiểm tra Model File

Đảm bảo có file `best_vit_wheat_model_4classes.pth` trong thư mục (khoảng 300MB+).

### 5. Chạy Service

```bash
python pest_disease_service.py
```

**Kiểm tra:**
- Health: http://localhost:5001/health
- API: http://localhost:5001/api/detect

---

## 🔗 Cài đặt IoT & Blockchain (Optional)

### 1. Flask API Service

```bash
cd SmartContract/flask-api

# Tạo virtual environment
python -m venv .venv
.venv\Scripts\activate  # Windows
source .venv/bin/activate  # Linux/Mac

# Cài đặt dependencies
pip install -r requirements.txt

# Cấu hình
cp env.sample .env
# Chỉnh sửa .env với thông tin database

# Chạy
python app.py
```

### 2. Arduino Forwarder

```bash
cd SmartContract/device

# Tạo virtual environment
python -m venv venv
venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac

# Cài đặt dependencies
pip install pyserial requests

# Cấu hình
# Chỉnh sửa PORT trong forwarder.py (COM4 trên Windows, /dev/ttyUSB0 trên Linux)

# Chạy
python forwarder.py
```

---

## ✅ Kiểm tra cài đặt

### 1. Kiểm tra tất cả services đang chạy

| Service | URL | Status Check |
|---------|-----|--------------|
| Backend | http://localhost:8080 | `/actuator/health` |
| Frontend | http://localhost:3000 | Mở trình duyệt |
| Chatbot | http://localhost:9002 | Mở trình duyệt |
| Crop ML | http://localhost:5000 | `/health` |
| Pest ML | http://localhost:5001 | `/health` |

### 2. Test API Endpoints

```bash
# Backend Health
curl http://localhost:8080/actuator/health

# Crop ML Health
curl http://localhost:5000/health

# Pest ML Health
curl http://localhost:5001/health
```

### 3. Test Frontend

1. Mở http://localhost:3000
2. Đăng ký/Đăng nhập
3. Tạo Farm và Field
4. Test Crop Recommendation
5. Test Pest Detection

---

## 🐛 Troubleshooting

### Lỗi: Port already in use

```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:8080 | xargs kill -9
```

### Lỗi: Database connection failed

- Kiểm tra PostgreSQL đang chạy
- Kiểm tra credentials trong `application.properties`
- Kiểm tra firewall

### Lỗi: Python dependencies

```bash
# Rebuild virtual environment
rm -rf .venv
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Lỗi: Maven build failed

```bash
# Clean và rebuild
mvn clean
mvn install -U
```

---

## 📚 Tài liệu tham khảo

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [React Documentation](https://react.dev/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Chúc bạn cài đặt thành công! 🎉**

