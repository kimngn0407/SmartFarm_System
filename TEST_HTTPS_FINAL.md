# ✅ Test HTTPS - smartfarm.kimngn.cfd

## 🎉 Services Đã Chạy Đúng!

**Kết quả `docker compose ps`:**
- ✅ `smartfarm-nginx` - bind port 80 và 443
- ✅ `smartfarm-frontend` - chỉ internal port 80 (không expose)
- ✅ Tất cả services đang healthy

---

## 🚀 Test HTTPS

### Bước 1: Test HTTPS Từ VPS

```bash
# Test HTTPS
curl -I https://smartfarm.kimngn.cfd

# Phải thấy:
# HTTP/2 200
# hoặc
# HTTP/1.1 200 OK
```

---

### Bước 2: Test HTTP Redirect

```bash
# Test HTTP redirect sang HTTPS
curl -I http://smartfarm.kimngn.cfd

# Phải thấy:
# HTTP/1.1 301 Moved Permanently
# Location: https://smartfarm.kimngn.cfd/
```

---

### Bước 3: Test Các Endpoints

```bash
# Test Frontend
curl -I https://smartfarm.kimngn.cfd

# Test API
curl -I https://smartfarm.kimngn.cfd/api/health

# Test Chatbot
curl -I https://smartfarm.kimngn.cfd/chatbot/
```

---

### Bước 4: Test Trên Trình Duyệt

**Mở trình duyệt:**
- `https://smartfarm.kimngn.cfd`
- Phải thấy **🔒 HTTPS** (không có cảnh báo)
- Phải load được frontend

---

## 🔍 Kiểm Tra Nginx Logs

```bash
# Xem logs Nginx
docker compose logs nginx --tail=20

# Kiểm tra lỗi SSL
docker compose logs nginx | grep -i ssl

# Test config
docker compose exec nginx nginx -t
```

---

## 🎯 Kết Quả Mong Đợi

**Sau khi test:**
- ✅ `https://smartfarm.kimngn.cfd` hoạt động với SSL
- ✅ `http://smartfarm.kimngn.cfd` tự động redirect sang HTTPS
- ✅ API: `https://smartfarm.kimngn.cfd/api` hoạt động
- ✅ Chatbot: `https://smartfarm.kimngn.cfd/chatbot/` hoạt động
- ✅ ESP32 có thể gửi data đến: `http://smartfarm.kimngn.cfd/api/sensor-data/iot`

---

## 🔄 Nếu Có Lỗi SSL

**Kiểm tra certificate:**

```bash
# Kiểm tra certificate đã được tạo
ls -la /opt/SmartFarm/certbot/conf/live/smartfarm.kimngn.cfd/

# Phải thấy:
# - fullchain.pem
# - privkey.pem

# Kiểm tra nginx config
grep ssl_certificate nginx/nginx.conf

# Kiểm tra volume mount
docker compose config | grep certbot
```

---

**Hãy test HTTPS ngay!** 🚀✨

