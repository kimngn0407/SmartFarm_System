# Hướng dẫn Cấu hình Email trên VPS - Từng bước

## 📋 Tổng quan
Hướng dẫn này sẽ giúp bạn cấu hình email alerts trên VPS từ đầu đến cuối.

---

## Bước 1: SSH vào VPS

```bash
ssh root@173.249.48.25
# hoặc
ssh root@your-vps-ip
```

---

## Bước 2: Di chuyển đến thư mục project

```bash
cd ~/projects/SmartFarm
# hoặc
cd /root/projects/SmartFarm
```

---

## Bước 3: Pull code mới nhất

```bash
git pull
```

Đảm bảo có các file mới:
- `EMAIL_SETUP_GUIDE.md`
- `docker-compose.yml` (đã cập nhật)
- `application-prod.properties` (đã cập nhật)

---

## Bước 4: Tạo Gmail App Password (Nếu dùng Gmail)

### 4.1. Mở trình duyệt và đăng nhập Gmail
- Vào https://myaccount.google.com/
- Đăng nhập bằng tài khoản Gmail bạn muốn dùng để gửi email

### 4.2. Bật 2-Step Verification (nếu chưa bật)
1. Vào **Security** (Bảo mật)
2. Tìm **2-Step Verification** (Xác minh 2 bước)
3. Bật nếu chưa bật

### 4.3. Tạo App Password
1. Vào: https://myaccount.google.com/apppasswords
2. Chọn:
   - **App**: Mail
   - **Device**: Other (Custom name)
   - Nhập tên: `SmartFarm VPS`
3. Click **Generate**
4. Copy password được tạo (16 ký tự, có dấu cách)
   - Ví dụ: `abcd efgh ijkl mnop`
   - **Lưu ý**: Bỏ dấu cách khi dùng → `abcdefghijklmnop`

---

## Bước 5: Cập nhật docker-compose.yml

### 5.1. Mở file docker-compose.yml

```bash
nano docker-compose.yml
# hoặc
vi docker-compose.yml
```

### 5.2. Tìm section `backend` và thêm email config

Tìm dòng:
```yaml
      FRONTEND_ORIGINS: ${FRONTEND_ORIGINS:-http://173.249.48.25,http://173.249.48.25:80,http://localhost:3000,http://localhost:80}
```

Thêm ngay sau dòng đó:
```yaml
      # Email Configuration
      MAIL_HOST: smtp.gmail.com
      MAIL_PORT: 587
      MAIL_USERNAME: your-email@gmail.com
      MAIL_PASSWORD: your-app-password-here
      MAIL_FROM: your-email@gmail.com
```

**Ví dụ cụ thể:**
```yaml
      # Email Configuration
      MAIL_HOST: smtp.gmail.com
      MAIL_PORT: 587
      MAIL_USERNAME: lovengan0407@gmail.com
      MAIL_PASSWORD: tjwzhozamzveaqgk
      MAIL_FROM: lovengan0407@gmail.com
```

### 5.3. Lưu file
- **Nano**: `Ctrl + O` → Enter → `Ctrl + X`
- **Vi**: `:wq` → Enter

---

## Bước 6: Chạy Migration SQL (Nếu chưa chạy)

