# 🚨 Fix ESP32 - Thiếu Dung lượng Ổ C:

## ❌ Vấn đề

**Ổ C: chỉ còn 446 MB trống** - Không đủ để giải nén `esp32-3.3.5-libs.zip` (~497MB, giải nén cần ~1GB)

## ✅ Giải pháp: Giải nén vào Ổ E: rồi Copy sang Ổ C:

### Bước 0: (Tùy chọn) Chuyển toàn bộ thư mục esp32-tools sang Ổ E:

**Chạy script để di chuyển toàn bộ thư mục:**

```powershell
cd E:\SmartFarm
.\move-esp32-tools-to-e.ps1
```

Script sẽ:
- Di chuyển `C:\Users\ASUS\Downloads\esp32-tools` sang `E:\esp32-tools`
- Tự động tạo symbolic link (nếu có quyền Admin) để các script cũ vẫn hoạt động
- Liệt kê các file đã di chuyển

**Lợi ích:**
- ✅ **Tiết kiệm dung lượng ổ C:** Toàn bộ tools (~2GB) ở trên ổ E:
- ✅ **Tổ chức tốt hơn:** Tất cả ESP32 tools ở một nơi
- ✅ **Scripts vẫn hoạt động:** Nhờ symbolic link

### Bước 1: Giải nén vào Ổ E:

1. **Mở File Explorer** (Win + E)
2. **Điều hướng đến:** `E:\esp32-tools\` (hoặc `E:\SmartFarm\esp32-tools\`)
3. **Tìm file:** `esp32-3.3.5-libs.zip`
   - Nếu đã chuyển thư mục: `E:\esp32-tools\esp32-3.3.5-libs.zip`
   - Nếu chưa chuyển: Copy từ `C:\Users\ASUS\Downloads\esp32-tools\` sang `E:\esp32-tools\`
4. **Right-click vào file:** `esp32-3.3.5-libs.zip`
5. **Chọn:** "Extract All..." hoặc "Extract to esp32-3.3.5-libs\"
6. **Giải nén vào:** `E:\esp32-tools\esp32-3.3.5-libs\` (hoặc các vị trí khác nếu cần)
7. **Đợi giải nén hoàn tất** (1-2 phút)

### Bước 2: Kiểm tra Cấu trúc sau khi giải nén

Sau khi giải nén, bạn sẽ thấy:

```
E:\esp32-tools\esp32-3.3.5-libs\
  └── esp32-arduino-libs\
      ├── esp32\
      │   └── bin\
      │       └── bootloader_qio_80m.elf  ✅
      ├── esp32s2\
      └── esp32s3\
```

**Hoặc các vị trí khác:**
- `E:\SmartFarm\esp32-tools\esp32-3.3.5-libs\`
- `E:\SmartFarm\esp32-3.3.5-libs\`

**Lưu ý:** Scripts sẽ tự động tìm trong tất cả các vị trí trên

### Bước 3: Tạo Symbolic Link (Giữ Libraries trên Ổ E:)

**Chạy script sau trong PowerShell (Run as Administrator):**

```powershell
cd E:\SmartFarm
.\create-esp32-libs-symlink.ps1
```

Script sẽ:
- Tự động tìm thư mục `esp32-arduino-libs` hoặc `esp32` trong thư mục giải nén
- Tạo symbolic link từ ổ C: đến ổ E:
- Kiểm tra bootloader có thể truy cập được

**Lợi ích:**
- ✅ **Tiết kiệm dung lượng ổ C:** Libraries vẫn ở trên ổ E:
- ✅ **Arduino IDE vẫn hoạt động bình thường:** Tìm thấy libraries qua symlink
- ✅ **Không cần copy:** Tiết kiệm thời gian và dung lượng

### Bước 4: (Tùy chọn) Copy vào Ổ C: nếu không muốn dùng Symlink

Nếu bạn muốn copy thực sự vào ổ C: (sau khi đã dọn dẹp ổ C:), chạy:

```powershell
cd E:\SmartFarm
.\copy-esp32-libs-from-e.ps1
```

**Lưu ý:** Cách này sẽ tốn dung lượng ổ C: (~1GB)

Sau khi copy thành công, bạn có thể xóa:

```powershell
# Xóa file ZIP và thư mục giải nén trên ổ E:
Remove-Item -Recurse -Force "E:\SmartFarm\esp32-3.3.5-libs" -ErrorAction SilentlyContinue
Remove-Item -Force "E:\SmartFarm\esp32-3.3.5-libs.zip" -ErrorAction SilentlyContinue
```

## 🧹 Dọn dẹp Ổ C: (Khuyến nghị)

### 1. Dọn dẹp Windows Temp

```powershell
# Chạy PowerShell as Administrator
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
```

### 2. Dọn dẹp Recycle Bin

```powershell
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
```

### 3. Dọn dẹp Windows Update Cache

```powershell
# Chạy PowerShell as Administrator
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv -ErrorAction SilentlyContinue
```

### 4. Dọn dẹp bằng Disk Cleanup

1. **Win + R** → Gõ: `cleanmgr`
2. **Chọn ổ C:**
3. **Chọn tất cả các mục**
4. **Click "OK"**

### 5. Di chuyển Downloads sang Ổ E:

```powershell
# Di chuyển thư mục Downloads sang ổ E:
$downloads = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$newDownloads = "E:\Downloads"

if (-not (Test-Path $newDownloads)) {
    New-Item -ItemType Directory -Force -Path $newDownloads | Out-Null
}

# Copy nội dung
Get-ChildItem -Path $downloads | Move-Item -Destination $newDownloads -Force -ErrorAction SilentlyContinue

# Tạo symbolic link (nâng cao - cần quyền Admin)
# cmd /c mklink /D "$downloads" "$newDownloads"
```

## 📋 Checklist

- [ ] Đã giải nén `esp32-3.3.5-libs.zip` vào ổ E:
- [ ] Đã kiểm tra cấu trúc thư mục sau khi giải nén
- [ ] Đã chạy script `create-esp32-libs-symlink.ps1` (PowerShell as Administrator)
- [ ] Đã kiểm tra symbolic link hoạt động (bootloader có thể truy cập)
- [ ] Đã dọn dẹp ổ C: (khuyến nghị)
- [ ] Đã restart Arduino IDE
- [ ] Đã thử compile lại code

## 🎯 Sau khi fix

1. **Restart Arduino IDE**
2. **Thử compile code ESP32**
3. **Phải compile thành công** ✅

## 💡 Lưu ý

- **Giải nén vào ổ E: trước** để tránh lỗi do thiếu dung lượng
- **Dùng Symbolic Link** để giữ libraries trên ổ E: và tiết kiệm dung lượng ổ C:
- **Không xóa thư mục** `E:\esp32-tools\esp32-3.3.5-libs` (hoặc các thư mục tương tự) sau khi tạo symlink
- **Dọn dẹp ổ C: thường xuyên** để tránh vấn đề tương tự (khuyến nghị ít nhất 2-3 GB trống)

