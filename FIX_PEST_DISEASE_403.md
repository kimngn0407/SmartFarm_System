# 🔧 Fix Lỗi 403 Forbidden cho Pest-Disease Endpoints

## 🔍 Vấn Đề

**Lỗi:**
```
api/pest-disease/classes:1  Failed to load resource: the server responded with a status of 403
api/pest-disease/detect:1  Failed to load resource: the server responded with a status of 403
```

**Nguyên nhân:**
- Backend trên VPS chưa được rebuild với code mới
- `SecurityConfig.java` đã được sửa để thêm `/api/pest-disease/**` vào `permitAll()`, nhưng backend container chưa có code mới

---

## ✅ Giải Pháp

### Bước 1: Pull Code Mới Trên VPS

```bash
cd /opt/SmartFarm

# Pull code mới từ git
git pull origin main

# Kiểm tra xem SecurityConfig.java đã có /api/pest-disease/** chưa
grep -A 2 "pest-disease" demoSmartFarm/demo/src/main/java/com/example/demo/Security/SecurityConfig.java

# Phải thấy:
# .requestMatchers("/api/pest-disease/**").permitAll()
```

---

### Bước 2: Rebuild Backend (QUAN TRỌNG!)

```bash
# Rebuild backend image với code mới
docker compose build backend

# Recreate backend container để áp dụng thay đổi
docker compose up -d --force-recreate backend

# Đợi backend khởi động (30-60 giây)
sleep 45
```

---

### Bước 3: Kiểm Tra Logs

```bash
# Xem logs backend để đảm bảo không có lỗi compile
docker compose logs backend --tail=50

# Kiểm tra backend đang chạy
docker compose ps backend
```

---

### Bước 4: Test Endpoints

**Test từ VPS:**
```bash
# Test pest-disease classes endpoint
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/classes

# Phải trả về: HTTP/2 200 (không phải 403)

# Test pest-disease health endpoint
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/health

# Test với JSON response
curl https://smartfarm.kimngn.cfd/api/pest-disease/classes
```

**Test từ browser console (F12):**
```javascript
// Test pest-disease classes
fetch('https://smartfarm.kimngn.cfd/api/pest-disease/classes')
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

// Phải trả về status 200 và data, không phải 403
```

---

## 🎯 Kiểm Tra SecurityConfig

**File phải có:**
```java
.authorizeHttpRequests(auth -> auth
    // Public endpoints - không cần authentication
    .requestMatchers("/api/auth/**", "/api/accounts/login", "/api/accounts/register").permitAll()
    .requestMatchers("/api/email/test/**").permitAll()
    .requestMatchers("/api/sensor-data/iot").permitAll()
    .requestMatchers("/api/health", "/health").permitAll()
    .requestMatchers("/api/pest-disease/**").permitAll()  // ✅ Phải có dòng này
    .requestMatchers("/api/crop/**").permitAll()          // ✅ Phải có dòng này
    .requestMatchers("/ws/**", "/app/**", "/topic/**").permitAll()
    .requestMatchers("/actuator/**").permitAll()
    .anyRequest().authenticated()
)
```

---

## 🚨 Nếu Vẫn Lỗi 403

### Kiểm Tra 1: Backend Đã Rebuild Chưa?

```bash
# Xem build date của backend image
docker images | grep smartfarm-backend

# Xem container đang chạy code nào
docker compose exec backend ls -la /app/

# Hoặc kiểm tra trong container
docker compose exec backend cat /app/BOOT-INF/classes/com/example/demo/Security/SecurityConfig.class
# (Nếu có thể, hoặc kiểm tra logs)
```

### Kiểm Tra 2: CORS Configuration

```bash
# Kiểm tra FRONTEND_ORIGINS trong backend container
docker compose exec backend printenv | grep FRONTEND_ORIGINS

# Phải có: https://smartfarm.kimngn.cfd
# Nếu không có, cần update .env file và recreate backend
```

### Kiểm Tra 3: Restart Tất Cả Services

```bash
# Restart tất cả services
docker compose down
docker compose up -d

# Đợi tất cả services khởi động
sleep 60

# Kiểm tra tất cả services đang chạy
docker compose ps
```

---

## 📋 Checklist

- [ ] Đã pull code mới từ git (`git pull origin main`)
- [ ] Đã kiểm tra `SecurityConfig.java` có `/api/pest-disease/**` trong `permitAll()`
- [ ] Đã rebuild backend (`docker compose build backend`)
- [ ] Đã recreate backend container (`docker compose up -d --force-recreate backend`)
- [ ] Đã đợi backend khởi động (45-60 giây)
- [ ] Đã kiểm tra logs không có lỗi compile
- [ ] Đã test endpoint từ VPS (`curl`)
- [ ] Đã test endpoint từ browser console
- [ ] Đã refresh browser (Ctrl+Shift+R)

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ `/api/pest-disease/classes` trả về 200 OK
- ✅ `/api/pest-disease/detect` trả về 200 OK (hoặc 400 nếu thiếu file)
- ✅ Không còn lỗi 403 Forbidden
- ✅ Frontend có thể load disease classes và detect disease

---

**Hãy rebuild backend trên VPS và test lại!** 🔧✨

