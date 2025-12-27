# 🚨 QUICK FIX: Lỗi API Duplicate `/api/api/...`

## ⚠️ Vấn Đề

Lỗi: `https://smartfarm.kimngn.cfd/api/api/sensor-data` → 404

**Nguyên nhân:** Code trên VPS chưa được rebuild với code mới

---

## ✅ Giải Pháp Nhanh

### Trên VPS, chạy các lệnh sau:

```bash
# 1. Vào thư mục project
cd /opt/SmartFarm

# 2. Pull code mới nhất
git pull origin main

# 3. Kiểm tra xem có file .env không (nếu có, cần sửa)
cat .env | grep REACT_APP_API_URL
# Nếu thấy có /api ở cuối, cần sửa hoặc xóa file .env

# 4. Rebuild frontend (QUAN TRỌNG!)
docker compose build frontend --no-cache

# 5. Restart frontend
docker compose up -d --force-recreate frontend

# 6. Đợi build xong (30-60 giây)
sleep 60

# 7. Kiểm tra logs
docker compose logs frontend --tail=50
```

### Nếu có file .env trên VPS:

```bash
# Kiểm tra file .env
cat .env

# Nếu REACT_APP_API_URL có /api, sửa lại:
# SAI: REACT_APP_API_URL=https://smartfarm.kimngn.cfd/api
# ĐÚNG: REACT_APP_API_URL=https://smartfarm.kimngn.cfd

# Hoặc comment/xóa dòng đó vì docker-compose.yml đã có default value
```

---

## 🔍 Kiểm Tra Sau Khi Rebuild

### 1. Kiểm tra container đang chạy:

```bash
docker compose ps frontend
```

**Kết quả mong đợi:** Status = `Up (healthy)`

### 2. Kiểm tra logs:

```bash
docker compose logs frontend --tail=30
```

**Không nên có lỗi build**

### 3. Test trên browser:

1. **Clear browser cache:**
   - `Ctrl + Shift + R` (Windows/Linux)
   - `Cmd + Shift + R` (Mac)
   - Hoặc dùng Incognito/Private mode

2. **Mở Developer Tools (F12) → Console**

3. **Kiểm tra:**
   - ❌ KHÔNG còn: `api/api/...` 
   - ✅ Phải thấy: `api/sensor-data`, `api/farms`, etc.

---

## 🐛 Nếu Vẫn Còn Lỗi

### Kiểm tra environment variable trong container:

```bash
# Vào trong container
docker compose exec frontend sh

# Kiểm tra env variable (nếu có thể)
env | grep REACT_APP_API_URL

# Exit
exit
```

### Kiểm tra file build trong container:

```bash
# Kiểm tra file JavaScript được build
docker compose exec frontend ls -la /usr/share/nginx/html/static/js/

# Xem một file JS để kiểm tra API_BASE_URL
docker compose exec frontend cat /usr/share/nginx/html/static/js/main.*.js | grep -o "smartfarm.kimngn.cfd[^\"]*" | head -5
```

**Nếu vẫn thấy `/api/api` → Code chưa được rebuild đúng**

---

## 💡 Lệnh Tất-Trong-Một (Copy-Paste)

```bash
cd /opt/SmartFarm && \
git pull origin main && \
docker compose build frontend --no-cache && \
docker compose up -d --force-recreate frontend && \
echo "⏳ Đợi 60 giây để build xong..." && \
sleep 60 && \
echo "📋 Logs:" && \
docker compose logs frontend --tail=30
```

---

## ✅ Checklist

- [ ] Đã pull code mới từ Git
- [ ] Đã rebuild frontend với `--no-cache`
- [ ] Container đã restart
- [ ] Đã clear browser cache hoặc dùng Incognito mode
- [ ] Console không còn lỗi `api/api/...`

---

**Lưu ý:** Build có thể mất 2-5 phút tùy vào tốc độ VPS.


