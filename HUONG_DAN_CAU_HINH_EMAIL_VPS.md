# 📧 Hướng Dẫn Cấu Hình Email Alert Trên VPS

> **Các bước cấu hình email cảnh báo trên VPS server**

---

## 🎯 CÁCH 1: Dùng Environment Variables (Khuyến nghị)

### Bước 1: Cập nhật `application-prod.properties`

Uncomment các dòng email configuration:

**File**: `demoSmartFarm/demo/src/main/resources/application-prod.properties`

```properties
# Email Configuration - Sử dụng environment variables từ docker-compose
spring.mail.host=${MAIL_HOST:}
spring.mail.port=${MAIL_PORT:587}
spring.mail.username=${MAIL_USERNAME:}
spring.mail.password=${MAIL_PASSWORD:}
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.starttls.required=true
spring.mail.default-encoding=UTF-8
app.mail.from=${MAIL_FROM:alerts@smartfarm.com}

# Connection timeout
spring.mail.properties.mail.smtp.connectiontimeout=5000
spring.mail.properties.mail.smtp.timeout=5000
spring.mail.properties.mail.smtp.writetimeout=5000
```

### Bước 2: Cấu hình trong `docker-compose.yml`

**File**: `docker-compose.yml`

Tìm phần `backend` environment và uncomment + set giá trị:

```yaml
backend:
  environment:
    SPRING_PROFILES_ACTIVE: prod
    # ... các biến khác ...
    
    # Email Configuration - Bật email alerts
    MAIL_HOST: smtp.gmail.com
    MAIL_PORT: 587
    MAIL_USERNAME: your-email@gmail.com
    MAIL_PASSWORD: your-app-password-here  # ⚠️ Gmail App Password
    MAIL_FROM: your-email@gmail.com
```

**Hoặc dùng file `.env`** (an toàn hơn):

1. Tạo file `.env` trên VPS:
```bash
# Trên VPS
cd /opt/SmartFarm
nano .env
```

2. Thêm vào `.env`:
```env
# Email Configuration
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password-here
MAIL_FROM=your-email@gmail.com
```

3. Cập nhật `docker-compose.yml` để dùng `.env`:
```yaml
backend:
  environment:
    MAIL_HOST: ${MAIL_HOST}
    MAIL_PORT: ${MAIL_PORT}
    MAIL_USERNAME: ${MAIL_USERNAME}
    MAIL_PASSWORD: ${MAIL_PASSWORD}
    MAIL_FROM: ${MAIL_FROM}
```

---

## 🎯 CÁCH 2: Cấu hình trực tiếp trong `application-prod.properties`

Nếu không muốn dùng environment variables, set trực tiếp:

**File**: `demoSmartFarm/demo/src/main/resources/application-prod.properties`

```properties
# Email Configuration - Cấu hình trực tiếp
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password-here
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.starttls.required=true
spring.mail.default-encoding=UTF-8
app.mail.from=your-email@gmail.com

# Connection timeout
spring.mail.properties.mail.smtp.connectiontimeout=5000
spring.mail.properties.mail.smtp.timeout=5000
spring.mail.properties.mail.smtp.writetimeout=5000
```

⚠️ **Lưu ý**: Cách này không an toàn vì password được lưu trong code.

---

## 📋 CÁC BƯỚC TRIỂN KHAI TRÊN VPS

### Bước 1: Chuẩn bị Gmail App Password (Nếu dùng Gmail)

1. Vào https://myaccount.google.com/
2. Bật **2-Step Verification** (nếu chưa bật)
3. Vào **App Passwords**: https://myaccount.google.com/apppasswords
4. Tạo App Password mới cho "Mail"
5. Copy password (16 ký tự, có dấu cách - có thể bỏ dấu cách)

### Bước 2: Cập nhật Code

**Trên máy local:**

1. Uncomment email config trong `application-prod.properties`
2. Cập nhật `docker-compose.yml` (nếu dùng env vars)
3. Commit và push code:

```bash
git add .
git commit -m "Enable email alert service"
git push origin main
```

### Bước 3: Deploy lên VPS

**SSH vào VPS:**

```bash
ssh root@109.205.180.72  # hoặc IP VPS của bạn
cd /opt/SmartFarm
git pull origin main
```

### Bước 4: Cấu hình Email trên VPS

**Option A: Dùng file `.env` (Khuyến nghị)**

```bash
# Tạo hoặc chỉnh sửa file .env
nano .env

# Thêm vào:
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_FROM=your-email@gmail.com

# Lưu: Ctrl+X, Y, Enter
```

**Option B: Set trực tiếp trong docker-compose.yml**

