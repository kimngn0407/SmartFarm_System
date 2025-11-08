# 🌾 Tạo Dữ Liệu Mẫu Cho SmartFarm

## ❌ Vấn Đề

Database trên VPS không có dữ liệu:
- ✅ Login thành công
- ❌ Farms: `[]` (empty)
- ❌ Sensors: `0`
- ❌ Fields: `[]`

## 🔨 Giải Pháp

### Option 1: Chạy Script Tự Động (Khuyến Nghị)

**Trên VPS:**
```bash
cd ~/projects/SmartFarm && git pull origin main && chmod +x create-sample-data.sh && ./create-sample-data.sh
```

Script sẽ tự động:
1. Tìm account đầu tiên trong database
2. Tạo 2 Farms mẫu
3. Tạo 3 Fields mẫu
4. Tạo Sensors mẫu
5. Tạo Sensor Data mẫu

### Option 2: Tạo Dữ Liệu Qua UI

1. **Đăng nhập** vào hệ thống
2. **Vào Farm Manager** (`/farm`)
3. **Tạo Farm mới:**
   - Farm Name: `Nông trại Đà Lạt`
   - Area: `5000`
   - Region: `Đà Lạt, Lâm Đồng`
   - Lat/Lng: `11.9404, 108.4583`
4. **Vào Field Manager** (`/field`)
5. **Tạo Field mới:**
   - Field Name: `Cánh đồng lúa số 1`
   - Farm: Chọn farm vừa tạo
   - Area: `1000`
   - Status: `GOOD`
6. **Vào Sensor Manager** (`/sensor`)
7. **Tạo Sensors:**
   - Sensor Name: `Cảm biến nhiệt độ 1`
   - Field: Chọn field vừa tạo
   - Type: `temperature`
   - Status: `active`

### Option 3: Tạo Dữ Liệu Qua API

**Trên VPS:**
```bash
# Lấy token từ login
TOKEN="YOUR_JWT_TOKEN"

# 1. Tạo Farm
curl -X POST http://173.249.48.25:8080/api/farms \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "farmName": "Nông trại Đà Lạt",
    "ownerId": 1,
    "area": 5000.0,
    "region": "Đà Lạt, Lâm Đồng",
    "lat": 11.9404,
    "lng": 108.4583
  }'

# 2. Tạo Field (cần farm_id từ response trên)
curl -X POST http://173.249.48.25:8080/api/fields \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "fieldName": "Cánh đồng lúa số 1",
    "farmId": 1,
    "status": "GOOD",
    "area": 1000.0,
    "region": "Đà Lạt, Lâm Đồng"
  }'

# 3. Tạo Sensor (cần field_id từ response trên)
curl -X POST http://173.249.48.25:8080/api/sensors \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "sensorName": "Cảm biến nhiệt độ 1",
    "fieldId": 1,
    "type": "temperature",
    "status": "active",
    "lat": 11.9404,
    "lng": 108.4583
  }'
```

## 🧪 Kiểm Tra Sau Khi Tạo

1. **Mở Dashboard:** `http://173.249.48.25/dashboard`
2. **Kiểm tra:**
   - ✅ Farms count > 0
   - ✅ Fields count > 0
   - ✅ Sensors count > 0
   - ✅ Charts hiển thị data

## 📝 Lưu Ý

- **Script tự động** sẽ tạo dữ liệu mẫu dựa trên account đầu tiên trong database
- **Nếu không có account**, cần đăng ký tài khoản trước
- **Dữ liệu mẫu** sẽ được tạo với tên cụ thể để dễ nhận biết

---

**Chúc bạn fix thành công! 🎉**

