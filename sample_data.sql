-- Sample Data for Smart Farm Production Database
-- Run this on Railway PostgreSQL to populate database

-- Note: Adjust IDs and foreign keys as needed

-- 1. Insert sample farms
INSERT INTO farms (id, name, location, area, description, created_at, updated_at) 
VALUES 
(1, 'Nông Trại Đà Lạt', 'Đà Lạt, Lâm Đồng', 50000, 'Nông trại trồng rau sạch', NOW(), NOW()),
(2, 'Vườn Hoa Hồng', 'Đà Lạt, Lâm Đồng', 30000, 'Chuyên trồng hoa hồng', NOW(), NOW()),
(3, 'Nông Trại Cà Phê', 'Buôn Ma Thuột, Đắk Lắk', 100000, 'Trồng cà phê arabica', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- 2. Insert sample fields
INSERT INTO fields (id, farm_id, name, area, soil_type, created_at, updated_at)
VALUES
(1, 1, 'Ruộng A1', 5000, 'Đất phù sa', NOW(), NOW()),
(2, 1, 'Ruộng A2', 5000, 'Đất phù sa', NOW(), NOW()),
(3, 2, 'Vườn Hoa 1', 10000, 'Đất bazan', NOW(), NOW()),
(4, 3, 'Vườn Cà Phê 1', 50000, 'Đất đỏ bazan', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- 3. Insert sample sensors
INSERT INTO sensors (id, field_id, sensor_type, name, status, created_at, updated_at)
VALUES
(1, 1, 'TEMPERATURE', 'Cảm biến nhiệt độ A1', 'ACTIVE', NOW(), NOW()),
(2, 1, 'HUMIDITY', 'Cảm biến độ ẩm A1', 'ACTIVE', NOW(), NOW()),
(3, 2, 'TEMPERATURE', 'Cảm biến nhiệt độ A2', 'ACTIVE', NOW(), NOW()),
(4, 3, 'SOIL_MOISTURE', 'Cảm biến độ ẩm đất Vườn Hoa', 'ACTIVE', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- 4. Insert sample plants/crops
INSERT INTO plants (id, field_id, name, variety, planted_date, expected_harvest_date, status, created_at, updated_at)
VALUES
(1, 1, 'Rau Xà Lách', 'Xà lách xoăn', '2024-01-15', '2024-03-15', 'GROWING', NOW(), NOW()),
(2, 2, 'Cà Chua', 'Cà chua bi', '2024-02-01', '2024-05-01', 'GROWING', NOW(), NOW()),
(3, 3, 'Hoa Hồng', 'Hồng Đà Lạt', '2023-06-01', NULL, 'MATURE', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- 5. Insert sample sensor data (last 24 hours)
INSERT INTO sensor_data (sensor_id, temperature, humidity, soil_moisture, light_intensity, timestamp)
SELECT 
    1 as sensor_id,
    20 + (random() * 10)::numeric(5,2) as temperature,
    60 + (random() * 20)::numeric(5,2) as humidity,
    NULL as soil_moisture,
    800 + (random() * 400)::numeric(7,2) as light_intensity,
    NOW() - (n || ' hours')::interval as timestamp
FROM generate_series(1, 24) n
ON CONFLICT DO NOTHING;

-- 6. Reset sequences (important!)
SELECT setval('farms_id_seq', (SELECT MAX(id) FROM farms));
SELECT setval('fields_id_seq', (SELECT MAX(id) FROM fields));
SELECT setval('sensors_id_seq', (SELECT MAX(id) FROM sensors));
SELECT setval('plants_id_seq', (SELECT MAX(id) FROM plants));

-- 7. Verify data
SELECT 'Farms:' as table_name, COUNT(*) as count FROM farms
UNION ALL
SELECT 'Fields:', COUNT(*) FROM fields
UNION ALL
SELECT 'Sensors:', COUNT(*) FROM sensors
UNION ALL
SELECT 'Plants:', COUNT(*) FROM plants
UNION ALL
SELECT 'Sensor Data:', COUNT(*) FROM sensor_data;

-- Done!


