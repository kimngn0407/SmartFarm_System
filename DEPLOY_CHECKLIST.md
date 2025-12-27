# ✅ Checklist Deploy SmartFarm lên VPS Contabo

**IP VPS:** `109.205.180.72`  
**Repository:** `https://github.com/kimngn0407/SmartFarm_System.git`

---

## 📋 Trước khi deploy

### Trên máy local (Windows)

- [ ] Đã commit và push code lên GitHub
- [ ] Đã có SSH key hoặc password để kết nối VPS
- [ ] Đã có Google GenAI API Key (cho chatbot)
- [ ] Đã chuẩn bị mật khẩu PostgreSQL mạnh

---

## 🚀 Các bước deploy

### Bước 1: Kết nối SSH vào VPS

```bash
ssh root@109.205.180.72
# Hoặc
ssh username@109.205.180.72
```

### Bước 2: Cài đặt Docker và Docker Compose

```bash
# Cập nhật hệ thống
apt update && apt upgrade -y

# Cài đặt Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Cài đặt Docker Compose
apt install docker-compose-plugin -y

# Kiểm tra
docker --version
docker compose version
```

✅ **Kết quả mong đợi:** Docker và Docker Compose đã được cài đặt

---

### Bước 3: Cấu hình Firewall

```bash
# Cho phép các port cần thiết
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP (Frontend)
ufw allow 443/tcp   # HTTPS
ufw allow 8080/tcp  # Backend API
ufw allow 9002/tcp  # Chatbot
ufw allow 5000/tcp  # Crop ML Service
ufw allow 5001/tcp  # Pest ML Service

# Bật firewall
ufw enable
ufw status
```

✅ **Kết quả mong đợi:** Firewall đã được bật và các port đã được mở

---

### Bước 4: Clone repository

```bash
cd /opt  # hoặc thư mục bạn muốn
git clone https://github.com/kimngn0407/SmartFarm_System.git SmartFarm
cd SmartFarm
```

✅ **Kết quả mong đợi:** Repository đã được clone về

---

### Bước 5: Tạo file `.env`

```bash
# Copy template (nếu có)
cp env.vps.template .env

# Hoặc tạo mới
nano .env
```

Thêm nội dung sau (thay các giá trị placeholder):

```env
# Database Configuration
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=YOUR_STRONG_PASSWORD_HERE

# JWT Configuration
JWT_SECRET=YOUR_JWT_SECRET_KEY_HERE
JWT_EXPIRATION=86400000

# VPS Configuration
VPS_IP=109.205.180.72

# Frontend Origins (CORS)
FRONTEND_ORIGINS=http://109.205.180.72,http://109.205.180.72:80,http://localhost:3000,http://localhost:80

# Google GenAI API Key (cho Chatbot)
GOOGLE_GENAI_API_KEY=your-google-genai-api-key-here

# API URLs - for VPS deployment
REACT_APP_API_URL=http://109.205.180.72:8080
NEXT_PUBLIC_API_URL=http://109.205.180.72:8080
```

**Lưu ý quan trọng:**
- Thay `YOUR_STRONG_PASSWORD_HERE` bằng mật khẩu PostgreSQL mạnh
- Tạo JWT_SECRET: `openssl rand -base64 32`
- Thay `your-google-genai-api-key-here` bằng API key thực từ Google AI Studio

✅ **Kết quả mong đợi:** File `.env` đã được tạo với đầy đủ thông tin

---

### Bước 6: Deploy với Docker Compose

```bash
# Build và start tất cả services
docker compose up -d --build

# Xem logs để kiểm tra
docker compose logs -f
```

**Thời gian:** Có thể mất 5-10 phút để build và khởi động tất cả services

✅ **Kết quả mong đợi:** Tất cả containers đã được tạo và chạy

---

### Bước 7: Kiểm tra trạng thái services

```bash
# Xem trạng thái tất cả containers
docker compose ps

# Kiểm tra logs từng service
docker compose logs backend
docker compose logs frontend
docker compose logs chatbot
docker compose logs postgres
```

✅ **Kết quả mong đợi:** Tất cả services đều ở trạng thái "Up" và healthy

---

### Bước 8: Kiểm tra ứng dụng

#### 8.1. Backend API
```bash
curl http://109.205.180.72:8080/api/auth/health
```
✅ **Kết quả mong đợi:** `{"status":"ok"}`

#### 8.2. Frontend
Mở browser: `http://109.205.180.72`
✅ **Kết quả mong đợi:** Trang web hiển thị bình thường