```bash
nano docker-compose.yml

# Tìm phần backend environment và uncomment + set giá trị:
# MAIL_HOST: smtp.gmail.com
# MAIL_PORT: 587
# ... (như hướng dẫn ở trên)
```

### Bước 5: Rebuild và Restart Backend

```bash
cd /opt/SmartFarm

# Rebuild backend container
docker compose build backend

# Restart backend
docker compose up -d backend

# Kiểm tra logs
docker compose logs -f backend | grep -i "email\|alert"
```

### Bước 6: Kiểm tra Email Service

**Kiểm tra logs khi start:**

```bash
docker compose logs backend | grep -i "email"
```

**Kết quả mong đợi:**
- ✅ Không có lỗi "Email service is not configured"
- ✅ Thấy log: "EmailService bean created" (hoặc tương tự)

**Test gửi email thủ công:**

```bash
# Gọi API tạo alerts để test
curl -X POST http://localhost:8080/api/alerts/generate/now \
  -H "Content-Type: application/json"
```

**Kiểm tra email trong inbox/spam folder**

---

## 🔍 KIỂM TRA HOẠT ĐỘNG

### 1. Kiểm tra EmailService được load:

```bash
docker compose logs backend | grep -i "EmailService\|email service"
```

### 2. Kiểm tra Cron Job chạy:

Sau 30 phút, trong logs sẽ thấy:
```bash
docker compose logs backend | grep -i "alert\|cron"
```

### 3. Kiểm tra Email được gửi:

```bash
docker compose logs backend | grep -i "Alert email sent"
```

---

## 🔒 BẢO MẬT

### Best Practices:

1. **Dùng file `.env`** thay vì hardcode trong code
2. **Không commit `.env`** vào git (thêm vào `.gitignore`)
3. **Dùng Gmail App Password** thay vì password thường
4. **Giới hạn quyền** file `.env`: `chmod 600 .env`

### Tạo `.gitignore` nếu chưa có:

```bash
# Thêm vào .gitignore
echo ".env" >> .gitignore
```

---

## ⚠️ XỬ LÝ LỖI

### Lỗi: "Email service is not configured"

**Kiểm tra:**
```bash
# Kiểm tra environment variables
docker compose exec backend env | grep MAIL

# Kiểm tra application-prod.properties
docker compose exec backend cat /app/application-prod.properties | grep mail
```

**Giải pháp:**
- Đảm bảo `MAIL_HOST` được set
- Kiểm tra `application-prod.properties` có uncomment email config

### Lỗi: "Authentication failed"

**Nguyên nhân:** 
- Sai username/password
- Chưa dùng App Password (Gmail)

**Giải pháp:**
- Kiểm tra username đúng
- Dùng Gmail App Password (16 ký tự)
- Đảm bảo 2-Step Verification đã bật

### Lỗi: "Connection timeout"

**Nguyên nhân:** 
- Firewall chặn port 587
- SMTP server không accessible

**Giải pháp:**
- Kiểm tra firewall VPS: `ufw status`
- Cho phép outbound connection port 587: `ufw allow out 587/tcp`
- Test kết nối: `telnet smtp.gmail.com 587`

---

## 📝 CHECKLIST TRIỂN KHAI VPS

- [ ] Tạo Gmail App Password
- [ ] Uncomment email config trong `application-prod.properties`
- [ ] Cấu hình `MAIL_*` trong `docker-compose.yml` hoặc `.env`
- [ ] Commit và push code lên git
- [ ] Pull code trên VPS: `git pull origin main`
- [ ] Tạo/cập nhật file `.env` trên VPS (nếu dùng)
- [ ] Rebuild backend: `docker compose build backend`
- [ ] Restart backend: `docker compose up -d backend`
- [ ] Kiểm tra logs: `docker compose logs -f backend`
- [ ] Test tạo alerts: `curl -X POST http://localhost:8080/api/alerts/generate/now`
- [ ] Kiểm tra email trong inbox/spam
- [ ] Đợi 30 phút để kiểm tra Cron Job tự động

---

## 🚀 LỆNH NHANH (Tóm tắt)

```bash
# 1. SSH vào VPS
ssh root@109.205.180.72

# 2. Vào thư mục project
cd /opt/SmartFarm

# 3. Pull code mới
git pull origin main

# 4. Tạo/cập nhật .env (nếu dùng)
nano .env
# Thêm: MAIL_HOST, MAIL_PORT, MAIL_USERNAME, MAIL_PASSWORD, MAIL_FROM

# 5. Rebuild và restart
docker compose build backend
docker compose up -d backend

# 6. Kiểm tra logs
docker compose logs -f backend
```

---

**Version**: 1.0  
**Last Updated**: 2025-01-20

