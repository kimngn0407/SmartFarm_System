# 🔧 Test Backend Trực Tiếp (Bypass Nginx)

## 🔍 Vấn Đề

**Backend logs không có request đến `/api/health`.**

**Cần test trực tiếp backend để xác định vấn đề ở đâu.**

---

## ✅ Giải Pháp: Test Trực Tiếp Backend

### Bước 1: Test Trực Tiếp Từ VPS Đến Backend

```bash
cd /opt/SmartFarm

# Test trực tiếp từ VPS đến backend container (port 8080)
curl -I http://localhost:8080/api/health

# Nếu trả về 200 → vấn đề ở Nginx
# Nếu trả về 403 → vấn đề ở Backend

# Test với /health (không có /api/)
curl -I http://localhost:8080/health

# Test pest-disease
curl -I http://localhost:8080/api/pest-disease/classes
```

---

### Bước 2: Xem Nginx Logs

```bash
# Xem Nginx logs khi có request
docker compose logs nginx --tail=100 | grep -i "pest-disease\|health\|403\|forbidden"

# Hoặc xem access logs
docker compose exec nginx tail -20 /var/log/nginx/access.log

# Hoặc xem error logs
docker compose exec nginx tail -20 /var/log/nginx/error.log
```

---

### Bước 3: Kiểm Tra Nginx Config

**Lưu ý:** Nginx config có:
```nginx
location /api/ {
    proxy_pass http://backend/;  # Dấu / ở cuối strip /api/
}
```

**Có nghĩa là:**
- Request: `/api/health` → Backend nhận: `/health` (không có `/api/`)
- Request: `/api/pest-disease/classes` → Backend nhận: `/pest-disease/classes` (không có `/api/`)

**SecurityConfig phải có:**
- `.requestMatchers("/health").permitAll()` ✅ (đã có)
- `.requestMatchers("/pest-disease/**").permitAll()` ❌ (chưa có, chỉ có `/api/pest-disease/**`)

---

## 🚨 Vấn Đề Phát Hiện

**Nginx strip `/api/` khi proxy đến backend!**

**SecurityConfig cần có cả 2 patterns:**
- `/api/pest-disease/**` (cho direct access)
- `/pest-disease/**` (cho access qua Nginx)

---

## ✅ Giải Pháp: Sửa SecurityConfig

**Cần thêm patterns không có `/api/` prefix:**

```java
.requestMatchers("/api/health", "/health").permitAll()
.requestMatchers("/api/pest-disease/**", "/pest-disease/**").permitAll()
.requestMatchers("/api/crop/**", "/crop/**").permitAll()
```

---

**Hãy test trực tiếp backend trước để xác nhận!** 🔧✨
