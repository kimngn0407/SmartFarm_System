# 🔧 Debug Lỗi 403 Pest-Disease - Chi Tiết

## 🔍 Vấn Đề

**Response headers cho thấy:**
- `vary: Origin` - CORS đang được xử lý
- Security headers từ Spring Security
- **403 Forbidden** - Spring Security đang chặn request

**Có thể SecurityConfig chưa được compile hoặc backend đang chạy code cũ.**

---

## ✅ Giải Pháp: Debug Chi Tiết

### Bước 1: So Sánh Với Health Endpoint

```bash
cd /opt/SmartFarm

# Test health endpoint (đã có trong permitAll())
curl -I https://smartfarm.kimngn.cfd/api/health

# Phải trả về: HTTP/2 200

# So sánh với pest-disease
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/classes
# Trả về: HTTP/2 403
```

---

### Bước 2: Kiểm Tra SecurityConfig Trong Code

```bash
# Kiểm tra SecurityConfig.java có pest-disease chưa
grep -A 5 "pest-disease" demoSmartFarm/demo/src/main/java/com/example/demo/Security/SecurityConfig.java

# Phải thấy:
# .requestMatchers("/api/pest-disease/**").permitAll()
```

---

### Bước 3: Xem Backend Logs Khi Có Request

```bash
# Xem logs backend khi có request đến pest-disease
docker compose logs backend --tail=100 | grep -i "pest-disease\|403\|forbidden\|SecurityFilterChain"

# Hoặc xem tất cả logs gần đây
docker compose logs backend --tail=50
```

---

### Bước 4: Rebuild Với --no-cache Và Xem Logs Compile

```bash
# Rebuild với --no-cache và xem logs compile
docker compose build --no-cache backend 2>&1 | tee build.log

# Tìm trong build.log xem có compile SecurityConfig không
grep -i "SecurityConfig\|pest-disease" build.log

# Sau khi build xong, recreate container
docker compose up -d --force-recreate backend
sleep 45

# Test lại
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/classes
```

---

### Bước 5: Kiểm Tra JAR File Trong Container

```bash
# Kiểm tra xem SecurityConfig có trong JAR không
docker compose exec backend sh -c "jar -tf /app/app.jar | grep SecurityConfig"

# Phải thấy: BOOT-INF/classes/com/example/demo/Security/SecurityConfig.class
```

---

### Bước 6: Test Với Authentication (Để So Sánh)

```bash
# Test endpoint cần authentication (để xem có khác không)
curl -I https://smartfarm.kimngn.cfd/api/sensors/data

# Phải trả về: HTTP/2 401 (Unauthorized) hoặc 403
# Nếu cũng trả về 403, có thể là vấn đề chung
```

---

## 🚨 Nếu Vẫn 403 Sau Khi Rebuild

### Option 1: Kiểm Tra Thứ Tự requestMatchers

**Có thể thứ tự trong SecurityConfig quan trọng. Kiểm tra:**

```bash
# Xem toàn bộ authorizeHttpRequests
cat demoSmartFarm/demo/src/main/java/com/example/demo/Security/SecurityConfig.java | grep -A 15 "authorizeHttpRequests"

# Đảm bảo `/api/pest-disease/**` được đặt TRƯỚC `.anyRequest().authenticated()`
```

### Option 2: Thử Thêm Explicit Path

**Thử thêm explicit path thay vì wildcard:**

```bash
# Sửa SecurityConfig.java
nano demoSmartFarm/demo/src/main/java/com/example/demo/Security/SecurityConfig.java

# Thay:
# .requestMatchers("/api/pest-disease/**").permitAll()
# Bằng:
# .requestMatchers("/api/pest-disease/classes").permitAll()
# .requestMatchers("/api/pest-disease/detect").permitAll()
# .requestMatchers("/api/pest-disease/health").permitAll()

# Rebuild
docker compose build backend
docker compose up -d --force-recreate backend
```

---

## 📋 Checklist

- [ ] Đã so sánh với health endpoint (phải 200)
- [ ] Đã kiểm tra SecurityConfig có pest-disease trong code
- [ ] Đã xem backend logs khi có request
- [ ] Đã rebuild với --no-cache
- [ ] Đã kiểm tra SecurityConfig có trong JAR
- [ ] Đã test với authentication endpoint để so sánh
- [ ] Đã kiểm tra thứ tự requestMatchers

---

**Hãy so sánh với health endpoint và xem backend logs!** 🔧✨
