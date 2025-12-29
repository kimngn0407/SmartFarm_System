# 📧 Hướng Dẫn Bật Dịch Vụ Gửi Email Cảnh Báo

> **Checklist các bước cần làm sau khi đã bật lại code**

---

## ✅ ĐÃ HOÀN THÀNH

- [x] Bật `@Scheduled` trong `AlertSchedulerService`
- [x] Bật logic tạo alerts trong `AlertService`
- [x] Bật `EmailService` và uncomment logic gửi email
- [x] Bỏ exclude `MailSenderAutoConfiguration` trong `application.properties`

---

## 📋 CÁC BƯỚC TIẾP THEO

### Bước 1: Cấu Hình SMTP Email ⚙️

**A. Nếu chạy Local/Development:**

Thêm cấu hình vào `application.properties` hoặc `application-email.properties`:

```properties
# Gmail SMTP (Khuyến nghị)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.starttls.required=true
spring.mail.default-encoding=UTF-8
app.mail.from=your-email@gmail.com
```

**Lưu ý cho Gmail:**
1. Bật 2-Step Verification
2. Tạo App Password: https://myaccount.google.com/apppasswords
3. Dùng App Password (không phải password thường)

**B. Nếu chạy trên VPS (Production):**

Cập nhật `docker-compose.yml` hoặc `application-prod.properties`:

**Option 1: Dùng Environment Variables trong docker-compose.yml**
```yaml
backend:
  environment:
    MAIL_HOST: smtp.gmail.com
    MAIL_PORT: 587
    MAIL_USERNAME: your-email@gmail.com
    MAIL_PASSWORD: your-app-password
    MAIL_FROM: your-email@gmail.com
```

**Option 2: Uncomment trong application-prod.properties**
```properties
spring.mail.host=${MAIL_HOST:}
spring.mail.port=${MAIL_PORT:587}
spring.mail.username=${MAIL_USERNAME:}
spring.mail.password=${MAIL_PASSWORD:}
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
app.mail.from=${MAIL_FROM:alerts@smartfarm.com}
```

---

### Bước 2: Kiểm Tra Ngưỡng (Thresholds) 📊

**Đảm bảo mỗi Crop Season có ngưỡng cảnh báo:**

1. Vào Frontend → Quản lý Farm → Crop Season
2. Tạo/kiểm tra **Warning Threshold** cho mỗi crop season:
   - Min/Max Temperature
   - Min/Max Humidity
   - Min/Max Soil Moisture

**Hoặc qua API:**
```bash
POST /api/thresholds
{
  "cropSeasonId": 1,
  "minTemperature": 20.0,
  "maxTemperature": 30.0,
  "minHumidity": 40.0,
  "maxHumidity": 70.0,
  "minSoilMoisture": 30.0,
  "maxSoilMoisture": 70.0
}
```

---

### Bước 3: Kiểm Tra Email trong Accounts 📧

**Đảm bảo các accounts có email hợp lệ:**

- **Farm Owner**: Phải có email
- **Field Accounts**: Các account được gán vào Field với roles:
  - FARMER
  - TECHNICIAN
  - FARM_OWNER

**Kiểm tra qua Database:**
```sql
SELECT a.email, a.username, r.name as role
FROM account a
LEFT JOIN account_roles ar ON a.id = ar.account_id
LEFT JOIN role r ON ar.role_id = r.id
WHERE a.email IS NOT NULL AND a.email != '';
```

---

### Bước 4: Rebuild và Deploy 🚀

**A. Local Development:**
```bash
cd demoSmartFarm/demo
mvn clean package
java -jar target/demo-*.jar
```

**B. VPS (Docker):**
```bash
# Trên VPS
cd /opt/SmartFarm
docker compose build backend
docker compose up -d backend
```

**C. Kiểm tra logs:**
```bash
docker compose logs -f backend | grep -i "alert\|email"
```

---

### Bước 5: Test Dịch Vụ Email 🧪

**A. Test thủ công (Qua API):**

Tạo alerts ngay lập tức để test:
```bash
POST http://your-server:8080/api/alerts/generate/now
```

**B. Kiểm tra logs:**

Xem có email được gửi không:
```
✅ Log thành công: "Alert email sent to [email] with subject=[SmartFarm] Critical Alert: ..."
❌ Log lỗi: "Email service is not configured" hoặc "Failed to send alert email"
```

**C. Đợi Cron Job tự động:**

- Cron job chạy mỗi 30 phút
- Kiểm tra sau khi có dữ liệu sensor mới và vượt ngưỡng

