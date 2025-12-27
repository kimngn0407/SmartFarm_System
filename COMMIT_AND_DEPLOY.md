# 📤 Commit và Deploy Code lên VPS

## Bước 1: Commit code lên Git

### Kiểm tra thay đổi

```bash
cd E:\SmartFarm
git status
```

### Add các file đã thay đổi

```bash
# Add file đã sửa
git add J2EE_Frontend/src/pages/irrigation/Irrigation.js

# Hoặc add tất cả thay đổi
git add .
```

### Commit

```bash
git commit -m "Fix: Khắc phục lỗi loading vô hạn ở trang quản lý tưới tiêu & bón phân"
```

### Push lên Git

```bash
git push origin main
# hoặc
git push origin master
```

## Bước 2: Trên VPS, pull code mới

```bash
cd /opt/SmartFarm

# Pull code mới
git pull origin main
# hoặc
git pull origin master
```

## Bước 3: Rebuild frontend container

```bash
cd /opt/SmartFarm

# Rebuild frontend
docker compose build frontend

# Restart frontend
docker compose up -d frontend

# Hoặc rebuild và restart cùng lúc
docker compose up -d --build frontend
```

## Bước 4: Kiểm tra

```bash
# Xem logs frontend
docker compose logs frontend --tail=50

# Kiểm tra frontend đang chạy
docker compose ps frontend

# Test từ browser
# Mở: http://109.205.180.72/irrigation
```

## Lưu ý

- Đảm bảo đã commit và push tất cả thay đổi trước khi pull trên VPS
- Nếu có conflict khi pull, cần resolve conflict trước
- Sau khi rebuild, có thể mất vài phút để frontend build xong





# 📤 Commit và Deploy Code lên VPS

## Bước 1: Commit code lên Git

### Kiểm tra thay đổi

```bash
cd E:\SmartFarm
git status
```

### Add các file đã thay đổi

```bash
# Add file đã sửa
git add J2EE_Frontend/src/pages/irrigation/Irrigation.js

# Hoặc add tất cả thay đổi
git add .
```

### Commit

```bash
git commit -m "Fix: Khắc phục lỗi loading vô hạn ở trang quản lý tưới tiêu & bón phân"
```

### Push lên Git

```bash
git push origin main
# hoặc
git push origin master
```

## Bước 2: Trên VPS, pull code mới

```bash
cd /opt/SmartFarm

# Pull code mới
git pull origin main
# hoặc
git pull origin master
```

## Bước 3: Rebuild frontend container

```bash
cd /opt/SmartFarm

# Rebuild frontend
docker compose build frontend

# Restart frontend
docker compose up -d frontend

# Hoặc rebuild và restart cùng lúc
docker compose up -d --build frontend
```

## Bước 4: Kiểm tra

```bash
# Xem logs frontend
docker compose logs frontend --tail=50

# Kiểm tra frontend đang chạy
docker compose ps frontend

# Test từ browser
# Mở: http://109.205.180.72/irrigation
```

## Lưu ý

- Đảm bảo đã commit và push tất cả thay đổi trước khi pull trên VPS
- Nếu có conflict khi pull, cần resolve conflict trước
- Sau khi rebuild, có thể mất vài phút để frontend build xong





