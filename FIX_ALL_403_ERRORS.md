# 🔧 Fix Lỗi 403 Cho Tất Cả Endpoints

## 🔍 Vấn Đề

**Cả `/api/health` cũng trả về 403!**

**Điều này có nghĩa là:**
- SecurityConfig không được áp dụng
- Backend container đang chạy code cũ
- Có thể SecurityConfig không được compile vào JAR

---

## ✅ Giải Pháp: Rebuild Và Kiểm Tra

### Bước 1: Kiểm Tra SecurityConfig Trong Code

```bash
cd /opt/SmartFarm

# Kiểm tra SecurityConfig có /api/health không
grep -A 10 "authorizeHttpRequests" demoSmartFarm/demo/src/main/java/com/example/demo/Security/SecurityConfig.java

# Phải thấy:
# .requestMatchers("/api/health", "/health").permitAll()
```

---

### Bước 2: Xem Backend Logs Khi Khởi Động

```bash
# Xem logs backend khi khởi động
docker compose logs backend --tail=100 | grep -i "SecurityConfig\|SecurityFilterChain\|Started DemoSmartFarm"

# Kiểm tra có lỗi gì không
docker compose logs backend --tail=100 | grep -i "error\|exception\|failed"
```

---

### Bước 3: Rebuild Với --no-cache Và Xem Logs Compile

```bash
# Rebuild với --no-cache
docker compose build --no-cache backend 2>&1 | tee build.log

# Tìm trong build.log xem có compile SecurityConfig không
grep -i "SecurityConfig\|Compiling" build.log | tail -20

# Sau khi build xong, recreate container
docker compose up -d --force-recreate backend
sleep 45

# Xem logs khởi động
docker compose logs backend --tail=50
```

---

### Bước 4: Test Endpoints

```bash
# Test health endpoint
curl -I https://smartfarm.kimngn.cfd/api/health
# Phải trả về: HTTP/2 200

# Test pest-disease
curl -I https://smartfarm.kimngn.cfd/api/pest-disease/classes
# Phải trả về: HTTP/2 200

# Test login endpoint (đã có trong permitAll())
curl -I https://smartfarm.kimngn.cfd/api/accounts/login
# Phải trả về: HTTP/2 200 hoặc 405 (Method Not Allowed nếu dùng GET)
```

---

### Bước 5: Kiểm Tra JAR File

```bash
# Kiểm tra SecurityConfig có trong JAR không
docker compose exec backend sh -c "cd /tmp && jar -xf /app/app.jar BOOT-INF/classes/com/example/demo/Security/SecurityConfig.class 2>&1 && ls -la BOOT-INF/classes/com/example/demo/Security/"

# Phải thấy: SecurityConfig.class
```

---

## 🚨 Nếu Vẫn 403 Sau Khi Rebuild

### Option 1: Kiểm Tra Có Lỗi Compile Không

```bash
# Xem build.log để tìm lỗi compile
grep -i "error\|failed\|exception" build.log

# Nếu có lỗi, sửa và rebuild lại
```

### Option 2: Kiểm Tra Application Properties

```bash
# Kiểm tra application.properties có override security không
cat demoSmartFarm/demo/src/main/resources/application.properties | grep -i "security\|cors"

# Kiểm tra application-prod.properties
cat demoSmartFarm/demo/src/main/resources/application-prod.properties | grep -i "security\|cors"
```

### Option 3: Test Trực Tiếp Từ Backend (Nếu Có wget)

```bash
# Test từ backend container (nếu có wget)
docker compose exec backend wget -O- http://localhost:8080/api/health 2>&1

# Hoặc dùng Java để test
docker compose exec backend sh -c "echo 'GET /api/health HTTP/1.1\nHost: localhost:8080\n\n' | nc localhost 8080"
```

---

## 📋 Checklist

- [ ] Đã kiểm tra SecurityConfig có /api/health trong code
- [ ] Đã xem backend logs khi khởi động
- [ ] Đã rebuild với --no-cache
- [ ] Đã xem logs compile
- [ ] Đã test health endpoint (phải 200)
- [ ] Đã kiểm tra SecurityConfig có trong JAR
- [ ] Đã kiểm tra application.properties

---

**Hãy rebuild với --no-cache và xem logs!** 🔧✨
