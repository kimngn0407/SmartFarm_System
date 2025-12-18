# 🎯 Hướng Dẫn Bật Lại Hệ Thống Cảnh Báo và Email - Cho Ngày Thi

> **📅 Sử dụng:** File này hướng dẫn cách bật lại hệ thống cảnh báo tự động và email để trình bày trong cuộc thi.

---

## 📋 Tổng Quan

Hiện tại hệ thống đã được **TẮT HOÀN TOÀN**:
- ✅ **Tự động tạo cảnh báo** (Alert Scheduler) - Đã tắt
- ✅ **API endpoints tạo cảnh báo** - Đã tắt
- ✅ **Logic tạo cảnh báo trong AlertService** - Đã tắt
- ✅ **Gửi email cảnh báo** (Email Service) - Đã tắt
- ✅ **Cấu hình email** - Đã comment

---

## 🚀 CÁCH NHANH NHẤT: Sử dụng Script Tự Động

### Trên VPS:

```bash
# 1. SSH vào VPS
ssh root@your-vps-ip

# 2. Vào thư mục project
cd ~/projects/SmartFarm

# 3. Chạy script bật lại
chmod +x enable_alerts_for_demo.sh
./enable_alerts_for_demo.sh

# 4. Rebuild backend
docker-compose up -d --build backend

# 5. Kiểm tra logs
docker-compose logs -f backend
```

---

## 📝 CÁCH THỦ CÔNG: Từng Bước Chi Tiết

### **Bước 1: Bật Tự Động Tạo Cảnh Báo (Alert Scheduler)**

#### 1.1. Bật @Scheduled annotation

**File:** `demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java`

**Tìm dòng 35:**
```java
// @Scheduled(fixedRate = 300000) // 5 phút = 300000 milliseconds - ĐÃ TẮT
```

**Sửa thành:**
```java
@Scheduled(fixedRate = 300000) // 5 phút = 300000 milliseconds
```

**Lệnh nhanh:**
```bash
sed -i 's|// @Scheduled(fixedRate = 300000)|@Scheduled(fixedRate = 300000)|' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java
```

**Uncomment import (nếu cần):**
```bash
sed -i 's|// import org.springframework.scheduling.annotation.Scheduled;|import org.springframework.scheduling.annotation.Scheduled;|' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java
```

---

#### 1.2. Bật Logic Tạo Cảnh Báo trong AlertService

**File:** `demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java`

**Tìm dòng 120-122:**
```java
// ⚠️ TẠM TẮT - Không tạo cảnh báo tự động
// Để bật lại, xóa hoặc comment dòng return bên dưới
return alerts;
```

**Xóa hoặc comment 3 dòng trên:**
```java
// return alerts; // Đã bật lại
```

**Tìm dòng 124:**
```java
/* ĐÃ TẮT - Uncomment để bật lại
```

**Xóa dòng comment mở đầu và tìm dòng đóng comment (khoảng dòng 188):**
```java
*/
```

**Xóa dòng đóng comment này.**

**Lệnh nhanh (sử dụng sed):**
```bash
# Xóa early return
sed -i '/⚠️ TẠM TẮT - Không tạo cảnh báo tự động/,/return alerts;/d' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java

# Uncomment phần code tạo cảnh báo
sed -i 's|/\* ĐÃ TẮT - Uncomment để bật lại||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java

sed -i 's|\*/||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java
```

**Hoặc sửa thủ công trong file:**
- Xóa dòng 120-122 (early return)
- Xóa dòng 124 (`/* ĐÃ TẮT - Uncomment để bật lại`)
- Xóa dòng 188 (`*/`)

---

#### 1.3. Bật API Endpoints Tạo Cảnh Báo

**File:** `demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java`

**Tìm dòng 97-98:**
```java
// ⚠️ ĐÃ TẮT - Để bật lại, uncomment các endpoint này
/*
```

**Xóa 2 dòng trên.**

**Tìm dòng cuối cùng của comment block (khoảng dòng 127):**
```java
*/
```

