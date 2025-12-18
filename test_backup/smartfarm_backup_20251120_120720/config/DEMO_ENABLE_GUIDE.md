# 🎯 Hướng Dẫn Bật Lại Hệ Thống Cảnh Báo và Email - Cho Ngày Thi

> **Lưu ý:** File này hướng dẫn cách bật lại hệ thống cảnh báo tự động và email để trình bày trong cuộc thi.

---

## 📋 Tổng Quan

Hiện tại hệ thống đã được tắt:
- ✅ **Tự động tạo cảnh báo** (Alert Scheduler) - Đã tắt
- ✅ **Gửi email cảnh báo** (Email Service) - Đã tắt

---

## 🚀 Các Bước Bật Lại

### **Bước 1: Bật Tự Động Tạo Cảnh Báo**

#### 1.1. Trên Local (để test trước):

1. Mở file: `demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java`

2. Tìm dòng này (khoảng dòng 33):
   ```java
   // @Scheduled(fixedRate = 300000) // 5 phút = 300000 milliseconds - ĐÃ TẮT
   ```

3. **Uncomment** dòng đó thành:
   ```java
   @Scheduled(fixedRate = 300000) // 5 phút = 300000 milliseconds
   ```

4. Xóa comment "ĐÃ TẮT" và comment cảnh báo phía trên nếu muốn:
   ```java
   /**
    * Tự động tạo alerts từ dữ liệu sensor mới nhất
    * Chạy mỗi 5 phút (300000 milliseconds)
    */
   @Scheduled(fixedRate = 300000) // 5 phút = 300000 milliseconds
   public void generateAlertsFromLatestSensorData() {
   ```

#### 1.2. Trên VPS:

**Cách 1: Sửa trực tiếp trên VPS (nhanh)**

```bash
# SSH vào VPS
ssh root@your-vps-ip

# Vào thư mục project
cd ~/projects/SmartFarm

# Sửa file AlertSchedulerService.java
nano demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java

# Tìm dòng có "ĐÃ TẮT" và uncomment @Scheduled
# Sau đó lưu (Ctrl+O, Enter, Ctrl+X)

# Rebuild backend service
docker-compose restart backend
# Hoặc rebuild hoàn toàn:
docker-compose up -d --build backend
```

**Cách 2: Pull code từ Git (nếu đã commit và push)**

```bash
# SSH vào VPS
ssh root@your-vps-ip

# Vào thư mục project
cd ~/projects/SmartFarm

# Pull code mới nhất
git pull origin main

# Rebuild backend service
docker-compose up -d --build backend
```

---

### **Bước 2: Bật Gửi Email Cảnh Báo**

#### 2.1. Trên Local (để test trước):

1. Mở file: `docker-compose.yml`

2. Tìm section `backend` → `environment` (khoảng dòng 39-44)

3. **Uncomment** các dòng email và điền thông tin:
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

#### 2.2. Trên VPS:

**Cách 1: Sửa trực tiếp trên VPS (nhanh)**

```bash
# SSH vào VPS
ssh root@your-vps-ip

# Vào thư mục project
cd ~/projects/SmartFarm

# Sửa file docker-compose.yml
nano docker-compose.yml

# Tìm section backend → environment
# Uncomment và điền thông tin email:
#   MAIL_HOST: smtp.gmail.com
#   MAIL_PORT: 587
#   MAIL_USERNAME: lovengan0407@gmail.com
#   MAIL_PASSWORD: bjjd yvqw rrmq dicg
#   MAIL_FROM: alerts@smartfarm.com

# Lưu file (Ctrl+O, Enter, Ctrl+X)

# Restart backend service để áp dụng thay đổi
docker-compose restart backend
```

**Cách 2: Sử dụng sed (nhanh hơn)**

```bash
# SSH vào VPS
ssh root@your-vps-ip

# Vào thư mục project
cd ~/projects/SmartFarm

# Uncomment và set các biến email
sed -i 's/# MAIL_HOST: ${MAIL_HOST:-}/MAIL_HOST: smtp.gmail.com/' docker-compose.yml
sed -i 's/# MAIL_PORT: ${MAIL_PORT:-587}/MAIL_PORT: 587/' docker-compose.yml
sed -i 's/# MAIL_USERNAME: ${MAIL_USERNAME:-}/MAIL_USERNAME: lovengan0407@gmail.com/' docker-compose.yml
sed -i 's/# MAIL_PASSWORD: ${MAIL_PASSWORD:-}/MAIL_PASSWORD: bjjd yvqw rrmq dicg/' docker-compose.yml
sed -i 's/# MAIL_FROM: ${MAIL_FROM:-alerts@smartfarm.com}/MAIL_FROM: alerts@smartfarm.com/' docker-compose.yml

# Restart backend
docker-compose restart backend
```

---

