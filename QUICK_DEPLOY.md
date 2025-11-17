# 🚀 Quick Deploy Guide - Giải quyết Git Pull Error

## ❌ Lỗi hiện tại

```
error: Your local changes to the following files would be overwritten by merge:
        SmartContract/cache/solidity-files-cache.json
        import-DB_SM_ver1.sh
```

## ✅ Giải pháp nhanh

### Cách 1: Stash changes (Khuyên dùng - giữ lại thay đổi)

```bash
# Lưu thay đổi tạm thời
git stash

# Pull code mới
git pull

# Nếu cần, restore thay đổi cũ
git stash pop
```

### Cách 2: Discard changes (Xóa thay đổi local)

```bash
# Xóa thay đổi local (CẨN THẬN!)
git checkout -- SmartContract/cache/solidity-files-cache.json
git checkout -- import-DB_SM_ver1.sh

# Pull code mới
git pull
```

### Cách 3: Force pull (Ghi đè tất cả)

```bash
# Reset về remote (MẤT TẤT CẢ THAY ĐỔI LOCAL!)
git fetch origin
git reset --hard origin/main
```

---

## 🚀 Sau khi pull xong, tiếp tục deploy:

```bash
# 1. Kiểm tra .env file
ls -la .env

# Nếu chưa có, tạo từ template
cp .env.example .env
nano .env  # Sửa YOUR_VPS_IP và passwords

# 2. Build và deploy
docker compose build --no-cache
docker compose up -d

# 3. Kiểm tra
./check-deployment.sh
```

---

## 📝 Lưu ý

- `SmartContract/cache/solidity-files-cache.json` - File cache, có thể xóa an toàn
- `import-DB_SM_ver1.sh` - Script import DB, nếu đã dùng xong có thể xóa

