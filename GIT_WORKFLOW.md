# Workflow Cập nhật Code: Local → Git → VPS

## Bước 1: Push code lên Git từ máy local

### Kiểm tra thay đổi

```bash
# Trên máy local (Windows)
cd E:\SmartFarm

# Xem các file đã thay đổi
git status

# Xem diff (nếu muốn)
git diff
```

### Commit và Push

```bash
# Add các file đã thay đổi
git add .

# Hoặc add từng file cụ thể
git add J2EE_Frontend/src/pages/dashboard/Dashboard.js
git add J2EE_Frontend/src/services/sensorService.js

# Commit với message
git commit -m "Update Dashboard to fetch real sensor data from IoT"

# Push lên Git
git push origin main
# hoặc
git push origin master
```

## Bước 2: Pull code về VPS và cập nhật

### SSH vào VPS

```bash
ssh root@173.249.48.25
```

### Pull code mới

```bash
cd ~/projects/SmartFarm

# Pull code mới từ Git
git pull origin main
# hoặc
git pull origin master
```

### Rebuild và restart services

```bash
# Rebuild frontend (vì đã sửa Dashboard.js)
docker-compose build --no-cache frontend

# Restart frontend
docker-compose up -d frontend

# Xem logs để kiểm tra
docker-compose logs -f frontend
```

## Script tự động cho VPS

Tạo file `update-from-git.sh` trên VPS:

```bash
#!/bin/bash

echo "🔄 Cập nhật SmartFarm từ Git..."

cd ~/projects/SmartFarm

# Pull code mới
echo "📥 Pulling code from Git..."
git pull

# Rebuild frontend
echo "🔨 Rebuilding frontend..."
docker-compose build --no-cache frontend

# Restart frontend
echo "🚀 Restarting frontend..."
docker-compose up -d frontend

# Đợi 5 giây
sleep 5

# Kiểm tra status
echo "📊 Checking status..."
docker-compose ps frontend

echo "✅ Done! Check logs: docker-compose logs -f frontend"
```

Sau đó chạy:
```bash
chmod +x update-from-git.sh
./update-from-git.sh
```

## Kiểm tra sau khi cập nhật

### 1. Kiểm tra code đã được cập nhật

```bash
# Trên VPS
cd ~/projects/SmartFarm
git log -1  # Xem commit mới nhất
```

### 2. Kiểm tra frontend đang chạy

```bash
docker-compose ps frontend
```

### 3. Kiểm tra trong browser

- Truy cập: http://173.249.48.25
- Mở Developer Tools (F12) → Console
- Kiểm tra có log "🔍 Fetching real sensor data from IoT..." không

## Troubleshooting

### Lỗi: Git pull bị conflict

```bash
# Backup code hiện tại
cd ~/projects/SmartFarm
cp -r J2EE_Frontend/src J2EE_Frontend/src.backup

# Stash thay đổi local (nếu có)
git stash

# Pull lại
git pull

# Nếu vẫn conflict, reset về remote
git fetch origin
git reset --hard origin/main
```

### Lỗi: Không pull được (có thay đổi local chưa commit)

```bash
# Xem thay đổi
git status

# Stash thay đổi local
git stash

# Pull
git pull

# Apply lại thay đổi (nếu cần)
git stash pop
```

### Lỗi: Frontend không build được sau khi pull

```bash
# Xem logs chi tiết
docker-compose build --no-cache frontend 2>&1 | tee build.log

# Kiểm tra lỗi
cat build.log
```

## Quick Commands Summary

### Trên Local (Windows)
```bash
cd E:\SmartFarm
git add .
git commit -m "Your commit message"
git push origin main
```

### Trên VPS
```bash
cd ~/projects/SmartFarm
git pull
docker-compose build --no-cache frontend
docker-compose up -d frontend
docker-compose logs -f frontend
```

