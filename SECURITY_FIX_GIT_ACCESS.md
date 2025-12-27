# 🔒 Fix Security Issue: .git Folder Accessible

## ⚠️ Vấn Đề Bảo Mật

Logs cho thấy có request đến `/.git/config`:
```
GET /.git/config HTTP/1.1" 200
```

**Đây là security vulnerability nghiêm trọng!**

Nếu `.git` folder bị expose, attacker có thể:
- Xem source code
- Xem commit history
- Tìm secrets, API keys, credentials
- Clone toàn bộ repository

---

## ✅ Đã Sửa

### 1. Thêm `.git` vào `.dockerignore`

File: `J2EE_Frontend/.dockerignore`

Đã thêm:
```
.git
.gitignore
```

### 2. Thêm Block Rule trong Nginx

File: `J2EE_Frontend/nginx.conf`

Đã thêm:
```nginx
# Block access to hidden files and directories (including .git)
location ~ /\. {
    deny all;
    return 404;
}
```

---

## 🚀 Deploy Fix

### Trên VPS:

```bash
# Pull code mới
cd /opt/SmartFarm
git pull origin main

# Rebuild frontend
docker compose build frontend --no-cache

# Restart frontend
docker compose up -d --force-recreate frontend

# Kiểm tra
docker compose logs frontend --tail=20
```

---

## ✅ Verify Fix

### Test từ browser:

1. Mở: `https://smartfarm.kimngn.cfd/.git/config`
2. **Kết quả mong đợi:** 404 Not Found (KHÔNG được 200 OK)

### Test từ command line:

```bash
curl -I https://smartfarm.kimngn.cfd/.git/config
```

**Kết quả mong đợi:**
```
HTTP/1.1 404 Not Found
```

---

## 🔍 Kiểm Tra Hiện Tại

### Trên VPS:

```bash
# Kiểm tra .git có trong container không
docker compose exec frontend ls -la /usr/share/nginx/html/ | grep git

# Nếu có output → .git đang bị expose
# Cần rebuild lại với .dockerignore
```

---

## 📋 Checklist

- [ ] Đã thêm `.git` vào `.dockerignore`
- [ ] Đã thêm block rule trong nginx.conf
- [ ] Đã rebuild frontend
- [ ] Test: `/.git/config` → 404 (không phải 200)
- [ ] (Optional) Kiểm tra không có file nhạy cảm nào khác bị expose

---

**Lưu ý:** Sau khi fix, cần rebuild lại frontend để áp dụng thay đổi!


