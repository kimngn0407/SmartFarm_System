# 🔧 Sửa Lỗi Git Local Changes

## 🔍 Vấn Đề

**Lỗi:**
```
error: Your local changes to the following files would be overwritten by merge:
        setup-ssl-standalone.sh
```

**Nguyên nhân:**
- File `setup-ssl-standalone.sh` đã được sửa trên VPS
- Git không thể pull code mới vì sẽ ghi đè local changes

---

## ✅ Giải Pháp

### Bước 1: Xử Lý Local Changes

```bash
cd /opt/SmartFarm

# Option 1: Stash local changes (khuyên dùng)
git stash
git pull origin main

# Option 2: Hoặc discard local changes (nếu không cần)
git checkout -- setup-ssl-standalone.sh
git pull origin main

# Option 3: Hoặc commit local changes
# git add setup-ssl-standalone.sh
# git commit -m "Local changes"
# git pull origin main
```

---

### Bước 2: Kiểm Tra Docker Compose Config

```bash
# Kiểm tra frontend không có port 80
grep -A 5 "frontend:" docker-compose.yml | grep -A 3 "ports"

# Phải thấy ports bị comment (có dấu #)
# Hoặc không thấy gì (đã bị xóa)
```

---

### Bước 3: Dừng và Restart Services

```bash
cd /opt/SmartFarm

# Dừng tất cả containers
docker compose down

# Xóa containers cũ
docker compose rm -f

# Khởi động lại
docker compose up -d

# Kiểm tra
docker compose ps
```

---

## 🎯 Giải Pháp Nhanh (All-in-One)

```bash
cd /opt/SmartFarm

# 1. Stash local changes
git stash

# 2. Pull code mới
git pull origin main

# 3. Kiểm tra config
grep -A 5 "frontend:" docker-compose.yml | grep ports
# Phải thấy ports bị comment

# 4. Dừng và restart
docker compose down
docker compose rm -f
docker compose up -d

# 5. Kiểm tra
docker compose ps
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep 80
```

---

**Hãy stash local changes và pull code mới!** 🔧✨

