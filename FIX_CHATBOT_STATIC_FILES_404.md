# 🔧 Fix Chatbot Static Files 404

## 🔍 Vấn Đề

**Lỗi trong browser console:**
```
Failed to load resource: the server responded with a status of 404
/chatbot/_next/static/chunks/webpack-816131fd3a11c9ed.js:1
/chatbot/_next/static/chunks/4bd1b696-38887bf642fe7ebe.js:1
...
```

**Nguyên nhân:**
- Next.js với `basePath: '/chatbot'` tạo static files tại `/chatbot/_next/...`
- Nginx đang proxy `/_next/` thay vì `/chatbot/_next/`
- Static files không được tìm thấy

---

## ✅ Giải Pháp: Fix Nginx Location

**Đã sửa `nginx/nginx.conf`:**

1. **Sửa location cho `/_next/` thành `/chatbot/_next/`:**
   ```nginx
   location /chatbot/_next/ {
       proxy_pass http://chatbot/chatbot/_next/;
       ...
   }
   ```

2. **Thêm location cho chatbot static files (CSS, JS, images):**
   ```nginx
   location ~* ^/chatbot/.*\.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
       proxy_pass http://chatbot;
       ...
   }
   ```

---

## 🔧 Áp Dụng Fix Trên VPS

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull code mới
git pull origin main --no-rebase --no-edit

# Kiểm tra Nginx config
docker compose exec nginx nginx -t

# Reload Nginx
docker compose restart nginx

# Test static files
curl -I https://smartfarm.kimngn.cfd/chatbot/_next/static/chunks/webpack-816131fd3a11c9ed.js

# Phải thấy: HTTP/2 200 (không phải 404)
```

---

## 🎯 Kiểm Tra Sau Khi Fix

**Test từ browser:**
- Truy cập: https://smartfarm.kimngn.cfd/chatbot
- Mở Developer Tools (F12) → Console
- Phải không còn lỗi 404 cho static files
- Chatbot phải load đầy đủ CSS và JavaScript

---

## 📋 Checklist

- [ ] Đã pull code mới
- [ ] Đã reload Nginx
- [ ] Đã test static files không còn 404
- [ ] Đã kiểm tra browser console không còn lỗi
- [ ] Chatbot load đầy đủ CSS và JavaScript

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ Static files load được (HTTP/2 200)
- ✅ Không còn 404 trong browser console
- ✅ Chatbot hiển thị đầy đủ CSS và JavaScript
- ✅ Chatbot hoạt động bình thường

---

**Hãy pull code mới và reload Nginx!** 🔧✨
