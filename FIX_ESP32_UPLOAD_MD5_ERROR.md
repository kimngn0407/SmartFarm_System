# 🔧 Fix ESP32 Upload Error - MD5 Checksum Mismatch

## ❌ Lỗi

```
A fatal error occurred: MD5 of file does not match data in flash!
Failed uploading: uploading error: exit status 2
```

## 🔍 Nguyên nhân

Lỗi này xảy ra khi:
1. **Baud rate quá cao** (921600) - không ổn định
2. **Cáp USB kém chất lượng** - mất dữ liệu khi truyền
3. **Flash bị lỗi** - sector flash bị hỏng
4. **Nhiễu điện** - nguồn điện không ổn định
5. **ESP32 đang chạy code cũ** - cần reset trước khi upload

## ✅ Giải pháp

### Cách 1: Giảm Baud Rate (Khuyến nghị)

1. **Tools → Upload Speed**
2. **Chọn:** `115200` hoặc `230400` (thay vì `921600`)
3. **Thử upload lại**

### Cách 2: Reset ESP32 trước khi Upload

1. **Nhấn nút RESET** trên ESP32
2. **Ngay lập tức nhấn Upload** trong Arduino IDE
3. **Hoặc giữ nút BOOT** khi upload

### Cách 3: Thử Cáp USB khác

- Thử cáp USB khác (tốt hơn, ngắn hơn)
- Tránh dùng USB hub
- Cắm trực tiếp vào cổng USB của máy tính

### Cách 4: Erase Flash trước khi Upload

1. **Tools → Erase All Flash Before Sketch Upload**
2. **Chọn:** "Enabled"
3. **Upload lại**

### Cách 5: Thay đổi Partition Scheme

1. **Tools → Partition Scheme**
2. **Chọn:** "Default 4MB with spiffs (1.2MB APP/1.5MB SPIFFS)"
3. **Upload lại**

### Cách 6: Giảm Kích thước Code (Nếu code quá lớn)

Nếu code quá lớn, có thể cần tối ưu:
- Giảm log Serial
- Tắt các tính năng không cần thiết
- Giảm buffer size

## 🚀 Quick Fix (Thử theo thứ tự)

### Bước 1: Erase Flash Hoàn toàn (Khuyến nghị)

**Cách 1: Dùng Script PowerShell**

```powershell
cd E:\SmartFarm
.\erase-esp32-flash.ps1
```

Script sẽ:
- Tự động tìm COM port
- Erase toàn bộ flash ESP32
- Xóa sạch dữ liệu cũ

**Cách 2: Dùng Arduino IDE**

1. **Tools → Erase All Flash Before Sketch Upload → Enabled**
2. **Tools → Erase Flash: "All Flash Contents"**
3. **Click "Erase"**

### Bước 2: Giảm Upload Speed

```
Tools → Upload Speed → 115200
```

### Bước 3: Reset ESP32

1. **Nhấn nút RESET** trên ESP32
2. **Ngay lập tức nhấn Upload**

### Bước 4: Thử lại

Nếu vẫn lỗi, thử:
- Cáp USB khác
- Cổng USB khác
- Restart Arduino IDE

## 📋 Checklist

- [ ] Đã erase flash hoàn toàn (dùng script hoặc Arduino IDE)
- [ ] Đã giảm Upload Speed xuống 115200
- [ ] Đã bật Erase All Flash Before Sketch Upload
- [ ] Đã reset ESP32 trước khi upload
- [ ] Đã thử cáp USB khác
- [ ] Đã thử cổng USB khác
- [ ] Đã restart Arduino IDE

## 🎯 Sau khi fix

1. **Upload thành công** ✅
2. **Code chạy trên ESP32**
3. **Serial Monitor hiển thị log**

## 💡 Lưu ý

- **Baud rate 115200** thường ổn định nhất
- **Erase Flash** sẽ xóa toàn bộ dữ liệu cũ (an toàn)
- **Reset ESP32** trước khi upload giúp tránh xung đột
- **Cáp USB chất lượng tốt** rất quan trọng

