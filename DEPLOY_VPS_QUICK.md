# 🚀 Quick Deploy lên VPS

## 📋 Chuẩn bị

1. **Commit và push code lên GitHub:**
   ```bash
   git add .
   git commit -m "Prepare for VPS deployment"
   git push origin main
   ```

2. **Chuẩn bị thông tin:**
   - [ ] Google GenAI API Key (cho chatbot)
   - [ ] Mật khẩu PostgreSQL mạnh
   - [ ] SSH access vào VPS

## 🔧 Trên VPS

### Bước 1: SSH vào VPS
```bash
ssh root@109.205.180.72
```

### Bước 2: Cài đặt Docker (nếu chưa có)
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

### Bước 3: Clone repository
```bash
cd /opt
git clone https://github.com/kimngn0407/SmartFarm_System.git SmartFarm
cd SmartFarm
```

### Bước 4: Tạo file `.env`

**Cách 1: Dùng script tự động (khuyến nghị)**
```bash
# Copy script từ repository hoặc tạo thủ công
# Script sẽ tự động clone repo và tạo .env
bash vps-quick-setup.sh
```

**Cách 2: Tạo thủ công**
```bash
# Đảm bảo đang ở thư mục SmartFarm
cd /opt/SmartFarm

# Tạo file .env
nano .env
```

Thêm nội dung sau (copy từ `env.vps.template` hoặc xem bên dưới):

**Cập nhật các giá trị:**
- `POSTGRES_PASSWORD`: Mật khẩu mạnh cho PostgreSQL
- `JWT_SECRET`: Tạo bằng `openssl rand -base64 32`
- `GOOGLE_GENAI_API_KEY`: API key từ Google AI Studio

### Bước 5: Cấu hình Firewall
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

### Bước 6: Deploy với Docker Compose
```bash
# Build và start tất cả services
docker compose up -d --build

# Xem logs
docker compose logs -f
```

**Thời gian:** Có thể mất 5-10 phút để build và khởi động tất cả services

### Bước 7: Kiểm tra services
```bash
# Xem trạng thái
docker compose ps

# Kiểm tra logs từng service
docker compose logs backend
docker compose logs frontend
docker compose logs chatbot
docker compose logs crop-service
docker compose logs pest-service
```

### Bước 8: Test các endpoints

```bash
# Backend
curl http://localhost:8080/api/auth/health

# Frontend
curl http://localhost/health

# Chatbot
curl http://localhost:9002/api/health

# Crop ML
curl http://localhost:5000/health

# Pest ML
curl http://localhost:5001/health
```

## ✅ Kiểm tra từ browser

- **Frontend:** http://109.205.180.72
- **Backend API:** http://109.205.180.72:8080
- **Chatbot:** http://109.205.180.72:9002
- **Crop ML:** http://109.205.180.72:5000/health
- **Pest ML:** http://109.205.180.72:5001/health

## 🔄 Update code mới

```bash
cd /opt/SmartFarm
git pull
docker compose up -d --build
```

## 🛑 Dừng services

```bash
docker compose down
```

## 🗑️ Xóa tất cả (cẩn thận!)

```bash
# Dừng và xóa containers
docker compose down -v

# Xóa images
docker compose down --rmi all
```

## 📊 Quản lý

```bash
# Xem logs real-time
docker compose logs -f

# Restart service cụ thể
docker compose restart backend

# Xem sử dụng tài nguyên
docker stats

# Backup database
docker compose exec postgres pg_dump -U postgres SmartFarm1 > backup_$(date +%Y%m%d_%H%M%S).sql
```

## 🐛 Troubleshooting

