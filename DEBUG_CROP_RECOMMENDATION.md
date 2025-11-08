# 🔍 Debug Crop Recommendation - Tên Cây Trồng Không Hiển Thị

## ✅ Đã Thêm Logging

Đã thêm logging chi tiết vào:
1. **Backend (Java):**
   - `AIRecommendationService.java` - Log response từ Python service
   - `CropRecommendationController.java` - Log mapping từ DTO sang response

2. **Frontend (React):**
   - `cropRecommendationService.js` - Log raw response từ backend
   - `CropRecommendation.js` - Log processed response

## 🔍 Cách Kiểm Tra

### Bước 1: Rebuild Backend và Frontend trên VPS

```bash
cd ~/projects/SmartFarm
git pull origin main

# Rebuild backend
docker compose stop backend
docker compose rm -f backend
docker compose build --no-cache backend
docker compose up -d backend

# Rebuild frontend
docker compose stop frontend
docker compose rm -f frontend
docker compose build --no-cache frontend
docker compose up -d frontend
```

### Bước 2: Kiểm Tra Backend Logs

**Xem logs của backend container:**
```bash
docker compose logs -f backend
```

**Sau đó test crop recommendation, bạn sẽ thấy logs như:**
```
🔍 Raw Python service response: {...}
🔍 Response keys: [success, recommended_crop, crop_name_en, confidence, input_data]
🔍 recommended_crop value: Dưa hấu
🔍 crop_name_en value: watermelon
✅ Set recommendedCrop: Dưa hấu
✅ AI prediction successful - Final AIPredictionResponse: recommendedCrop=Dưa hấu, cropNameEn=watermelon, confidence=0.8

🔍 AIPredictionResponse from service:
  - success: true
  - recommendedCrop: Dưa hấu
  - cropNameEn: watermelon
  - confidence: 0.8
✅ Set recommended_crop: Dưa hấu
```

### Bước 3: Kiểm Tra Frontend Console

1. Mở browser: `http://173.249.48.25`
2. Nhấn **F12** để mở Developer Tools
3. Chọn tab **Console**
4. Test crop recommendation với dữ liệu mẫu:
   - Temp: 25°C
   - Humidity: 80%
   - Soil: 45%
5. Xem logs trong console:

```
🔍 Raw crop recommendation response: {success: true, recommended_crop: "Dưa hấu", ...}
🔍 Response keys: ["success", "recommended_crop", "crop_name_en", "confidence", "input_data"]
✅ Final processed result: {success: true, recommended_crop: "Dưa hấu", crop_name_en: "watermelon", confidence: 0.8, input_data: {...}}

🔍 Crop recommendation response: {success: true, recommended_crop: "Dưa hấu", ...}
🔍 Response keys: ["success", "recommended_crop", "crop_name_en", "confidence", "input_data"]
```

## 🐛 Các Trường Hợp Có Thể Xảy Ra

### Trường Hợp 1: Python Service Không Trả Về `recommended_crop`

**Backend logs sẽ hiển thị:**
```
⚠️ Response không có key 'recommended_crop'
⚠️ recommendedCrop is null/empty, trying cropNameEn: 'watermelon'
✅ Set recommended_crop from cropNameEn: watermelon
```

**Giải pháp:** Kiểm tra Python service có chạy đúng không:
```bash
docker compose logs crop-service
```

### Trường Hợp 2: Response Có Nhưng Bị Null/Empty

**Backend logs sẽ hiển thị:**
```
🔍 recommended_crop value: null
⚠️ recommendedCrop is null/empty, trying cropNameEn: 'watermelon'
```

**Giải pháp:** Kiểm tra Python service response format

### Trường Hợp 3: Frontend Không Nhận Được Response

**Frontend console sẽ hiển thị:**
```
🔍 Raw crop recommendation response: null
❌ Error: ...
```

**Giải pháp:** Kiểm tra network tab trong browser để xem API call có thành công không

### Trường Hợp 4: Response Đúng Nhưng Component Không Render

**Frontend console sẽ hiển thị:**
```
✅ Final processed result: {success: true, recommended_crop: "Dưa hấu", ...}
🔍 Crop recommendation response: {success: true, recommended_crop: "Dưa hấu", ...}
```

Nhưng UI không hiển thị → Kiểm tra component render logic

## 📋 Checklist Debug

- [ ] Backend logs hiển thị response từ Python service
- [ ] Backend logs hiển thị `recommendedCrop` không null
- [ ] Backend logs hiển thị `Set recommended_crop: ...`
- [ ] Frontend console hiển thị raw response
- [ ] Frontend console hiển thị processed result
- [ ] Network tab hiển thị API call thành công (200 OK)
- [ ] Response body có `recommended_crop` field

## 🔧 Nếu Vẫn Không Hiển Thị

**Gửi cho tôi:**
1. Backend logs (từ `docker compose logs backend`)
2. Frontend console logs (từ browser F12)
3. Network request/response (từ browser Network tab)

---

**Sau khi rebuild, test lại và xem logs để tìm vấn đề! 🔍**