#### 8.3. Chatbot
Mở browser: `http://109.205.180.72:9002`
✅ **Kết quả mong đợi:** Chatbot hiển thị và có thể chat

#### 8.4. ML Services
```bash
# Crop Recommendation
curl http://109.205.180.72:5000/health

# Pest Detection
curl http://109.205.180.72:5001/health
```
✅ **Kết quả mong đợi:** Cả hai đều trả về status OK

---

## 🎉 Hoàn tất!

Sau khi tất cả các bước trên đều thành công, bạn có thể:

- ✅ Truy cập Frontend: `http://109.205.180.72`
- ✅ Truy cập Backend API: `http://109.205.180.72:8080`
- ✅ Truy cập Chatbot: `http://109.205.180.72:9002`
- ✅ Sử dụng ML Services: `http://109.205.180.72:5000` và `http://109.205.180.72:5001`

---

## 🐛 Xử lý lỗi

### Lỗi: "Cannot connect to database"
```bash
# Kiểm tra PostgreSQL container
docker compose logs postgres
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "\dt"
```

### Lỗi: "Port already in use"
```bash
# Kiểm tra port đang được sử dụng
netstat -tulpn | grep :8080
# Hoặc dừng service đang dùng port đó
```

### Lỗi: "Out of memory"
```bash
# Xem sử dụng RAM
free -h
docker stats
# Có thể cần nâng cấp VPS hoặc tối ưu services
```

### Lỗi: "Build failed"
```bash
# Xem logs chi tiết
docker compose logs --tail=100
# Kiểm tra file .env có đúng không
cat .env
```

---

## 📝 Lệnh quản lý thường dùng

```bash
# Xem logs
docker compose logs -f

# Restart services
docker compose restart

# Stop services
docker compose stop

# Start services
docker compose start

# Rebuild và restart
docker compose up -d --build

# Xem trạng thái
docker compose ps

# Xem sử dụng tài nguyên
docker stats
```

---

## 🔄 Update code mới

```bash
# Pull code mới
git pull

# Rebuild và restart
docker compose up -d --build
```

---

## 💾 Backup database

```bash
# Backup
docker compose exec postgres pg_dump -U postgres SmartFarm1 > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore
docker compose exec -T postgres psql -U postgres SmartFarm1 < backup_file.sql
```












**IP VPS:** `109.205.180.72`  
**Repository:** `https://github.com/kimngn0407/SmartFarm_System.git`

---

## 📋 Trước khi deploy

### Trên máy local (Windows)

- [ ] Đã commit và push code lên GitHub
- [ ] Đã có SSH key hoặc password để kết nối VPS
- [ ] Đã có Google GenAI API Key (cho chatbot)
- [ ] Đã chuẩn bị mật khẩu PostgreSQL mạnh

---

## 🚀 Các bước deploy

### Bước 1: Kết nối SSH vào VPS

```bash
ssh root@109.205.180.72
# Hoặc
ssh username@109.205.180.72
```

### Bước 2: Cài đặt Docker và Docker Compose

```bash
# Cập nhật hệ thống
apt update && apt upgrade -y

# Cài đặt Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Cài đặt Docker Compose
apt install docker-compose-plugin -y

# Kiểm tra
docker --version
docker compose version
```

✅ **Kết quả mong đợi:** Docker và Docker Compose đã được cài đặt

---

### Bước 3: Cấu hình Firewall

```bash
# Cho phép các port cần thiết
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP (Frontend)
ufw allow 443/tcp   # HTTPS
ufw allow 8080/tcp  # Backend API
ufw allow 9002/tcp  # Chatbot
ufw allow 5000/tcp  # Crop ML Service
ufw allow 5001/tcp  # Pest ML Service

# Bật firewall
ufw enable
ufw status
```

✅ **Kết quả mong đợi:** Firewall đã được bật và các port đã được mở

---

### Bước 4: Clone repository

```bash
cd /opt  # hoặc thư mục bạn muốn
git clone https://github.com/kimngn0407/SmartFarm_System.git SmartFarm
cd SmartFarm
```

✅ **Kết quả mong đợi:** Repository đã được clone về

---

### Bước 5: Tạo file `.env`

```bash
# Copy template (nếu có)
cp env.vps.template .env

# Hoặc tạo mới
nano .env
```

Thêm nội dung sau (thay các giá trị placeholder):