Nếu chưa chạy migration cho alert table:

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
ALTER TABLE public.alert 
ADD COLUMN IF NOT EXISTS type VARCHAR(255),
ADD COLUMN IF NOT EXISTS value DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS threshold_min DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS threshold_max DOUBLE PRECISION;
"
```

Kiểm tra kết quả:
```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "\d alert"
```

Bạn sẽ thấy các cột mới: `type`, `value`, `threshold_min`, `threshold_max`

---

## Bước 7: Rebuild và Restart Backend

### 7.1. Dừng backend (tạm thời)
```bash
docker-compose stop backend
```

### 7.2. Rebuild backend với cấu hình mới
```bash
docker-compose build --no-cache backend
```

### 7.3. Khởi động lại backend
```bash
docker-compose up -d backend
```

### 7.4. Kiểm tra backend đã chạy
```bash
docker-compose ps backend
```

Bạn sẽ thấy status: `Up` hoặc `Healthy`

---

## Bước 8: Kiểm tra Email Service đã hoạt động

### 8.1. Xem logs backend
```bash
docker-compose logs -f backend
```

Tìm các dòng:
- `Email service is not configured` → ❌ Chưa cấu hình đúng
- Không có thông báo lỗi về email → ✅ Đã cấu hình

### 8.2. Kiểm tra environment variables
```bash
docker exec smartfarm-backend env | grep MAIL
```

Bạn sẽ thấy:
```
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_FROM=your-email@gmail.com
```

---

## Bước 9: Test Email (Tạo Critical Alert)

### 9.1. Tạo Critical Alert thủ công

Có 2 cách:

#### Cách 1: Qua API (nếu có sensor data)
```bash
curl -X POST http://localhost:8080/api/alerts/generate/now \
  -H "Content-Type: application/json"
```

#### Cách 2: Đợi scheduled task (mỗi 5 phút)
- Scheduled task sẽ tự động tạo alerts từ sensor data
- Nếu có sensor value vượt ngưỡng → sẽ tạo Critical alert

### 9.2. Kiểm tra logs
```bash
docker-compose logs -f backend | grep -i "email\|mail\|alert"
```

Bạn sẽ thấy:
```
Alert email sent to [email1, email2] with subject=[SmartFarm] Critical Alert: Temperature
```

### 9.3. Kiểm tra email inbox
- Kiểm tra inbox của:
  - Farm Owner email
  - Farmer/Technician emails được gán cho field
- Kiểm tra cả **Spam folder**

---

## Bước 10: Troubleshooting (Nếu có lỗi)

### Lỗi: "Email service is not configured"
**Nguyên nhân**: Environment variables chưa được set đúng

**Giải pháp**:
1. Kiểm tra lại docker-compose.yml
2. Đảm bảo đã restart backend sau khi sửa
3. Kiểm tra: `docker exec smartfarm-backend env | grep MAIL`

### Lỗi: "Authentication failed"
**Nguyên nhân**: 
- Sai username/password
- Với Gmail: Dùng mật khẩu thông thường thay vì App Password

**Giải pháp**:
1. Tạo lại App Password
2. Đảm bảo bỏ dấu cách trong App Password
3. Kiểm tra 2-Step Verification đã bật

### Lỗi: "Connection timeout"
**Nguyên nhân**: 
- Firewall chặn port 587
- SMTP server không accessible

**Giải pháp**:
1. Kiểm tra firewall: `ufw status`
2. Mở port 587 nếu cần: `ufw allow 587`
3. Test kết nối: `telnet smtp.gmail.com 587`

### Email vào Spam
**Giải pháp**:
1. Thêm địa chỉ gửi vào whitelist
2. Đánh dấu "Not Spam"
3. Với Gmail: Kiểm tra trong tab "All Mail"

---

## ✅ Checklist hoàn thành

- [ ] Đã SSH vào VPS
- [ ] Đã pull code mới nhất
- [ ] Đã tạo Gmail App Password
- [ ] Đã cập nhật docker-compose.yml với email config
- [ ] Đã chạy migration SQL (nếu cần)
- [ ] Đã rebuild và restart backend
- [ ] Đã kiểm tra environment variables
- [ ] Đã test tạo Critical alert
- [ ] Đã nhận được email cảnh báo

---

## 📞 Hỗ trợ

Nếu gặp vấn đề, kiểm tra:
1. Logs: `docker-compose logs backend | grep -i mail`
2. Environment: `docker exec smartfarm-backend env | grep MAIL`
3. Backend health: `curl http://localhost:8080/actuator/health`

---

## 🔒 Bảo mật

⚠️ **QUAN TRỌNG**:
- Không commit password vào Git
- App Password chỉ dùng cho ứng dụng, không dùng cho đăng nhập
- Nếu bị lộ, tạo App Password mới ngay lập tức

