# 🔍 Kiểm Tra Dữ Liệu Trên VPS

## 📊 Thông Tin Server

- **Server URL:** `http://109.205.180.72:8080/api/sensor-data/iot`
- **Dữ liệu gửi:** Temperature, Humidity, Soil, Light
- **Tần suất:** Mỗi 60 giây (1 phút)

---

## ✅ Cách 1: Kiểm Tra Qua API (Dễ Nhất!)

### Bước 1: Kiểm Tra Dữ Liệu Mới Nhất

**Endpoint:** `GET /api/sensor-data/latest/{sensorId}`

**Kiểm tra từng sensor:**

```bash
# Temperature (Sensor ID = 1)
curl http://109.205.180.72:8080/api/sensor-data/latest/1

# Humidity (Sensor ID = 2)
curl http://109.205.180.72:8080/api/sensor-data/latest/2

# Soil (Sensor ID = 3)
curl http://109.205.180.72:8080/api/sensor-data/latest/3

# Light (Sensor ID = 4)
curl http://109.205.180.72:8080/api/sensor-data/latest/4
```

**Hoặc mở trình duyệt:**
- `http://109.205.180.72:8080/api/sensor-data/latest/1` (Temperature)
- `http://109.205.180.72:8080/api/sensor-data/latest/2` (Humidity)
- `http://109.205.180.72:8080/api/sensor-data/latest/3` (Soil)
- `http://109.205.180.72:8080/api/sensor-data/latest/4` (Light)

### Bước 2: Kiểm Tra Dữ Liệu Theo Khoảng Thời Gian

**Endpoint:** `GET /api/sensor-data?sensorId={id}&from={time}&to={time}`

**Ví dụ:**
```bash
# Lấy dữ liệu 1 giờ gần nhất
curl "http://109.205.180.72:8080/api/sensor-data?sensorId=1&from=2024-12-20T09:00:00Z&to=2024-12-20T10:00:00Z"
```

---

## ✅ Cách 2: Kiểm Tra Database Trực Tiếp

### Nếu Có Quyền Truy Cập VPS:

**SSH vào VPS:**
```bash
ssh user@109.205.180.72
```

**Kiểm tra database (tùy loại database):**

#### Nếu dùng MySQL/MariaDB:
```sql
-- Kết nối database
mysql -u username -p database_name

-- Xem bảng sensor data
SHOW TABLES;

-- Xem dữ liệu mới nhất
SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;

-- Đếm số lượng dữ liệu
SELECT COUNT(*) FROM sensor_data;

-- Xem dữ liệu theo sensor ID
SELECT * FROM sensor_data WHERE sensor_id = 1 ORDER BY time DESC LIMIT 10;
```

#### Nếu dùng PostgreSQL:
```sql
-- Kết nối database
psql -U username -d database_name

-- Xem dữ liệu mới nhất
SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;
```

#### Nếu dùng MongoDB:
```javascript
// Kết nối MongoDB
mongo

// Xem collection
use database_name
db.sensor_data.find().sort({time: -1}).limit(10)
```

---

## ✅ Cách 3: Kiểm Tra Logs Trên Server

### Xem Logs Ứng Dụng:

**Nếu dùng Nginx:**
```bash
# Xem access log
tail -f /var/log/nginx/access.log

# Xem error log
tail -f /var/log/nginx/error.log
```

**Nếu dùng Application Logs:**
```bash
# Tìm file log của ứng dụng
# Thường ở: /var/log/app/ hoặc /home/user/app/logs/
tail -f /path/to/app.log
```

**Tìm log POST request:**
```bash
# Tìm POST request đến /api/sensor-data/iot
grep "POST /api/sensor-data/iot" /var/log/nginx/access.log | tail -20
```

---

## ✅ Cách 4: Kiểm Tra Từ ESP32 Serial Monitor

### Xem Thông Báo Gửi Dữ Liệu:

**Trong Serial Monitor, bạn sẽ thấy:**

**Khi gửi thành công:**
```
🚀 Gửi dữ liệu lên server...
✅ Đã gửi xong!
```

**Nếu gửi thất bại:**
- Không có thông báo "✅ Đã gửi xong!"
- Hoặc có lỗi kết nối

---

## ✅ Cách 5: Kiểm Tra Bằng Postman/HTTP Client

### Test API Endpoint:

1. **Mở Postman hoặc HTTP Client**

2. **Tạo request POST:**
   - **URL:** `http://109.205.180.72:8080/api/sensor-data/iot`
   - **Method:** POST
   - **Headers:**
     - `Content-Type: application/json`
   - **Body (JSON):**
     ```json
     {
       "sensorId": 1,
       "value": 25.5,
       "time": "2024-12-20T10:30:00Z"
     }
     ```

3. **Gửi request và xem response:**
   - **200 OK** = Thành công ✅
   - **400/500** = Lỗi ❌

---

## ✅ Cách 6: Kiểm Tra Database Qua Web Interface

### Nếu Có PhpMyAdmin hoặc Adminer:

1. **Truy cập:** `http://109.205.180.72:8080/phpmyadmin`
   - Hoặc port khác tùy cấu hình

2. **Chọn database**

3. **Xem bảng `sensor_data` hoặc tương tự**

4. **Xem dữ liệu mới nhất**

---

## 🔍 Checklist Kiểm Tra

- [ ] ESP32 Serial Monitor hiển thị: `✅ Đã gửi xong!`
- [ ] API endpoint trả về dữ liệu (nếu có GET endpoint)
- [ ] Database có dữ liệu mới (kiểm tra timestamp)
- [ ] Logs server hiển thị POST request thành công
- [ ] Không có lỗi trong logs

---

## 🆘 Nếu Không Thấy Dữ Liệu

### Kiểm Tra Từng Bước:

1. **ESP32 có gửi không?**
   - Xem Serial Monitor có `🚀 Gửi dữ liệu lên server...` không?
   - Có thông báo `✅ Đã gửi xong!` không?

2. **Server có nhận không?**
   - Xem logs server có POST request không?
   - Kiểm tra firewall/port 8080 có mở không?

3. **Database có lưu không?**
   - Kiểm tra database có dữ liệu mới không?
   - Kiểm tra timestamp có gần đây không?

---

## 💡 Lưu Ý

**Thời gian gửi:**
- ESP32 gửi dữ liệu mỗi **60 giây** (1 phút)
- Phải đợi ít nhất 1 phút để thấy dữ liệu mới

**Kiểm tra thời gian:**
- Xem timestamp trong database
- So sánh với thời gian hiện tại
- Nếu cách quá xa → Có thể ESP32 không gửi được

---

**Hãy thử Cách 1 (Kiểm tra API) hoặc Cách 2 (Kiểm tra Database) trước!** 🔍✨
