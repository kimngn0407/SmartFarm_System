# 🔧 Sửa Lỗi Port 80 Sau Khi Setup SSL

## 🔍 Vấn Đề

**Lỗi:**
```
Bind for 0.0.0.0:80 failed: port is already allocated
```

**Nguyên nhân:**
- Nginx trên host đã tự động khởi động lại
- Hoặc có service khác đang dùng port 80
- Docker không thể bind port 80 vì đã được sử dụng

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra Process Đang Dùng Port 80

```bash
# Kiểm tra process đang dùng port 80
lsof -i :80
# Hoặc
netstat -tulpn | grep :80
```

---

### Bước 2: Dừng Nginx Trên Host

```bash
# Dừng Nginx service
systemctl stop nginx

# Tắt tự động khởi động (quan trọng!)
systemctl disable nginx

# Kill tất cả process nginx (để chắc chắn)
killall nginx 2>/dev/null || true

# Kiểm tra lại
lsof -i :80
# Phải không còn process nào
```

---

### Bước 3: Khởi Động Lại Docker Services

```bash
cd /opt/SmartFarm

# Khởi động lại services
docker compose up -d

# Kiểm tra services
docker compose ps
```

---

## 🎯 Giải Pháp Vĩnh Viễn: Tắt Nginx Trên Host

**Nếu bạn chỉ dùng Nginx trong Docker, tắt Nginx trên host vĩnh viễn:**

```bash
# Dừng Nginx
systemctl stop nginx

# Tắt tự động khởi động
systemctl disable nginx

# Kiểm tra status
systemctl status nginx
# Phải thấy: inactive (dead)
```

**Sau đó khởi động lại Docker services:**
```bash
cd /opt/SmartFarm
docker compose up -d
```

---

## 📋 Checklist

- [ ] Đã kiểm tra process đang dùng port 80
- [ ] Đã dừng Nginx trên host
- [ ] Đã tắt auto-start Nginx
- [ ] Đã kill tất cả process nginx
- [ ] Đã kiểm tra port 80 free
- [ ] Đã khởi động lại Docker services

---

**Hãy dừng Nginx trên host và khởi động lại Docker services!** 🔧✨

