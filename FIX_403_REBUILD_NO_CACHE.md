# 🔧 Fix Lỗi 403 - Rebuild Với --no-cache

## 🔍 Vấn Đề

**Cả `/api/health` và `/api/pest-disease/classes` đều trả về 403.**

**Code đã đúng, nhưng backend container có thể đang chạy code cũ.**

---

## ✅ Giải Pháp: Rebuild Với --no-cache

### Bước 1: Rebuild Backend Với --no-cache

```bash
cd /opt/SmartFarm

# Rebuild với --no-cache để đảm bảo code mới được build
docker compose build --no-cache backend

# Quá trình này sẽ mất 5-10 phút
# Xem logs để đảm bảo không có lỗi compile
```

---

### Bước 2: Recreate Backend Container

```bash
# Recreate backend container
docker compose up -d --force-recreate backend

# Đợi backend khởi động (30-60 giây)
sleep 45
```

---

### Bước 3: Kiểm Tra Logs Backend

```bash
# Xem logs backend khi khởi động
docker compose logs backend --tail=100

# Kiểm tra có lỗi gì không
docker compose logs backend --tail=100 | grep -i "error\|exception\|failed"

# Kiểm tra SecurityConfig có được load không
docker compose logs backend --tail=100 | grep -i "SecurityConfig\|SecurityFilterChain"
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

# Test login endpoint
curl -X POST https://smartfarm.kimngn.cfd/api/accounts/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test","password":"test"}'
# Phải trả về: HTTP/2 200 hoặc 401 (không phải 403)
```

---

## 🚨 Nếu Vẫn 403 Sau Khi Rebuild

### Kiểm Tra 1: Xem Build Logs

```bash
# Xem logs build để đảm bảo SecurityConfig được compile
docker compose build --no-cache backend 2>&1 | grep -i "SecurityConfig\|Compiling.*Security"

# Hoặc xem toàn bộ logs build
docker compose build --no-cache backend 2>&1 | tee build.log
grep -i "error\|failed" build.log
```

### Kiểm Tra 2: Kiểm Tra JAR File

```bash
# Kiểm tra SecurityConfig có trong JAR không
docker compose exec backend sh -c "cd /tmp && jar -xf /app/app.jar BOOT-INF/classes/com/example/demo/Security/SecurityConfig.class 2>&1 && ls -la BOOT-INF/classes/com/example/demo/Security/ 2>&1"

# Phải thấy: SecurityConfig.class
```

### Kiểm Tra 3: Test Trực Tiếp Từ Backend (Nếu Có wget)

```bash
# Test từ backend container (nếu có wget)
docker compose exec backend sh -c "wget -O- http://localhost:8080/api/health 2>&1" || echo "wget not found"

# Hoặc dùng Java để test
docker compose exec backend sh -c "echo -e 'GET /api/health HTTP/1.1\nHost: localhost:8080\n\n' | nc localhost 8080" || echo "nc not found"
```

---

## 📋 Checklist

- [ ] Đã rebuild với --no-cache
- [ ] Đã recreate backend container
- [ ] Đã đợi backend khởi động (45 giây)
- [ ] Đã xem backend logs không có lỗi
- [ ] Đã test health endpoint (phải 200)
- [ ] Đã test pest-disease endpoint (phải 200)
- [ ] Đã kiểm tra SecurityConfig có trong JAR

---

**Hãy rebuild với --no-cache!** 🔧✨