**Xóa dòng này.**

**Lệnh nhanh:**
```bash
# Uncomment API endpoints
sed -i '/⚠️ ĐÃ TẮT - Để bật lại, uncomment các endpoint này/d' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java

sed -i 's|/\*||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java

sed -i 's|\*/||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java
```

---

### **Bước 2: Bật Gửi Email Cảnh Báo**

#### 2.1. Bật EmailService

**File:** `demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java`

**Tìm dòng 27:**
```java
// @Service - ĐÃ TẮT
```

**Sửa thành:**
```java
@Service
```

**Lệnh nhanh:**
```bash
sed -i 's|// @Service - ĐÃ TẮT|@Service|' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java
```

---

#### 2.2. Bật Logic Gửi Email

**File:** `demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java`

**Tìm dòng 49-51:**
```java
// ⚠️ ĐÃ TẮT - Không gửi email
logger.warn("Email service is disabled. Skipping email to: {}", to);
return;
```

**Xóa hoặc comment 3 dòng trên:**
```java
// return; // Đã bật lại
```

**Tìm dòng 53:**
```java
/* ĐÃ TẮT - Uncomment để bật lại
```

**Xóa dòng này.**

**Tìm dòng đóng comment (khoảng dòng 101):**
```java
*/
```

**Xóa dòng này.**

**Lệnh nhanh:**
```bash
# Xóa early return
sed -i '/⚠️ ĐÃ TẮT - Không gửi email/,/return;/d' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java

# Uncomment code gửi email
sed -i 's|/\* ĐÃ TẮT - Uncomment để bật lại||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java

sed -i 's|\*/||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java
```

---

#### 2.3. Bật Cấu Hình Email trong application-prod.properties

**File:** `demoSmartFarm/demo/src/main/resources/application-prod.properties`

**Tìm dòng 64-78 (các dòng có `#spring.mail`):**

**Uncomment tất cả các dòng email config:**
```properties
# Email Configuration - Sử dụng environment variables từ docker-compose
# Nếu không set, email service sẽ không hoạt động (không gây lỗi)
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

**Lệnh nhanh:**
```bash
# Uncomment email config
sed -i 's|#spring.mail.host|spring.mail.host|' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties

sed -i 's|#spring.mail.port|spring.mail.port|' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties

sed -i 's|#spring.mail.username|spring.mail.username|' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties

sed -i 's|#spring.mail.password|spring.mail.password|' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties

sed -i 's|#spring.mail.properties|spring.mail.properties|' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties

sed -i 's|#spring.mail.default-encoding|spring.mail.default-encoding|' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties

sed -i 's|#app.mail.from|app.mail.from|' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties
```

---

#### 2.4. Bật Cấu Hình Email trong docker-compose.yml

**File:** `docker-compose.yml`

**Tìm section `backend` → `environment` (khoảng dòng 39-44):**

**Uncomment và điền thông tin email:**
```yaml
backend:
  environment:
    # ... các biến khác ...
    
    # Email Configuration - UNCOMMENT VÀ ĐIỀN THÔNG TIN
    MAIL_HOST: smtp.gmail.com
    MAIL_PORT: 587
    MAIL_USERNAME: lovengan0407@gmail.com
    MAIL_PASSWORD: bjjd yvqw rrmq dicg  # App Password từ Gmail
    MAIL_FROM: alerts@smartfarm.com
```

**Lệnh nhanh:**
```bash
# Uncomment và set các biến email
sed -i 's|# MAIL_HOST: ${MAIL_HOST:-}|MAIL_HOST: smtp.gmail.com|' docker-compose.yml
sed -i 's|# MAIL_PORT: ${MAIL_PORT:-587}|MAIL_PORT: 587|' docker-compose.yml
sed -i 's|# MAIL_USERNAME: ${MAIL_USERNAME:-}|MAIL_USERNAME: lovengan0407@gmail.com|' docker-compose.yml
sed -i 's|# MAIL_PASSWORD: ${MAIL_PASSWORD:-}|MAIL_PASSWORD: bjjd yvqw rrmq dicg|' docker-compose.yml
sed -i 's|# MAIL_FROM: ${MAIL_FROM:-alerts@smartfarm.com}|MAIL_FROM: alerts@smartfarm.com|' docker-compose.yml
```

---

### **Bước 3: Rebuild và Restart Backend**

Sau khi sửa tất cả các file, rebuild backend:

```bash
# Rebuild backend service
docker-compose up -d --build backend

