# 🚀 Build Frontend Trên VPS

## ✅ Code Đã Được Push Lên Git

**Repository:** `https://github.com/kimngn0407/SmartFarm_System.git`
**Commit:** `0dbce8d` - Fix frontend sensor IDs

---

## 📋 Các Bước Build Trên VPS

### 1. SSH Vào VPS

```bash
ssh root@109.205.180.72
```

### 2. Vào Thư Mục Project

```bash
cd /opt/SmartFarm
```

### 3. Pull Code Mới Nhất

```bash
git pull origin main
```

### 4. Build Frontend

```bash
cd J2EE_Frontend

# Cài đặt dependencies (nếu chưa có)
npm install

# Build production
npm run build
```

### 5. Restart Services (Nếu Cần)

**Nếu dùng Docker Compose:**
```bash
cd /opt/SmartFarm

# Restart frontend container
docker compose restart frontend

# Hoặc rebuild nếu cần
docker compose up -d --build frontend
```

**Nếu dùng PM2 hoặc systemd:**
```bash
# PM2
pm2 restart frontend

# Systemd
sudo systemctl restart frontend
```

---

## 🔍 Kiểm Tra

### 1. Kiểm Tra Frontend Đang Chạy

```bash
# Xem logs
docker compose logs frontend --tail=50

# Hoặc
pm2 logs frontend
```

### 2. Kiểm Tra Dashboard

Mở trình duyệt:
- `http://109.205.180.72:3000` (hoặc port frontend của bạn)
- Vào Dashboard
- Kiểm tra biểu đồ có hiển thị dữ liệu từ ESP32 không

**Kết quả mong đợi:**
- ✅ Temperature: ~26.2°C
- ✅ Humidity: ~53-54%
- ⚠️ Soil: Sẽ sửa sau (hiện tại luôn 100%)
- ⚠️ Light: Sẽ sửa sau (hiện tại luôn 0%)

---

## 🐳 Nếu Dùng Docker Compose

### Build và Deploy Tất Cả

```bash
cd /opt/SmartFarm

# Pull code
git pull origin main

# Rebuild và restart
docker compose down
docker compose up -d --build
```

### Chỉ Build Frontend

```bash
cd /opt/SmartFarm

# Pull code
git pull origin main

# Build frontend
cd J2EE_Frontend
npm install
npm run build

# Restart frontend container
cd ..
docker compose restart frontend
```

---

## 📊 Thay Đổi Trong Commit

**File đã sửa:**
- `J2EE_Frontend/src/pages/dashboard/Dashboard.js`
  - Sensor IDs: 7,8,9,10 → 1,2,3,4

**Files mới:**
- `FIX_FRONTEND_SENSOR_IDS.md`
- `FIX_SENSOR_ISSUES.md`
- `KIEM_TRA_DU_LIEU_VPS*.md`
- `Arduino_SmartFarm_Demo/Arduino_SmartFarm_Demo.ino`

---

## ⚠️ Lưu Ý

1. **Nếu build lỗi:**
   - Kiểm tra Node.js version: `node -v` (nên >= 16)
   - Xóa `node_modules` và `package-lock.json`, sau đó `npm install` lại

2. **Nếu không thấy dữ liệu:**
   - Kiểm tra ESP32 có đang gửi dữ liệu không
   - Kiểm tra database có dữ liệu mới không
   - Kiểm tra API endpoint có hoạt động không

3. **Nếu cần rollback:**
   ```bash
   git log --oneline
   git checkout <commit-hash-before>
   ```

---

**Đã push code lên git! Hãy pull và build trên VPS!** 🚀✨


