# 🔄 RESET VÀ TẠO ADMIN MỚI

## 🎯 MỤC TIÊU:
Xóa toàn bộ data cũ và tạo admin mới với password biết trước!

---

## 📋 BƯỚC 1: XÓA DATA CŨ TRONG RAILWAY

### **1. Mở Railway Dashboard:**
```
https://railway.app/
→ Project của bạn
→ PostgreSQL service
→ Tab "Data"
```

### **2. Xóa toàn bộ account cũ:**

**Table `account_roles`:**
- Click vào table `account_roles`
- Xóa TẤT CẢ rows (click "⋮" → Delete cho mỗi row)
- Hoặc chạy query: `DELETE FROM account_roles;`

**Table `account`:**
- Click vào table `account`
- Xóa TẤT CẢ rows
- Hoặc chạy query: `DELETE FROM account;`

---

## 📋 BƯỚC 2: TẠO ADMIN MỚI QUA HTML TOOL

### **1. Mở HTML tool:**
```
http://localhost:8000/CREATE_TEST_DATA_NO_IMPORT.html
```

**Nếu server chưa chạy:**
```cmd
cd E:\DoAnJ2EE
START_LOCAL_SERVER.bat
```

### **2. Fill form tạo admin:**
```
Email: admin@test.com
Password: admin123
Full Name: Admin User
```

### **3. Click "🚀 Tạo Admin Account"**

**Đợi xem:**
```
✅ Tạo admin thành công!
✅ Login thành công!
✅ Token: eyJ...
```

---

## 📋 BƯỚC 3: LOGIN FRONTEND

### **1. Mở Frontend:**
```
https://hackathon-pione-dream.vercel.app/
```

### **2. Login:**
```
Email: admin@test.com
Password: admin123
```

### **3. Kiểm tra:**
- ✅ Login thành công
- ✅ Vào được Dashboard
- ✅ Không có lỗi "map is not a function" (vì chưa có data farms/fields)

---

## 📋 BƯỚC 4: TẠO DATA MẪU

**Trong HTML tool (vẫn ở `http://localhost:8000`):**

**1. Scroll xuống phần "Tạo Test Data"**

**2. Click các button theo thứ tự:**
```
✅ Tạo 3 Farms
✅ Tạo 5 Fields
✅ Tạo 10 Sensors
✅ Tạo 3 Plants
```

**3. Đợi mỗi step thành công!**

---

## 📋 BƯỚC 5: KIỂM TRA FRONTEND

**Refresh Frontend:**
```
https://hackathon-pione-dream.vercel.app/
```

**Kiểm tra các trang:**
- ✅ Dashboard: Hiển thị farms, fields, sensors
- ✅ Farm Management: Hiển thị danh sách farms
- ✅ Field Management: Hiển thị danh sách fields
- ✅ Sensor Management: Hiển thị danh sách sensors
- ✅ Crop Management: Hiển thị danh sách plants

---

## ✅ KẾT QUẢ MONG ĐỢI:

```
✅ Admin account mới: admin@test.com / admin123
✅ Login thành công
✅ Dashboard hiển thị đầy đủ
✅ Tất cả APIs hoạt động
✅ Không còn lỗi "map is not a function"
```

---

## 🚨 NẾU CÓ LỖI:

### **Lỗi: "Failed to fetch" khi tạo admin**
**Giải pháp:**
```
1. Kiểm tra Railway backend có running không:
   https://hackathonpionedream-production.up.railway.app/actuator/health

2. Nếu trả về 404 hoặc timeout → Backend đang sleep
   → Đợi 30s, F5 lại
   → Thử tạo admin lại

3. Nếu vẫn lỗi → Check console (F12) xem lỗi gì
```

### **Lỗi: "Email already exists"**
**Giải pháp:**
```
→ Quay lại Railway, xóa account trong table `account`
→ Hoặc dùng email khác: admin2@test.com
```

### **Lỗi: "401 Unauthorized" khi tạo farms/fields**
**Giải pháp:**
```
→ Token hết hạn
→ Click "Tạo Admin Account" lại để login lại
→ Sau đó tạo farms/fields
```

---

## 💡 LƯU Ý:

```
⚠️  ĐỪNG XÓA TABLE! Chỉ xóa DATA (rows)!
⚠️  Phải xóa account_roles TRƯỚC, rồi mới xóa account!
⚠️  Nếu HTML tool báo lỗi, check Railway logs!
```

---

## 🎯 TÓM TẮT NGẮN:

```bash
# 1. XÓA DATA CŨ TRONG RAILWAY
DELETE FROM account_roles;
DELETE FROM account;

# 2. MỞ HTML TOOL
http://localhost:8000/CREATE_TEST_DATA_NO_IMPORT.html

# 3. TẠO ADMIN
admin@test.com / admin123

# 4. LOGIN FRONTEND
https://hackathon-pione-dream.vercel.app/

# 5. TẠO DATA MẪU QUA HTML TOOL
Farms → Fields → Sensors → Plants
```

---

**BẮT ĐẦU TỪ BƯỚC 1!** 🚀