```env
# Database Configuration
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=YOUR_STRONG_PASSWORD_HERE

# JWT Configuration
JWT_SECRET=YOUR_JWT_SECRET_KEY_HERE
JWT_EXPIRATION=86400000

# VPS Configuration
VPS_IP=109.205.180.72

# Frontend Origins (CORS)
FRONTEND_ORIGINS=http://109.205.180.72,http://109.205.180.72:80,http://localhost:3000,http://localhost:80

# Google GenAI API Key (cho Chatbot)
GOOGLE_GENAI_API_KEY=your-google-genai-api-key-here

# API URLs - for VPS deployment
REACT_APP_API_URL=http://109.205.180.72:8080
NEXT_PUBLIC_API_URL=http://109.205.180.72:8080
```

**Lưu ý quan trọng:**
- Thay `YOUR_STRONG_PASSWORD_HERE` bằng mật khẩu PostgreSQL mạnh
- Tạo JWT_SECRET: `openssl rand -base64 32`
- Thay `your-google-genai-api-key-here` bằng API key thực từ Google AI Studio

✅ **Kết quả mong đợi:** File `.env` đã được tạo với đầy đủ thông tin

---

### Bước 6: Deploy với Docker Compose

```bash
# Build và start tất cả services
docker compose up -d --build

# Xem logs để kiểm tra
docker compose logs -f
```

**Thời gian:** Có thể mất 5-10 phút để build và khởi động tất cả services

✅ **Kết quả mong đợi:** Tất cả containers đã được tạo và chạy

---

### Bước 7: Kiểm tra trạng thái services

```bash
# Xem trạng thái tất cả containers
docker compose ps

# Kiểm tra logs từng service
docker compose logs backend
docker compose logs frontend
docker compose logs chatbot
docker compose logs postgres
```

✅ **Kết quả mong đợi:** Tất cả services đều ở trạng thái "Up" và healthy

---

### Bước 8: Kiểm tra ứng dụng

#### 8.1. Backend API
```bash
curl http://109.205.180.72:8080/api/auth/health
```
✅ **Kết quả mong đợi:** `{"status":"ok"}`

#### 8.2. Frontend
Mở browser: `http://109.205.180.72`
✅ **Kết quả mong đợi:** Trang web hiển thị bình thường

#### 8.3. Chatbot
Mở browser: `http://109.205.180.72:9002`
✅ **Kết quả mong đợi:** Chatbot hiển thị và có thể chat

#### 8.4. ML Services
```bash
# Crop Recommendation
curl http://109.205.180.72:5000/health

# Pest Detection
curl http://109.205.180.72:5001/health
```
✅ **Kết quả mong đợi:** Cả hai đều trả về status OK

---

## 🎉 Hoàn tất!

Sau khi tất cả các bước trên đều thành công, bạn có thể:

- ✅ Truy cập Frontend: `http://109.205.180.72`
- ✅ Truy cập Backend API: `http://109.205.180.72:8080`
- ✅ Truy cập Chatbot: `http://109.205.180.72:9002`
- ✅ Sử dụng ML Services: `http://109.205.180.72:5000` và `http://109.205.180.72:5001`

---

## 🐛 Xử lý lỗi

### Lỗi: "Cannot connect to database"
```bash
# Kiểm tra PostgreSQL container
docker compose logs postgres
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "\dt"
```

### Lỗi: "Port already in use"
```bash
# Kiểm tra port đang được sử dụng
netstat -tulpn | grep :8080
# Hoặc dừng service đang dùng port đó
```

### Lỗi: "Out of memory"
```bash
# Xem sử dụng RAM
free -h
docker stats
# Có thể cần nâng cấp VPS hoặc tối ưu services
```

### Lỗi: "Build failed"
```bash
# Xem logs chi tiết
docker compose logs --tail=100
# Kiểm tra file .env có đúng không
cat .env
```

---

## 📝 Lệnh quản lý thường dùng

```bash
# Xem logs
docker compose logs -f

# Restart services
docker compose restart

# Stop services
docker compose stop

# Start services
docker compose start

# Rebuild và restart
docker compose up -d --build

# Xem trạng thái
docker compose ps

# Xem sử dụng tài nguyên
docker stats
```

---

## 🔄 Update code mới

```bash
# Pull code mới
git pull

# Rebuild và restart
docker compose up -d --build
```

---

## 💾 Backup database

```bash
# Backup
docker compose exec postgres pg_dump -U postgres SmartFarm1 > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore
docker compose exec -T postgres psql -U postgres SmartFarm1 < backup_file.sql
```











