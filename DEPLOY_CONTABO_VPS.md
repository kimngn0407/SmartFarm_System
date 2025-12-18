# 🚀 Hướng dẫn Deploy SmartFarm lên VPS Contabo

## 📋 Yêu cầu

- VPS Contabo đã được cấp (Ubuntu 20.04+ hoặc 22.04)
- Quyền root hoặc sudo
- Domain name (tùy chọn, có thể dùng IP)
- SSH access đến VPS

## 🔧 Bước 1: Chuẩn bị VPS

### 1.1. Kết nối SSH vào VPS

```bash
ssh root@YOUR_VPS_IP
# Hoặc
ssh username@YOUR_VPS_IP
```

### 1.2. Cập nhật hệ thống

```bash
apt update && apt upgrade -y
```

### 1.3. Cài đặt Docker và Docker Compose

```bash
# Cài đặt Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Cài đặt Docker Compose
apt install docker-compose-plugin -y

# Kiểm tra cài đặt
docker --version
docker compose version
```

### 1.4. Cấu hình Firewall (UFW)

```bash
# Cho phép các port cần thiết
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP (Frontend)
ufw allow 443/tcp   # HTTPS (Nginx)
ufw allow 8080/tcp  # Backend API
ufw allow 9002/tcp  # Chatbot
ufw allow 5000/tcp  # Crop ML Service
ufw allow 5001/tcp  # Pest ML Service

# Bật firewall
ufw enable
ufw status
```

## 📦 Bước 2: Clone và cấu hình dự án

### 2.1. Clone repository

```bash
cd /opt  # hoặc thư mục bạn muốn
git clone https://github.com/kimngn0407/SmartFarm_System.git SmartFarm
cd SmartFarm
```

### 2.2. Tạo file `.env` cho cấu hình

```bash
nano .env
```

Thêm nội dung sau (thay `YOUR_VPS_IP` hoặc `YOUR_DOMAIN` bằng IP/domain của bạn):

```env
# Database Configuration
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=YOUR_STRONG_PASSWORD_HERE

# JWT Configuration
JWT_SECRET=YOUR_JWT_SECRET_KEY_HERE
JWT_EXPIRATION=86400000

# VPS IP/Domain (đã cập nhật với IP mới)
VPS_IP=109.205.180.72
# Hoặc nếu có domain:
# VPS_DOMAIN=yourdomain.com

# Frontend Origins (cho CORS)
FRONTEND_ORIGINS=http://109.205.180.72,http://109.205.180.72:80,http://localhost:3000,http://localhost:80
# Nếu có domain:
# FRONTEND_ORIGINS=http://109.205.180.72,http://109.205.180.72:80,https://yourdomain.com,http://yourdomain.com,http://localhost:3000

# Google GenAI API Key (cho Chatbot)
GOOGLE_GENAI_API_KEY=your-google-genai-api-key-here

# API URLs
NEXT_PUBLIC_API_URL=http://109.205.180.72:8080
# Hoặc nếu có domain:
# NEXT_PUBLIC_API_URL=https://yourdomain.com:8080
```

**Lưu ý quan trọng:**
- IP VPS đã được cập nhật: `109.205.180.72`
- Nếu có domain, thay IP bằng domain (ví dụ: `smartfarm.com`)
- Đặt mật khẩu PostgreSQL mạnh
- Tạo JWT_SECRET ngẫu nhiên (có thể dùng: `openssl rand -base64 32`)

### 2.3. Cập nhật docker-compose.yml

✅ **Đã được cập nhật tự động!** File `docker-compose.yml` đã được cập nhật với IP mới `109.205.180.72`.

Nếu bạn muốn kiểm tra hoặc thay đổi, mở file:

```bash
nano docker-compose.yml
```

Tất cả các tham chiếu đến IP đã được cập nhật:
- Frontend: `http://109.205.180.72:8080`
- Chatbot: `http://109.205.180.72:8080`
- CORS: `http://109.205.180.72,http://109.205.180.72:80`

## 🚀 Bước 3: Deploy ứng dụng

### 3.1. Build và khởi động tất cả services

```bash
# Build và start tất cả containers
docker compose up -d --build

# Xem logs để kiểm tra
docker compose logs -f
```

### 3.2. Kiểm tra trạng thái services

```bash
# Xem trạng thái tất cả containers
docker compose ps

# Kiểm tra logs từng service
docker compose logs backend
docker compose logs frontend
docker compose logs chatbot
docker compose logs postgres
```

## ✅ Bước 4: Kiểm tra và xác minh

### 4.1. Kiểm tra Backend API

