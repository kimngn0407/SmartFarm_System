# ⚡ Quick Fix - ESP32 Tools Missing

## ❌ Lỗi hiện tại

```
The system cannot find the path specified.
Compilation error: exit status 1
```

## ✅ Fix nhanh nhất (2 bước)

### Bước 1: Tăng Timeout

1. **Đóng Arduino IDE**
2. **Mở:** `Win + R` → Gõ: `%LOCALAPPDATA%\Arduino15\preferences.txt`
3. **Thêm dòng:** `network.timeout=600`
4. **Lưu file**

### Bước 2: Cài Tools

1. **Mở Arduino IDE**
2. **Tools → Board → Boards Manager**
3. **Tìm "esp32"**
4. **Click "REMOVE"** cho version 3.3.5
5. **Click "INSTALL"** lại cho version 3.3.5
6. **Đợi download tools** (Arduino IDE sẽ chỉ download tools, không download hardware nữa)

**Lưu ý:** 
- Tools nhỏ hơn hardware (~50-100MB vs ~200MB)
- Ít bị timeout hơn
- Có thể mất 5-10 phút

## 🔍 Kiểm tra sau khi cài

```powershell
# Chạy script kiểm tra
.\check-esp32-tools.ps1
```

Hoặc kiểm tra thủ công:

```powershell
dir "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools"
```

**Phải thấy:**
- `xtensa-esp32-elf-gcc/`
- `esptool_py/`
- `mkspiffs/`
- `mklittlefs/`
- `partitions/`

## ✅ Sau khi cài tools

1. **Restart Arduino IDE**
2. **Thử compile lại code**
3. **Phải compile thành công**

## 🎯 Nếu vẫn timeout

1. **Thử vào giờ ít người dùng** (sáng sớm/đêm khuya)
2. **Dùng kết nối internet ổn định** (LAN tốt hơn WiFi)
3. **Tắt các ứng dụng download khác**
