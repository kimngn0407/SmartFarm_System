# 🔧 Sửa Lỗi ACME Challenge - 404 Error

## 🔍 Vấn Đề

**Lỗi:**
```
Invalid response from http://smartfarm.kimngn.cfd/.well-known/acme-challenge/...: 404
```

**Nguyên nhân:**
- Nginx chưa reload config mới
- Hoặc Nginx container chưa được restart sau khi cập nhật config
- Volume mount có thể chưa đúng

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra Nginx Đang Chạy

```bash
docker ps | grep nginx
```

**Phải thấy container `smartfarm-nginx` đang chạy.**

---

### Bước 2: Kiểm Tra Nginx Config

```bash
cd /opt/SmartFarm

# Kiểm tra config có location cho ACME challenge
grep -A 3 "acme-challenge" nginx/nginx.conf
```

**Phải thấy:**
```nginx
location /.well-known/acme-challenge/ {
    root /var/www/certbot;
}
```

---

### Bước 3: Restart Nginx Container

```bash
# Restart Nginx để áp dụng config mới
docker-compose restart nginx

# Hoặc nếu dùng docker compose (không có dấu gạch ngang)
docker compose restart nginx

# Kiểm tra logs
docker-compose logs nginx | tail -20
```

---

### Bước 4: Test ACME Challenge Path

**Tạo file test để kiểm tra:**

```bash
# Tạo file test
mkdir -p /opt/SmartFarm/certbot/www/.well-known/acme-challenge/
echo "test" > /opt/SmartFarm/certbot/www/.well-known/acme-challenge/test.txt

# Test từ bên ngoài (từ máy local)
curl http://smartfarm.kimngn.cfd/.well-known/acme-challenge/test.txt

# Phải trả về: "test"
```

**Nếu vẫn 404:**
- Kiểm tra volume mount trong docker-compose.yml
- Kiểm tra quyền truy cập file

---

### Bước 5: Kiểm Tra Volume Mount

```bash
# Kiểm tra volume mount
docker inspect smartfarm-nginx | grep -A 10 Mounts

# Hoặc
docker-compose config | grep -A 5 certbot
```

**Phải thấy:**
```yaml
- ./certbot/www:/var/www/certbot:ro
```

---

### Bước 6: Tạm Thời Tắt HTTPS Redirect (Nếu Cần)

**Nếu vẫn không được, tạm thời comment redirect:**

```bash
cd /opt/SmartFarm
nano nginx/nginx.conf
```

**Tìm và comment dòng redirect:**
```nginx
# Tạm thời comment để certbot có thể verify
# location / {
#     return 301 https://$host$request_uri;
# }
```

**Thay bằng:**
```nginx
location / {
    proxy_pass http://frontend;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

**Lưu và restart:**
```bash
docker-compose restart nginx
```

**Sau khi lấy được certificate, uncomment lại redirect.**

---

### Bước 7: Chạy Lại Certbot

```bash
cd /opt/SmartFarm

# Đảm bảo thư mục tồn tại
mkdir -p certbot/www/.well-known/acme-challenge/

# Chạy lại certbot
./setup-ssl-docker.sh
```

---

## 🎯 Giải Pháp Nhanh (Recommended)

**Chạy các lệnh sau theo thứ tự:**

```bash
cd /opt/SmartFarm

# 1. Pull code mới (đảm bảo nginx.conf đúng)
git pull origin main

# 2. Restart Nginx
docker-compose restart nginx

# 3. Đợi 5 giây
sleep 5

# 4. Test ACME challenge path
mkdir -p certbot/www/.well-known/acme-challenge/
echo "test" > certbot/www/.well-known/acme-challenge/test.txt
curl http://smartfarm.kimngn.cfd/.well-known/acme-challenge/test.txt

# 5. Nếu test thành công, chạy lại certbot
./setup-ssl-docker.sh
```

---

## 🔍 Debug Chi Tiết

### Kiểm Tra Nginx Logs

```bash
docker-compose logs nginx | grep acme
```

### Kiểm Tra File Trong Container

```bash
docker exec smartfarm-nginx ls -la /var/www/certbot/.well-known/acme-challenge/
```

### Test Từ Container

```bash
docker exec smartfarm-nginx curl http://localhost/.well-known/acme-challenge/test.txt
```

---

## 📋 Checklist

- [ ] Nginx container đang chạy
- [ ] Nginx config có location cho ACME challenge
- [ ] Volume mount đúng trong docker-compose.yml
- [ ] Đã restart Nginx sau khi cập nhật config
- [ ] Có thể truy cập file test từ bên ngoài
- [ ] Đã chạy lại certbot

---

**Hãy thử restart Nginx và chạy lại certbot!** 🔧✨
