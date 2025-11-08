# 🔍 Hướng Dẫn Kiểm Tra Lỗi Crop Recommendation

## 📋 Các Bước Kiểm Tra Lỗi

### 1. Kiểm Tra Browser Console (Frontend)

**Mở browser và nhấn F12, chọn tab Console:**

1. **Test crop recommendation:**
   - Vào trang "Gợi Ý Cây Trồng"
   - Điền dữ liệu: Temp=25, Humidity=80, Soil=45
   - Click "Gợi ý cây trồng"

2. **Xem các logs:**
   ```
   🔍 Crop recommendation response: {...}
   🔍 Response type: object
   🔍 Response keys: [...]
   🔍 response.success: true/false
   🔍 response.recommended_crop: "..."
   🔍 isSuccess: true/false
   ✅ Setting result with: {...}
   🎨 Rendering crop name: "..."
   🎨 Full result object: {...}
   ```

3. **Nếu có lỗi, sẽ thấy:**
   ```
   ❌ Error response: ...
   Error recommending crop: ...
   ```

### 2. Kiểm Tra Network Tab (Frontend)

**Trong browser F12, chọn tab Network:**

1. **Filter:** Chọn "Fetch/XHR"
2. **Test crop recommendation**
3. **Tìm request:** `/api/crop/recommend`
4. **Kiểm tra:**
   - Status: 200 (OK) hay 4xx/5xx (Error)?
   - Request payload: `{temperature: 25, humidity: 80, soil_moisture: 45}`
   - Response body: Có `recommended_crop` không?

### 3. Kiểm Tra Backend Logs (VPS)

**SSH vào VPS và chạy:**

```bash
# Xem logs backend
docker compose logs -f backend | grep -i "crop\|recommend\|prediction"

# Hoặc xem tất cả logs
docker compose logs -f backend
```

**Tìm các logs:**
```
🔍 Raw Python service response: {...}
🔍 Response keys: [...]
🔍 recommended_crop value: "..."
✅ Set recommendedCrop: "..."
✅ AI prediction successful: ... (...)
🔍 AIPredictionResponse from service:
  - success: true
  - recommendedCrop: "..."
✅ Set recommended_crop: "..."
```

### 4. Kiểm Tra Python Service Logs (VPS)

```bash
# Xem logs crop-service
docker compose logs -f crop-service

# Tìm logs:
# Dự đoán: Dưa hấu (watermelon), Confidence: 0.8
```

### 5. Test API Trực Tiếp

**Trên VPS, test backend API:**

```bash
# Test crop recommendation API
curl -X POST http://localhost:8080/api/crop/recommend \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "temperature": 25,
    "humidity": 80,
    "soil_moisture": 45
  }'
```

**Kết quả mong đợi:**
```json
{
  "success": true,
  "recommended_crop": "Dưa hấu",
  "crop_name_en": "watermelon",
  "confidence": 0.8,
  "input_data": {
    "temperature": 25,
    "humidity": 80,
    "soil_moisture": 45
  }
}
```

## 🐛 Các Lỗi Thường Gặp

### Lỗi 1: Network Error / CORS

**Triệu chứng:**
- Browser console: `Network Error` hoặc `CORS policy`
- Network tab: Request failed

**Giải pháp:**
- Kiểm tra backend có chạy không: `docker compose ps backend`
- Kiểm tra CORS config trong `SecurityConfig.java`
- Kiểm tra `FRONTEND_ORIGINS` trong `docker-compose.yml`

### Lỗi 2: 500 Internal Server Error

**Triệu chứng:**
- Network tab: Status 500
- Backend logs: Exception stack trace

**Giải pháp:**
- Xem backend logs để tìm exception
- Kiểm tra Python service có chạy không: `docker compose ps crop-service`
- Kiểm tra model có được load không

### Lỗi 3: Response Không Có `recommended_crop`

**Triệu chứng:**
- Browser console: `⚠️ Response không có recommended_crop`
- UI hiển thị: "Cây trồng được gợi ý" (default)

**Giải pháp:**
- Kiểm tra Python service response
- Kiểm tra mapping trong `AIRecommendationService.java`
- Kiểm tra `CropRecommendationController.java`

### Lỗi 4: Component Không Render

**Triệu chứng:**
- Browser console: Có logs nhưng UI không hiển thị
- `result` có giá trị nhưng không render

**Giải pháp:**
- Kiểm tra condition render: `{result && ...}`
- Kiểm tra CSS có ẩn element không
- Xem `🎨 Rendering crop name:` log

## 📝 Checklist Debug

- [ ] Browser console không có JavaScript errors
- [ ] Network request thành công (200 OK)
- [ ] Response có `recommended_crop` field
- [ ] `result` state có giá trị
- [ ] Component render với `result && ...`
- [ ] Backend logs hiển thị prediction successful
- [ ] Python service logs hiển thị prediction

## 🔧 Script Test Nhanh

**Tạo file `test-crop-api.sh` trên VPS:**

```bash
#!/bin/bash

echo "Testing Crop Recommendation API..."

# Get token (cần login trước)
TOKEN="YOUR_JWT_TOKEN"

# Test API
curl -X POST http://localhost:8080/api/crop/recommend \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "temperature": 25,
    "humidity": 80,
    "soil_moisture": 45
  }' | jq .

echo ""
echo "✅ Test completed!"
```

**Chạy:**
```bash
chmod +x test-crop-api.sh
./test-crop-api.sh
```

---

**Nếu vẫn có lỗi, gửi cho tôi:**
1. Browser console logs (F12 → Console)
2. Network request/response (F12 → Network)
3. Backend logs (`docker compose logs backend`)
4. Python service logs (`docker compose logs crop-service`)

