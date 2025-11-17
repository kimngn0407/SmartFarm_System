-- Kiểm tra tên bảng thực tế trong database
-- Chạy: docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < check_table_names.sql

-- 1. Xem tất cả bảng có chứa "sensor"
SELECT table_name, table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND (table_name ILIKE '%sensor%')
ORDER BY table_name;

-- 2. Kiểm tra cả lowercase và uppercase
SELECT 
    CASE 
        WHEN table_name = 'sensor_data' THEN 'Lowercase: sensor_data'
        WHEN table_name = 'Sensor_data' THEN 'Uppercase: Sensor_data'
        ELSE 'Other: ' || table_name
    END as table_name_status,
    table_name
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('sensor_data', 'Sensor_data', 'sensor', 'Sensor');

-- 3. Test query với cả 2 tên
SELECT 'Testing sensor_data (lowercase)' as test;
SELECT COUNT(*) FROM sensor_data;

SELECT 'Testing "Sensor_data" (uppercase with quotes)' as test;
SELECT COUNT(*) FROM "Sensor_data";

