# 🔧 Sửa Lỗi 403 Forbidden và Gợi Ý Cây Trồng

## ✅ Đã Sửa

### 1. Lỗi 403 Forbidden khi gọi API Profile và Accounts

**Vấn đề:**
- Frontend gọi `/api/accounts/profile` và `/api/accounts/all` nhưng không gửi Authorization header
- Backend yêu cầu JWT token với role ADMIN/FARMER/etc.

**Giải pháp:**
- ✅ Thêm `Authorization: Bearer ${token}` header vào:
  - `profileService.getCurrentUserProfile()`
  - `profileService.getAllAccounts()`

**Files đã sửa:**
- `J2EE_Frontend/src/services/profileService.js`

### 2. Gợi Ý Cây Trồng Không Giống Mẫu

**Vấn đề:**
- Frontend check `result.crop` nhưng backend trả về `result.recommended_crop`
- Response format không đúng với frontend expect

**Giải pháp:**
- ✅ Sửa logic check response: `!result.success && !result.recommended_crop`
- ✅ Đảm bảo `input_data` luôn có trong response
- ✅ Backend trả về format: `{ success: true, recommended_crop: "...", crop_name_en: "...", confidence: 0.8, input_data: {...} }`

**Files đã sửa:**
- `J2EE_Frontend/src/services/cropRecommendationService.js`

## 🚀 Triển Khai Lên VPS

### Bước 1: Pull Latest Code

```bash
cd ~/projects/SmartFarm
git pull origin main
```

### Bước 2: Rebuild Frontend

```bash
# Stop frontend
docker compose stop frontend

# Remove old container
docker compose rm -f frontend

# Rebuild với no cache
docker compose build --no-cache frontend

# Start frontend
docker compose up -d frontend
```

### Bước 3: Kiểm Tra

1. **Test Profile API:**
   - Login: `http://173.249.48.25/login`
   - Vào Profile page
   - Không còn lỗi 403

2. **Test Crop Recommendation:**
   - Vào trang "Gợi Ý Cây Trồng"
   - Điền dữ liệu mẫu: Temp=25°C, Humidity=80%, Soil=45%
   - Click "Gợi ý cây trồng"
   - Kết quả hiển thị đúng với format: `recommended_crop`, `confidence`, `input_data`

## 📝 Chi Tiết Thay Đổi

### profileService.js

**Trước:**
```javascript
const response = await axios.get(
  `${API_BASE_URL}/api/accounts/profile?email=${email}`
);
```

**Sau:**
```javascript
const response = await axios.get(
  `${API_BASE_URL}/api/accounts/profile?email=${email}`,
  { headers: getAuthHeader() }
);
```

### cropRecommendationService.js

**Trước:**
```javascript
if (!result.success && !result.crop) {
  return { success: false, error: ... };
}
```

**Sau:**
```javascript
if (!result.success && !result.recommended_crop) {
  return { success: false, error: ... };
}

// Đảm bảo có input_data
if (result.success && !result.input_data) {
  result.input_data = {
    temperature: result.temperature || '',
    humidity: result.humidity || '',
    soil_moisture: result.soil_moisture || ''
  };
}
```

## ✅ Kết Quả Mong Đợi

1. ✅ Không còn lỗi 403 khi load profile
2. ✅ Không còn lỗi 403 khi load accounts list (nếu là ADMIN)
3. ✅ Crop recommendation hiển thị đúng format với:
   - Tên cây trồng (recommended_crop)
   - Tên tiếng Anh (crop_name_en)
   - Độ tin cậy (confidence)
   - Thông số đầu vào (input_data)

---

**Chúc bạn test thành công! 🎉**

