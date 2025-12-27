# 🔧 Kiểm Tra Nginx Chatbot Config Trên VPS

## 🔍 Vấn Đề

**Vẫn còn redirect loop sau khi reload:**
```
GET /chatbot HTTP/2.0" 301
GET /chatbot/ HTTP/2.0" 308
```

**Có thể do:**
- Nginx config trên VPS vẫn là version cũ
- Code mới chưa được pull đúng

---

## ✅ Kiểm Tra Config Trên VPS

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra nginx.conf có đúng code mới chưa
grep -A 15 "location.*chatbot" nginx/nginx.conf

# Phải thấy:
# location ~ ^/chatbot(/.*)?$ {
#     rewrite ^/chatbot(/.*)?$ /chatbot$1 break;
#     proxy_pass http://chatbot;
#     ...
# }
```

**Nếu KHÔNG thấy regex location:**
- Config vẫn là version cũ
- Cần kiểm tra lại git pull

---

## ✅ Kiểm Tra Git Status

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra nginx.conf có thay đổi chưa
git status nginx/nginx.conf

# Xem nội dung file
cat nginx/nginx.conf | grep -A 15 "location.*chatbot"
```

---

## 🔧 Nếu Config Vẫn Cũ

**Option 1: Force Pull Code Mới**
```bash
cd /opt/SmartFarm

# Discard local changes
git checkout -- nginx/nginx.conf

# Pull lại
git pull origin main --no-rebase --no-edit

# Kiểm tra lại
grep -A 15 "location.*chatbot" nginx/nginx.conf
```

**Option 2: Copy Config Trực Tiếp**
```bash
cd /opt/SmartFarm

# Backup config cũ
cp nginx/nginx.conf nginx/nginx.conf.backup

# Xem config mới từ git
git show origin/main:nginx/nginx.conf | grep -A 15 "location.*chatbot"

# Nếu đúng, copy toàn bộ
git show origin/main:nginx/nginx.conf > nginx/nginx.conf

# Kiểm tra
docker compose exec nginx nginx -t

# Reload
docker compose restart nginx
```

---

## 📋 Checklist

- [ ] Đã kiểm tra nginx.conf có regex location chưa
- [ ] Đã kiểm tra git status
- [ ] Đã pull code mới nếu cần
- [ ] Đã reload Nginx
- [ ] Đã test chatbot không còn redirect loop

---

**Hãy kiểm tra nginx.conf trên VPS có đúng code mới chưa!** 🔧✨
