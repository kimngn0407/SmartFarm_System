# 🔧 Sửa Lỗi DNS - Domain Trỏ IPv6 Thay Vì IPv4

## 🔍 Vấn Đề

**Kết quả nslookup:**
```
Name:    smartfarm.codex.io.vn
Addresses:  2606:4700:3031::6815:305c  (IPv6)
          2606:4700:3035::ac43:b73e    (IPv6)
```

**Vấn đề:**
- Domain chỉ có IPv6 record, không có IPv4 (A record)
- Địa chỉ IPv6 là của Cloudflare (2606:4700 là prefix Cloudflare)
- Cần thêm A record trỏ đến `109.205.180.72`

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra DNS Record Hiện Tại

**Sử dụng dig (trên Linux/Mac) hoặc online tool:**
```bash
# Kiểm tra A record (IPv4)
dig smartfarm.codex.io.vn A

# Kiểm tra AAAA record (IPv6)
dig smartfarm.codex.io.vn AAAA

# Hoặc dùng online tool:
# https://dnschecker.org/#A/smartfarm.codex.io.vn
```

**Kết quả mong đợi:**
- **A record:** `109.205.180.72` ✅
- **AAAA record:** Có thể có hoặc không (tùy chọn)

---

### Bước 2: Thêm A Record Trong DNS Provider

**Nếu dùng Cloudflare:**
1. Đăng nhập Cloudflare Dashboard
2. Chọn domain `codex.io.vn`
3. Vào **DNS** → **Records**
4. Tìm record `smartfarm` (type AAAA hoặc CNAME)
5. **Thêm mới hoặc sửa:**
   - **Type:** `A`
   - **Name:** `smartfarm`
   - **IPv4 address:** `109.205.180.72`
   - **Proxy status:** **DNS only** (tắt proxy - quan trọng!)
   - **TTL:** Auto hoặc 3600
6. **Lưu**

**Lưu ý quan trọng:**
- ⚠️ **Phải tắt Cloudflare Proxy** (chuyển từ "Proxied" sang "DNS only")
- Let's Encrypt cần truy cập trực tiếp đến VPS, không qua Cloudflare proxy
- Nếu bật proxy, Let's Encrypt sẽ không verify được domain

**Nếu dùng DNS provider khác:**
1. Đăng nhập DNS provider
2. Tìm zone `codex.io.vn`
3. Thêm A record:
   - **Host:** `smartfarm`
   - **Type:** `A`
   - **Value:** `109.205.180.72`
   - **TTL:** 3600

---

### Bước 3: Xóa AAAA Record (Tùy Chọn)

**Nếu không cần IPv6:**
- Xóa AAAA record `smartfarm` (IPv6)
- Chỉ giữ A record (IPv4)

**Nếu cần IPv6:**
- Giữ cả A và AAAA record
- Đảm bảo A record trỏ đến `109.205.180.72`

---

### Bước 4: Đợi DNS Propagate

**Thời gian:**
- Thường: 5-15 phút
- Tối đa: 24-48 giờ (hiếm)

**Kiểm tra:**
```bash
# Kiểm tra A record
dig smartfarm.codex.io.vn A +short
# Kết quả mong đợi: 109.205.180.72

# Hoặc
nslookup smartfarm.codex.io.vn
# Phải thấy: Address: 109.205.180.72
```

**Online check:**
- https://dnschecker.org/#A/smartfarm.codex.io.vn
- https://www.whatsmydns.net/#A/smartfarm.codex.io.vn

---

### Bước 5: Kiểm Tra Kết Nối

```bash
# Ping domain
ping smartfarm.codex.io.vn

# Kiểm tra HTTP
curl -I http://smartfarm.codex.io.vn

# Kiểm tra từ VPS
curl -I http://109.205.180.72
```

---

## 🐛 Troubleshooting

### Vẫn Thấy IPv6 Sau Khi Thêm A Record

**Nguyên nhân:**
- DNS chưa propagate
- Cache DNS local
- Cloudflare proxy vẫn bật

**Giải pháp:**
```bash
# Xóa DNS cache Windows
ipconfig /flushdns

# Kiểm tra lại
nslookup smartfarm.codex.io.vn

# Hoặc dùng Google DNS
nslookup smartfarm.codex.io.vn 8.8.8.8
```

### Let's Encrypt Vẫn Không Verify Được

**Nguyên nhân:**
- Cloudflare proxy vẫn bật
- Firewall chặn port 80
- Nginx chưa chạy

**Giải pháp:**
1. **Tắt Cloudflare Proxy:**
   - Cloudflare Dashboard → DNS
   - Record `smartfarm` → Chuyển từ "Proxied" sang "DNS only" (gray cloud)

2. **Kiểm tra port 80:**
   ```bash
   # Trên VPS
   netstat -tuln | grep :80
   # Phải thấy: LISTEN
   ```

3. **Kiểm tra Nginx:**
   ```bash
   docker compose ps nginx
   docker compose logs nginx
   ```

---

## 📋 Checklist

- [ ] Đã thêm A record: `smartfarm` → `109.205.180.72`
- [ ] Đã tắt Cloudflare Proxy (nếu dùng Cloudflare)
- [ ] DNS đã propagate (kiểm tra bằng dig/nslookup)
- [ ] Ping domain thành công
- [ ] HTTP request đến domain thành công
- [ ] Let's Encrypt có thể verify domain

---

## 🎯 Sau Khi Sửa DNS

**Chạy lại setup SSL:**
```bash
cd /opt/SmartFarm
./setup-ssl-docker.sh
```

**Kiểm tra:**
```bash
curl -I http://smartfarm.codex.io.vn
# Phải redirect đến HTTPS
```

---

**Hãy thêm A record và tắt Cloudflare Proxy (nếu có)!** 🔧✨