# 🔧 Fix ESP32 Upload Error - MD5 Checksum Mismatch

## ❌ Lỗi

```
A fatal error occurred: MD5 of file does not match data in flash!
Failed uploading: uploading error: exit status 2
```

## 🔍 Nguyên nhân

Lỗi này xảy ra khi:
1. **Baud rate quá cao** (921600) - không ổn định
2. **Cáp USB kém chất lượng** - mất dữ liệu khi truyền
3. **Flash bị lỗi** - sector flash bị hỏng
4. **Nhiễu điện** - nguồn điện không ổn định
5. **ESP32 đang chạy code cũ** - cần reset trước khi upload

## ✅ Giải pháp

### Cách 1: Giảm Baud Rate (Khuyến nghị)

1. **Tools → Upload Speed**
2. **Chọn:** `115200` hoặc `230400` (thay vì `921600`)
3. **Thử upload lại**

### Cách 2: Reset ESP32 trước khi Upload

1. **Nhấn nút RESET** trên ESP32
2. **Ngay lập tức nhấn Upload** trong Arduino IDE
3. **Hoặc giữ nút BOOT** khi upload

### Cách 3: Thử Cáp USB khác

- Thử cáp USB khác (tốt hơn, ngắn hơn)
- Tránh dùng USB hub
- Cắm trực tiếp vào cổng USB của máy tính

### Cách 4: Erase Flash trước khi Upload

1. **Tools → Erase All Flash Before Sketch Upload**
2. **Chọn:** "Enabled"
3. **Upload lại**

### Cách 5: Thay đổi Partition Scheme

1. **Tools → Partition Scheme**
2. **Chọn:** "Default 4MB with spiffs (1.2MB APP/1.5MB SPIFFS)"
3. **Upload lại**

### Cách 6: Giảm Kích thước Code (Nếu code quá lớn)

Nếu code quá lớn, có thể cần tối ưu:
- Giảm log Serial
- Tắt các tính năng không cần thiết
- Giảm buffer size

## 🚀 Quick Fix (Thử theo thứ tự)

### Bước 1: Erase Flash Hoàn toàn (Khuyến nghị)

**Cách 1: Dùng Script PowerShell**

```powershell
cd E:\SmartFarm
.\erase-esp32-flash.ps1
```

Script sẽ:
- Tự động tìm COM port
- Erase toàn bộ flash ESP32
- Xóa sạch dữ liệu cũ

**Cách 2: Dùng Arduino IDE**

1. **Tools → Erase All Flash Before Sketch Upload → Enabled**
2. **Tools → Erase Flash: "All Flash Contents"**
3. **Click "Erase"**

### Bước 2: Giảm Upload Speed

```
Tools → Upload Speed → 115200
```

### Bước 3: Reset ESP32

1. **Nhấn nút RESET** trên ESP32
2. **Ngay lập tức nhấn Upload**

### Bước 4: Thử lại

Nếu vẫn lỗi, thử:
- Cáp USB khác
- Cổng USB khác
- Restart Arduino IDE

## 📋 Checklist

- [ ] Đã erase flash hoàn toàn (dùng script hoặc Arduino IDE)
- [ ] Đã giảm Upload Speed xuống 115200
- [ ] Đã bật Erase All Flash Before Sketch Upload
- [ ] Đã reset ESP32 trước khi upload
- [ ] Đã thử cáp USB khác
- [ ] Đã thử cổng USB khác
- [ ] Đã restart Arduino IDE

## 🎯 Sau khi fix

1. **Upload thành công** ✅
2. **Code chạy trên ESP32**
3. **Serial Monitor hiển thị log**

## 💡 Lưu ý

- **Baud rate 115200** thường ổn định nhất
- **Erase Flash** sẽ xóa toàn bộ dữ liệu cũ (an toàn)
- **Reset ESP32** trước khi upload giúp tránh xung đột
- **Cáp USB chất lượng tốt** rất quan trọng

