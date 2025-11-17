# ⚡ Quick Fix - Tạo Bảng Sensor

## Vấn đề: Bảng `Sensor` và `Sensor_data` không tồn tại

## ✅ Giải pháp nhanh (chọn 1 trong 3 cách)

### Cách 1: Tạo bảng bằng script (Khuyên dùng)

```bash
# Trên VPS
cd ~/projects/SmartFarm
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < create_missing_tables.sql
```

### Cách 2: Tạo thủ công trong psql

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1
```

Sau đó copy và paste SQL này:

```sql
-- Tạo bảng Sensor
CREATE TABLE IF NOT EXISTS "Sensor" (
    id BIGSERIAL PRIMARY KEY,
    farm_id BIGINT,
    field_id BIGINT,
    "sensor_name" VARCHAR(255),
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    "point_order" INTEGER,
    status VARCHAR(255) DEFAULT 'Active',
    type VARCHAR(255),
    installation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tạo bảng Sensor_data
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
```

### Cách 3: Restart Backend để Spring Boot tạo bảng

```bash
# Restart backend (Spring Boot sẽ tạo bảng nếu DDL_AUTO=update)
docker compose restart backend

# Xem logs
docker compose logs -f backend | grep -i "create\|table"
```

---

## ✅ Kiểm tra sau khi tạo

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# Kiểm tra bảng
\dt

# Hoặc
SELECT table_name FROM information_schema.tables 
WHERE table_name IN ('Sensor', 'Sensor_data');

# Kiểm tra có dữ liệu không
SELECT COUNT(*) FROM "Sensor";
SELECT COUNT(*) FROM "Sensor_data";
```

---

## 📝 Lưu ý

- Tên bảng phải có **quotes** và **chữ hoa**: `"Sensor"` và `"Sensor_data"`
- PostgreSQL case-sensitive khi dùng quotes
- Nếu không dùng quotes, PostgreSQL sẽ chuyển thành lowercase

---

## 🚀 Bước tiếp theo

Sau khi có bảng:
1. Tạo sensors (xem `create_test_sensors.sql`)
2. Insert dữ liệu test hoặc gửi qua ESP32
3. Kiểm tra dashboard

