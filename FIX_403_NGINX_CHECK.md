# 🔧 Fix Lỗi 403 - Kiểm Tra Nginx

## 🔍 Vấn Đề

**Backend logs không có request đến `/api/health`.**

**Có nghĩa là request bị chặn ở Nginx hoặc không đến backend.**

---

## ✅ Giải Pháp: Kiểm Tra Nginx

### Bước 1: Xem Nginx Logs

```bash
cd /opt/SmartFarm

# Xem Nginx logs khi có request
docker compose logs nginx --tail=100 | grep -i "pest-disease\|health\|403\|forbidden"

# Hoặc xem tất cả logs gần đây
docker compose logs nginx --tail=100
```

---

### Bước 2: Test Trực Tiếp Backend (Bypass Nginx)

```bash
# Test trực tiếp từ VPS đến backend container (port 8080)
curl -I http://localhost:8080/api/health

# Hoặc từ VPS IP
curl -I http://109.205.180.72:8080/api/health

# Nếu trả về 200 → vấn đề ở Nginx
# Nếu trả về 403 → vấn đề ở Backend
```

---

### Bước 3: Kiểm Tra Nginx Config

```bash
# Kiểm tra Nginx config có chặn request không
cat nginx/nginx.conf | grep -A 10 "location /api"

# Kiểm tra proxy_pass có đúng không
cat nginx/nginx.conf | grep -i "proxy_pass.*backend"
```

---

### Bước 4: Reload Nginx Config

```bash
# Reload Nginx config
docker compose exec nginx nginx -t
docker compose exec nginx nginx -s reload

# Hoặc restart Nginx
docker compose restart nginx

# Test lại
curl -I https://smartfarm.kimngn.cfd/api/health
```

---

## 🚨 Nếu Test Trực Tiếp Backend Vẫn 403

**Có nghĩa là vấn đề ở Backend. Cần:**

```bash
# Rebuild backend với --no-cache
docker compose build --no-cache backend
docker compose up -d --force-recreate backend
sleep 45

# Test lại
curl -I http://localhost:8080/api/health
```

---

## 📋 Checklist

- [ ] Đã xem Nginx logs
- [ ] Đã test trực tiếp backend (bypass Nginx)
- [ ] Đã kiểm tra Nginx config
- [ ] Đã reload Nginx config
- [ ] Đã test lại endpoints

---

**Hãy test trực tiếp backend để xác định vấn đề!** 🔧✨
