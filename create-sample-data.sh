#!/bin/bash

# Script tạo dữ liệu mẫu cho SmartFarm
# Chạy trên VPS

echo "🌾 Tạo dữ liệu mẫu cho SmartFarm..."
echo ""

# Lấy database container
DB_CONTAINER=$(docker compose ps -q postgres 2>/dev/null || docker compose ps -q db 2>/dev/null)

if [ -z "$DB_CONTAINER" ]; then
    echo "❌ Không tìm thấy PostgreSQL container"
    exit 1
fi

echo "📦 PostgreSQL container: $DB_CONTAINER"
echo ""

# Kiểm tra xem có account nào không
ACCOUNT_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d smartfarm -t -c "SELECT COUNT(*) FROM account;" 2>/dev/null | xargs)

if [ "$ACCOUNT_COUNT" -eq "0" ]; then
    echo "⚠️  Không có account nào trong database!"
    echo "   Vui lòng đăng ký tài khoản trước khi chạy script này."
    exit 1
fi

echo "✅ Tìm thấy $ACCOUNT_COUNT account(s)"
echo ""

# Lấy account_id đầu tiên (thường là admin)
FIRST_ACCOUNT_ID=$(docker exec $DB_CONTAINER psql -U postgres -d smartfarm -t -c "SELECT id FROM account LIMIT 1;" 2>/dev/null | xargs)

echo "🔍 Sử dụng account_id: $FIRST_ACCOUNT_ID"
echo ""

# Tạo dữ liệu mẫu
echo "📝 Đang tạo dữ liệu mẫu..."

docker exec -i $DB_CONTAINER psql -U postgres -d smartfarm <<EOF

-- 1. Tạo Farm mẫu
INSERT INTO "Farm" (farm_name, owner_id, area, region, lat, lng)
VALUES 
    ('Nông trại Đà Lạt', $FIRST_ACCOUNT_ID, 5000.0, 'Đà Lạt, Lâm Đồng', 11.9404, 108.4583),
    ('Nông trại Tây Nguyên', $FIRST_ACCOUNT_ID, 3000.0, 'Buôn Ma Thuột, Đắk Lắk', 12.6667, 108.0500)
ON CONFLICT DO NOTHING;

-- 2. Tạo Field mẫu
INSERT INTO "Field" (field_name, farm_id, status, area, region, date_created)
SELECT 
    'Cánh đồng lúa số 1', f.id, 'GOOD', 1000.0, 'Đà Lạt, Lâm Đồng', CURRENT_TIMESTAMP
FROM "Farm" f WHERE f.farm_name = 'Nông trại Đà Lạt'
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO "Field" (field_name, farm_id, status, area, region, date_created)
SELECT 
    'Cánh đồng rau số 1', f.id, 'GOOD', 800.0, 'Đà Lạt, Lâm Đồng', CURRENT_TIMESTAMP
FROM "Farm" f WHERE f.farm_name = 'Nông trại Đà Lạt'
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO "Field" (field_name, farm_id, status, area, region, date_created)
SELECT 
    'Cánh đồng cà phê số 1', f.id, 'GOOD', 1200.0, 'Buôn Ma Thuột, Đắk Lắk', CURRENT_TIMESTAMP
FROM "Farm" f WHERE f.farm_name = 'Nông trại Tây Nguyên'
LIMIT 1
ON CONFLICT DO NOTHING;

-- 3. Tạo Sensor mẫu
INSERT INTO "Sensor" (sensor_name, field_id, type, status, lat, lng)
SELECT 
    'Cảm biến nhiệt độ 1', f.id, 'temperature', 'active', 11.9404, 108.4583
FROM "Field" f WHERE f.field_name = 'Cánh đồng lúa số 1'
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO "Sensor" (sensor_name, field_id, type, status, lat, lng)
SELECT 
    'Cảm biến độ ẩm 1', f.id, 'humidity', 'active', 11.9404, 108.4583
FROM "Field" f WHERE f.field_name = 'Cánh đồng lúa số 1'
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO "Sensor" (sensor_name, field_id, type, status, lat, lng)
SELECT 
    'Cảm biến độ ẩm đất 1', f.id, 'soil', 'active', 11.9404, 108.4583
FROM "Field" f WHERE f.field_name = 'Cánh đồng lúa số 1'
LIMIT 1
ON CONFLICT DO NOTHING;

-- 4. Tạo Sensor Data mẫu
INSERT INTO "SensorData" (sensor_id, temperature, humidity, soil_moisture, light, "time")
SELECT 
    s.id, 25.5, 65.0, 45.0, 800.0, CURRENT_TIMESTAMP - INTERVAL '1 hour'
FROM "Sensor" s WHERE s.sensor_name = 'Cảm biến nhiệt độ 1'
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO "SensorData" (sensor_id, temperature, humidity, soil_moisture, light, "time")
SELECT 
    s.id, 26.0, 66.0, 46.0, 850.0, CURRENT_TIMESTAMP
FROM "Sensor" s WHERE s.sensor_name = 'Cảm biến nhiệt độ 1'
LIMIT 1
ON CONFLICT DO NOTHING;

-- 5. Kiểm tra dữ liệu
SELECT 'Farms:' as info, COUNT(*) as count FROM "Farm";
SELECT 'Fields:' as info, COUNT(*) as count FROM "Field";
SELECT 'Sensors:' as info, COUNT(*) as count FROM "Sensor";
SELECT 'Sensor Data:' as info, COUNT(*) as count FROM "SensorData";

EOF

echo ""
echo "✅ Dữ liệu mẫu đã được tạo!"
echo ""
echo "🧪 Kiểm tra lại:"
echo "   - Mở Dashboard: http://173.249.48.25/dashboard"
echo "   - Sẽ thấy Farms, Fields, và Sensors data"

