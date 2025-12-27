# 🔒 Setup SSL Certificate - smartfarm.kimngn.cfd

## ✅ DNS Đã Hoạt Động

**Kết quả kiểm tra:**
```
Name:    smartfarm.kimngn.cfd
Address: 109.205.180.72
```

✅ DNS record đã được tạo và propagate thành công!

---

## 🚀 Các Bước Setup SSL

### Bước 1: SSH Vào VPS

```bash
ssh root@109.205.180.72
# Hoặc dùng user của bạn
```

---

### Bước 2: Pull Code Mới Từ Git

```bash
cd /opt/SmartFarm
git pull origin main
```

**Kiểm tra xem đã có file `setup-ssl-docker.sh`:**
```bash
ls -la setup-ssl-docker.sh
```

---

### Bước 3: Chỉnh Sửa SSL Setup Script

```bash
nano setup-ssl-docker.sh
```

**Cần chỉnh sửa:**
1. **DOMAIN:** Đã là `smartfarm.kimngn.cfd` (đã cập nhật)
2. **EMAIL:** Thay bằng email thật của bạn
   ```bash
   EMAIL="your-email@example.com"  # Thay bằng email của bạn
   ```

**Lưu và thoát:** `Ctrl+X`, `Y`, `Enter`

---

### Bước 4: Chạy Setup SSL

```bash
# Cấp quyền thực thi
chmod +x setup-ssl-docker.sh

# Chạy script
./setup-ssl-docker.sh
```

**Script sẽ:**
1. Kiểm tra DNS đã trỏ đúng chưa
2. Tạo thư mục cho Certbot
3. Chạy Certbot để lấy SSL certificate
4. Cấu hình auto-renewal

**Thời gian:** 1-3 phút

---

### Bước 5: Kiểm Tra SSL Certificate

```bash
# Kiểm tra certificate đã được tạo
ls -la /opt/SmartFarm/certbot/conf/live/smartfarm.kimngn.cfd/

# Phải thấy:
# - fullchain.pem
# - privkey.pem
```

---

### Bước 6: Restart Docker Services

```bash
cd /opt/SmartFarm

# Restart để áp dụng config mới
docker-compose down
docker-compose up -d

# Kiểm tra logs
docker-compose logs -f nginx
```

**Đợi 30 giây để services khởi động xong.**

---

### Bước 7: Kiểm Tra HTTPS

**Trên trình duyệt:**
1. Mở: `https://smartfarm.kimngn.cfd`
2. Phải thấy **🔒 HTTPS** (không có cảnh báo)
3. Test các trang:
   - Frontend: `https://smartfarm.kimngn.cfd`
   - API: `https://smartfarm.kimngn.cfd/api/health`
   - Chatbot: `https://smartfarm.kimngn.cfd/chatbot/`

---

## 🔍 Troubleshooting

### Lỗi 1: Certbot Không Thể Verify Domain

**Triệu chứng:**
```
Failed to verify domain ownership
```

**Giải pháp:**
1. Kiểm tra DNS lại:
   ```bash
   dig smartfarm.kimngn.cfd +short
   # Phải trả về: 109.205.180.72
   ```

2. Kiểm tra port 80 đã mở:
   ```bash
   netstat -tuln | grep :80
   # Phải thấy nginx đang listen port 80
   ```

3. Kiểm tra firewall:
   ```bash
   ufw status
   # Port 80 và 443 phải được mở
   ```

---

### Lỗi 2: Nginx Không Start

**Triệu chứng:**
```
nginx: [emerg] SSL certificate not found
```

**Giải pháp:**
1. Kiểm tra certificate path trong `nginx.conf`:
   ```bash
   grep ssl_certificate nginx/nginx.conf
   ```

2. Kiểm tra volume mount trong `docker-compose.yml`:
   ```bash
   grep certbot docker-compose.yml
   ```

3. Restart nginx:
   ```bash
   docker-compose restart nginx
   ```

---

### Lỗi 3: HTTP Redirect Không Hoạt Động

**Triệu chứng:**
- Truy cập `http://smartfarm.kimngn.cfd` không redirect sang HTTPS

**Giải pháp:**
1. Kiểm tra nginx config:
   ```bash
   docker-compose exec nginx nginx -t
   ```

2. Reload nginx:
   ```bash
   docker-compose exec nginx nginx -s reload
   ```

---

## 📋 Checklist

- [ ] Đã SSH vào VPS
- [ ] Đã pull code mới (`git pull origin main`)
- [ ] Đã chỉnh sửa email trong `setup-ssl-docker.sh`
- [ ] Đã chạy `./setup-ssl-docker.sh` thành công
- [ ] Đã kiểm tra certificate được tạo
- [ ] Đã restart Docker services (`docker-compose down && docker-compose up -d`)
- [ ] Đã test HTTPS trên trình duyệt
- [ ] Đã test HTTP redirect sang HTTPS
- [ ] Đã test API endpoint
- [ ] Đã test Chatbot

---

## 🎯 Kết Quả Mong Đợi

**Sau khi hoàn tất:**
- ✅ `https://smartfarm.kimngn.cfd` hoạt động với SSL
- ✅ `http://smartfarm.kimngn.cfd` tự động redirect sang HTTPS
- ✅ API: `https://smartfarm.kimngn.cfd/api` hoạt động
- ✅ Chatbot: `https://smartfarm.kimngn.cfd/chatbot/` hoạt động
- ✅ ESP32 có thể gửi data đến: `http://smartfarm.kimngn.cfd/api/sensor-data/iot`

---

## 🔄 Auto-Renewal

**SSL certificate sẽ tự động renew mỗi 90 ngày.**

**Kiểm tra auto-renewal:**
```bash
# Xem cron job
crontab -l | grep certbot

# Test renewal (dry-run)
docker-compose run --rm certbot renew --dry-run
```

---

**Bắt đầu setup SSL trên VPS ngay!** 🔒✨

