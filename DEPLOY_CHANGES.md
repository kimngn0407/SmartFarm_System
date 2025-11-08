# 🚀 Hướng Dẫn Deploy Thay Đổi Lên VPS

## 📋 Quy Trình

1. **Commit và Push code lên Git** (từ local)
2. **Pull code về VPS** (trên VPS)
3. **Rebuild các services đã thay đổi** (trên VPS)

---

## 🔄 BƯỚC 1: Commit và Push Code (Trên Local - Windows)

**Trên máy local (E:\SmartFarm), chạy trong PowerShell:**

```powershell
cd E:\SmartFarm

# Kiểm tra các file đã thay đổi
git status

# Add các file đã sửa
git add .

# Hoặc add từng file cụ thể:
# git add demoSmartFarm/demo/src/main/java/com/example/demo/Services/PestDiseaseService.java
# git add J2EE_Frontend/src/pages/crop/CropRecommendation.js
# git add docker-compose.yml

# Commit với message
git commit -m "Fix: Tăng timeout cho pest detection và sửa UI crop recommendation"

# Push lên remote repository
git push origin main

# Hoặc nếu branch khác:
# git push origin <branch-name>
```

---

## 📥 BƯỚC 2: Pull Code Về VPS (Trên VPS)

**SSH vào VPS và chạy:**

```bash
cd ~/projects/SmartFarm

# Kiểm tra branch hiện tại
git branch

# Pull code mới nhất
git pull origin main

# Hoặc nếu branch khác:
# git pull origin <branch-name>

# Kiểm tra các file đã thay đổi
git log --oneline -5
git diff HEAD~1 HEAD --name-only
```

---

## 🔨 BƯỚC 3: Rebuild Services Đã Thay Đổi

### 3.1. Rebuild Backend (đã sửa PestDiseaseService.java)

```bash
cd ~/projects/SmartFarm

# Dừng backend
docker compose stop backend

# Rebuild backend với code mới
docker compose build --no-cache backend

# Start lại backend
docker compose up -d backend

# Kiểm tra logs
docker compose logs -f backend | tail -50
```

### 3.2. Rebuild Frontend (đã sửa CropRecommendation.js)

```bash
# Dừng frontend
docker compose stop frontend

# Rebuild frontend với UI mới
docker compose build --no-cache frontend

# Start lại frontend
docker compose up -d frontend

# Kiểm tra logs
docker compose logs -f frontend | tail -50
```

### 3.3. Restart ML Services (nếu cần)

```bash
# Restart pest service để đảm bảo model đã load
docker compose restart pest-service

# Đợi model load (ViT model cần 60-90 giây)
sleep 90

# Kiểm tra health
curl http://localhost:5001/health

# Restart crop service (nếu cần)
docker compose restart crop-service
sleep 30
curl http://localhost:5000/health
```

---

## ✅ BƯỚC 4: Kiểm Tra Sau Khi Deploy

```bash
# Kiểm tra tất cả services đang chạy
docker compose ps

# Kiểm tra health của các services
curl http://localhost:8080/actuator/health
curl http://localhost:5000/health
curl http://localhost:5001/health

# Kiểm tra logs để đảm bảo không có lỗi
docker compose logs backend | tail -20
docker compose logs frontend | tail -20
docker compose logs pest-service | tail -20
```

---

## 🚀 Script Tự Động (Tất Cả Trong Một)

**Trên VPS, tạo script:**

```bash
cd ~/projects/SmartFarm

cat > deploy-updates.sh << 'EOF'
#!/bin/bash

echo "🚀 Deploy Updates..."
echo ""

# 1. Pull code
echo "1. Pulling latest code..."
git pull origin main

# 2. Rebuild backend
echo ""
echo "2. Rebuilding backend..."
docker compose stop backend
docker compose build --no-cache backend
docker compose up -d backend

# 3. Rebuild frontend
echo ""
echo "3. Rebuilding frontend..."
docker compose stop frontend
docker compose build --no-cache frontend
docker compose up -d frontend

# 4. Restart ML services
echo ""
echo "4. Restarting ML services..."
docker compose restart pest-service crop-service

# 5. Đợi services khởi động
echo ""
echo "5. Waiting for services to start..."
sleep 30

# 6. Kiểm tra
echo ""
echo "6. Checking services..."
docker compose ps

echo ""
echo "✅ Deploy completed!"
echo ""
echo "📝 Check logs if needed:"
echo "   docker compose logs -f backend"
echo "   docker compose logs -f frontend"
EOF

chmod +x deploy-updates.sh

# Chạy script
./deploy-updates.sh
```

---

## 🔍 Troubleshooting

### Nếu git pull bị conflict:

```bash
# Xem các file conflict
git status

# Backup thay đổi local (nếu có)
git stash

# Pull lại
git pull origin main

# Apply lại thay đổi local (nếu cần)
git stash pop
```

### Nếu rebuild bị lỗi:

```bash
# Xem logs chi tiết
docker compose build --no-cache backend 2>&1 | tee build.log

# Hoặc xem logs của container
docker compose logs backend | tail -100
```

### Nếu service không start:

```bash
# Kiểm tra lỗi
docker compose ps -a
docker compose logs <service-name> | tail -50

# Restart service
docker compose restart <service-name>
```

---

## 📝 Checklist

- [ ] Code đã được commit và push lên git
- [ ] Đã pull code mới nhất về VPS
- [ ] Backend đã rebuild thành công
- [ ] Frontend đã rebuild thành công
- [ ] ML services đã restart và model đã load
- [ ] Tất cả services đang chạy (docker compose ps)
- [ ] Health checks đều OK
- [ ] Test lại chức năng trên browser

---

**Chúc bạn deploy thành công! 🎉**


