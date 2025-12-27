# 🔧 Fix Lỗi Upload ESP32 - MD5 Mismatch

## ✅ Tin Tốt!

**Code đã compile thành công!** 🎉

Bây giờ gặp lỗi khi upload lên ESP32:
```
A fatal error occurred: MD5 of file does not match data in flash!
```

---

## ✅ Giải Pháp: Fix Lỗi Upload

### Giải Pháp 1: Giảm Upload Speed (Thử Trước!)

1. **Tools** → **Upload Speed**

2. **Chọn tốc độ chậm hơn:**
   - Từ: `921600` hoặc `115200`
   - Đổi thành: **`115200`** hoặc **`57600`**

3. **Upload lại:**
   - Click **Upload** (mũi tên bên phải)
   - Hoặc **Ctrl + U**

---

### Giải Pháp 2: Xóa Flash và Upload Lại

1. **Tools** → **Erase Flash: "All Flash Contents"**

2. **Upload lại:**
   - Click **Upload**

---

### Giải Pháp 3: Thử Cổng COM Khác (Nếu Có)

1. **Rút USB ra**

2. **Cắm lại USB vào cổng khác**

3. **Tools** → **Port** → Chọn cổng COM mới

4. **Upload lại**

---

### Giải Pháp 4: Giữ Nút BOOT Khi Upload

1. **Giữ nút BOOT** trên ESP32

2. **Click Upload** trong Arduino IDE

3. **Đợi thấy "Connecting..."**

4. **Thả nút BOOT** ngay khi thấy "Connecting..."

5. **Đợi upload xong**

---

### Giải Pháp 5: Kiểm Tra Cáp USB

1. **Thử cáp USB khác** (nếu có)

2. **Đảm bảo cáp USB hỗ trợ data** (không phải cáp chỉ sạc)

3. **Upload lại**

---

## 🎯 Thứ Tự Thử

1. ✅ **Giải Pháp 1:** Giảm Upload Speed (thử trước!)
2. ✅ **Giải Pháp 2:** Xóa Flash và Upload lại
3. ✅ **Giải Pháp 4:** Giữ nút BOOT khi upload
4. ✅ **Giải Pháp 3:** Thử cổng COM khác
5. ✅ **Giải Pháp 5:** Kiểm tra cáp USB

---

## 💡 Lưu Ý

**Lỗi MD5 Mismatch thường do:**
- Upload speed quá nhanh
- Flash memory bị lỗi
- Kết nối USB không ổn định

**Giải pháp tốt nhất:**
- Giảm Upload Speed xuống **115200** hoặc **57600**
- Xóa Flash trước khi upload

---

## 🆘 Nếu Vẫn Lỗi

**Vui lòng cung cấp:**
1. **Tools** → **Upload Speed** → Đang chọn gì?
2. **Tools** → **Port** → Đang chọn COM nào?
3. **Đã thử giữ nút BOOT chưa?**
4. **Thông báo lỗi đầy đủ** (copy toàn bộ)

---

**Hãy thử Giải Pháp 1 (Giảm Upload Speed) trước - Đây là cách đơn giản nhất!** 🔧✨


