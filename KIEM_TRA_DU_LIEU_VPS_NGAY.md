# 🔍 Kiểm Tra Dữ Liệu Trên VPS - Ngay Bây Giờ

## ✅ Cách 1: Kiểm Tra Database Trực Tiếp (Chắc Chắn Nhất!)

### Nếu Dùng Docker Compose:

```bash
cd /opt/SmartFarm

# Kiểm tra database qua Docker
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;"

# Hoặc kết nối vào PostgreSQL
docker compose exec postgres psql -U postgres -d SmartFarm1

# Trong psql:
SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;
SELECT sensor_id, value, time FROM sensor_data WHERE sensor_id = 1 ORDER BY time DESC LIMIT 5;
```

### Nếu Không Dùng Docker:

```bash
# Kết nối PostgreSQL trực tiếp
sudo -u postgres psql

# Hoặc
psql -U postgres -d SmartFarm1

# Trong psql:
SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;
```

---

## ✅ Cách 2: Kiểm Tra Logs Docker Compose

```bash
cd /opt/SmartFarm

# Xem logs backend (Spring Boot)
docker compose logs backend --tail=50

# Xem logs realtime
docker compose logs -f backend

# Tìm POST request
docker compose logs backend | grep "POST /api/sensor-data/iot" | tail -20
```

---

## ✅ Cách 3: Kiểm Tra Qua API

```bash
# Kiểm tra dữ liệu mới nhất
curl http://localhost:8080/api/sensor-data/latest/1
curl http://localhost:8080/api/sensor-data/latest/2
curl http://localhost:8080/api/sensor-data/latest/3
curl http://109.205.180.72:8080/api/sensor-data/latest/4
```

---

## ✅ Cách 4: Kiểm Tra Nginx Logs

```bash
# Xem access log
tail -f /var/log/nginx/access.log

# Tìm POST request
grep "POST /api/sensor-data/iot" /var/log/nginx/access.log | tail -20
```

---

## 🎯 Lệnh Nhanh (Copy & Paste)

```bash
# 1. Kiểm tra database
cd /opt/SmartFarm
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT sensor_id, value, time FROM sensor_data ORDER BY time DESC LIMIT 10;"

# 2. Xem logs backend
docker compose logs backend --tail=30 | grep -i sensor

# 3. Kiểm tra API
curl http://localhost:8080/api/sensor-data/latest/1
```

---

**Hãy chạy lệnh kiểm tra database trước - Đây là cách chắc chắn nhất!** 🔍✨
