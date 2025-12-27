# 🔧 Kiểm Tra Backend Logs - Lỗi 403

## 🔍 Vấn Đề

**Vẫn còn 403 sau khi rebuild. Cần kiểm tra backend logs để xem có gì bất thường.**

---

## ✅ Giải Pháp: Kiểm Tra Logs

### Bước 1: Xem Backend Logs Khi Có Request

```bash
cd /opt/SmartFarm

# Xem logs backend khi có request đến
docker compose logs backend --tail=200

# Tìm các dòng liên quan đến request
docker compose logs backend --tail=200 | grep -i "pest-disease\|health\|403\|forbidden\|SecurityConfig\|SecurityFilterChain"

# Hoặc xem tất cả logs từ khi khởi động
docker compose logs backend --since 10m
```

---

### Bước 2: Test Và Xem Logs Real-time

```bash
# Mở một terminal để xem logs real-time
docker compose logs -f backend

# Trong terminal khác, test endpoint
curl -I https://smartfarm.kimngn.cfd/api/health

# Xem logs có gì xuất hiện không
```

---

### Bước 3: Kiểm Tra Backend Đang Chạy Code Nào

```bash
# Kiểm tra build date của backend image
docker images | grep smartfarm-backend

# Kiểm tra container đang chạy image nào
docker compose ps backend

# Xem container ID
docker ps | grep smartfarm-backend
```

---

### Bước 4: Test Login Endpoint (Để So Sánh)

```bash
# Test login endpoint (đã có trong permitAll())
curl -v -X POST https://smartfarm.kimngn.cfd/api/accounts/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test","password":"test"}'

# Xem response status
# Nếu cũng 403 → vấn đề chung với SecurityConfig
# Nếu 200 hoặc 401 → chỉ có vấn đề với một số endpoints
```

---

### Bước 5: Kiểm Tra Có Lỗi Khi Khởi Động

```bash
# Xem logs khi backend khởi động
docker compose logs backend | grep -i "error\|exception\|failed\|SecurityConfig\|SecurityFilterChain" | tail -50

# Kiểm tra có lỗi compile hoặc runtime không
docker compose logs backend | grep -i "error\|exception" | tail -20
```

---

## 🚨 Nếu Không Thấy Logs Gì

**Có thể request không đến backend. Kiểm tra Nginx:**

```bash
# Xem Nginx logs
docker compose logs nginx --tail=100 | grep -i "pest-disease\|health\|403"

# Kiểm tra Nginx config
cat nginx/nginx.conf | grep -A 10 "location /api"
```

---

## 📋 Checklist

- [ ] Đã xem backend logs khi có request
- [ ] Đã test và xem logs real-time
- [ ] Đã kiểm tra backend đang chạy code nào
- [ ] Đã test login endpoint để so sánh
- [ ] Đã kiểm tra có lỗi khi khởi động
- [ ] Đã kiểm tra Nginx logs

---

**Hãy xem backend logs và test login endpoint!** 🔧✨
