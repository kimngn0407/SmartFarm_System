# 🔍 Hướng Dẫn Kiểm Tra Hệ Thống SmartFarm

> **IP VPS:** 173.249.48.25

---

## 🌐 Các URL Hệ Thống

| Service | URL | Port | Mô tả |
|---------|-----|------|-------|
| **Frontend** | http://173.249.48.25/ | 80 | Giao diện người dùng |
| **Backend API** | http://173.249.48.25:8080/ | 8080 | API server |
| **Chatbot** | http://173.249.48.25:9002/ | 9002 | AI Chatbot |
| **Crop ML** | http://173.249.48.25:5000/ | 5000 | Crop Recommendation |
| **Pest ML** | http://173.249.48.25:5001/ | 5001 | Pest Detection |

---

## ✅ Kiểm Tra Nhanh (Từ Local)

### Sử dụng Script:

```bash
# Chạy script kiểm tra
chmod +x check_system_status.sh
./check_system_status.sh
```

### Kiểm Tra Thủ Công:

```bash
# 1. Kiểm tra Frontend
curl -I http://173.249.48.25/

# 2. Kiểm tra Backend
curl http://173.249.48.25:8080/actuator/health

# 3. Kiểm tra API Alerts
curl http://173.249.48.25:8080/api/alerts

# 4. Kiểm tra Chatbot
curl http://173.249.48.25:9002

# 5. Kiểm tra Crop ML
curl http://173.249.48.25:5000/health

# 6. Kiểm tra Pest ML
curl http://173.249.48.25:5001/health
```

---

## 🔧 Kiểm Tra Chi Tiết (Trên VPS)

### 1. SSH vào VPS

```bash
ssh root@173.249.48.25
cd ~/projects/SmartFarm
```

### 2. Kiểm Tra Docker Containers

```bash
# Xem trạng thái tất cả containers
docker-compose ps

# Xem logs của từng service
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres
docker-compose logs chatbot
docker-compose logs crop-service
docker-compose logs pest-service

# Xem logs realtime
docker-compose logs -f
```

### 3. Kiểm Tra Database

```bash
# Kiểm tra PostgreSQL đang chạy
docker-compose exec postgres psql -U postgres -c "\l"

# Kiểm tra kết nối database
docker-compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM sensor;"
```

### 4. Kiểm Tra Dung Lượng

```bash
# Kiểm tra dung lượng disk
df -h

# Kiểm tra dung lượng Docker
docker system df

# Kiểm tra logs size
du -sh /var/lib/docker/containers/*
```

### 5. Kiểm Tra Network

```bash
# Kiểm tra ports đang listen
netstat -tulpn | grep LISTEN

# Hoặc
ss -tulpn | grep LISTEN

# Kiểm tra firewall
ufw status
# hoặc
iptables -L
```

---

## 🐛 Troubleshooting

### Frontend không load được

```bash
# Kiểm tra frontend container
docker-compose ps frontend
docker-compose logs frontend

# Restart frontend
docker-compose restart frontend

# Rebuild frontend
docker-compose up -d --build frontend
```

### Backend không phản hồi

```bash
# Kiểm tra backend container
docker-compose ps backend
docker-compose logs backend

# Kiểm tra database connection
docker-compose exec backend env | grep DATABASE

# Restart backend
docker-compose restart backend

# Rebuild backend
docker-compose up -d --build backend
```

### Database connection error

```bash
# Kiểm tra PostgreSQL
docker-compose ps postgres
docker-compose logs postgres

# Test connection
docker-compose exec postgres psql -U postgres -c "SELECT 1;"

# Restart postgres
docker-compose restart postgres
```

### Port đã được sử dụng

```bash
# Tìm process đang dùng port
lsof -i :8080
lsof -i :80
lsof -i :5432

# Kill process (cẩn thận!)
kill -9 <PID>
```

---

## 📊 Monitoring Commands

### Xem Resource Usage

```bash
# CPU và Memory
docker stats

# Disk I/O
iostat -x 1

# Network
iftop
```

### Xem Logs

```bash
# Tất cả logs
docker-compose logs --tail=100

# Logs của service cụ thể
docker-compose logs --tail=100 backend

# Logs realtime
docker-compose logs -f backend
```

---

## 🔄 Restart Services

```bash
# Restart tất cả
docker-compose restart

# Restart service cụ thể
docker-compose restart backend
docker-compose restart frontend

# Stop và start lại
docker-compose stop
docker-compose start

# Rebuild và restart
docker-compose up -d --build
```

---

## 📞 Thông Tin Hữu Ích

### IP VPS
- **IP:** 173.249.48.25
- **Provider:** Toolowx (có thể)

### Thư Mục Project
```bash
~/projects/SmartFarm
# hoặc
/root/projects/SmartFarm
```

### Docker Compose File
```bash
~/projects/SmartFarm/docker-compose.yml
```

---

**Lưu ý:** Nếu website không load được, kiểm tra logs và trạng thái containers trước!