## ✅ Kiểm Tra Sau Khi Bật

### 1. Kiểm Tra Alert Scheduler:

```bash
# Xem logs của backend
docker-compose logs -f backend

# Tìm dòng có "🔄 Bắt đầu tạo alerts từ dữ liệu sensor mới nhất..."
# Nếu thấy dòng này mỗi 5 phút → Alert Scheduler đã hoạt động ✅
```

### 2. Kiểm Tra Email Service:

```bash
# Xem logs của backend
docker-compose logs -f backend

# Tìm dòng có "Alert email sent to ..."
# Hoặc kiểm tra email inbox của lovengan0407@gmail.com
```

### 3. Kiểm Tra Qua API (Optional):

```bash
# Trigger tạo alerts thủ công
curl -X POST http://your-vps-ip/api/alerts/generate/now

# Xem danh sách alerts
curl http://your-vps-ip/api/alerts
```

---

## 🔄 Quy Trình Nhanh Cho Ngày Thi

### **Trước khi thi (5-10 phút):**

```bash
# 1. SSH vào VPS
ssh root@your-vps-ip
cd ~/projects/SmartFarm

# 2. Bật Alert Scheduler
sed -i 's|// @Scheduled(fixedRate = 300000)|@Scheduled(fixedRate = 300000)|' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java

# 3. Bật Email (nếu cần)
sed -i 's/# MAIL_HOST:/MAIL_HOST:/' docker-compose.yml
sed -i 's/# MAIL_PORT:/MAIL_PORT:/' docker-compose.yml
sed -i 's/# MAIL_USERNAME:/MAIL_USERNAME:/' docker-compose.yml
sed -i 's/# MAIL_PASSWORD:/MAIL_PASSWORD:/' docker-compose.yml
sed -i 's/# MAIL_FROM:/MAIL_FROM:/' docker-compose.yml

# 4. Rebuild và restart
docker-compose up -d --build backend

# 5. Kiểm tra logs
docker-compose logs -f backend
```

### **Sau khi thi (tắt lại):**

```bash
# 1. Tắt Alert Scheduler
sed -i 's|@Scheduled(fixedRate = 300000)|// @Scheduled(fixedRate = 300000) // ĐÃ TẮT|' \
  demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java

# 2. Tắt Email
sed -i 's/^      MAIL_HOST:/      # MAIL_HOST:/' docker-compose.yml
sed -i 's/^      MAIL_PORT:/      # MAIL_PORT:/' docker-compose.yml
sed -i 's/^      MAIL_USERNAME:/      # MAIL_USERNAME:/' docker-compose.yml
sed -i 's/^      MAIL_PASSWORD:/      # MAIL_PASSWORD:/' docker-compose.yml
sed -i 's/^      MAIL_FROM:/      # MAIL_FROM:/' docker-compose.yml

# 3. Restart
docker-compose restart backend
```

---

## 📝 Lưu Ý Quan Trọng

1. **Alert Scheduler** chạy mỗi 5 phút, nên cần đợi tối đa 5 phút để thấy alerts mới được tạo.

2. **Email Service** chỉ hoạt động khi có cấu hình `MAIL_HOST` trong `docker-compose.yml`. Nếu không set, service sẽ không được tạo và không gây lỗi.

3. **Gmail App Password**: Đảm bảo đã tạo App Password từ Gmail và sử dụng đúng password (không phải password thường).

4. **Test trước khi thi**: Nên test trên local hoặc VPS trước ngày thi để đảm bảo mọi thứ hoạt động.

5. **Backup**: Trước khi sửa, nên backup file hoặc commit code hiện tại:
   ```bash
   git add .
   git commit -m "Backup before enabling alerts for demo"
   ```

---

## 🆘 Troubleshooting

### Alert không được tạo:

- Kiểm tra logs: `docker-compose logs backend | grep -i alert`
- Kiểm tra database có dữ liệu sensor không
- Kiểm tra `@Scheduled` đã được uncomment chưa
- Restart backend: `docker-compose restart backend`

### Email không gửi được:

- Kiểm tra logs: `docker-compose logs backend | grep -i mail`
- Kiểm tra Gmail App Password có đúng không
- Kiểm tra `MAIL_HOST`, `MAIL_PORT` có đúng không
- Kiểm tra firewall có chặn port 587 không

### Backend không start:

- Kiểm tra logs: `docker-compose logs backend`
- Kiểm tra syntax trong `docker-compose.yml`
- Rebuild: `docker-compose up -d --build backend`

---

## 📞 Liên Hệ

Nếu gặp vấn đề, kiểm tra:
1. Logs của backend: `docker-compose logs -f backend`
2. Status của services: `docker-compose ps`
3. Database connection: `docker-compose exec postgres psql -U postgres -d SmartFarm1`

---

**Chúc bạn trình bày thành công! 🎉**

