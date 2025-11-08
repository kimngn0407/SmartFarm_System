# 🚀 Hướng dẫn Chạy Toàn Bộ Ứng Dụng SmartFarm trên VPS

## 📋 Các Services trong Hệ Thống

1. **PostgreSQL Database** - Port 5432
2. **Spring Boot Backend API** - Port 8080
3. **React Frontend** - Port 80
4. **Crop Recommendation ML Service** - Port 5000
5. **Pest & Disease Detection ML Service** - Port 5001
6. **Next.js AI Chatbot** - Port 9002
7. **Nginx Reverse Proxy** (Optional) - Port 443, 8443

---

## 🎯 Cách 1: Chạy Tất Cả Services (Khuyến nghị)

**Trên VPS, chạy:**

```bash
cd ~/projects/SmartFarm

# Kiểm tra file .env có chưa
if [ ! -f .env ]; then
    echo "⚠️  File .env chưa có, tạo từ env.example..."
    cp env.example .env
    echo "✅ Đã tạo file .env, vui lòng chỉnh sửa nếu cần"
fi

# Build và start tất cả services
docker compose up -d --build

# Xem logs của tất cả services
docker compose logs -f
```

**Hoặc start từng service một:**

```bash
# 1. Start database trước
docker compose up -d postgres

# Đợi database sẵn sàng (khoảng 10 giây)
sleep 10

# 2. Start ML services
docker compose up -d crop-service pest-service

# Đợi ML services sẵn sàng (khoảng 30 giây)
sleep 30

# 3. Start backend
docker compose up -d backend

# Đợi backend sẵn sàng (khoảng 60 giây)
sleep 60

# 4. Start frontend và chatbot
docker compose up -d frontend chatbot

# 5. Start nginx (nếu cần)
docker compose up -d nginx
```

---

## ✅ Kiểm Tra Services Đã Chạy

```bash
# Kiểm tra tất cả containers
docker compose ps

# Hoặc
docker ps

# Kiểm tra logs từng service
docker compose logs postgres
docker compose logs backend
docker compose logs frontend
docker compose logs crop-service
docker compose logs pest-service
docker compose logs chatbot
```

---

## 🔍 Kiểm Tra Health của Services

```bash
# Kiểm tra database
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT version();"

# Kiểm tra backend API
curl http://localhost:8080/actuator/health

# Kiểm tra crop service
curl http://localhost:5000/health

# Kiểm tra pest service
curl http://localhost:5001/health

# Kiểm tra frontend
curl http://localhost/

# Kiểm tra chatbot
curl http://localhost:9002/api/health
```

---

## 🌐 Truy Cập Ứng Dụng

Sau khi tất cả services đã chạy, truy cập:

- **Frontend (React):** `http://173.249.48.25` hoặc `http://173.249.48.25:80`
- **Backend API:** `http://173.249.48.25:8080`
- **API Documentation:** `http://173.249.48.25:8080/swagger-ui.html` (nếu có)
- **Chatbot:** `http://173.249.48.25:9002`
- **Crop ML Service:** `http://173.249.48.25:5000`
- **Pest ML Service:** `http://173.249.48.25:5001`

---

## 🔧 Các Lệnh Quản Lý

### Dừng tất cả services:

```bash
docker compose down
```

### Dừng và xóa volumes (xóa data):

```bash
docker compose down -v
```

### Restart một service cụ thể:

```bash
docker compose restart backend
docker compose restart frontend
docker compose restart postgres
```

### Xem logs real-time:

```bash
# Tất cả services
docker compose logs -f

# Một service cụ thể
docker compose logs -f backend
docker compose logs -f frontend
```

### Rebuild một service:

```bash
docker compose up -d --build backend
docker compose up -d --build frontend
```

---

## 🐛 Xử Lý Lỗi

### Lỗi Frontend gọi API đến localhost thay vì VPS IP:

**Triệu chứng:** `ERR_CONNECTION_REFUSED` khi frontend gọi API

**Giải pháp:**

```bash
# Rebuild frontend với đúng API URL
docker compose stop frontend
docker compose build --no-cache frontend
docker compose up -d frontend
```

**Xem chi tiết:** [FIX_FRONTEND_API_ERROR.md](./FIX_FRONTEND_API_ERROR.md)

### Lỗi ML Services không hoạt động:

**Triệu chứng:** Crop/Pest service không trả về kết quả

**Giải pháp:**

```bash
# Kiểm tra logs
docker compose logs crop-service | tail -50
docker compose logs pest-service | tail -50

# Restart services
docker compose restart crop-service pest-service

# Đợi services load models (cần thời gian)
sleep 30

# Kiểm tra health
curl http://localhost:5000/health
curl http://localhost:5001/health
```

### Service không start được:

```bash
# Xem logs để tìm lỗi
docker compose logs <service_name>

# Ví dụ:
docker compose logs backend
docker compose logs postgres
```

### Port đã được sử dụng:

```bash
# Kiểm tra port nào đang được dùng
netstat -tulpn | grep :8080
netstat -tulpn | grep :80

# Hoặc
lsof -i :8080
lsof -i :80

# Dừng service đang dùng port đó hoặc đổi port trong docker-compose.yml
```

### Database connection error:

```bash
# Kiểm tra database có chạy không
docker compose ps postgres

# Kiểm tra kết nối
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT 1;"

# Restart backend
docker compose restart backend
```

### Backend không kết nối được database:

```bash
# Kiểm tra environment variables
docker exec smartfarm-backend env | grep SPRING_DATASOURCE

# Kiểm tra network
docker network ls
docker network inspect smartfarm_smartfarm-network
```

---

## 📊 Kiểm Tra Tài Nguyên

```bash
# Xem CPU, Memory usage
docker stats

# Xem disk usage
docker system df

# Xem logs size
docker compose logs --tail=100
```

---

## 🔄 Update và Deploy Mới

```bash
cd ~/projects/SmartFarm

# Pull code mới nhất (nếu dùng Git)
git pull origin main

# Rebuild và restart
docker compose down
docker compose up -d --build

# Hoặc chỉ rebuild service thay đổi
docker compose up -d --build backend
```

---

## ✅ Checklist Sau Khi Start

- [ ] Database đã chạy và có dữ liệu
- [ ] Backend API đã start và kết nối được database
- [ ] Frontend đã build và chạy
- [ ] ML services (crop, pest) đã sẵn sàng
- [ ] Chatbot đã chạy
- [ ] Có thể truy cập frontend qua browser
- [ ] API endpoints hoạt động

---

**Chúc bạn deploy thành công! 🎉**

