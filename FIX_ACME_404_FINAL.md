# 🔧 Sửa Lỗi ACME 404 - Giải Pháp Cuối Cùng

## 🔍 Vấn Đề

1. **Git có local changes:** `setup-ssl-docker.sh` đã bị sửa
2. **docker-compose không tìm thấy:** Có thể cần dùng `docker compose`
3. **Nginx trả về 404:** Không serve được file từ `/var/www/certbot`

---

## ✅ Giải Pháp

### Bước 1: Xử Lý Git Local Changes

```bash
cd /opt/SmartFarm

# Option 1: Stash local changes (khuyên dùng)
git stash
git pull origin main

# Option 2: Hoặc commit local changes
# git add setup-ssl-docker.sh
# git commit -m "Local changes"
# git pull origin main

# Option 3: Hoặc discard local changes (nếu không cần)
# git checkout -- setup-ssl-docker.sh
# git pull origin main
```

---

### Bước 2: Kiểm Tra Docker Compose Command

```bash
# Thử cả 2 lệnh
docker compose version
# Hoặc
docker-compose version

# Dùng lệnh nào hoạt động
```

**Nếu cả 2 đều không hoạt động:**
```bash
# Cài đặt docker-compose
apt update
apt install -y docker-compose
```

---

### Bước 3: Kiểm Tra Nginx Config và Volume

```bash
cd /opt/SmartFarm

# Kiểm tra Nginx config có location cho ACME challenge
grep -A 3 "acme-challenge" nginx/nginx.conf

# Kiểm tra docker-compose.yml có mount volume
grep -A 2 "certbot/www" docker-compose.yml
```

---

### Bước 4: Restart Nginx Đúng Cách

```bash
# Thử cả 2 lệnh, dùng lệnh nào hoạt động
docker compose restart nginx
# Hoặc
docker-compose restart nginx

# Hoặc restart toàn bộ
docker compose down
docker compose up -d
```

---

### Bước 5: Test ACME Challenge Path

```bash
# Tạo file test
mkdir -p certbot/www/.well-known/acme-challenge/
echo "test123" > certbot/www/.well-known/acme-challenge/test.txt

# Kiểm tra file có trong container không
docker compose exec nginx ls -la /var/www/certbot/.well-known/acme-challenge/

# Test từ container
docker compose exec nginx cat /var/www/certbot/.well-known/acme-challenge/test.txt

# Test từ bên ngoài
curl http://smartfarm.kimngn.cfd/.well-known/acme-challenge/test.txt
```

**Nếu vẫn 404, có thể volume mount không đúng.**

---

### Bước 6: Sửa Volume Mount (Nếu Cần)

**Kiểm tra docker-compose.yml:**
```bash
cat docker-compose.yml | grep -A 5 "nginx:" | grep -A 5 "volumes"
```

**Phải thấy:**
```yaml
volumes:
  - ./certbot/www:/var/www/certbot:ro
```

**Nếu không thấy hoặc sai, sửa lại và restart:**
```bash
docker compose down
docker compose up -d
```

---

### Bước 7: Dùng Standalone Mode (Nếu Webroot Vẫn Không Hoạt Động)

**Standalone mode tạm thời dừng Nginx và dùng port 80 trực tiếp:**

```bash
cd /opt/SmartFarm

# Dừng Nginx
docker compose stop nginx

# Chạy certbot với standalone mode
docker run -it --rm \
    -p 80:80 \
    -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
    certbot/certbot certonly \
    --standalone \
    --email your-email@example.com \
    --agree-tos \
    --no-eff-email \
    -d smartfarm.kimngn.cfd

# Khởi động lại Nginx
docker compose start nginx
```

**Lưu ý:** Thay `your-email@example.com` bằng email thật của bạn!

---

## 🎯 Script Tự Động (All-in-One)

**Tạo script để làm tất cả:**

```bash
cd /opt/SmartFarm

cat > fix-and-setup-ssl.sh << 'EOF'
#!/bin/bash
set -e

cd /opt/SmartFarm

# 1. Xử lý git
echo "📥 Pulling latest code..."
git stash
git pull origin main

# 2. Kiểm tra docker compose command
if command -v docker &> /dev/null && docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
elif command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "❌ docker compose not found!"
    exit 1
fi

# 3. Restart Nginx
echo "🔄 Restarting Nginx..."
$DOCKER_COMPOSE restart nginx
sleep 5

# 4. Test ACME challenge
echo "🧪 Testing ACME challenge path..."
mkdir -p certbot/www/.well-known/acme-challenge/
echo "test" > certbot/www/.well-known/acme-challenge/test.txt
sleep 2

TEST_RESULT=$(curl -s -o /dev/null -w "%{http_code}" http://smartfarm.kimngn.cfd/.well-known/acme-challenge/test.txt || echo "000")

if [ "$TEST_RESULT" = "200" ]; then
    echo "✅ ACME challenge path is accessible"
    echo "🔒 Running certbot with webroot mode..."
    ./setup-ssl-docker.sh
else
    echo "⚠️  ACME challenge path not accessible (HTTP $TEST_RESULT)"
    echo "🔒 Running certbot with standalone mode..."
    
    # Dừng Nginx
    $DOCKER_COMPOSE stop nginx
    
    # Chạy certbot standalone
    docker run -it --rm \
        -p 80:80 \
        -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
        certbot/certbot certonly \
        --standalone \
        --email your-email@example.com \
        --agree-tos \
        --no-eff-email \
        -d smartfarm.kimngn.cfd
    
    # Khởi động lại Nginx
    $DOCKER_COMPOSE start nginx
fi

echo "✅ Done!"
EOF

chmod +x fix-and-setup-ssl.sh

# Chỉnh sửa email trong script
nano fix-and-setup-ssl.sh
# Thay: your-email@example.com → Email thật của bạn

# Chạy script
./fix-and-setup-ssl.sh
```

---

## 📋 Checklist

- [ ] Đã xử lý git local changes (stash/commit)
- [ ] Đã pull code mới
- [ ] Đã kiểm tra docker compose command
- [ ] Đã restart Nginx
- [ ] Đã test ACME challenge path
- [ ] Đã chạy certbot (webroot hoặc standalone)
- [ ] Đã kiểm tra certificate được tạo
- [ ] Đã restart services

---

**Hãy thử dùng standalone mode nếu webroot không hoạt động!** 🔒✨
