# ✅ SSL Setup Hoàn Tất - smartfarm.kimngn.cfd

## 🎉 Thành Công!

**SSL certificate đã được tạo:**
- Certificate: `/opt/SmartFarm/certbot/conf/live/smartfarm.kimngn.cfd/fullchain.pem`
- Private Key: `/opt/SmartFarm/certbot/conf/live/smartfarm.kimngn.cfd/privkey.pem`
- Expires: 2026-03-25 (90 ngày)

---

## 🚀 Các Bước Tiếp Theo

### Bước 1: Restart Tất Cả Services

```bash
cd /opt/SmartFarm

# Restart tất cả services để áp dụng SSL config
docker compose down
docker compose up -d

# Kiểm tra services đang chạy
docker compose ps
```

**Đợi 30-60 giây để tất cả services khởi động xong.**

---

### Bước 2: Kiểm Tra HTTPS

```bash
# Test HTTPS từ VPS
curl -I https://smartfarm.kimngn.cfd

# Phải thấy:
# HTTP/2 200
# hoặc
# HTTP/1.1 200 OK
```

**Hoặc mở trình duyệt:**
- `https://smartfarm.kimngn.cfd`
- Phải thấy **🔒 HTTPS** (không có cảnh báo)

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

### Bước 4: Kiểm Tra HTTP Redirect

```bash
# Test HTTP redirect sang HTTPS
curl -I http://smartfarm.kimngn.cfd

# Phải thấy:
# HTTP/1.1 301 Moved Permanently
# Location: https://smartfarm.kimngn.cfd/
```

---

### Bước 5: Kiểm Tra Nginx Logs

```bash
# Xem logs Nginx
docker compose logs nginx --tail=50

# Kiểm tra lỗi SSL
docker compose logs nginx | grep -i ssl
```

**Nếu có lỗi SSL, kiểm tra:**
- Certificate path trong `nginx/nginx.conf`
- Volume mount trong `docker-compose.yml`

---

## 🔄 Setup Auto-Renewal

**SSL certificate sẽ tự động renew trước khi hết hạn (90 ngày).**

### Cách 1: Dùng Cron Job

```bash
# Mở crontab
crontab -e

# Thêm dòng sau (chạy mỗi ngày lúc 0:00)
0 0 * * * cd /opt/SmartFarm && docker run --rm -v /opt/SmartFarm/certbot/conf:/etc/letsencrypt -p 80:80 certbot/certbot renew --standalone && docker compose restart nginx

# Lưu và thoát
```

### Cách 2: Test Renewal (Dry-Run)

```bash
# Test renewal (không thực sự renew)
docker run --rm \
    -v /opt/SmartFarm/certbot/conf:/etc/letsencrypt \
    -p 80:80 \
    certbot/certbot renew --dry-run

# Nếu thành công, renewal sẽ hoạt động
```

---

## 📋 Checklist

- [x] SSL certificate đã được tạo
- [ ] Đã restart tất cả services
- [ ] Đã test HTTPS trên trình duyệt
- [ ] Đã test API endpoint
- [ ] Đã test HTTP redirect
- [ ] Đã setup auto-renewal
- [ ] Đã test renewal (dry-run)

---

## 🎯 Kết Quả Mong Đợi

**Sau khi hoàn tất:**
- ✅ `https://smartfarm.kimngn.cfd` hoạt động với SSL
- ✅ `http://smartfarm.kimngn.cfd` tự động redirect sang HTTPS
- ✅ API: `https://smartfarm.kimngn.cfd/api` hoạt động
- ✅ Chatbot: `https://smartfarm.kimngn.cfd/chatbot/` hoạt động
- ✅ ESP32 có thể gửi data đến: `http://smartfarm.kimngn.cfd/api/sensor-data/iot`

---

## 🔍 Troubleshooting

### Lỗi: SSL Certificate Not Found

**Triệu chứng:**
```
nginx: [emerg] SSL certificate not found
```

**Giải pháp:**
```bash
# Kiểm tra certificate path
ls -la /opt/SmartFarm/certbot/conf/live/smartfarm.kimngn.cfd/

# Kiểm tra nginx config
grep ssl_certificate nginx/nginx.conf

# Kiểm tra volume mount
docker compose config | grep certbot
```

---

### Lỗi: Mixed Content

**Triệu chứng:**
- Trang web có cảnh báo "Mixed Content"
- Một số resource load qua HTTP thay vì HTTPS

**Giải pháp:**
- Kiểm tra frontend config: `REACT_APP_API_URL` phải dùng HTTPS
- Kiểm tra backend CORS: `FRONTEND_ORIGINS` phải có HTTPS

---

## 🎉 Chúc Mừng!

**SSL setup đã hoàn tất!** Bạn có thể:
1. Truy cập website qua HTTPS
2. ESP32 có thể gửi data qua HTTP (không cần HTTPS)
3. Certificate sẽ tự động renew

---

**Hãy restart services và test HTTPS!** 🚀✨

