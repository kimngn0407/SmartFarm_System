# 🚀 Hướng Dẫn Deploy SmartFarm lên VPS

## 📋 Yêu cầu VPS

- **OS**: Ubuntu 20.04+ hoặc Debian 11+
- **RAM**: Tối thiểu 2GB (khuyến nghị 4GB)
- **CPU**: 2 cores trở lên
- **Disk**: 20GB trống
- **Ports cần mở**: 80, 443, 8080, 5000, 5001, 9002, 5432

---

## 🔧 Bước 1: Chuẩn bị VPS

### 1.1. Kết nối SSH vào VPS

```bash
ssh root@YOUR_VPS_IP
```

### 1.2. Cập nhật hệ thống

```bash
apt update && apt upgrade -y
```

### 1.3. Cài đặt Docker & Docker Compose

```bash
# Cài Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Cài Docker Compose
apt install docker-compose-plugin -y

# Khởi động Docker
systemctl start docker
systemctl enable docker

# Kiểm tra
docker --version
docker compose version
```

---

## 📦 Bước 2: Upload code lên VPS

### Cách 1: Dùng Git (Khuyên dùng)

```bash
# Trên VPS
cd /opt
git clone YOUR_GIT_REPO_URL SmartFarm
cd SmartFarm
```

### Cách 2: Dùng SCP (từ máy local)

```bash
# Trên máy local (Windows)
scp -r E:\SmartFarm root@YOUR_VPS_IP:/opt/SmartFarm
```

### Cách 3: Dùng WinSCP (GUI)

1. Mở WinSCP
2. Kết nối VPS
3. Upload thư mục `SmartFarm` vào `/opt/`

---

## ⚙️ Bước 3: Cấu hình Environment

### 3.1. Tạo file `.env`

```bash
cd /opt/SmartFarm
nano .env
```

### 3.2. Nội dung file `.env`:

```env
# Database
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=YOUR_STRONG_PASSWORD_HERE

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRATION=86400000

# VPS IP (thay YOUR_VPS_IP bằng IP thật của bạn)
FRONTEND_ORIGINS=http://YOUR_VPS_IP,http://YOUR_VPS_IP:80,http://localhost:3000

# Google Gemini API (cho chatbot)
GOOGLE_GENAI_API_KEY=your-google-gemini-api-key

# Next.js API URL
NEXT_PUBLIC_API_URL=http://YOUR_VPS_IP:8080
```

**Lưu ý**: Thay `YOUR_VPS_IP` bằng IP thật của VPS (ví dụ: `173.249.48.25`)

---

## 🏗️ Bước 4: Build và Deploy

### 4.1. Build tất cả services

```bash
cd /opt/SmartFarm
docker compose build --no-cache
```

**Lưu ý**: Lần đầu build sẽ mất 10-20 phút tùy VPS.

### 4.2. Khởi động services

```bash
docker compose up -d
```

### 4.3. Kiểm tra logs

```bash
# Xem logs tất cả services
docker compose logs -f

# Xem logs từng service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f postgres
```

---

## ✅ Bước 5: Kiểm tra Deployment

### 5.1. Kiểm tra containers đang chạy

```bash
docker compose ps
```

Kết quả mong đợi: Tất cả services có status `Up` hoặc `Up (healthy)`

### 5.2. Kiểm tra từng service

```bash
# Backend API
curl http://localhost:8080/actuator/health

# Frontend
curl http://localhost:80

# Database
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT version();"
```

### 5.3. Kiểm tra từ trình duyệt

- **Frontend**: `http://YOUR_VPS_IP`
- **Backend API**: `http://YOUR_VPS_IP:8080`
- **Chatbot**: `http://YOUR_VPS_IP:9002`

---

## 🔄 Bước 6: Cập nhật Code (Sau khi sửa)

### 6.1. Pull code mới (nếu dùng Git)

```bash
cd /opt/SmartFarm
git pull
```

### 6.2. Rebuild và restart

```bash
# Rebuild services đã thay đổi
docker compose build backend frontend

# Restart services
docker compose up -d --force-recreate backend frontend
```

---

## 🛠️ Bước 7: Xử lý sự cố

### 7.1. Service không khởi động được

```bash
# Xem logs chi tiết
docker compose logs SERVICE_NAME

# Restart service
docker compose restart SERVICE_NAME

# Rebuild service
docker compose build --no-cache SERVICE_NAME
docker compose up -d SERVICE_NAME
```

### 7.2. Database connection error

```bash
# Kiểm tra database đang chạy
docker compose ps postgres

# Kiểm tra connection
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1
```

### 7.3. Port đã được sử dụng

```bash
# Kiểm tra port nào đang dùng
netstat -tulpn | grep :8080

# Hoặc
lsof -i :8080

# Dừng service đang dùng port
docker compose down
```

### 7.4. Hết RAM

```bash
# Xem RAM đang dùng
docker stats

# Dọn dẹp
docker system prune -a
```

---

## 📊 Bước 8: Monitoring

### 8.1. Xem resource usage

```bash
docker stats
```

### 8.2. Xem logs real-time

```bash
docker compose logs -f --tail=100
```

### 8.3. Backup database

```bash
# Backup
docker exec smartfarm-postgres pg_dump -U postgres SmartFarm1 > backup_$(date +%Y%m%d).sql

# Restore
docker exec -i smartfarm-postgres psql -U postgres SmartFarm1 < backup_20240101.sql
```

---

## 🔒 Bước 9: Bảo mật (Quan trọng!)

### 9.1. Đổi mật khẩu database

```bash
# Sửa trong .env
POSTGRES_PASSWORD=NEW_STRONG_PASSWORD

# Restart
docker compose restart postgres
```

### 9.2. Cấu hình Firewall

```bash
# Cài UFW
apt install ufw -y

# Cho phép SSH
ufw allow 22/tcp

# Cho phép HTTP/HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Cho phép Backend (chỉ từ localhost hoặc IP cụ thể)
ufw allow from YOUR_TRUSTED_IP to any port 8080

# Bật firewall
ufw enable
```

### 9.3. Setup SSL/HTTPS (Nginx + Let's Encrypt)

Xem file `NGINX_SSL_SETUP.md` để setup HTTPS.

---

## 🎯 Checklist Deploy

- [ ] VPS đã cài Docker & Docker Compose
- [ ] Code đã upload lên VPS
- [ ] File `.env` đã được cấu hình đúng
- [ ] Đã build thành công: `docker compose build`
- [ ] Tất cả services đang chạy: `docker compose ps`
- [ ] Frontend truy cập được: `http://YOUR_VPS_IP`
- [ ] Backend API hoạt động: `http://YOUR_VPS_IP:8080/actuator/health`
- [ ] Database kết nối được
- [ ] Đã đổi mật khẩu mặc định
- [ ] Firewall đã được cấu hình

---

## 📞 Hỗ trợ

Nếu gặp lỗi, kiểm tra:
1. Logs: `docker compose logs -f`
2. Status: `docker compose ps`
3. Resources: `docker stats`

---

## 🚀 Quick Commands

```bash
# Start tất cả
docker compose up -d

# Stop tất cả
docker compose down

# Restart tất cả
docker compose restart

# Xem logs
docker compose logs -f

# Rebuild và restart
docker compose build && docker compose up -d

# Xóa tất cả và làm lại
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

