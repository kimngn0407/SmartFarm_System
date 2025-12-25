# 🔧 Sửa Cloudflare Proxy - Trỏ Domain Về VPS

## 🔍 Vấn Đề

**Kết quả nslookup:**
```
Name:    smartfarm.codex.io.vn
Addresses:  172.67.183.62    (Cloudflare IP)
          104.21.48.92      (Cloudflare IP)
```

**Vấn đề:**
- Domain đang qua Cloudflare Proxy (Proxied)
- Trỏ đến Cloudflare IPs, không phải VPS IP
- Let's Encrypt không thể verify domain qua Cloudflare proxy

---

## ✅ Giải Pháp: Tắt Cloudflare Proxy

### Bước 1: Đăng Nhập Cloudflare

1. Truy cập: https://dash.cloudflare.com
2. Đăng nhập tài khoản
3. Chọn domain `codex.io.vn`

---

### Bước 2: Vào DNS Settings

1. Click **DNS** ở menu bên trái
2. Tìm record `smartfarm` trong danh sách

---

### Bước 3: Tắt Proxy (Quan Trọng!)

**Tìm record `smartfarm`:**
- Nếu có record AAAA (IPv6) → Xóa hoặc sửa
- Nếu có record A (IPv4) → Sửa

**Sửa record A:**
1. Click vào record `smartfarm` (type A)
2. **Quan trọng:** Click vào icon **orange cloud** (Proxied)
3. Icon sẽ chuyển thành **gray cloud** (DNS only)
4. **IPv4 address:** Đổi thành `109.205.180.72` (nếu chưa đúng)
5. Click **Save**

**Hoặc thêm mới nếu chưa có:**
1. Click **Add record**
2. **Type:** `A`
3. **Name:** `smartfarm`
4. **IPv4 address:** `109.205.180.72`
5. **Proxy status:** **DNS only** (gray cloud - KHÔNG phải orange cloud!)
6. **TTL:** Auto
7. Click **Save**

---

### Bước 4: Xóa AAAA Record (Nếu Không Cần IPv6)

1. Tìm record AAAA `smartfarm`
2. Click **Delete**
3. Xác nhận xóa

**Lưu ý:** Có thể giữ AAAA nếu cần IPv6, nhưng phải có A record trỏ đến `109.205.180.72`

---

### Bước 5: Đợi DNS Propagate

**Thời gian:**
- Thường: 1-5 phút
- Tối đa: 24 giờ (hiếm)

**Kiểm tra:**
```powershell
# Xóa DNS cache
ipconfig /flushdns

# Kiểm tra lại
nslookup smartfarm.codex.io.vn
```

**Kết quả mong đợi:**
```
Name:    smartfarm.codex.io.vn
Address:  109.205.180.72
```

**KHÔNG còn thấy:**
- `172.67.183.62` (Cloudflare)
- `104.21.48.92` (Cloudflare)

---

## 🎯 Hình Ảnh Hướng Dẫn

**Trước khi sửa (Proxied - Orange Cloud):**
```
Type | Name      | IPv4 address      | Proxy status
-----|-----------|-------------------|-------------
A    | smartfarm | 109.205.180.72    | 🟠 Proxied
```

**Sau khi sửa (DNS only - Gray Cloud):**
```
Type | Name      | IPv4 address      | Proxy status
-----|-----------|-------------------|-------------
A    | smartfarm | 109.205.180.72    | ⚪ DNS only
```

---

## ⚠️ Lưu Ý Quan Trọng

1. **Phải tắt Proxy (gray cloud):**
   - Let's Encrypt cần truy cập trực tiếp đến VPS
   - Cloudflare proxy sẽ chặn ACME challenge

2. **Kiểm tra A record:**
   - Phải có A record trỏ đến `109.205.180.72`
   - Không phải Cloudflare IPs

3. **Đợi DNS propagate:**
   - Có thể mất vài phút
   - Kiểm tra bằng nslookup hoặc online tool

---

## 🔍 Kiểm Tra Sau Khi Sửa

### 1. Kiểm Tra DNS

```powershell
nslookup smartfarm.codex.io.vn
```

**Kết quả đúng:**
```
Name:    smartfarm.codex.io.vn
Address:  109.205.180.72
```

### 2. Kiểm Tra Online

- https://dnschecker.org/#A/smartfarm.codex.io.vn
- Phải thấy: `109.205.180.72` ở tất cả locations

### 3. Kiểm Tra Kết Nối

```powershell
ping smartfarm.codex.io.vn
# Phải ping được đến 109.205.180.72
```

---

## 🚀 Sau Khi DNS Đúng

**Chạy setup SSL:**
```bash
cd /opt/SmartFarm
git pull origin main
chmod +x setup-ssl-docker.sh
# Chỉnh sửa email trong script
nano setup-ssl-docker.sh
./setup-ssl-docker.sh
```

---

## 📋 Checklist

- [ ] Đã đăng nhập Cloudflare Dashboard
- [ ] Đã tìm record `smartfarm`
- [ ] Đã tắt Proxy (gray cloud, không phải orange cloud)
- [ ] A record trỏ đến `109.205.180.72`
- [ ] Đã xóa AAAA record (nếu không cần IPv6)
- [ ] DNS đã propagate (kiểm tra bằng nslookup)
- [ ] Ping domain thành công

---

**Hãy tắt Cloudflare Proxy (chuyển từ orange cloud sang gray cloud)!** 🔧✨