```bash
curl http://109.205.180.72:8080/api/auth/health
```

Kết quả mong đợi: `{"status":"ok"}`

### 4.2. Kiểm tra Frontend

Mở browser và truy cập:
```
http://109.205.180.72
```

### 4.3. Kiểm tra Chatbot

```
http://109.205.180.72:9002
```

### 4.4. Kiểm tra ML Services

```bash
# Crop Recommendation
curl http://109.205.180.72:5000/health

# Pest Detection
curl http://109.205.180.72:5001/health
```

## 🔒 Bước 5: Cấu hình bảo mật (Tùy chọn nhưng khuyến nghị)

### 5.1. Cài đặt SSL với Let's Encrypt (nếu có domain)

```bash
# Cài đặt Certbot
apt install certbot python3-certbot-nginx -y

# Tạo certificate (nếu dùng Nginx)
certbot --nginx -d yourdomain.com
```

### 5.2. Cấu hình Nginx Reverse Proxy (nếu cần)

Nếu bạn muốn dùng Nginx để route traffic, cấu hình trong `nginx/nginx.conf` và `nginx/conf.d/`.

## 📊 Bước 6: Quản lý và bảo trì

### 6.1. Xem logs

```bash
# Tất cả services
docker compose logs -f

# Một service cụ thể
docker compose logs -f backend
docker compose logs -f frontend
```

### 6.2. Restart services

```bash
# Restart tất cả
docker compose restart

# Restart một service
docker compose restart backend
```

### 6.3. Stop/Start services

```bash
# Stop tất cả
docker compose stop

# Start lại
docker compose start

# Stop và xóa containers (giữ data)
docker compose down

# Stop và xóa tất cả (kể cả volumes - CẨN THẬN!)
docker compose down -v
```

### 6.4. Update code mới

```bash
# Pull code mới
git pull

# Rebuild và restart
docker compose up -d --build
```

### 6.5. Backup database

```bash
# Backup
docker compose exec postgres pg_dump -U postgres SmartFarm1 > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore
docker compose exec -T postgres psql -U postgres SmartFarm1 < backup_file.sql
```

## 🐛 Xử lý lỗi thường gặp

### Lỗi: "Cannot connect to database"

```bash
# Kiểm tra PostgreSQL container
docker compose logs postgres

# Kiểm tra kết nối
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "\dt"
```

### Lỗi: "Port already in use"

```bash
# Kiểm tra port đang được sử dụng
netstat -tulpn | grep :8080

# Hoặc thay đổi port trong docker-compose.yml
```

### Lỗi: "CORS policy"

Kiểm tra `FRONTEND_ORIGINS` trong `.env` và `docker-compose.yml` đã đúng chưa.

### Lỗi: "Out of memory"

VPS Contabo có thể có RAM hạn chế. Kiểm tra:

```bash
# Xem sử dụng RAM
free -h

# Xem sử dụng của containers
docker stats
```

Nếu thiếu RAM, có thể tắt một số services không cần thiết hoặc nâng cấp VPS.

## 📝 Checklist sau khi deploy

- [ ] Backend API chạy trên port 8080
- [ ] Frontend truy cập được qua IP/domain
- [ ] Chatbot chạy trên port 9002
- [ ] Database kết nối thành công
- [ ] ML Services (Crop & Pest) chạy trên port 5000 và 5001
- [ ] CORS đã được cấu hình đúng
- [ ] Firewall đã mở các port cần thiết
- [ ] SSL certificate đã được cài (nếu có domain)
- [ ] Backup database đã được thiết lập

## 🎉 Hoàn tất!

Sau khi hoàn tất, bạn có thể truy cập:

- **Frontend**: `http://109.205.180.72` hoặc `https://yourdomain.com`
- **Backend API**: `http://109.205.180.72:8080`
- **Chatbot**: `http://109.205.180.72:9002`
- **Crop ML**: `http://109.205.180.72:5000`
- **Pest ML**: `http://109.205.180.72:5001`

---

## 💡 Tips

1. **Giám sát**: Có thể cài đặt monitoring tools như `htop`, `docker stats`
2. **Auto-restart**: Docker Compose đã cấu hình `restart: unless-stopped` cho tất cả services
3. **Logs rotation**: Cấu hình log rotation để tránh đầy disk
4. **Backup tự động**: Thiết lập cron job để backup database định kỳ

## 📞 Hỗ trợ

Nếu gặp vấn đề, kiểm tra:
1. Logs: `docker compose logs -f`
2. Trạng thái containers: `docker compose ps`
3. Tài nguyên hệ thống: `docker stats`
4. Firewall: `ufw status`

