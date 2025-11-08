-- Script tạo dữ liệu mẫu cho SmartFarm
-- Chạy script này để có dữ liệu test

-- 1. Tạo Farm mẫu (cần có account với id = 1)
INSERT INTO "Farm" (farm_name, owner_id, area, region, lat, lng)
VALUES 
    ('Nông trại Đà Lạt', 1, 5000.0, 'Đà Lạt, Lâm Đồng', 11.9404, 108.4583),
    ('Nông trại Tây Nguyên', 1, 3000.0, 'Buôn Ma Thuột, Đắk Lắk', 12.6667, 108.0500)
ON CONFLICT DO NOTHING;

-- 2. Tạo Field mẫu (cần có farm_id)
INSERT INTO "Field" (field_name, farm_id, status, area, region, date_created)
VALUES 
    ('Cánh đồng lúa số 1', 1, 'GOOD', 1000.0, 'Đà Lạt, Lâm Đồng', CURRENT_TIMESTAMP),
    ('Cánh đồng rau số 1', 1, 'GOOD', 800.0, 'Đà Lạt, Lâm Đồng', CURRENT_TIMESTAMP),
    ('Cánh đồng cà phê số 1', 2, 'GOOD', 1200.0, 'Buôn Ma Thuột, Đắk Lắk', CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 3. Tạo Sensor mẫu (cần có field_id)
INSERT INTO "Sensor" (sensor_name, field_id, type, status, lat, lng)
VALUES 
    ('Cảm biến nhiệt độ 1', 1, 'temperature', 'active', 11.9404, 108.4583),
    ('Cảm biến độ ẩm 1', 1, 'humidity', 'active', 11.9404, 108.4583),
    ('Cảm biến độ ẩm đất 1', 1, 'soil', 'active', 11.9404, 108.4583),
    ('Cảm biến ánh sáng 1', 1, 'light', 'active', 11.9404, 108.4583),
    ('Cảm biến nhiệt độ 2', 2, 'temperature', 'active', 11.9404, 108.4583),
    ('Cảm biến độ ẩm 2', 2, 'humidity', 'active', 11.9404, 108.4583),
    ('Cảm biến nhiệt độ 3', 3, 'temperature', 'active', 12.6667, 108.0500),
    ('Cảm biến độ ẩm 3', 3, 'humidity', 'active', 12.6667, 108.0500)
ON CONFLICT DO NOTHING;

-- 4. Tạo Sensor Data mẫu (cần có sensor_id)
INSERT INTO "SensorData" (sensor_id, temperature, humidity, soil_moisture, light, "time")
VALUES 
    (1, 25.5, 65.0, 45.0, 800.0, CURRENT_TIMESTAMP - INTERVAL '1 hour'),
    (1, 26.0, 66.0, 46.0, 850.0, CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
    (1, 25.8, 65.5, 45.5, 820.0, CURRENT_TIMESTAMP),
    (2, 24.5, 70.0, 50.0, 750.0, CURRENT_TIMESTAMP - INTERVAL '1 hour'),
    (2, 25.0, 71.0, 51.0, 780.0, CURRENT_TIMESTAMP),
    (5, 23.0, 68.0, 48.0, 700.0, CURRENT_TIMESTAMP),
    (7, 22.5, 65.0, 42.0, 650.0, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 5. Kiểm tra dữ liệu đã tạo
SELECT 'Farms created:' as info, COUNT(*) as count FROM "Farm";
SELECT 'Fields created:' as info, COUNT(*) as count FROM "Field";
SELECT 'Sensors created:' as info, COUNT(*) as count FROM "Sensor";
SELECT 'Sensor Data created:' as info, COUNT(*) as count FROM "SensorData";

