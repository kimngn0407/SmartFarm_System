# ✅ Kiểm tra nhanh SmartContract Services trên VPS

## 📊 Trạng thái hiện tại

Từ `pm2 status`, bạn có:
- ✅ **flask-api**: online (đã restart 3 lần - có thể do lỗi ban đầu, nhưng giờ đã ổn)
- ✅ **oracle-node**: online (chưa restart - rất tốt!)

## ⚠️ Thiếu service

Bạn **chưa có** `arduino-forwarder` trong PM2. Service này cần thiết nếu bạn muốn:
- Tự động đọc data từ Arduino qua USB
- Tự động gửi data lên Flask API

---

## 🔍 Kiểm tra chi tiết

### 1. Kiểm tra Flask API hoạt động:

```bash
# Test endpoint
curl http://localhost:8000/api/sensors/latest

# Hoặc test từ bên ngoài
curl http://173.249.48.25:8000/api/sensors/latest
```

### 2. Kiểm tra Oracle Node:

```bash
# Health check
curl http://localhost:5001/oracle/health

# Kết quả mong đợi: {"ok":true,"status":"running",...}
```

### 3. Kiểm tra ports:

```bash
# Xem ports đang listen
netstat -tuln | grep -E "8000|5001"
# hoặc
ss -tuln | grep -E "8000|5001"
```

### 4. Xem logs:

```bash
# Logs Flask API
pm2 logs flask-api --lines 20

# Logs Oracle Node
pm2 logs oracle-node --lines 20
```

---

## 🔄 Đảm bảo Auto-Start khi Boot

### Kiểm tra xem đã setup chưa:

```bash
# Kiểm tra PM2 startup
pm2 startup

# Nếu chưa setup, PM2 sẽ hiển thị lệnh cần chạy, ví dụ:
# sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u root --hp /root
```

### Setup auto-start (nếu chưa):

```bash
# 1. Generate startup script
pm2 startup

# 2. Copy và chạy lệnh mà PM2 hiển thị (thường là sudo ...)

# 3. Save current process list
pm2 save
```

### Test auto-start:

```bash
# Reboot VPS và kiểm tra
sudo reboot

# Sau khi reboot, SSH lại và chạy:
pm2 status
# Tất cả services sẽ tự động chạy lại
```

---

## ➕ Thêm Arduino Forwarder (nếu cần)

Nếu bạn muốn tự động đọc data từ Arduino:

```bash
cd ~/projects/SmartFarm/SmartContract/device

# Chỉnh sửa ecosystem.config.js
nano ecosystem.config.js
# Chỉnh đường dẫn và config

# Start với PM2
pm2 start ecosystem.config.js

# Save để tự động chạy khi boot
pm2 save
```

---

## ✅ Checklist

- [x] Flask API đang chạy (online)
- [x] Oracle Node đang chạy (online)
- [ ] Arduino Forwarder (chưa có - tùy chọn)
- [ ] Auto-start khi boot đã setup (`pm2 startup` + `pm2 save`)
- [ ] Ports đang listen (8000, 5001)
- [ ] Health checks OK

---

## 🎯 Kết luận

**Hiện tại:**
- ✅ Flask API và Oracle Node đang chạy tốt
- ⚠️ Chưa có Arduino Forwarder (chỉ cần nếu dùng Arduino qua USB)
- ❓ Chưa chắc auto-start khi boot đã setup

**Cần làm:**
1. Kiểm tra auto-start: `pm2 startup` và `pm2 save`
2. (Tùy chọn) Thêm Arduino Forwarder nếu cần
3. Test health checks để đảm bảo mọi thứ hoạt động

