# 🔍 Kiểm Tra Dữ Liệu Trên VPS - Hướng Dẫn Cụ Thể

## 📊 Thông Tin Server

- **Server:** `109.205.180.72:8080`
- **API Endpoint:** `/api/sensor-data/iot`
- **Database:** PostgreSQL (có thể)

---

## ✅ Cách 1: Kiểm Tra Qua API (Dễ Nhất!)

### Kiểm Tra Dữ Liệu Mới Nhất:

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
- `http://109.205.180.72:8080/api/sensor-data/latest/1`

---

## ✅ Cách 2: Kiểm Tra Database Trực Tiếp

### Tìm File Log Spring Boot:

```bash
# Tìm file log của Spring Boot
find /opt -name "*.log" 2>/dev/null
find /var/log -name "*spring*" 2>/dev/null
find /home -name "*.log" 2>/dev/null

# Hoặc tìm trong thư mục ứng dụng
ls -la /opt/SmartFarm/*.log
ls -la /opt/SmartFarm/logs/
```

### Kiểm Tra Database PostgreSQL:

```bash
# Kết nối PostgreSQL
sudo -u postgres psql

# Hoặc nếu có user khác
psql -U username -d database_name

# Xem danh sách database
\l

# Kết nối database SmartFarm
\c smartfarm
# Hoặc tên database khác

# Xem bảng sensor_data
\dt

# Xem dữ liệu mới nhất
SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;

# Xem dữ liệu theo sensor ID
SELECT * FROM sensor_data WHERE sensor_id = 1 ORDER BY time DESC LIMIT 10;

# Đếm số lượng dữ liệu
SELECT COUNT(*) FROM sensor_data;

# Xem dữ liệu trong 1 giờ gần nhất
SELECT * FROM sensor_data 
WHERE time > NOW() - INTERVAL '1 hour' 
ORDER BY time DESC;
```

---

## ✅ Cách 3: Kiểm Tra Logs Nginx

### Xem Access Log:

```bash
# Xem access log
tail -f /var/log/nginx/access.log

# Tìm POST request đến /api/sensor-data/iot
grep "POST /api/sensor-data/iot" /var/log/nginx/access.log | tail -20

# Xem log realtime
tail -f /var/log/nginx/access.log | grep "sensor-data"
```

### Xem Error Log:

```bash
tail -f /var/log/nginx/error.log
```

---

## ✅ Cách 4: Kiểm Tra Process Spring Boot

### Tìm Process và Logs:

```bash
# Tìm process Spring Boot
ps aux | grep java
ps aux | grep spring

# Xem stdout/stderr của process (nếu chạy bằng systemd)
sudo journalctl -u smartfarm -f
# Hoặc tên service khác

# Xem tất cả logs systemd
sudo journalctl -f | grep sensor
```

---

## ✅ Cách 5: Kiểm Tra Trong Thư Mục Ứng Dụng

### Tìm Logs Trong /opt/SmartFarm:

```bash
cd /opt/SmartFarm

# Tìm file log
find . -name "*.log" -type f

# Xem cấu trúc thư mục
ls -la

# Kiểm tra file application.properties hoặc application.yml
cat application.properties | grep -i log
# Hoặc
cat application.yml | grep -i log

# Tìm thư mục logs
ls -la logs/
```

---

## ✅ Cách 6: Kiểm Tra Database Qua psql

### Nếu Biết Thông Tin Database:

```bash
# Kết nối PostgreSQL
sudo -u postgres psql

# Hoặc với user khác
psql -U postgres -d smartfarm

# Trong psql:
-- Xem tất cả bảng
\dt

-- Xem cấu trúc bảng sensor_data
\d sensor_data

-- Xem dữ liệu mới nhất (10 dòng)
SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;

-- Xem dữ liệu theo sensor ID
SELECT sensor_id, value, time 
FROM sensor_data 
WHERE sensor_id = 1 
ORDER BY time DESC 
LIMIT 10;

-- Đếm số lượng dữ liệu mỗi sensor
SELECT sensor_id, COUNT(*) 
FROM sensor_data 
GROUP BY sensor_id;

-- Xem dữ liệu trong 10 phút gần nhất
SELECT * FROM sensor_data 
WHERE time > NOW() - INTERVAL '10 minutes' 
ORDER BY time DESC;
```

---

## 🔍 Checklist Kiểm Tra

- [ ] API endpoint trả về dữ liệu: `curl http://109.205.180.72:8080/api/sensor-data/latest/1`
- [ ] Database có dữ liệu mới: `SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;`
- [ ] Nginx logs có POST request: `grep "POST /api/sensor-data/iot" /var/log/nginx/access.log`
- [ ] ESP32 Serial Monitor hiển thị: `✅ Đã gửi xong!`

---

## 🆘 Nếu Không Tìm Thấy Logs

### Tìm Logs Spring Boot:

```bash
# Tìm trong thư mục home
find ~ -name "*.log" 2>/dev/null

# Tìm trong /var/log
sudo find /var/log -name "*app*" -o -name "*spring*" 2>/dev/null

# Xem systemd service logs
sudo systemctl status smartfarm
sudo journalctl -u smartfarm -n 50

# Hoặc tìm service name
sudo systemctl list-units | grep -i smart
sudo systemctl list-units | grep -i farm
```

---

## 💡 Lưu Ý

**Thời gian gửi:**
- ESP32 gửi mỗi **60 giây** (1 phút)
- Phải đợi ít nhất 1 phút để thấy dữ liệu mới

**Kiểm tra database:**
- Xem timestamp trong database
- So sánh với thời gian hiện tại
- Nếu cách quá xa → ESP32 có thể không gửi được

---

**Hãy thử kiểm tra database trực tiếp (Cách 2) - Đây là cách chắc chắn nhất!** 🔍✨
