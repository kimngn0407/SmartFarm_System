# 🔧 Sửa Lỗi Port 80 Đã Được Sử Dụng

## 🔍 Vấn Đề

**Lỗi:**
```
failed to bind host port 0.0.0.0:80/tcp: address already in use
```

**Nguyên nhân:**
- Nginx chưa dừng hoàn toàn
- Hoặc có service khác đang dùng port 80
- Hoặc container Nginx vẫn đang chạy

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra Process Đang Dùng Port 80

```bash
# Kiểm tra process đang dùng port 80
lsof -i :80
# Hoặc
netstat -tulpn | grep :80
# Hoặc
ss -tulpn | grep :80
```

**Kết quả sẽ cho biết process nào đang dùng port 80.**

---

### Bước 2: Dừng Nginx Hoàn Toàn

```bash
cd /opt/SmartFarm

# Dừng Nginx
docker compose stop nginx

# Đợi 3 giây
sleep 3

# Kiểm tra Nginx đã dừng chưa
docker compose ps nginx

# Phải thấy: "Exited" hoặc không có container nào

# Nếu vẫn còn, force stop
docker compose kill nginx
```

---

### Bước 3: Kiểm Tra Lại Port 80

```bash
# Kiểm tra lại
lsof -i :80
# Hoặc
netstat -tulpn | grep :80

# Nếu vẫn có process, kill nó
# Lấy PID từ lệnh trên, ví dụ: 1234
kill -9 <PID>
```

---

### Bước 4: Chạy Lại Script

```bash
cd /opt/SmartFarm
./setup-ssl-standalone.sh
```

---

## 🎯 Giải Pháp Thay Thế: Dùng Webroot Mode (Không Cần Dừng Nginx)

**Nếu vẫn không được, dùng webroot mode nhưng sửa Nginx config:**

### Bước 1: Sửa Nginx Config

```bash
cd /opt/SmartFarm
nano nginx/nginx.conf
```

**Tìm server block HTTP (port 80), đảm bảo có:**

```nginx
server {
    listen 80;
    server_name smartfarm.kimngn.cfd smartfarm.codex.io.vn;
    
    # Let's Encrypt ACME challenge - PHẢI ĐẶT TRƯỚC location /
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
        try_files $uri =404;
    }
    
    # Redirect all HTTP to HTTPS - CHỈ redirect nếu không phải ACME challenge
    location / {
        return 301 https://$host$request_uri;
    }
}
```

**Lưu và thoát:** `Ctrl+X`, `Y`, `Enter`

---

### Bước 2: Restart Nginx

```bash
docker compose restart nginx
sleep 5
```

---

### Bước 3: Test ACME Challenge Path

```bash
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

## 🔧 Script Tự Động Fix Port 80

**Tạo script để tự động fix:**

```bash
cat > fix-port-80-and-ssl.sh << 'EOF'
#!/bin/bash
set -e

cd /opt/SmartFarm

echo "🔍 Checking port 80..."

# Kiểm tra process đang dùng port 80
PORT80_PID=$(lsof -ti :80 || echo "")

if [ -n "$PORT80_PID" ]; then
    echo "⚠️  Port 80 is in use by PID: $PORT80_PID"
    echo "🛑 Stopping processes..."
    
    # Dừng Nginx
    docker compose stop nginx 2>/dev/null || true
    sleep 3
    
    # Kill process nếu vẫn còn
    if lsof -ti :80 > /dev/null 2>&1; then
        echo "🔪 Killing process on port 80..."
        kill -9 $(lsof -ti :80) 2>/dev/null || true
        sleep 2
    fi
fi

# Kiểm tra lại
if lsof -ti :80 > /dev/null 2>&1; then
    echo "❌ ERROR: Port 80 is still in use!"
    echo "   Please manually stop the process:"
    lsof -i :80
    exit 1
else
    echo "✅ Port 80 is free"
fi

# Chạy SSL setup
echo "🔒 Running SSL setup..."
./setup-ssl-standalone.sh
EOF

chmod +x fix-port-80-and-ssl.sh
./fix-port-80-and-ssl.sh
```

---

## 📋 Checklist

- [ ] Đã kiểm tra process đang dùng port 80
- [ ] Đã dừng Nginx hoàn toàn
- [ ] Đã kill process nếu cần
- [ ] Đã kiểm tra port 80 free
- [ ] Đã chạy lại SSL setup script

---

**Hãy kiểm tra và dừng process đang dùng port 80!** 🔧✨
