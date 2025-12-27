# 🔧 Fix Lỗi 403 - Kiểm Tra JWT Filter

## 🔍 Vấn Đề

**Vẫn còn 403 sau khi rebuild với --no-cache.**

**Có thể JWT Filter đang chặn tất cả requests, kể cả những endpoint đã có trong permitAll().**

---

## ✅ Giải Pháp: Kiểm Tra JWT Filter

### Bước 1: Xem Backend Logs

```bash
cd /opt/SmartFarm

# Xem logs backend khi có request đến
docker compose logs backend --tail=200 | grep -i "pest-disease\|health\|403\|forbidden\|JwtAuthenticationFilter"

# Hoặc xem tất cả logs gần đây
docker compose logs backend --tail=100
```

---

### Bước 2: Kiểm Tra JWT Filter Code

**JWT Filter có thể đang chặn requests trước khi đến SecurityConfig.**

**Cần kiểm tra xem JWT Filter có skip các public endpoints không.**

---

### Bước 3: Test Login Endpoint (Để So Sánh)

```bash
# Test login endpoint (đã có trong permitAll())
curl -X POST https://smartfarm.kimngn.cfd/api/accounts/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test","password":"test"}'

# Nếu cũng trả về 403 → JWT Filter đang chặn
# Nếu trả về 200 hoặc 401 → JWT Filter OK, vấn đề ở SecurityConfig
```

---

### Bước 4: Kiểm Tra SecurityConfig Có Được Load Không

```bash
# Xem logs backend khi khởi động
docker compose logs backend --tail=200 | grep -i "SecurityConfig\|SecurityFilterChain\|Started DemoSmartFarm"

# Kiểm tra có lỗi gì không
docker compose logs backend --tail=200 | grep -i "error\|exception\|failed"
```

---

## 🚨 Nếu JWT Filter Đang Chặn

**Cần sửa JWT Filter để skip các public endpoints.**

---

## 📋 Checklist

- [ ] Đã xem backend logs khi có request
- [ ] Đã test login endpoint để so sánh
- [ ] Đã kiểm tra SecurityConfig có được load không
- [ ] Đã kiểm tra JWT Filter code

---

**Hãy xem backend logs và test login endpoint!** 🔧✨
