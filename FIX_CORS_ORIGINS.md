# 🔧 Sửa Lỗi CORS - FRONTEND_ORIGINS Không Đúng

## 🔍 Vấn Đề

**Kết quả kiểm tra:**
```
FRONTEND_ORIGINS=http://109.205.180.72,http://109.205.180.72:80,http://localhost:3000,http://localhost:80
```

**Vấn đề:**
- `FRONTEND_ORIGINS` trong backend container vẫn là IP cũ
- Không có `https://smartfarm.kimngn.cfd` trong allowed origins
- CORS sẽ reject request từ browser (origin: `https://smartfarm.kimngn.cfd`)

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra File .env Trên VPS

```bash
cd /opt/SmartFarm

# Kiểm tra file .env (nếu có)
cat .env | grep FRONTEND_ORIGINS

# Nếu có file .env với FRONTEND_ORIGINS cũ, sửa nó
nano .env
# Tìm: FRONTEND_ORIGINS=...
# Thay bằng: FRONTEND_ORIGINS=https://smartfarm.kimngn.cfd,https://smartfarm.codex.io.vn,http://localhost:3000,http://localhost:80
```

---

### Bước 2: Kiểm Tra docker-compose.yml

```bash
# Kiểm tra FRONTEND_ORIGINS trong docker-compose.yml
grep FRONTEND_ORIGINS docker-compose.yml

# Phải thấy:
# FRONTEND_ORIGINS: ${FRONTEND_ORIGINS:-https://smartfarm.kimngn.cfd,https://smartfarm.codex.io.vn,...}
```

---

### Bước 3: Cập Nhật .env Hoặc docker-compose.yml

**Option 1: Sửa file .env (nếu có)**

```bash
nano .env
# Thêm hoặc sửa:
FRONTEND_ORIGINS=https://smartfarm.kimngn.cfd,https://smartfarm.codex.io.vn,http://localhost:3000,http://localhost:80
```

**Option 2: Xóa file .env và dùng default từ docker-compose.yml**

```bash
# Backup .env (nếu cần)
cp .env .env.backup

# Xóa hoặc comment FRONTEND_ORIGINS trong .env
nano .env
# Comment dòng: # FRONTEND_ORIGINS=...
```

---

### Bước 4: Recreate Backend Container

```bash
cd /opt/SmartFarm

# Recreate backend để áp dụng environment variables mới
docker compose up -d --force-recreate backend

# Hoặc restart tất cả
docker compose down
docker compose up -d

# Đợi backend khởi động
sleep 30
```

---

### Bước 5: Kiểm Tra Lại FRONTEND_ORIGINS

```bash
# Kiểm tra FRONTEND_ORIGINS trong backend container
docker compose exec backend printenv | grep FRONTEND_ORIGINS

# Phải thấy:
# FRONTEND_ORIGINS=https://smartfarm.kimngn.cfd,https://smartfarm.codex.io.vn,...
```

---

### Bước 6: Test API

```bash
# Test từ VPS
curl -X GET https://smartfarm.kimngn.cfd/api/health

# Test từ browser
# https://smartfarm.kimngn.cfd/api/health
```

---

## 🎯 Giải Pháp Nhanh (All-in-One)

```bash
cd /opt/SmartFarm

# 1. Kiểm tra .env
if [ -f .env ]; then
    echo "📝 File .env tồn tại"
    grep FRONTEND_ORIGINS .env || echo "   Không có FRONTEND_ORIGINS trong .env"
else
    echo "✅ Không có file .env, sẽ dùng default từ docker-compose.yml"
fi

# 2. Sửa .env hoặc tạo mới
cat > .env << 'EOF'
FRONTEND_ORIGINS=https://smartfarm.kimngn.cfd,https://smartfarm.codex.io.vn,http://localhost:3000,http://localhost:80
EOF

# 3. Recreate backend
docker compose up -d --force-recreate backend

# 4. Đợi và kiểm tra
sleep 30
docker compose exec backend printenv | grep FRONTEND_ORIGINS
```

---

## 📋 Checklist

- [ ] Đã kiểm tra file .env
- [ ] Đã cập nhật FRONTEND_ORIGINS với HTTPS domain
- [ ] Đã recreate backend container
- [ ] Đã kiểm tra FRONTEND_ORIGINS trong container
- [ ] Đã test API từ browser

---

**Hãy cập nhật FRONTEND_ORIGINS và recreate backend!** 🔧✨
