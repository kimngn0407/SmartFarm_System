# 🔧 Fix Missing Database Tables

## Vấn đề: Bảng `Sensor_data` và `Sensor` không tồn tại

## ✅ Giải pháp

### Bước 1: Kiểm tra các bảng có sẵn

Trên VPS, chạy:

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# Xem tất cả các bảng
\dt

# Hoặc
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

# Thoát
\q
```

### Bước 2: Kiểm tra Spring Boot có tạo bảng không

```bash
# Xem logs backend khi khởi động
docker compose logs backend | grep -i "create\|table\|schema"

# Hoặc xem toàn bộ logs
docker compose logs backend | tail -100
```

### Bước 3: Restart Backend để Spring Boot tạo bảng

Spring Boot sẽ tự động tạo bảng nếu `SPRING_JPA_HIBERNATE_DDL_AUTO=update`

```bash
# Restart backend
docker compose restart backend

# Xem logs khi khởi động
docker compose logs -f backend
```

### Bước 4: Kiểm tra lại

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# Kiểm tra bảng (PostgreSQL có thể chuyển thành lowercase)
\dt

# Hoặc thử với lowercase
SELECT * FROM sensor_data LIMIT 5;
SELECT * FROM sensor LIMIT 5;

# Hoặc với quotes (case-sensitive)
SELECT * FROM "Sensor_data" LIMIT 5;
SELECT * FROM "Sensor" LIMIT 5;
```

---

## 🔍 Nếu vẫn không có bảng

### Cách 1: Tạo bảng thủ công

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1
```

Chạy SQL:

```sql
-- Tạo bảng Sensor (nếu chưa có)
CREATE TABLE IF NOT EXISTS "Sensor" (
    id BIGSERIAL PRIMARY KEY,
    farm_id BIGINT,
    field_id BIGINT,
    "sensor_name" VARCHAR(255),
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    "point_order" INTEGER,
    status VARCHAR(255),
    type VARCHAR(255),
    installation_date TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES "Farm"(id),
    FOREIGN KEY (field_id) REFERENCES "Field"(id)
);

-- Tạo bảng Sensor_data (nếu chưa có)
CREATE TABLE IF NOT EXISTS "Sensor_data" (
    id BIGSERIAL PRIMARY KEY,
    sensor_id BIGINT,
    value DOUBLE PRECISION NOT NULL,
    "time" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensor_id) REFERENCES "Sensor"(id)
);

-- Tạo indexes
CREATE INDEX IF NOT EXISTS idx_sensor_data_sensor_id ON "Sensor_data"(sensor_id);
CREATE INDEX IF NOT EXISTS idx_sensor_data_time ON "Sensor_data"("time");
CREATE INDEX IF NOT EXISTS idx_sensor_type ON "Sensor"(type);
CREATE INDEX IF NOT EXISTS idx_sensor_field_id ON "Sensor"(field_id);
```

### Cách 2: Import từ file SQL có sẵn

```bash
# Nếu có file DB_SM_ver1.sql
cd ~/projects/SmartFarm
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < DB_SM_ver1.sql
```

---

## ✅ Sau khi có bảng

1. **Tạo sensors** (xem `create_test_sensors.sql`)
2. **Insert dữ liệu test** hoặc **gửi qua ESP32/Flask API**
3. **Kiểm tra dashboard** có hiển thị dữ liệu không

---

## 🚨 Troubleshooting

### Nếu Spring Boot không tạo bảng:

1. **Kiểm tra application.properties**:
```bash
docker exec smartfarm-backend env | grep SPRING
```

2. **Kiểm tra DDL_AUTO** phải là `update` hoặc `create`

3. **Xem logs chi tiết**:
```bash
docker compose logs backend | grep -i "error\|exception\|failed"
```