### Lỗi: "Cannot connect to database"
```bash
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

## 📝 Lưu ý quan trọng

1. **Bảo mật:**
   - Đổi mật khẩu PostgreSQL mạnh
   - Tạo JWT_SECRET ngẫu nhiên
   - Không commit file `.env` lên Git

2. **Performance:**
   - VPS nên có ít nhất 4GB RAM
   - Đảm bảo đủ disk space cho Docker images

3. **Backup:**
   - Backup database thường xuyên
   - Lưu file `.env` ở nơi an toàn

4. **Monitoring:**
   - Kiểm tra logs thường xuyên
   - Monitor resource usage
   - Set up alerts nếu có thể





# 🚀 Quick Deploy lên VPS

## 📋 Chuẩn bị

1. **Commit và push code lên GitHub:**
   ```bash
   git add .
   git commit -m "Prepare for VPS deployment"
   git push origin main
   ```

2. **Chuẩn bị thông tin:**
   - [ ] Google GenAI API Key (cho chatbot)
   - [ ] Mật khẩu PostgreSQL mạnh
   - [ ] SSH access vào VPS

## 🔧 Trên VPS

### Bước 1: SSH vào VPS
```bash
ssh root@109.205.180.72
```

### Bước 2: Cài đặt Docker (nếu chưa có)
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

### Bước 3: Clone repository
```bash
cd /opt
git clone https://github.com/kimngn0407/SmartFarm_System.git SmartFarm
cd SmartFarm
```

### Bước 4: Tạo file `.env`

**Cách 1: Dùng script tự động (khuyến nghị)**
```bash
# Copy script từ repository hoặc tạo thủ công
# Script sẽ tự động clone repo và tạo .env
bash vps-quick-setup.sh
```

**Cách 2: Tạo thủ công**
```bash
# Đảm bảo đang ở thư mục SmartFarm
cd /opt/SmartFarm

# Tạo file .env
nano .env
```

Thêm nội dung sau (copy từ `env.vps.template` hoặc xem bên dưới):

**Cập nhật các giá trị:**
- `POSTGRES_PASSWORD`: Mật khẩu mạnh cho PostgreSQL
- `JWT_SECRET`: Tạo bằng `openssl rand -base64 32`
- `GOOGLE_GENAI_API_KEY`: API key từ Google AI Studio

### Bước 5: Cấu hình Firewall
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

### Bước 6: Deploy với Docker Compose
```bash
# Build và start tất cả services
docker compose up -d --build

# Xem logs
docker compose logs -f
```

**Thời gian:** Có thể mất 5-10 phút để build và khởi động tất cả services

### Bước 7: Kiểm tra services
```bash
# Xem trạng thái
docker compose ps

# Kiểm tra logs từng service
docker compose logs backend
docker compose logs frontend
docker compose logs chatbot
docker compose logs crop-service
docker compose logs pest-service
```

### Bước 8: Test các endpoints

```bash
# Backend
curl http://localhost:8080/api/auth/health

# Frontend
curl http://localhost/health

# Chatbot
curl http://localhost:9002/api/health

# Crop ML
curl http://localhost:5000/health

# Pest ML
curl http://localhost:5001/health
```

## ✅ Kiểm tra từ browser

- **Frontend:** http://109.205.180.72
- **Backend API:** http://109.205.180.72:8080
- **Chatbot:** http://109.205.180.72:9002
- **Crop ML:** http://109.205.180.72:5000/health
- **Pest ML:** http://109.205.180.72:5001/health

## 🔄 Update code mới

```bash
cd /opt/SmartFarm
git pull
docker compose up -d --build
```

## 🛑 Dừng services

```bash
docker compose down
```

## 🗑️ Xóa tất cả (cẩn thận!)

```bash
# Dừng và xóa containers
docker compose down -v

# Xóa images
docker compose down --rmi all
```

## 📊 Quản lý

```bash
# Xem logs real-time
docker compose logs -f

# Restart service cụ thể
docker compose restart backend

# Xem sử dụng tài nguyên
docker stats

# Backup database
docker compose exec postgres pg_dump -U postgres SmartFarm1 > backup_$(date +%Y%m%d_%H%M%S).sql
```

## 🐛 Troubleshooting

### Lỗi: "Cannot connect to database"
```bash
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

## 📝 Lưu ý quan trọng

1. **Bảo mật:**
   - Đổi mật khẩu PostgreSQL mạnh
   - Tạo JWT_SECRET ngẫu nhiên
   - Không commit file `.env` lên Git

2. **Performance:**
   - VPS nên có ít nhất 4GB RAM
   - Đảm bảo đủ disk space cho Docker images

3. **Backup:**
   - Backup database thường xuyên
   - Lưu file `.env` ở nơi an toàn

4. **Monitoring:**
   - Kiểm tra logs thường xuyên
   - Monitor resource usage
   - Set up alerts nếu có thể





