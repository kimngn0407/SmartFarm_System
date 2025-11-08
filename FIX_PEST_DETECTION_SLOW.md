# 🔧 Sửa Lỗi Pest Detection Load Quá Lâu

## ❌ Vấn Đề

Pest detection service (dự đoán sâu bệnh) load kết quả rất lâu, có thể mất 30-60 giây hoặc timeout.

**Nguyên nhân:**
1. **Model Vision Transformer (ViT) rất lớn** - cần thời gian load và xử lý
2. **Backend timeout quá ngắn** - không đủ thời gian cho model xử lý
3. **Model chưa được load vào memory** - phải load lại mỗi lần
4. **Image processing chậm** - resize và transform ảnh lớn

---

## ✅ Giải Pháp

### 1. Kiểm Tra Model Đã Load Chưa

**Trên VPS, chạy:**

```bash
# Kiểm tra health của pest service
curl http://localhost:5001/health

# Response phải có:
# {
#   "status": "healthy",
#   "model_loaded": true,
#   "device": "cpu" hoặc "cuda",
#   "classes": 4
# }
```

**Nếu `model_loaded: false`, restart service:**

```bash
docker compose restart pest-service

# Đợi 60-90 giây để model load (ViT model rất lớn)
sleep 90

# Kiểm tra lại
curl http://localhost:5001/health
```

### 2. Tăng Timeout Cho Backend

**File cần sửa:** `demoSmartFarm/demo/src/main/java/com/example/demo/Services/PestDiseaseService.java`

**Thêm timeout configuration:**

```java
@Service
public class PestDiseaseService {

    private final RestTemplate restTemplate;

    public PestDiseaseService() {
        // Tạo RestTemplate với timeout dài hơn
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        factory.setConnectTimeout(5000);      // 5 giây để connect
        factory.setReadTimeout(120000);       // 120 giây (2 phút) để đọc response - QUAN TRỌNG!
        factory.setConnectionRequestTimeout(5000);
        
        this.restTemplate = new RestTemplate(factory);
    }
    
    // ... rest of code
}
```

**Sau khi sửa, rebuild backend:**

```bash
cd ~/projects/SmartFarm
docker compose stop backend
docker compose build --no-cache backend
docker compose up -d backend
```

### 3. Tối Ưu Image Processing

**Kiểm tra kích thước ảnh:**

Frontend đã giới hạn 10MB, nhưng có thể tối ưu thêm:

```javascript
// Trong PestDetection.js, thêm resize ảnh trước khi gửi
const resizeImage = (file, maxWidth = 800, maxHeight = 800) => {
  return new Promise((resolve) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      const img = new Image();
      img.onload = () => {
        const canvas = document.createElement('canvas');
        let width = img.width;
        let height = img.height;
        
        if (width > height) {
          if (width > maxWidth) {
            height *= maxWidth / width;
            width = maxWidth;
          }
        } else {
          if (height > maxHeight) {
            width *= maxHeight / height;
            height = maxHeight;
          }
        }
        
        canvas.width = width;
        canvas.height = height;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, width, height);
        
        canvas.toBlob(resolve, 'image/jpeg', 0.8);
      };
      img.src = e.target.result;
    };
    reader.readAsDataURL(file);
  });
};

// Sử dụng trong handleDetect
const resizedImage = await resizeImage(selectedImage);
const response = await pestDiseaseService.detectDisease(resizedImage);
```

### 4. Kiểm Tra Performance Trực Tiếp

**Test trực tiếp ML service:**

```bash
# Test với ảnh mẫu (cần có file ảnh)
time curl -X POST http://localhost:5001/api/detect \
  -F "image=@test_image.jpg"

# Hoặc test với base64 (nếu có)
curl -X POST http://localhost:5001/api/detect \
  -H "Content-Type: application/json" \
  -d '{"image": "base64_encoded_image_here"}'
```

**Kiểm tra resource usage:**

```bash
# Xem CPU và Memory usage
docker stats smartfarm-pest-service

# Nếu memory quá cao, có thể cần tăng memory limit
```

### 5. Tăng Memory Cho Pest Service

**Trong `docker-compose.yml`:**

```yaml
pest-service:
  # ... existing config ...
  deploy:
    resources:
      limits:
        memory: 4G      # Tăng từ default lên 4GB
      reservations:
        memory: 2G
```

**Sau đó restart:**

```bash
docker compose up -d pest-service
```

### 6. Kiểm Tra Logs

**Xem logs để tìm bottleneck:**

```bash
# Xem logs real-time khi test
docker compose logs -f pest-service

# Tìm các dòng liên quan đến model loading
docker compose logs pest-service | grep -i "model\|load\|cuda\|device"

# Kiểm tra thời gian xử lý
docker compose logs pest-service | grep -i "prediction\|confidence"
```

---

## 🔍 Debug Chi Tiết

### Kiểm tra toàn bộ flow:

```bash
# 1. Kiểm tra service health
curl http://localhost:5001/health

# 2. Test trực tiếp ML service (đo thời gian)
time curl -X POST http://localhost:5001/api/detect \
  -F "image=@test_image.jpg"

# 3. Test qua backend
time curl -X POST http://localhost:8080/api/pest-disease/detect \
  -F "image=@test_image.jpg"

# 4. Xem logs real-time
docker compose logs -f backend pest-service
```

### Nếu vẫn chậm:

1. **Kiểm tra model file có tồn tại:**
```bash
docker exec smartfarm-pest-service ls -lh best_vit_wheat_model_4classes.pth
```

2. **Kiểm tra device (CPU vs GPU):**
```bash
docker exec smartfarm-pest-service python -c "import torch; print(torch.cuda.is_available())"
```

3. **Kiểm tra network latency:**
```bash
docker exec smartfarm-backend ping pest-service
docker exec smartfarm-backend wget -O- http://pest-service:5001/health
```

---

## ✅ Checklist Sau Khi Sửa

- [ ] Pest service health check trả về `model_loaded: true`
- [ ] Backend timeout đã tăng lên 120 giây
- [ ] Test API trực tiếp ML service < 30 giây (cho ảnh nhỏ)
- [ ] Test API qua backend < 60 giây
- [ ] Frontend hiển thị loading indicator rõ ràng
- [ ] Memory limit đã tăng nếu cần

---

## 🚀 Lệnh Nhanh - Sửa Tất Cả

```bash
cd ~/projects/SmartFarm

# 1. Kiểm tra model đã load
curl http://localhost:5001/health

# 2. Nếu chưa load, restart và đợi
docker compose restart pest-service
sleep 90

# 3. Kiểm tra lại
curl http://localhost:5001/health

# 4. Tăng timeout trong backend code (cần sửa file Java)
# Sau đó rebuild backend:
docker compose stop backend
docker compose build --no-cache backend
docker compose up -d backend

# 5. Test
time curl -X POST http://localhost:5001/api/detect \
  -F "image=@test_image.jpg"
```

---

## 💡 Lưu Ý

1. **ViT model rất lớn** - lần đầu load có thể mất 30-60 giây
2. **Inference time** - mỗi ảnh cần 5-15 giây để xử lý (tùy kích thước)
3. **CPU vs GPU** - Nếu có GPU, model sẽ chạy nhanh hơn nhiều
4. **Image size** - Ảnh nhỏ hơn (< 1MB) sẽ xử lý nhanh hơn

**Nếu vẫn quá chậm sau khi sửa, có thể cần:**
- Sử dụng GPU (nếu có)
- Giảm kích thước model
- Sử dụng model nhẹ hơn (MobileNet thay vì ViT)


