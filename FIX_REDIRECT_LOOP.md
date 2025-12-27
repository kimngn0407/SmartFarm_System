# 🔧 Fix ERR_TOO_MANY_REDIRECTS - Redirect Loop

## 🔍 Vấn Đề

**Lỗi khi truy cập:**
```
ERR_TOO_MANY_REDIRECTS
Trang này hiện không hoạt động
smartfarm.kimngn.cfd đã chuyển hướng bạn quá nhiều lần.
```

**Nguyên nhân:**
- Frontend có thể đang redirect HTTP → HTTPS
- Nginx đang redirect HTTP → HTTPS
- Tạo ra redirect loop: HTTP → HTTPS → HTTP → HTTPS → ...

---

## ✅ Giải Pháp: Fix Nginx Config

**Đã sửa `nginx/nginx.conf`:**

1. **Force `X-Forwarded-Proto` header thành `https`:**
   ```nginx
   proxy_set_header X-Forwarded-Proto https;  # Force HTTPS
   ```

2. **Thêm `proxy_redirect` để chuyển HTTP redirects sang HTTPS:**
   ```nginx
   proxy_redirect http:// https://;
   ```

3. **Thêm các headers bổ sung:**
   ```nginx
   proxy_set_header X-Forwarded-Host $host;
   proxy_set_header X-Forwarded-Port 443;
   ```

---

## 🔧 Áp Dụng Fix Trên VPS

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull code mới
git pull origin main

# Kiểm tra Nginx config có hợp lệ không
docker compose exec nginx nginx -t

# Nếu OK, reload Nginx
docker compose restart nginx

# Kiểm tra logs
docker compose logs nginx --tail=50
```

---

## 🎯 Kiểm Tra Sau Khi Fix

**Test website:**
```bash
# Test từ VPS
curl -I https://smartfarm.kimngn.cfd

# Phải thấy: HTTP/2 200 (không phải 301/302 redirect)
```

**Test từ browser:**
- Truy cập: https://smartfarm.kimngn.cfd
- Phải load được trang (không còn redirect loop)

---

## 📋 Checklist

- [ ] Đã pull code mới từ git
- [ ] Đã kiểm tra Nginx config (`nginx -t`)
- [ ] Đã reload Nginx (`docker compose restart nginx`)
- [ ] Đã test website không còn redirect loop
- [ ] Đã kiểm tra logs không có lỗi

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ Website load được bình thường
- ✅ Không còn ERR_TOO_MANY_REDIRECTS
- ✅ HTTPS hoạt động đúng

---

**Hãy pull code mới và reload Nginx!** 🔧✨
