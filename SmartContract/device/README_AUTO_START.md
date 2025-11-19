# 🚀 Hướng dẫn Tự động Chạy Arduino Forwarder

## 📋 Tổng quan

Thay vì phải chạy thủ công `forwarder.py` mỗi lần cắm USB Arduino, bạn có thể:

> **📌 Lưu ý:** 
> - **Windows (Local)**: Xem hướng dẫn bên dưới
> - **Linux/VPS**: Xem [README_VPS_LINUX.md](README_VPS_LINUX.md) cho hướng dẫn systemd service và udev rules

1. **Tự động phát hiện COM port** - Không cần chỉnh PORT trong code
2. **Tự động chạy khi cắm USB** - Dùng Windows Task Scheduler
3. **Tự động chạy lại khi mất kết nối** - Dùng script loop

---

## 🎯 Cách 1: Chạy Tự động với Auto Port Detection (Đơn giản nhất)

### Bước 1: Chạy script mới
```bash
cd SmartContract/device
python forwarder_auto.py
```

**Ưu điểm:**
- ✅ Tự động tìm COM port của Arduino
- ✅ Không cần chỉnh PORT trong code
- ✅ Hoạt động với nhiều loại Arduino (Uno, Mega, clone CH340, CP210x)

### Bước 2: Dùng batch script (Windows)
Double-click vào:
- `start_forwarder.bat` - Chạy 1 lần
- `start_forwarder_loop.bat` - Tự động chạy lại khi mất kết nối

---

## 🔄 Cách 2: Tự động Chạy Khi Cắm USB (Windows Task Scheduler)

### Bước 1: Tạo Task trong Task Scheduler

1. Mở **Task Scheduler** (Win + R → `taskschd.msc`)
2. Click **Create Basic Task...**
3. Đặt tên: `Smart Farm Arduino Forwarder`
4. Trigger: **When a specific event is logged**
5. Log: **Microsoft-Windows-UserModePowerService/Diagnostic**
6. Source: **UserModePowerService**
7. Event ID: **1074** (hoặc chọn "Any event")

### Bước 2: Hoặc dùng USB Device Event (Phức tạp hơn)

1. Tạo Task mới
2. Trigger: **On an event**
3. Log: **System**
4. Source: **USBSTOR**
5. Event ID: **20001** (Device connected)

### Bước 3: Action

1. Action: **Start a program**
2. Program: `C:\Windows\System32\cmd.exe`
3. Arguments: `/c "cd /d E:\SmartFarm\SmartContract\device && start_forwarder_loop.bat"`
4. Start in: `E:\SmartFarm\SmartContract\device`

---

## 🔧 Cách 3: Tạo Windows Service (Nâng cao)

### Sử dụng NSSM (Non-Sucking Service Manager)

1. Download NSSM: https://nssm.cc/download
2. Extract và chạy:
```cmd
nssm install SmartFarmForwarder
```

3. Trong NSSM GUI:
   - **Path**: `C:\Python311\python.exe` (hoặc path đến Python của bạn)
   - **Startup directory**: `E:\SmartFarm\SmartContract\device`
   - **Arguments**: `forwarder_auto.py`
   - **Service name**: `SmartFarmForwarder`

4. Start service:
```cmd
nssm start SmartFarmForwarder
```

---

## 📝 Cách 4: Tạo Shortcut trên Desktop

1. Right-click `start_forwarder_loop.bat` → **Create shortcut**
2. Kéo shortcut ra Desktop
3. Mỗi lần cắm USB, double-click shortcut

---

## 🛠️ Troubleshooting

### Không tìm thấy Arduino?
- Kiểm tra Device Manager → Ports (COM & LPT)
- Cài driver USB cho Arduino (CH340, CP210x, hoặc Arduino driver)
- Thử cắm vào USB port khác

### Script dừng đột ngột?
- Dùng `start_forwarder_loop.bat` để tự động chạy lại
- Kiểm tra kết nối internet (cần gửi data lên VPS)
- Kiểm tra VPS có đang chạy Flask API không

### Muốn chỉnh PORT thủ công?
- Mở `forwarder_auto.py`
- Tìm dòng `port = find_arduino_port()`
- Thay bằng: `port = "COM4"` (thay COM4 bằng port của bạn)

---

## ✅ Kiểm tra Hoạt động

1. Cắm USB Arduino
2. Chạy `forwarder_auto.py` hoặc `start_forwarder_loop.bat`
3. Xem console output:
   - `✅ Found Arduino at COM4`
   - `✅ Connected to COM4 at 9600 baud`
   - `📥 Received: {...}`
   - `✅ Sent successfully: 200`

4. Kiểm tra dashboard: http://173.249.48.25/dashboard
   - Dữ liệu mới sẽ xuất hiện sau vài giây

---

## 📌 Lưu ý

- Script sẽ tự động tìm Arduino, không cần chỉnh PORT
- Nếu có nhiều Arduino, script sẽ chọn port đầu tiên tìm thấy
- Để dừng script, nhấn `Ctrl+C`
- Script `start_forwarder_loop.bat` sẽ tự động chạy lại khi mất kết nối

