# 🔧 Sửa Lỗi API 403 Forbidden

## 🔍 Vấn Đề

**Lỗi:**
- `https://smartfarm.kimngn.cfd/api/health` → 403 Forbidden
- `https://smartfarm.kimngn.cfd/api/sensor-data/iot` → 403 Forbidden

**Nguyên nhân có thể:**
1. Backend chưa restart sau khi cập nhật `FRONTEND_ORIGINS`
2. CORS không match với origin từ browser
3. Nginx không forward đúng headers
4. Spring Security đang chặn request

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra Backend Environment Variables

```bash
cd /opt/SmartFarm

# Kiểm tra FRONTEND_ORIGINS trong container
docker compose exec backend printenv | grep FRONTEND_ORIGINS

# Phải thấy:
# FRONTEND_ORIGINS=https://smartfarm.kimngn.cfd,https://smartfarm.codex.io.vn,...
```

---

### Bước 2: Restart Backend Container

```bash
# Restart backend để áp dụng environment variables mới
docker compose restart backend

# Đợi backend khởi động
sleep 10

# Kiểm tra logs
docker compose logs backend --tail=30
```

---

### Bước 3: Kiểm Tra CORS Configuration

**Trong SecurityConfig.java:**
- `/api/sensor-data/iot` đã được `.permitAll()` ✅
- CORS đọc từ `FRONTEND_ORIGINS` environment variable

**Kiểm tra backend logs:**
```bash
docker compose logs backend | grep -i cors
docker compose logs backend | grep -i "403"
```

---

### Bước 4: Test API Từ VPS

```bash
# Test API từ VPS (không qua browser)
curl -X GET https://smartfarm.kimngn.cfd/api/health

# Test IoT endpoint
curl -X POST https://smartfarm.kimngn.cfd/api/sensor-data/iot \
  -H "Content-Type: application/json" \
  -d '{"sensorId":1,"value":25.5,"time":"2024-12-25T10:00:00Z"}'
```

**Nếu thành công từ VPS nhưng lỗi từ browser → CORS issue**

---

### Bước 5: Kiểm Tra Nginx Headers

**Nginx đã forward đúng headers chưa?**

```bash
# Xem Nginx config cho /api/
grep -A 10 "location /api/" nginx/nginx.conf
```

**Phải thấy:**
```nginx
location /api/ {
    proxy_pass http://backend/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

---

### Bước 6: Thêm Origin Header (Nếu Cần)

**Nếu CORS vẫn lỗi, thêm Origin header trong Nginx:**

```bash
nano nginx/nginx.conf
```

**Tìm location /api/, thêm:**
```nginx
location /api/ {
    proxy_pass http://backend/;
    proxy_set_header Host $host;
    proxy_set_header Origin $scheme://$host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

**Reload Nginx:**
```bash
docker compose exec nginx nginx -s reload
```

---

## 🎯 Giải Pháp Nhanh (All-in-One)

```bash
cd /opt/SmartFarm

# 1. Pull code mới (nếu có)
git pull origin main

# 2. Kiểm tra FRONTEND_ORIGINS
grep FRONTEND_ORIGINS docker-compose.yml

# 3. Restart backend
docker compose restart backend
sleep 10

# 4. Test API
curl -X GET https://smartfarm.kimngn.cfd/api/health

# 5. Xem logs
docker compose logs backend --tail=20
```

---

## 🔍 Debug Chi Tiết

### Kiểm Tra CORS Headers

**Từ browser console (F12 → Network):**
- Xem request headers
- Xem response headers (có `Access-Control-Allow-Origin` không?)

**Hoặc từ curl:**
```bash
curl -I -X OPTIONS https://smartfarm.kimngn.cfd/api/health \
  -H "Origin: https://smartfarm.kimngn.cfd" \
  -H "Access-Control-Request-Method: GET"

# Phải thấy:
# Access-Control-Allow-Origin: https://smartfarm.kimngn.cfd
```

---

## 📋 Checklist

- [ ] Đã kiểm tra FRONTEND_ORIGINS trong backend container
- [ ] Đã restart backend container
- [ ] Đã test API từ VPS (curl)
- [ ] Đã kiểm tra Nginx headers
- [ ] Đã kiểm tra CORS headers
- [ ] Đã xem backend logs

---

**Hãy restart backend và test lại!** 🔧✨
