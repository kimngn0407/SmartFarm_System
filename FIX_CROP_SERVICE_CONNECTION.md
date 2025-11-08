# 🔧 Sửa Lỗi Connection Refused - Crop Service

## 🐛 Vấn Đề

Backend không thể kết nối đến Python crop-service:
```
Error calling AI API: I/O error on POST request for "http://localhost:5000/api/recommend-crop": Connection refused
```

**Nguyên nhân:**
- Backend đang dùng `localhost:5000` thay vì `crop-service:5000` (service name trong Docker network)
- Property name không khớp: Code dùng `crop.recommendation.service.url` nhưng properties file dùng `crop.recommendation.url`

## ✅ Đã Sửa

1. **Sửa property name trong `AIRecommendationService.java`:**
   - Trước: `@Value("${crop.recommendation.service.url:http://localhost:5000}")`
   - Sau: `@Value("${crop.recommendation.url:http://crop-service:5000}")`

2. **Default URL đã đúng:** `http://crop-service:5000` (service name trong Docker network)

## 🚀 Triển Khai Lên VPS

### Bước 1: Pull Latest Code

```bash
cd ~/projects/SmartFarm
git pull origin main
```

### Bước 2: Kiểm Tra Crop Service

```bash
# Kiểm tra crop-service có chạy không
docker compose ps crop-service

# Xem logs crop-service
docker compose logs crop-service

# Kiểm tra health
docker compose logs crop-service | grep -i "health\|model\|ready"
```

### Bước 3: Rebuild Backend

```bash
# Stop backend
docker compose stop backend

# Remove old container
docker compose rm -f backend

# Rebuild với no cache
docker compose build --no-cache backend

# Start backend
docker compose up -d backend
```

### Bước 4: Kiểm Tra Kết Nối

```bash
# Xem logs backend để kiểm tra kết nối
docker compose logs -f backend | grep -i "crop\|recommend"

# Sẽ thấy:
# ✅ Calling AI API for prediction: {...}
# ✅ AI prediction successful: Dưa hấu (watermelon)
# ✅ Set recommendedCrop: Dưa hấu
```

## 🔍 Kiểm Tra Chi Tiết

### 1. Kiểm Tra Crop Service Status

```bash
# Xem status
docker compose ps crop-service

# Kết quả mong đợi:
# smartfarm-crop-service   Up X minutes (healthy)
```

### 2. Test Crop Service Trực Tiếp

```bash
# Test từ backend container
docker exec smartfarm-backend wget -qO- http://crop-service:5000/health

# Hoặc từ host
curl http://localhost:5000/health

# Kết quả mong đợi:
# {"status":"healthy","model_loaded":true}
```

### 3. Kiểm Tra Backend Logs

```bash
# Xem logs sau khi rebuild
docker compose logs backend | tail -50

# Tìm:
# ✅ Calling AI API for prediction: {...}
# ✅ AI prediction successful: ... (...)
# ✅ Set recommendedCrop: ...
```

## 📝 Lưu Ý

- **Service name trong Docker:** Phải dùng `crop-service:5000` (không phải `localhost:5000`)
- **Environment variable:** `CROP_RECOMMENDATION_URL=http://crop-service:5000` (đã có trong docker-compose.yml)
- **Property name:** `crop.recommendation.url` (đã match với application-prod.properties)

## ✅ Kết Quả Mong Đợi

Sau khi rebuild, backend logs sẽ hiển thị:
```
INFO: Calling AI API for prediction: {temperature=25.0, humidity=80.0, soil_moisture=45.0}
INFO: 🔍 Raw Python service response: {success=true, recommended_crop=Dưa hấu, ...}
INFO: ✅ Set recommendedCrop: Dưa hấu
INFO: ✅ AI prediction successful: Dưa hấu (watermelon)
```

Và frontend sẽ hiển thị tên cây trồng đúng!

---

**Sau khi rebuild backend, test lại crop recommendation! 🎉**

