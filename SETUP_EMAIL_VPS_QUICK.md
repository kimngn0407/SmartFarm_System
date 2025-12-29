# 🚀 Setup Email Alert trên VPS - Hướng dẫn nhanh

## Cách A: Dùng file `.env` (Khuyến nghị)

### Bước 1: Pull code mới

```bash
ssh root@109.205.180.72  # hoặc IP VPS của bạn
cd /opt/SmartFarm
git pull origin main
```

### Bước 2: Chạy script tự động (Dễ nhất)

```bash
chmod +x setup-email-vps.sh
./setup-email-vps.sh
```

Script sẽ hỏi bạn:
- MAIL_HOST (mặc định: smtp.gmail.com)
- MAIL_PORT (mặc định: 587)
- MAIL_USERNAME (email của bạn)
- MAIL_PASSWORD (Gmail App Password)
- MAIL_FROM (mặc định = MAIL_USERNAME)

### Bước 3 (Nếu không dùng script): Tạo file `.env` thủ công

```bash
nano .env
```

Thêm vào:

```env
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-gmail-app-password
MAIL_FROM=your-email@gmail.com
```

Lưu: `Ctrl+X`, `Y`, `Enter`

Set permission bảo mật:
```bash
chmod 600 .env
```

### Bước 4: Rebuild và restart backend

```bash
docker compose build backend
docker compose up -d backend
```

### Bước 5: Kiểm tra

```bash
# Xem logs
docker compose logs -f backend | grep -i "email\|alert"

# Test tạo alerts
curl -X POST http://localhost:8080/api/alerts/generate/now
```

---

## 📋 Checklist

- [ ] Đã có Gmail App Password (16 ký tự)
- [ ] Pull code: `git pull origin main`
- [ ] Chạy script: `./setup-email-vps.sh` HOẶC tạo `.env` thủ công
- [ ] Rebuild: `docker compose build backend`
- [ ] Restart: `docker compose up -d backend`
- [ ] Kiểm tra logs
- [ ] Test tạo alerts và kiểm tra email

---

## 🔑 Lấy Gmail App Password

1. Vào: https://myaccount.google.com/apppasswords
2. Chọn "Mail" và "Other (Custom name)"
3. Nhập tên: "SmartFarm VPS"
4. Copy password (16 ký tự, có thể bỏ dấu cách)

---

**Xem chi tiết trong**: `HUONG_DAN_CAU_HINH_EMAIL_VPS.md`

