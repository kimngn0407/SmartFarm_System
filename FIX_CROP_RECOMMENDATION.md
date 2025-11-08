# 🔧 Sửa Lỗi Crop Recommendation: Load Quá Lâu và Không Hiển Thị Tên Cây

## ❌ Vấn Đề

1. **Load quá lâu**: Crop recommendation service mất nhiều thời gian để trả về kết quả
2. **Không hiển thị tên cây đúng**: Không hiển thị format "Dưa hấu (watermelon)" như mong muốn

---

## ✅ Giải Pháp

### 1. Sửa UI Frontend (Đã sửa trong code)

UI đã được cập nhật để hiển thị:
- Tên tiếng Việt: **Dưa hấu**
- Tên tiếng Anh trong ngoặc: **(watermelon)**
- Độ tin cậy: **80.0%**

**Cần rebuild frontend:**

```bash
cd ~/projects/SmartFarm

# Rebuild frontend
docker compose stop frontend
docker compose build --no-cache frontend
docker compose up -d frontend
```

### 2. Tối Ưu Performance - Kiểm Tra Timeout

**Kiểm tra backend timeout settings:**

```bash
# Xem logs backend khi gọi crop recommendation
docker compose logs backend | grep -i "crop\|recommend\|timeout" | tail -20
```

**Nếu timeout quá ngắn, cần tăng timeout trong backend:**

File: `demoSmartFarm/demo/src/main/java/com/example/demo/Services/AIRecommendationService.java`

Tìm và sửa:
```java
// Tăng timeout từ 5 giây lên 30 giây
restTemplate.setRequestFactory(new HttpComponentsClientHttpRequestFactory());
HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
factory.setConnectTimeout(5000);
factory.setReadTimeout(30000); // Tăng từ 5000 lên 30000
```

### 3. Kiểm Tra ML Service Performance

**Test trực tiếp ML service:**

```bash
# Test crop service trực tiếp
curl -X POST http://localhost:5000/api/recommend-crop \
  -H "Content-Type: application/json" \
  -d '{
    "temperature": 25,
    "humidity": 80,
    "soil_moisture": 45
  }'

# Kiểm tra thời gian response
time curl -X POST http://localhost:5000/api/recommend-crop \
  -H "Content-Type: application/json" \
  -d '{
    "temperature": 25,
    "humidity": 80,
    "soil_moisture": 45
  }'
```

**Nếu ML service chậm:**

1. **Kiểm tra model đã load chưa:**
```bash
curl http://localhost:5000/health
# Response phải có: "model_loaded": true
```

2. **Kiểm tra logs crop service:**
```bash
docker compose logs crop-service | tail -50
```

3. **Nếu model chưa load, restart service:**
```bash
docker compose restart crop-service
# Đợi 30-60 giây để model load
sleep 60
curl http://localhost:5000/health
```

### 4. Tối Ưu Frontend - Thêm Loading Indicator

Frontend đã có loading state, nhưng có thể cải thiện:

```javascript
// Trong CropRecommendation.js
const [loading, setLoading] = useState(false);

// Khi submit
setLoading(true);
try {
  const response = await cropRecommendationService.recommendCrop(requestData);
  // ...
} finally {
  setLoading(false);
}
```

### 5. Kiểm Tra Network Latency

**Kiểm tra kết nối giữa backend và ML service:**

```bash
# Từ trong backend container
docker exec smartfarm-backend ping crop-service

# Test API call từ backend
docker exec smartfarm-backend wget -O- http://crop-service:5000/health
```

---

## 🔍 Debug Chi Tiết

### Kiểm tra toàn bộ flow:

```bash
# 1. Kiểm tra ML service health
curl http://localhost:5000/health

# 2. Test ML service trực tiếp
curl -X POST http://localhost:5000/api/recommend-crop \
  -H "Content-Type: application/json" \
  -d '{"temperature": 25, "humidity": 80, "soil_moisture": 45}'

# 3. Test backend API
curl -X POST http://localhost:8080/api/crop/recommend \
  -H "Content-Type: application/json" \
  -d '{"temperature": 25, "humidity": 80, "soil_moisture": 45}'

# 4. Xem logs real-time
docker compose logs -f backend crop-service
```

### Nếu vẫn chậm:

1. **Kiểm tra resource usage:**
```bash
docker stats smartfarm-crop-service smartfarm-backend
```

2. **Kiểm tra network:**
```bash
docker network inspect smartfarm_smartfarm-network
```

3. **Tăng memory cho ML service (nếu cần):**
Trong `docker-compose.yml`:
```yaml
crop-service:
  deploy:
    resources:
      limits:
        memory: 2G
      reservations:
        memory: 1G
```

---

## ✅ Checklist Sau Khi Sửa

- [ ] Frontend đã rebuild và hiển thị đúng format "Dưa hấu (watermelon)"
- [ ] ML service health check trả về `model_loaded: true`
- [ ] Test API trực tiếp ML service < 5 giây
- [ ] Test API qua backend < 10 giây
- [ ] Frontend hiển thị loading indicator khi đang xử lý
- [ ] Kết quả hiển thị đầy đủ: tên Việt, tên Anh, độ tin cậy

---

## 🚀 Lệnh Nhanh - Sửa Tất Cả

```bash
cd ~/projects/SmartFarm

# 1. Rebuild frontend
docker compose stop frontend
docker compose build --no-cache frontend
docker compose up -d frontend

# 2. Restart ML service để đảm bảo model đã load
docker compose restart crop-service
sleep 60

# 3. Kiểm tra
curl http://localhost:5000/health
curl -X POST http://localhost:5000/api/recommend-crop \
  -H "Content-Type: application/json" \
  -d '{"temperature": 25, "humidity": 80, "soil_moisture": 45}'

# 4. Test qua backend
curl -X POST http://localhost:8080/api/crop/recommend \
  -H "Content-Type: application/json" \
  -d '{"temperature": 25, "humidity": 80, "soil_moisture": 45}'
```

**Sau đó refresh browser và test lại!**