# Hoặc nếu muốn rebuild từ đầu
docker-compose stop backend
docker-compose rm -f backend
docker-compose up -d --build backend
```

---

### **Bước 4: Kiểm Tra**

#### 4.1. Kiểm tra logs

```bash
# Xem logs realtime
docker-compose logs -f backend

# Hoặc xem 100 dòng cuối
docker-compose logs --tail=100 backend
```

**Tìm các dòng sau để xác nhận đã bật:**
- ✅ `🔄 Bắt đầu tạo alerts từ dữ liệu sensor mới nhất...` (mỗi 5 phút)
- ✅ `✅ Đã tạo thành công X alerts`
- ✅ `Alert email sent to ...` (khi có cảnh báo critical)

#### 4.2. Kiểm tra Alert Scheduler

```bash
# Đợi 5-10 phút và kiểm tra logs
docker-compose logs backend | grep -i "tạo alerts"

# Nếu thấy dòng "🔄 Bắt đầu tạo alerts" → Đã bật thành công ✅
```

#### 4.3. Kiểm tra Email Service

```bash
# Kiểm tra email service đã được tạo
docker-compose logs backend | grep -i "email service"

# Tạo cảnh báo thủ công để test email
curl -X POST http://your-vps-ip:8080/api/alerts/generate/now
```

#### 4.4. Kiểm tra API Endpoints

```bash
# Test API tạo cảnh báo
curl -X POST http://your-vps-ip:8080/api/alerts/generate/now

# Xem danh sách cảnh báo
curl http://your-vps-ip:8080/api/alerts
```

---

## 🔄 QUY TRÌNH NHANH CHO NGÀY THI (5-10 phút)

### **Trước khi thi:**

```bash
# 1. SSH vào VPS
ssh root@your-vps-ip
cd ~/projects/SmartFarm

# 2. Pull code mới nhất (nếu có)
git pull origin main

# 3. Chạy script bật lại (nếu có)
chmod +x enable_alerts_for_demo.sh
./enable_alerts_for_demo.sh

# HOẶC chạy các lệnh sed nhanh:

# Bật Alert Scheduler
sed -i 's|// @Scheduled(fixedRate = 300000)|@Scheduled(fixedRate = 300000)|' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java

# Bật AlertService (xóa early return và uncomment code)
sed -i '/⚠️ TẠM TẮT - Không tạo cảnh báo tự động/,/return alerts;/d' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java
sed -i 's|/\* ĐÃ TẮT - Uncomment để bật lại||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java
sed -i 's|\*/||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java

# Bật API endpoints
sed -i '/⚠️ ĐÃ TẮT - Để bật lại, uncomment các endpoint này/d' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java
sed -i 's|/\*||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java
sed -i 's|\*/||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java

# Bật EmailService
sed -i 's|// @Service - ĐÃ TẮT|@Service|' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java
sed -i '/⚠️ ĐÃ TẮT - Không gửi email/,/return;/d' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java
sed -i 's|/\* ĐÃ TẮT - Uncomment để bật lại||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java
sed -i 's|\*/||' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java

# Bật email config trong application-prod.properties
sed -i 's|#spring.mail|spring.mail|g' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties
sed -i 's|#app.mail|app.mail|' \
  demoSmartFarm/demo/src/main/resources/application-prod.properties

