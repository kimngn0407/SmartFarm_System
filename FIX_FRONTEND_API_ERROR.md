# 🔧 Sửa Lỗi Frontend API và ML Services

## ❌ Vấn Đề

1. **Frontend đang gọi `localhost:8080`** thay vì `173.249.48.25:8080`
2. **2 service AI không hoạt động** (crop-service và pest-service)

---

## ✅ Giải Pháp

### 1. Rebuild Frontend với đúng API URL

**Trên VPS, chạy:**

```bash
cd ~/projects/SmartFarm

# Dừng frontend
docker compose stop frontend

# Rebuild frontend với đúng API URL
docker compose build --no-cache frontend

# Start lại frontend
docker compose up -d frontend

# Kiểm tra logs
docker compose logs -f frontend
```

### 2. Kiểm Tra Backend Có Chạy Không

```bash
# Kiểm tra backend container
docker ps | grep smartfarm-backend

# Kiểm tra backend logs
docker compose logs backend | tail -50

# Kiểm tra backend health
curl http://localhost:8080/actuator/health

# Nếu backend không chạy, start lại
docker compose up -d backend
docker compose logs -f backend
```

### 3. Kiểm Tra và Sửa ML Services

#### Kiểm tra Crop Service:

```bash
# Kiểm tra container
docker ps | grep smartfarm-crop-service

# Kiểm tra logs
docker compose logs crop-service | tail -50

# Kiểm tra health
curl http://localhost:5000/health

# Nếu không chạy, restart
docker compose restart crop-service
docker compose logs -f crop-service
```

#### Kiểm tra Pest Service:

```bash
# Kiểm tra container
docker ps | grep smartfarm-pest-service

# Kiểm tra logs
docker compose logs pest-service | tail -50

# Kiểm tra health
curl http://localhost:5001/health

# Nếu không chạy, restart
docker compose restart pest-service
docker compose logs -f pest-service
```

### 4. Rebuild Tất Cả Services (Nếu Cần)

```bash
cd ~/projects/SmartFarm

# Dừng tất cả
docker compose down

# Rebuild tất cả với đúng cấu hình
docker compose build --no-cache

# Start lại
docker compose up -d

# Kiểm tra tất cả services
docker compose ps
```

---

## 🔍 Kiểm Tra Chi Tiết

### Kiểm tra Frontend đã dùng đúng API URL:

```bash
# Vào trong container frontend
docker exec -it smartfarm-frontend sh

# Kiểm tra environment variables
env | grep REACT_APP

# Hoặc kiểm tra file build
cat /usr/share/nginx/html/static/js/*.js | grep -o "http://[^/]*" | head -5
```

### Kiểm tra Network:

```bash
# Kiểm tra frontend có kết nối được backend không
docker exec smartfarm-frontend wget -O- http://backend:8080/actuator/health

# Kiểm tra backend có kết nối được ML services không
docker exec smartfarm-backend wget -O- http://crop-service:5000/health
docker exec smartfarm-backend wget -O- http://pest-service:5001/health
```

---

## 🐛 Xử Lý Lỗi Cụ Thể

### Lỗi: "ERR_CONNECTION_REFUSED" khi gọi API

**Nguyên nhân:** Backend không chạy hoặc không accessible

**Giải pháp:**

```bash
# 1. Kiểm tra backend có chạy không
docker compose ps backend

# 2. Nếu không chạy, start lại
docker compose up -d backend

# 3. Kiểm tra logs để tìm lỗi
docker compose logs backend | tail -100

# 4. Kiểm tra port 8080 có bị chiếm không
netstat -tulpn | grep :8080
```

### Lỗi: ML Services không trả về kết quả

**Nguyên nhân:** Service chưa sẵn sàng hoặc có lỗi

**Giải pháp:**

```bash
# 1. Kiểm tra logs
docker compose logs crop-service | tail -100
docker compose logs pest-service | tail -100

# 2. Kiểm tra health endpoint
curl -v http://localhost:5000/health
curl -v http://localhost:5001/health

# 3. Nếu có lỗi, rebuild service
docker compose build --no-cache crop-service pest-service
docker compose up -d crop-service pest-service

# 4. Đợi service khởi động (ML models cần thời gian load)
sleep 30

# 5. Test lại
curl http://localhost:5000/health
curl http://localhost:5001/health
```

### Lỗi: "fieldId is required"

**Nguyên nhân:** Frontend gọi API thiếu tham số

**Giải pháp:**

1. Kiểm tra code frontend có truyền đúng `fieldId` không
2. Kiểm tra backend API có yêu cầu `fieldId` không
3. Xem logs backend để biết request nào bị lỗi:

```bash
docker compose logs backend | grep -i "fieldId\|irrigation\|fertilization"
```

---

## ✅ Checklist Sau Khi Sửa

- [ ] Frontend đã rebuild với đúng API URL (`http://173.249.48.25:8080`)
- [ ] Backend đang chạy và accessible
- [ ] Crop service đang chạy và trả về `/health`
- [ ] Pest service đang chạy và trả về `/health`
- [ ] Frontend có thể gọi được backend API
- [ ] Backend có thể gọi được ML services
- [ ] Không còn lỗi "ERR_CONNECTION_REFUSED"
- [ ] Không còn lỗi "fieldId is required"

---

## 🚀 Lệnh Nhanh - Sửa Tất Cả

```bash
cd ~/projects/SmartFarm

# 1. Rebuild frontend
docker compose build --no-cache frontend
docker compose up -d frontend

# 2. Restart backend
docker compose restart backend

# 3. Restart ML services
docker compose restart crop-service pest-service

# 4. Đợi services khởi động
sleep 30

# 5. Kiểm tra
docker compose ps
curl http://localhost:8080/actuator/health
curl http://localhost:5000/health
curl http://localhost:5001/health
```

**Sau đó refresh browser và test lại!**


