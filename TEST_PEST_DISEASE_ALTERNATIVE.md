# 🔧 Test Pest-Disease Endpoint - Alternative Methods

## 🔍 Vấn Đề

**Backend container không có `curl`. Cần dùng cách khác để test.**

---

## ✅ Giải Pháp: Test Từ VPS (Không Qua Browser)

### Bước 1: Test Từ VPS Với curl

```bash
cd /opt/SmartFarm

# Test trực tiếp từ VPS (không qua browser)
curl -v https://smartfarm.kimngn.cfd/api/pest-disease/classes

# Xem response headers và status code
# Phải thấy: HTTP/2 200 (không phải 403)
```

---

### Bước 2: Test Với Origin Header (Giống Browser)

```bash
# Test với Origin header (giống browser gửi)
curl -v https://smartfarm.kimngn.cfd/api/pest-disease/classes \
  -H "Origin: https://smartfarm.kimngn.cfd" \
  -H "Referer: https://smartfarm.kimngn.cfd/pest-detection"

# Xem response headers
```

---

### Bước 3: Kiểm Tra FRONTEND_ORIGINS

```bash
# Kiểm tra FRONTEND_ORIGINS trong backend container
docker compose exec backend printenv | grep FRONTEND_ORIGINS

# Phải có: https://smartfarm.kimngn.cfd
# Nếu không có, cần update .env file
```

---

### Bước 4: Update .env File (Nếu Cần)

```bash
# Kiểm tra .env file
cat .env | grep FRONTEND_ORIGINS

# Nếu không có hoặc không đúng, sửa:
nano .env

# Thêm hoặc sửa:
# FRONTEND_ORIGINS=https://smartfarm.kimngn.cfd,https://smartfarm.codex.io.vn,http://localhost:3000,http://localhost:80

# Sau đó recreate backend
docker compose up -d --force-recreate backend
sleep 30
```

---

### Bước 5: Test Health Endpoint (Để So Sánh)

```bash
# Test health endpoint (đã có trong permitAll())
curl -I https://smartfarm.kimngn.cfd/api/health

# Phải trả về: HTTP/2 200

# So sánh với pest-disease
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/classes
```

---

## 🚨 Nếu Vẫn 403

### Kiểm Tra 1: SecurityConfig Có Được Compile Không?

```bash
# Kiểm tra SecurityConfig trong code
grep -A 2 "pest-disease" demoSmartFarm/demo/src/main/java/com/example/demo/Security/SecurityConfig.java

# Phải thấy: .requestMatchers("/api/pest-disease/**").permitAll()
```

### Kiểm Tra 2: Rebuild Với --no-cache

```bash
# Rebuild với --no-cache để đảm bảo code mới
docker compose build --no-cache backend
docker compose up -d --force-recreate backend
sleep 45

# Test lại
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/classes
```

### Kiểm Tra 3: Xem Backend Logs

```bash
# Xem logs backend khi có request
docker compose logs backend --tail=50 | grep -i "pest-disease\|403\|forbidden"

# Hoặc xem tất cả logs
docker compose logs backend --tail=100
```

---

## 🎯 Test Từ Browser Console

**Sau khi fix, test từ browser:**

```javascript
// Test pest-disease classes
fetch('https://smartfarm.kimngn.cfd/api/pest-disease/classes', {
  method: 'GET',
  headers: {
    'Content-Type': 'application/json'
  }
})
  .then(r => {
    console.log('Status:', r.status);
    return r.json();
  })
  .then(data => {
    console.log('✅ Success:', data);
  })
  .catch(err => {
    console.error('❌ Error:', err);
  });
```

---

## 📋 Checklist

- [ ] Đã test từ VPS với curl (không qua browser)
- [ ] Đã test với Origin header
- [ ] Đã kiểm tra FRONTEND_ORIGINS có HTTPS domain
- [ ] Đã update .env file nếu cần
- [ ] Đã recreate backend sau khi update .env
- [ ] Đã test health endpoint để so sánh
- [ ] Đã rebuild với --no-cache nếu cần
- [ ] Đã test từ browser console

---

**Hãy test từ VPS với curl trước!** 🔧✨