---

### Bước 6: Kiểm Tra Dữ Liệu Sensor 📡

**Đảm bảo ESP32 đang gửi dữ liệu:**

1. Kiểm tra dữ liệu mới nhất trong database:
```sql
SELECT sensor_id, value, time 
FROM sensor_data 
ORDER BY time DESC 
LIMIT 10;
```

2. Kiểm tra sensor có field và crop season:
```sql
SELECT s.id, s.type, s.sensor_name, f.field_name, cs.id as crop_season_id
FROM sensor s
LEFT JOIN field f ON s.field_id = f.id
LEFT JOIN crop_season cs ON cs.field_id = f.id
WHERE s.id IN (7, 8, 9, 10);
```

---

### Bước 7: Tạo Cảnh Báo Test (Tùy chọn) 🎯

**Tạo dữ liệu sensor giả để test Critical Alert:**

```sql
-- Tạo dữ liệu sensor vượt ngưỡng (ví dụ: Temperature quá cao)
INSERT INTO sensor_data (sensor_id, value, time)
VALUES (7, 35.0, NOW());  -- Temperature = 35°C (giả sử ngưỡng max = 30°C)
```

Sau đó gọi API để tạo alert:
```bash
POST /api/alerts/generate/now
```

---

## 🔍 KIỂM TRA HOẠT ĐỘNG

### 1. Kiểm tra EmailService được load:

Trong logs khi start application:
```
✅ EmailService bean created
❌ Không thấy EmailService (kiểm tra cấu hình SMTP)
```

### 2. Kiểm tra Cron Job chạy:

Sau mỗi 30 phút, trong logs sẽ thấy:
```
🔄 Bắt đầu tạo alerts từ dữ liệu sensor mới nhất...
📊 Tìm thấy X sensors có dữ liệu mới nhất
✅ Đã tạo thành công X alerts
```

### 3. Kiểm tra Email được gửi:

Khi có Critical Alert:
```
Alert email sent to [email] with subject=[SmartFarm] Critical Alert: Temperature
```

---

## ⚠️ XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi 1: "Email service is not configured"

**Nguyên nhân:** Không có cấu hình `spring.mail.host`

**Giải pháp:** 
- Kiểm tra `application.properties` hoặc `application-prod.properties`
- Đảm bảo có `spring.mail.host=smtp.gmail.com` (hoặc SMTP server khác)

### Lỗi 2: "Failed to send alert email: Authentication failed"

**Nguyên nhân:** Sai username/password hoặc chưa dùng App Password (Gmail)

**Giải pháp:**
- Gmail: Dùng App Password (không phải password thường)
- Kiểm tra username/password đúng

### Lỗi 3: "No alerts created"

**Nguyên nhân:** 
- Không có dữ liệu sensor
- Sensor không có field/crop season
- Không có threshold cho crop season

**Giải pháp:**
- Kiểm tra dữ liệu sensor trong database
- Đảm bảo sensor có field
- Đảm bảo crop season có threshold

### Lỗi 4: "No recipients found"

**Nguyên nhân:** Không có email trong accounts

**Giải pháp:**
- Kiểm tra Farm Owner có email
- Kiểm tra Field accounts có email và đúng roles

---

## 📝 CHECKLIST TÓM TẮT

- [ ] Cấu hình SMTP trong `application.properties` hoặc `docker-compose.yml`
- [ ] Rebuild/Deploy backend
- [ ] Kiểm tra logs khi start (EmailService được load)
- [ ] Đảm bảo có Threshold cho Crop Seasons
- [ ] Đảm bảo Accounts có email hợp lệ
- [ ] Kiểm tra ESP32 đang gửi dữ liệu
- [ ] Test tạo alerts thủ công qua API
- [ ] Kiểm tra email có được gửi (check inbox/spam)
- [ ] Đợi 30 phút để kiểm tra Cron Job tự động
- [ ] Monitor logs để đảm bảo hoạt động đúng

---

## 🎯 KẾT QUẢ MONG ĐỢI

Sau khi hoàn thành tất cả bước:

✅ **Cron Job chạy mỗi 30 phút** tự động tạo alerts  
✅ **Critical Alerts** → Gửi email đến Farm Owner và Field accounts  
✅ **Warning Alerts** → Lưu vào database, không gửi email  
✅ **Good Status** → Không tạo alert  
✅ **WebSocket** → Push realtime updates lên frontend  
✅ **Field Status** → Tự động cập nhật dựa trên alerts  

---

**Version**: 1.0  
**Last Updated**: 2025-01-20

