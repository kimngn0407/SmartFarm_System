# 🔧 Sửa Lỗi Frontend Vẫn Bind Port 80

## 🔍 Vấn Đề

**Lỗi:**
```
Bind for :::80 failed: port is already allocated
```

**Nguyên nhân:**
- Frontend container cũ vẫn đang chạy với port 80
- Hoặc code chưa được pull (vẫn có port 80 trong docker-compose.yml)
- Nginx không thể bind port 80 vì frontend đã bind trước

---

## ✅ Giải Pháp

### Bước 1: Dừng Tất Cả Containers

```bash
cd /opt/SmartFarm

# Dừng tất cả containers
docker compose down

# Kiểm tra không còn container nào
docker ps -a | grep smartfarm
# Phải không còn container nào
```

---

### Bước 2: Pull Code Mới

```bash
cd /opt/SmartFarm

# Pull code mới
git pull origin main

# Kiểm tra docker-compose.yml đã được cập nhật
grep -A 3 "frontend:" docker-compose.yml | grep -A 2 "ports"
# Phải KHÔNG thấy "80:80" (đã bị comment)
```

---

### Bước 3: Xóa Container Cũ (Nếu Cần)

```bash
# Xóa tất cả containers cũ
docker compose rm -f

# Hoặc xóa từng container
docker rm -f smartfarm-frontend smartfarm-nginx 2>/dev/null || true
```

---

### Bước 4: Khởi Động Lại Services

```bash
cd /opt/SmartFarm

# Khởi động lại services
docker compose up -d

# Kiểm tra services
docker compose ps

# Phải thấy:
# - smartfarm-nginx (đang chạy, có port 80:80 và 443:443)
# - smartfarm-frontend (đang chạy, KHÔNG có port 80:80)
```

---

### Bước 5: Kiểm Tra Port 80

```bash
# Kiểm tra port 80 đang được dùng bởi container nào
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep 80

# Phải chỉ thấy smartfarm-nginx bind port 80
# KHÔNG thấy smartfarm-frontend bind port 80
```

---

## 🎯 Giải Pháp Nhanh (All-in-One)

```bash
cd /opt/SmartFarm

# 1. Dừng tất cả
docker compose down

# 2. Xóa containers cũ
docker compose rm -f

# 3. Pull code mới
git pull origin main

# 4. Kiểm tra config
grep -A 5 "frontend:" docker-compose.yml | grep ports
# Phải thấy ports bị comment

# 5. Khởi động lại
docker compose up -d

# 6. Kiểm tra
docker compose ps
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep 80
```

---

## 📋 Checklist

- [ ] Đã dừng tất cả containers
- [ ] Đã pull code mới
- [ ] Đã kiểm tra docker-compose.yml (frontend không có port 80)
- [ ] Đã xóa containers cũ
- [ ] Đã khởi động lại services
- [ ] Đã kiểm tra chỉ Nginx bind port 80
- [ ] Đã test HTTPS

---

**Hãy dừng containers, pull code mới và restart!** 🔧✨

