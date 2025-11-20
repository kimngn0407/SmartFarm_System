# Hướng dẫn Cấu hình Email cho SmartFarm

## Tổng quan
Hệ thống SmartFarm có thể gửi email cảnh báo khi có alert **Critical** đến:
- Chủ nông trại (Farm Owner)
- Nông dân (Farmer) được gán cho field
- Kỹ thuật viên (Technician) được gán cho field

## Cách hoạt động
- Email chỉ được gửi khi alert có status = **"Critical"**
- Email được gửi **bất đồng bộ** (async) - không chặn quá trình tạo alert
- Nếu email service không được cấu hình, hệ thống vẫn hoạt động bình thường (chỉ không gửi email)

## Cấu hình trên VPS (Docker)

### Cách 1: Sử dụng Environment Variables trong docker-compose.yml

Thêm các biến môi trường vào service `backend` trong `docker-compose.yml`:

```yaml
backend:
  environment:
    # ... các biến khác ...
    # Email Configuration
    MAIL_HOST: smtp.gmail.com
    MAIL_PORT: 587
    MAIL_USERNAME: your-email@gmail.com
    MAIL_PASSWORD: your-app-password
    MAIL_FROM: your-email@gmail.com
```

### Cách 2: Sử dụng Gmail (Khuyến nghị)

#### Bước 1: Tạo App Password cho Gmail
1. Vào [Google Account](https://myaccount.google.com/)
2. Bật **2-Step Verification** (nếu chưa bật)
3. Tạo **App Password**: https://myaccount.google.com/apppasswords
4. Chọn app: "Mail", device: "Other (Custom name)" → nhập "SmartFarm"
5. Copy password được tạo (16 ký tự, không có dấu cách)

#### Bước 2: Cập nhật docker-compose.yml
```yaml
backend:
  environment:
    MAIL_HOST: smtp.gmail.com
    MAIL_PORT: 587
    MAIL_USERNAME: your-email@gmail.com
    MAIL_PASSWORD: xxxx xxxx xxxx xxxx  # App password (16 ký tự, bỏ dấu cách)
    MAIL_FROM: your-email@gmail.com
```

#### Bước 3: Restart backend
```bash
docker-compose up -d --build backend
```

### Cách 3: Sử dụng SMTP Server khác

#### Outlook/Office 365
```yaml
MAIL_HOST: smtp.office365.com
MAIL_PORT: 587
MAIL_USERNAME: your-email@outlook.com
MAIL_PASSWORD: your-password
MAIL_FROM: your-email@outlook.com
```

#### Custom SMTP Server
```yaml
MAIL_HOST: smtp.yourdomain.com
MAIL_PORT: 587  # hoặc 465 cho SSL
MAIL_USERNAME: your-username
MAIL_PASSWORD: your-password
MAIL_FROM: alerts@yourdomain.com
```

## Kiểm tra Email Service

### 1. Kiểm tra logs backend
```bash
docker-compose logs -f backend | grep -i mail
```

Bạn sẽ thấy:
- `Email service is not configured` → Chưa cấu hình email
- `Alert email sent to [...]` → Email đã được gửi thành công
- `Failed to send alert email` → Có lỗi khi gửi email

### 2. Test bằng cách tạo Critical Alert
- Tạo một alert Critical (giá trị sensor vượt ngưỡng nhiều)
- Kiểm tra email inbox của:
  - Farm Owner
  - Users được gán cho field đó

### 3. Kiểm tra trong code
Email được gửi trong `AlertService.createAlertsFromSensorData()` khi:
- `status.equalsIgnoreCase("critical")`
- `emailService != null` (đã được cấu hình)

## Template Email

Email sử dụng template Thymeleaf: `templates/alert-email.html`

Nội dung email bao gồm:
- Tên trang trại và khu vực
- Tên sensor
- Loại cảnh báo (Temperature, Humidity, Soil Moisture)
- Giá trị hiện tại và ngưỡng
- Trạng thái (Critical)
- Thông điệp
- Thời gian

## Troubleshooting

### Email không được gửi

1. **Kiểm tra cấu hình:**
   ```bash
   docker exec smartfarm-backend env | grep MAIL
   ```

2. **Kiểm tra logs:**
   ```bash
   docker-compose logs backend | grep -i "email\|mail"
   ```

3. **Kiểm tra Gmail App Password:**
   - Đảm bảo đã tạo App Password (không dùng mật khẩu Gmail thông thường)
   - App Password phải là 16 ký tự, không có dấu cách

4. **Kiểm tra firewall/network:**
   - Port 587 phải được mở
   - SMTP server phải accessible từ VPS

### Lỗi "Authentication failed"
- Kiểm tra lại username và password
- Với Gmail: Đảm bảo dùng App Password, không phải mật khẩu thông thường
- Kiểm tra 2-Step Verification đã bật

### Email vào Spam
- Thêm địa chỉ gửi vào whitelist
- Kiểm tra SPF/DKIM records (nếu dùng custom domain)

## Bảo mật

⚠️ **QUAN TRỌNG:**
- Không commit password vào Git
- Sử dụng environment variables hoặc secrets management
- Với Gmail, luôn dùng App Password, không dùng mật khẩu chính

## Tắt Email Service

Nếu không muốn dùng email, chỉ cần không set các biến môi trường `MAIL_*`. Hệ thống sẽ hoạt động bình thường mà không gửi email.

