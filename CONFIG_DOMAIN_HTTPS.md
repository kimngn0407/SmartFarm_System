# 🔐 Cấu Hình Domain và HTTPS

## 📋 Thông Tin

- **Domain:** `smartfarm.codex.io.vn`
- **IP VPS:** `109.205.180.72` (đã trỏ DNS)
- **SSL:** Let's Encrypt (miễn phí)

---

## 🚀 Các Bước Setup

### Bước 1: Kiểm Tra DNS

```bash
# Kiểm tra domain đã trỏ đến IP chưa
dig smartfarm.codex.io.vn
# Hoặc
nslookup smartfarm.codex.io.vn
```

**Kết quả mong đợi:** Trả về IP `109.205.180.72`

---

### Bước 2: Setup SSL Certificate

**Cách 1: Sử dụng script tự động (Khuyên dùng)**

```bash
cd /opt/SmartFarm

# Chỉnh sửa email trong script
nano setup-ssl-docker.sh
# Thay: EMAIL="your-email@example.com" → Email thật của bạn

# Chạy script
chmod +x setup-ssl-docker.sh
./setup-ssl-docker.sh
```

**Cách 2: Manual với certbot**

```bash
cd /opt/SmartFarm

# Tạo thư mục
mkdir -p certbot/conf certbot/www

# Chạy certbot trong Docker
docker run -it --rm \
    -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
    -v "$(pwd)/certbot/www:/var/www/certbot" \
    certbot/certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email your-email@example.com \
    --agree-tos \
    --no-eff-email \
    -d smartfarm.codex.io.vn
```

---

### Bước 3: Cập Nhật Docker Compose

**File đã được cập nhật:** `docker-compose.yml`

**Kiểm tra volumes:**
```yaml
volumes:
  - ./certbot/conf:/etc/letsencrypt:ro
  - ./certbot/www:/var/www/certbot:ro
```

**Ports:**
```yaml
ports:
  - "80:80"
  - "443:443"
```

---

### Bước 4: Restart Services

```bash
cd /opt/SmartFarm

# Pull code mới (nếu chưa)
git pull origin main

# Restart Nginx
docker compose restart nginx

# Hoặc rebuild tất cả
docker compose down
docker compose up -d
```

---

### Bước 5: Cập Nhật Cấu Hình Ứng Dụng

**1. Frontend (J2EE_Frontend):**

Cập nhật `docker-compose.yml`:
```yaml
frontend:
  environment:
    - REACT_APP_API_URL=https://smartfarm.codex.io.vn/api
```

**2. Backend (Spring Boot):**

Cập nhật `docker-compose.yml`:
```yaml
backend:
  environment:
    - FRONTEND_ORIGINS=https://smartfarm.codex.io.vn,https://smartfarm.codex.io.vn:443
```

**3. Chatbot:**

Cập nhật `docker-compose.yml`:
```yaml
chatbot:
  environment:
    - NEXT_PUBLIC_API_URL=https://smartfarm.codex.io.vn/api
```

---

## 🔍 Kiểm Tra

### 1. Kiểm Tra HTTP Redirect

```bash
curl -I http://smartfarm.codex.io.vn
```

**Kết quả mong đợi:**
```
HTTP/1.1 301 Moved Permanently
Location: https://smartfarm.codex.io.vn/
```

### 2. Kiểm Tra HTTPS

```bash
curl -I https://smartfarm.codex.io.vn
```

**Kết quả mong đợi:**
```
HTTP/2 200
```

### 3. Kiểm Tra SSL Certificate

Mở trình duyệt:
- `https://smartfarm.codex.io.vn`
- Click vào icon khóa → Xem certificate
- Phải thấy "Let's Encrypt" và "Valid"

---

## 🔄 Auto-Renewal SSL Certificate

Let's Encrypt certificate hết hạn sau 90 ngày. Cần setup auto-renewal:

**Thêm vào crontab:**
```bash
crontab -e

# Thêm dòng này (chạy mỗi ngày lúc 2:00 AM)
0 2 * * * cd /opt/SmartFarm && docker run --rm -v /opt/SmartFarm/certbot/conf:/etc/letsencrypt certbot/certbot renew --quiet && docker compose restart nginx
```

**Hoặc tạo script:**
```bash
# Tạo file renew-ssl.sh
cat > /opt/SmartFarm/renew-ssl.sh << 'EOF'
#!/bin/bash
cd /opt/SmartFarm
docker run --rm \
    -v /opt/SmartFarm/certbot/conf:/etc/letsencrypt \
    certbot/certbot renew --quiet
docker compose restart nginx
EOF

chmod +x /opt/SmartFarm/renew-ssl.sh

# Thêm vào crontab
(crontab -l 2>/dev/null; echo "0 2 * * * /opt/SmartFarm/renew-ssl.sh") | crontab -
```

---

## 🐛 Troubleshooting

### Lỗi: "Failed to obtain certificate"

**Nguyên nhân:**
- DNS chưa trỏ đúng
- Port 80 bị chặn
- Nginx chưa chạy

**Giải pháp:**
```bash
# Kiểm tra DNS
dig smartfarm.codex.io.vn

# Kiểm tra port 80
netstat -tuln | grep :80

# Kiểm tra Nginx
docker compose ps nginx
docker compose logs nginx
```

### Lỗi: "Certificate not found"

**Giải pháp:**
```bash
# Kiểm tra certificate
ls -la certbot/conf/live/smartfarm.codex.io.vn/

# Nếu không có, chạy lại certbot
./setup-ssl-docker.sh
```

### Lỗi: "502 Bad Gateway"

**Giải pháp:**
```bash
# Kiểm tra các service đang chạy
docker compose ps

# Kiểm tra logs
docker compose logs nginx
docker compose logs backend
docker compose logs frontend
```

---

## 📝 Checklist

- [ ] DNS đã trỏ đến IP VPS
- [ ] SSL certificate đã được tạo
- [ ] Nginx config đã cập nhật
- [ ] Docker Compose đã cập nhật
- [ ] Services đã restart
- [ ] HTTPS hoạt động (kiểm tra trình duyệt)
- [ ] HTTP redirect đến HTTPS
- [ ] Auto-renewal đã setup

---

## 🎉 Sau Khi Hoàn Thành

**URL mới:**
- Frontend: `https://smartfarm.codex.io.vn`
- API: `https://smartfarm.codex.io.vn/api`
- Chatbot: `https://smartfarm.codex.io.vn/chatbot`

**Cần cập nhật:**
- ESP32 code: Thay IP bằng domain
- Các file config khác: Thay IP bằng domain

---

**Chúc bạn setup thành công!** 🚀✨
