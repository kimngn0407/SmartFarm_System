# 🌐 Setup Domain Mới - kimngn.cfd

## 📋 Thông Tin Domain

- **Domain mới:** `kimngn.cfd`
- **VPS IP:** `109.205.180.72`
- **SSL:** Let's Encrypt (miễn phí)

---

## 🚀 Các Bước Setup

### Bước 1: Trỏ DNS Domain Về VPS

**Trong Domain Management Interface (như hình bạn đã gửi):**

1. Tìm phần **DNS Management** hoặc **DNS Settings**
2. Thêm **A Record:**
   - **Type:** `A`
   - **Host/Name:** `@` (root domain) hoặc để trống
   - **Value/IP:** `109.205.180.72`
   - **TTL:** 3600 hoặc Auto
3. **Lưu**

**Nếu muốn dùng subdomain (ví dụ: `smartfarm.kimngn.cfd`):**
- **Host/Name:** `smartfarm`
- **Value/IP:** `109.205.180.72`

---

### Bước 2: Chọn Domain Để Dùng

**Bạn muốn dùng:**
- **Option 1:** `kimngn.cfd` (root domain)
- **Option 2:** `smartfarm.kimngn.cfd` (subdomain)
- **Option 3:** Giữ `smartfarm.codex.io.vn` và thêm domain mới

**Khuyên dùng:** `smartfarm.kimngn.cfd` (subdomain) để dễ quản lý

---

### Bước 3: Cập Nhật Cấu Hình

**Nếu chọn `smartfarm.kimngn.cfd`:**

**1. Cập nhật Nginx config:**
```bash
# File: nginx/nginx.conf
# Thay đổi server_name
server_name smartfarm.kimngn.cfd;
```

**2. Cập nhật docker-compose.yml:**
```yaml
frontend:
  environment:
    - REACT_APP_API_URL=https://smartfarm.kimngn.cfd/api

backend:
  environment:
    - FRONTEND_ORIGINS=https://smartfarm.kimngn.cfd

chatbot:
  environment:
    - NEXT_PUBLIC_API_URL=https://smartfarm.kimngn.cfd/api
```

**3. Cập nhật ESP32 code:**
```cpp
const char* serverUrl = "http://smartfarm.kimngn.cfd/api/sensor-data/iot";
```

---

### Bước 4: Setup SSL Certificate

**Sau khi DNS đã trỏ đúng:**

```bash
cd /opt/SmartFarm

# Chỉnh sửa script
nano setup-ssl-docker.sh
# Thay: DOMAIN="smartfarm.codex.io.vn" → DOMAIN="smartfarm.kimngn.cfd"
# Thay: EMAIL="your-email@example.com" → Email thật của bạn

# Chạy setup SSL
chmod +x setup-ssl-docker.sh
./setup-ssl-docker.sh
```

---

### Bước 5: Kiểm Tra DNS

**Đợi 5-15 phút sau khi thêm A record, rồi kiểm tra:**

```powershell
# Kiểm tra DNS
nslookup smartfarm.kimngn.cfd
# Hoặc
nslookup kimngn.cfd

# Kết quả mong đợi:
# Address: 109.205.180.72
```

**Online check:**
- https://dnschecker.org/#A/smartfarm.kimngn.cfd
- https://www.whatsmydns.net/#A/smartfarm.kimngn.cfd

---

## 🔄 Nếu Muốn Dùng Cả 2 Domain

**Có thể cấu hình Nginx để chấp nhận cả 2 domain:**

```nginx
server {
    listen 443 ssl http2;
    server_name smartfarm.codex.io.vn smartfarm.kimngn.cfd;
    
    # SSL config...
}
```

---

## 📝 Checklist

- [ ] Đã thêm A record trong DNS provider
- [ ] DNS đã propagate (kiểm tra bằng nslookup)
- [ ] Đã cập nhật Nginx config với domain mới
- [ ] Đã cập nhật docker-compose.yml
- [ ] Đã setup SSL certificate
- [ ] Đã test HTTPS hoạt động

---

## 🎯 Bạn Muốn Dùng Domain Nào?

**Cho tôi biết:**
1. Bạn muốn dùng `kimngn.cfd` hay `smartfarm.kimngn.cfd`?
2. Bạn muốn thay thế `smartfarm.codex.io.vn` hay dùng cả 2?

**Sau đó tôi sẽ cập nhật tất cả config files cho bạn!** 🚀✨
