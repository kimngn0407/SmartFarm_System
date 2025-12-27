# 🔧 Fix Chatbot Redirect Loop (301/308)

## 🔍 Vấn Đề

**Logs cho thấy redirect loop:**
```
GET /chatbot HTTP/2.0" 301
GET /chatbot/ HTTP/2.0" 308
GET /chatbot HTTP/2.0" 301
GET /chatbot/ HTTP/2.0" 308
...
```

**Nguyên nhân:**
- `/chatbot` redirect → `/chatbot/` (301)
- `/chatbot/` redirect → `/chatbot` (308)
- Tạo loop

---

## ✅ Giải Pháp: Fix Nginx Location

**Đã sửa `nginx/nginx.conf`:**

1. **Dùng regex để match cả `/chatbot` và `/chatbot/`:**
   ```nginx
   location ~ ^/chatbot(/.*)?$ {
       rewrite ^/chatbot(/.*)?$ /chatbot$1 break;
       proxy_pass http://chatbot;
       ...
   }
   ```

2. **Force HTTPS headers:**
   ```nginx
   proxy_set_header X-Forwarded-Proto https;
   proxy_redirect http:// https://;
   ```

3. **Fix deprecated http2 directive:**
   ```nginx
   listen 443 ssl;
   http2 on;
   ```

---

## 🔧 Áp Dụng Fix Trên VPS

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull code mới (với merge)
git pull origin main --no-rebase --no-edit

# Kiểm tra Nginx config
docker compose exec nginx nginx -t

# Reload Nginx
docker compose restart nginx

# Kiểm tra logs
docker compose logs nginx --tail=20 | grep chatbot
```

---

## 🎯 Kiểm Tra Sau Khi Fix

**Test chatbot:**
```bash
# Test từ VPS
curl -I https://smartfarm.kimngn.cfd/chatbot
curl -I https://smartfarm.kimngn.cfd/chatbot/

# Phải thấy: HTTP/2 200 (không phải 301/308)
```

**Test từ browser:**
- Truy cập: https://smartfarm.kimngn.cfd/chatbot
- Phải load được (không còn redirect loop)

---

## 📋 Checklist

- [ ] Đã pull code mới với `--no-rebase --no-edit`
- [ ] Đã kiểm tra Nginx config (`nginx -t`)
- [ ] Đã reload Nginx
- [ ] Đã test chatbot không còn redirect loop
- [ ] Đã kiểm tra logs không có 301/308 liên tục

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ `/chatbot` và `/chatbot/` đều hoạt động
- ✅ Không còn redirect loop
- ✅ Chatbot load được bình thường

---

**Hãy pull code mới và reload Nginx!** 🔧✨