# Bật email config trong docker-compose.yml
sed -i 's|# MAIL_HOST: ${MAIL_HOST:-}|MAIL_HOST: smtp.gmail.com|' docker-compose.yml
sed -i 's|# MAIL_PORT: ${MAIL_PORT:-587}|MAIL_PORT: 587|' docker-compose.yml
sed -i 's|# MAIL_USERNAME: ${MAIL_USERNAME:-}|MAIL_USERNAME: lovengan0407@gmail.com|' docker-compose.yml
sed -i 's|# MAIL_PASSWORD: ${MAIL_PASSWORD:-}|MAIL_PASSWORD: bjjd yvqw rrmq dicg|' docker-compose.yml
sed -i 's|# MAIL_FROM: ${MAIL_FROM:-alerts@smartfarm.com}|MAIL_FROM: alerts@smartfarm.com|' docker-compose.yml

# 4. Rebuild backend
docker-compose up -d --build backend

# 5. Kiểm tra logs
docker-compose logs -f backend
```

### **Sau khi thi (tắt lại):**

```bash
# Chạy script tắt lại
chmod +x disable_alerts_after_demo.sh
./disable_alerts_after_demo.sh

# Hoặc rebuild lại với code đã tắt
git pull origin main
docker-compose up -d --build backend
```

---

## 📋 CHECKLIST TRƯỚC KHI THI

- [ ] Đã bật @Scheduled trong AlertSchedulerService
- [ ] Đã xóa early return trong AlertService.createAlertsFromSensorData()
- [ ] Đã uncomment code tạo cảnh báo trong AlertService
- [ ] Đã uncomment API endpoints trong AlertController
- [ ] Đã bật @Service trong EmailService
- [ ] Đã xóa early return trong EmailService.sendAlertEmail()
- [ ] Đã uncomment code gửi email trong EmailService
- [ ] Đã uncomment email config trong application-prod.properties
- [ ] Đã uncomment và set MAIL_* trong docker-compose.yml
- [ ] Đã rebuild backend: `docker-compose up -d --build backend`
- [ ] Đã kiểm tra logs và thấy "🔄 Bắt đầu tạo alerts"
- [ ] Đã test tạo cảnh báo thủ công: `curl -X POST http://your-vps-ip:8080/api/alerts/generate/now`
- [ ] Đã kiểm tra email được gửi (nếu có cảnh báo critical)

---

## 🆘 TROUBLESHOOTING

### Alert không được tạo:

1. **Kiểm tra @Scheduled đã được uncomment:**
   ```bash
   grep "@Scheduled" demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java
   ```

2. **Kiểm tra early return đã bị xóa:**
   ```bash
   grep "return alerts;" demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java
   # Không nên thấy dòng này (hoặc đã bị comment)
   ```

3. **Kiểm tra logs:**
   ```bash
   docker-compose logs backend | grep -i alert
   ```

4. **Restart backend:**
   ```bash
   docker-compose restart backend
   ```

### Email không gửi được:

1. **Kiểm tra EmailService đã được bật:**
   ```bash
   grep "@Service" demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java
   # Phải thấy: @Service (không có //)
   ```

2. **Kiểm tra MAIL_* trong docker-compose.yml:**
   ```bash
   grep "MAIL_" docker-compose.yml
   # Phải thấy các dòng không có #
   ```

3. **Kiểm tra Gmail App Password:**
   - Đảm bảo đã tạo App Password từ Gmail
   - Sử dụng App Password, không phải password thường

4. **Kiểm tra logs:**
   ```bash
   docker-compose logs backend | grep -i mail
   ```

### Backend không start:

1. **Kiểm tra syntax errors:**
   ```bash
   docker-compose logs backend | grep -i error
   ```

2. **Rebuild từ đầu:**
   ```bash
   docker-compose stop backend
   docker-compose rm -f backend
   docker-compose up -d --build backend
   ```

---

## 📞 LIÊN HỆ

Nếu gặp vấn đề, kiểm tra:
1. Logs: `docker-compose logs -f backend`
2. File đã được sửa đúng chưa
3. Đã rebuild backend chưa

---

**Chúc bạn thi tốt! 🎉**

