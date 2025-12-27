# ✅ Kiểm Tra Docker Services Status

## 🔍 Kiểm Tra Port 80

**Kết quả `lsof -i :80`:**
```
docker-pr 2493272 root    7u  IPv4 10132435      0t0  TCP *:http (LISTEN)
docker-pr 2493280 root    7u  IPv6 10132436      0t0  TCP *:http (LISTEN)
```

**✅ Port 80 đang được Docker sử dụng** - Đây là bình thường!

---

## 🚀 Kiểm Tra Docker Services

```bash
cd /opt/SmartFarm

# Xem tất cả containers
docker compose ps

# Hoặc
docker ps

# Xem logs Nginx
docker compose logs nginx --tail=20
```

---

## ✅ Test HTTPS

```bash
# Test HTTPS từ VPS
curl -I https://smartfarm.kimngn.cfd

# Hoặc test từ trình duyệt
# https://smartfarm.kimngn.cfd
```

---

## 🔍 Nếu Vẫn Có Lỗi

**Kiểm tra Nginx container:**

```bash
# Xem container nào đang chạy
docker ps | grep nginx

# Xem logs
docker compose logs nginx

# Kiểm tra config
docker compose exec nginx nginx -t
```

---

**Port 80 đã được Docker bind thành công! Hãy test HTTPS!** ✅✨

