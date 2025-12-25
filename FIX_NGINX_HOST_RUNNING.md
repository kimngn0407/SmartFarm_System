# 🔧 Sửa Lỗi Nginx Đang Chạy Trên Host

## 🔍 Vấn Đề

**Kết quả `lsof -i :80`:**
```
nginx   1952879     root    5u  IPv4  7915082      0t0  TCP *:http (LISTEN)
```

**Vấn đề:**
- Nginx đang chạy trực tiếp trên host (không phải trong Docker container)
- Script chỉ dừng Nginx container, không dừng được Nginx trên host
- Port 80 đang được Nginx trên host sử dụng

---

## ✅ Giải Pháp 1: Dừng Nginx Trên Host (Để Dùng Standalone Mode)

### Bước 1: Dừng Nginx Trên Host

```bash
# Kiểm tra Nginx service
systemctl status nginx

# Dừng Nginx
systemctl stop nginx

# Hoặc nếu không có systemctl
service nginx stop

# Hoặc kill tất cả process nginx
killall nginx

# Kiểm tra lại
lsof -i :80
# Phải không còn process nào
```

---

### Bước 2: Chạy SSL Setup

```bash
cd /opt/SmartFarm
git pull origin main

# Chỉnh sửa email
nano setup-ssl-standalone.sh
# Thay: EMAIL="your-email@example.com" → Email thật

# Chạy script
./setup-ssl-standalone.sh
```

---

### Bước 3: Khởi Động Lại Nginx (Sau Khi Có Certificate)

```bash
# Sau khi có certificate, khởi động lại Nginx trên host (nếu cần)
# Nhưng thường thì chỉ cần dùng Nginx trong Docker
systemctl start nginx
# Hoặc
service nginx start
```

---

## ✅ Giải Pháp 2: Dùng Webroot Mode (Không Cần Dừng Nginx)

**Giải pháp này tốt hơn vì không cần dừng Nginx trên host.**

### Bước 1: Kiểm Tra Nginx Config Trên Host

```bash
# Tìm file config Nginx trên host
nginx -t
# Hoặc
cat /etc/nginx/sites-enabled/default
# Hoặc
ls -la /etc/nginx/conf.d/
```

---

### Bước 2: Sửa Nginx Config Trên Host

```bash
# Tìm file config chính
nginx -T | grep "server_name smartfarm"

# Hoặc sửa file config
nano /etc/nginx/sites-available/default
# Hoặc
nano /etc/nginx/conf.d/smartfarm.conf
```

**Thêm hoặc sửa server block:**

```nginx
server {
    listen 80;
    server_name smartfarm.kimngn.cfd smartfarm.codex.io.vn;
    
    # Let's Encrypt ACME challenge
    location /.well-known/acme-challenge/ {
        root /opt/SmartFarm/certbot/www;
        try_files $uri =404;
    }
    
    # Redirect all HTTP to HTTPS
    location / {
        return 301 https://$host$request_uri;
    }
}
```

**Lưu và test config:**
```bash
nginx -t
```

**Reload Nginx:**
```bash
systemctl reload nginx
# Hoặc
service nginx reload
```

---

### Bước 3: Test ACME Challenge Path

```bash
cd /opt/SmartFarm

# Tạo file test
mkdir -p certbot/www/.well-known/acme-challenge/
echo "test" > certbot/www/.well-known/acme-challenge/test.txt

# Test từ bên ngoài
curl http://smartfarm.kimngn.cfd/.well-known/acme-challenge/test.txt

# Phải trả về: "test"
```

---

### Bước 4: Chạy Certbot Với Webroot Mode

```bash
cd /opt/SmartFarm

# Chỉnh sửa email trong setup-ssl-docker.sh
nano setup-ssl-docker.sh
# Thay: EMAIL="your-email@example.com" → Email thật

# Chạy script
chmod +x setup-ssl-docker.sh
./setup-ssl-docker.sh
```

---

## 🎯 Giải Pháp 3: Tắt Nginx Trên Host, Chỉ Dùng Docker (Khuyên Dùng)

**Nếu bạn chỉ dùng Nginx trong Docker, tắt Nginx trên host:**

### Bước 1: Tắt Nginx Trên Host

```bash
# Dừng Nginx
systemctl stop nginx

# Tắt tự động khởi động
systemctl disable nginx

# Kiểm tra
systemctl status nginx
# Phải thấy: inactive (dead)
```

---

### Bước 2: Chạy SSL Setup

```bash
cd /opt/SmartFarm
git pull origin main

# Chỉnh sửa email
nano setup-ssl-standalone.sh
# Thay: EMAIL="your-email@example.com" → Email thật

# Chạy script
./setup-ssl-standalone.sh
```

---

## 📋 Checklist

- [ ] Đã kiểm tra Nginx đang chạy ở đâu (host hay Docker)
- [ ] Đã dừng Nginx trên host (nếu dùng standalone mode)
- [ ] Hoặc đã sửa Nginx config trên host (nếu dùng webroot mode)
- [ ] Đã test ACME challenge path
- [ ] Đã chạy SSL setup script
- [ ] Đã kiểm tra certificate được tạo

---

## 💡 Khuyên Dùng

**Giải pháp 3 (tắt Nginx trên host) là tốt nhất vì:**
- Tránh xung đột port
- Chỉ dùng Nginx trong Docker (dễ quản lý)
- Không cần sửa nhiều config

**Sau đó dùng standalone mode để lấy certificate.**

---

**Hãy chọn một trong 3 giải pháp trên!** 🔧✨
