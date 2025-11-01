# 📖 HƯỚNG DẪN TẠO DATA QUA FRONTEND

## 🎯 KHÔNG CẦN pg_dump, KHÔNG CẦN psql!

Chỉ cần dùng Frontend để tạo data!

---

## 📋 BƯỚC 1: LOGIN

1. Mở trình duyệt
2. Vào: **https://hackathon-pione-dream.vercel.app/**
3. Đăng nhập:
   - **Email:** `admin@smartfarm.com`
   - **Password:** `123456`
4. Click **"ĐĂNG NHẬP"**

---

## 🏢 BƯỚC 2: TẠO FARM

1. Vào menu **"Farms"** hoặc **"Nông Trại"** (sidebar bên trái)
2. Click nút **"Add Farm"** hoặc **"Thêm Nông Trại"**
3. Điền thông tin:
   ```
   Name:        Nông Trại Đà Lạt
   Location:    Đà Lạt, Lâm Đồng
   Area:        50000
   Description: Nông trại trồng rau sạch cao cấp
   ```
4. Click **"Save"** hoặc **"Lưu"**
5. ✅ Farm đã được tạo!

**Lặp lại để tạo thêm farms:**
- Nông Trại 2: Vườn Hoa Hồng (Đà Lạt)
- Nông Trại 3: Vườn Cà Phê (Buôn Ma Thuột)

---

## 🌾 BƯỚC 3: TẠO FIELD

1. Vào menu **"Fields"** hoặc **"Ruộng"**
2. Click **"Add Field"** hoặc **"Thêm Ruộng"**
3. Điền thông tin:
   ```
   Name:       Ruộng A1
   Farm:       Chọn "Nông Trại Đà Lạt" (từ dropdown)
   Area:       5000
   Soil Type:  Đất phù sa
   Status:     Active
   ```
4. Click **"Save"**
5. ✅ Field đã được tạo!

**Tạo thêm fields cho farm này:**
- Field 2: Ruộng A2 (5000m²)
- Field 3: Ruộng B1 (10000m²)

---

## 📡 BƯỚC 4: TẠO SENSOR

1. Vào menu **"Sensors"** hoặc **"Cảm Biến"**
2. Click **"Add Sensor"** hoặc **"Thêm Cảm Biến"**
3. Điền thông tin:
   ```
   Name:        Cảm biến nhiệt độ A1
   Field:       Chọn "Ruộng A1" (từ dropdown)
   Sensor Type: Temperature
   Status:      Active
   Location:    Góc Đông Bắc
   ```
4. Click **"Save"**
5. ✅ Sensor đã được tạo!

**Tạo thêm sensors:**
- Sensor 2: Cảm biến độ ẩm A1 (Humidity)
- Sensor 3: Cảm biến ánh sáng A1 (Light)
- Sensor 4: Cảm biến độ ẩm đất A1 (Soil Moisture)

---

## 🌱 BƯỚC 5: TẠO CROP/PLANT

1. Vào menu **"Crops"** hoặc **"Cây Trồng"**
2. Click **"Add Crop"** hoặc **"Thêm Cây Trồng"**
3. Điền thông tin:
   ```
   Name:                Rau Xà Lách
   Field:               Chọn "Ruộng A1"
   Variety:             Xà lách xoăn
   Planted Date:        2024-01-15
   Expected Harvest:    2024-03-15
   Status:              Growing
   ```
4. Click **"Save"**
5. ✅ Crop đã được tạo!

---

## 🎉 BƯỚC 6: KIỂM TRA

### **Dashboard:**
1. Vào **Dashboard**
2. Bạn sẽ thấy:
   - ✅ Số lượng farms
   - ✅ Số lượng fields
   - ✅ Số lượng sensors
   - ✅ Charts với data

### **Test các trang:**
- ✅ Farms page → Thấy farms vừa tạo
- ✅ Fields page → Thấy fields vừa tạo
- ✅ Sensors page → Thấy sensors vừa tạo
- ✅ Crops page → Thấy crops vừa tạo

### **KHÔNG CÒN LỖI `.map()`:**
- ✅ APIs trả về arrays với data
- ✅ Frontend hiển thị bình thường
- ✅ Charts có data để vẽ

---

## ⏱️ THỜI GIAN:

- **1 Farm:** ~1 phút
- **1 Field:** ~1 phút
- **1 Sensor:** ~30 giây
- **1 Crop:** ~1 phút

**Tổng:** ~10-15 phút để có đầy đủ test data!

---

## 💡 LỢI ÍCH:

✅ **Không cần cài pg_dump**
✅ **Không cần export/import**
✅ **Không cần command line**
✅ **Data được tạo đúng format**
✅ **Test luôn Frontend UI**
✅ **Dễ modify sau**

---

## 🔄 NẾU SAI HOẶC CẦN SỬA:

- Click vào item muốn sửa
- Click "Edit" hoặc "Sửa"
- Thay đổi thông tin
- Click "Save"

- Hoặc xóa: Click "Delete" / "Xóa"

---

## 📊 KẾT QUẢ MONG ĐỢI:

Sau khi tạo xong, bạn sẽ có:

```
Production Database (Railway):
├─ Accounts: 1+ (admin và user khác)
├─ Farms: 3+
├─ Fields: 5+
├─ Sensors: 10+
├─ Crops: 3+
└─ Sensor Data: (sẽ tích lũy theo thời gian)
```

---

## 🚀 BẮT ĐẦU NGAY:

1. Mở: https://hackathon-pione-dream.vercel.app/
2. Login: admin@smartfarm.com / 123456
3. Bắt đầu tạo từ Farm → Field → Sensor → Crop
4. Enjoy! 🎉

---

**KHÔNG CẦN pg_dump, KHÔNG CẦN export/import!**
**Chỉ cần 10-15 phút với Frontend!** 🌾


