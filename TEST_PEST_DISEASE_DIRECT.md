# 🔧 Test Pest-Disease Endpoint Trực Tiếp

## 🔍 Vấn Đề

**Lỗi 403 vẫn còn sau khi rebuild backend.**

**Có thể do:**
1. CORS configuration
2. SecurityConfig chưa được áp dụng
3. Nginx đang chặn request

---

## ✅ Giải Pháp: Test Trực Tiếp Từ Backend Container

### Bước 1: Test Trực Tiếp Từ Backend (Bypass Nginx)

```bash
cd /opt/SmartFarm

# Test trực tiếp từ backend container (không qua Nginx)
docker compose exec backend curl -I http://localhost:8080/api/pest-disease/classes

# Phải trả về: HTTP/1.1 200 (không phải 403)

# Test với JSON
docker compose exec backend curl http://localhost:8080/api/pest-disease/classes
```

---

### Bước 2: Kiểm Tra SecurityConfig Trong Container

```bash
# Kiểm tra xem SecurityConfig có được compile vào JAR không
docker compose exec backend jar -tf /app/app.jar | grep SecurityConfig

# Hoặc test endpoint health trước
docker compose exec backend curl http://localhost:8080/api/health
# Phải trả về 200 (vì đã có trong permitAll())
```

---

### Bước 3: Kiểm Tra CORS Configuration

```bash
# Kiểm tra FRONTEND_ORIGINS
docker compose exec backend printenv | grep FRONTEND_ORIGINS

# Phải có: https://smartfarm.kimngn.cfd
# Nếu không có, cần update .env file
```

---

### Bước 4: Test Với Origin Header

```bash
# Test với Origin header (giống browser)
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/classes \
  -H "Origin: https://smartfarm.kimngn.cfd"

# Hoặc test từ VPS với Origin
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/classes \
  -H "Origin: https://smartfarm.kimngn.cfd" \
  -H "Access-Control-Request-Method: GET"
```

---

## 🚨 Nếu Test Trực Tiếp Từ Backend Vẫn 403

**Có nghĩa là SecurityConfig chưa được áp dụng. Cần:**

```bash
# 1. Kiểm tra code trong container
docker compose exec backend ls -la /app/

# 2. Rebuild với --no-cache và kiểm tra logs compile
docker compose build --no-cache backend 2>&1 | grep -i "pest-disease\|SecurityConfig"

# 3. Xem SecurityConfig có được compile không
docker compose exec backend jar -xf /app/app.jar BOOT-INF/classes/com/example/demo/Security/SecurityConfig.class
docker compose exec backend ls -la BOOT-INF/classes/com/example/demo/Security/
```

---

## 🎯 Nếu Test Trực Tiếp Từ Backend Trả Về 200

**Có nghĩa là vấn đề ở Nginx hoặc CORS. Cần:**

```bash
# 1. Kiểm tra Nginx config
cat nginx/nginx.conf | grep -A 5 "location /api"

# 2. Kiểm tra Nginx có chặn request không
docker compose logs nginx --tail=50 | grep "403\|pest-disease"

# 3. Test với curl từ VPS (không qua browser)
curl -v https://smartfarm.kimngn.cfd/api/pest-disease/classes \
  -H "Origin: https://smartfarm.kimngn.cfd"
```

---

## 📋 Checklist

- [ ] Đã test trực tiếp từ backend container (`docker compose exec backend curl`)
- [ ] Đã kiểm tra SecurityConfig có được compile vào JAR
- [ ] Đã kiểm tra FRONTEND_ORIGINS có HTTPS domain
- [ ] Đã test với Origin header
- [ ] Đã kiểm tra Nginx logs
- [ ] Đã test từ VPS với curl (không qua browser)

---

**Hãy test trực tiếp từ backend container trước!** 🔧✨
