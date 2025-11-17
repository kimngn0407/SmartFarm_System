-- Script tạo sensors mẫu cho SmartFarm
-- Chạy trên VPS: docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < create_test_sensors.sql

-- Kiểm tra xem đã có sensors chưa
SELECT id, "sensor_name", type, status FROM "Sensor" WHERE type IN ('Temperature', 'Humidity', 'Soil Moisture', 'Light');

-- Tạo sensors nếu chưa có (cần có field_id và farm_id)
-- LƯU Ý: Cần thay field_id và farm_id bằng ID thật trong database của bạn

-- Lấy field_id và farm_id đầu tiên
DO $$
DECLARE
    v_field_id BIGINT;
    v_farm_id BIGINT;
BEGIN
    -- Lấy field_id đầu tiên
    SELECT id INTO v_field_id FROM "Field" LIMIT 1;
    
    -- Lấy farm_id đầu tiên
    SELECT id INTO v_farm_id FROM "Farm" LIMIT 1;
    
    -- Nếu không có field hoặc farm, tạo mẫu
    IF v_field_id IS NULL THEN
        -- Tạo farm mẫu
        INSERT INTO "Farm" (farm_name, owner_id, area, region, created_at)
        VALUES ('Test Farm', 1, 1000, 'Test Region', NOW())
        RETURNING id INTO v_farm_id;
        
        -- Tạo field mẫu
        INSERT INTO "Field" (farm_id, name, area, location, created_at)
        VALUES (v_farm_id, 'Test Field', 500, 'Test Location', NOW())
        RETURNING id INTO v_field_id;
    END IF;
    
    -- Tạo sensors nếu chưa có
    IF NOT EXISTS (SELECT 1 FROM "Sensor" WHERE type = 'Temperature' AND farm_id = v_farm_id) THEN
        INSERT INTO "Sensor" (farm_id, field_id, "sensor_name", lat, lng, type, status, installation_date, point_order)
        VALUES (v_farm_id, v_field_id, 'Temperature Sensor', 10.0, 106.0, 'Temperature', 'Active', NOW(), 1);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "Sensor" WHERE type = 'Humidity' AND farm_id = v_farm_id) THEN
        INSERT INTO "Sensor" (farm_id, field_id, "sensor_name", lat, lng, type, status, installation_date, point_order)
        VALUES (v_farm_id, v_field_id, 'Humidity Sensor', 10.0, 106.0, 'Humidity', 'Active', NOW(), 2);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "Sensor" WHERE type = 'Soil Moisture' AND farm_id = v_farm_id) THEN
        INSERT INTO "Sensor" (farm_id, field_id, "sensor_name", lat, lng, type, status, installation_date, point_order)
        VALUES (v_farm_id, v_field_id, 'Soil Moisture Sensor', 10.0, 106.0, 'Soil Moisture', 'Active', NOW(), 3);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM "Sensor" WHERE type = 'Light' AND farm_id = v_farm_id) THEN
        INSERT INTO "Sensor" (farm_id, field_id, "sensor_name", lat, lng, type, status, installation_date, point_order)
        VALUES (v_farm_id, v_field_id, 'Light Sensor', 10.0, 106.0, 'Light', 'Active', NOW(), 4);
    END IF;
    
    RAISE NOTICE 'Sensors created successfully!';
    RAISE NOTICE 'Farm ID: %, Field ID: %', v_farm_id, v_field_id;
END $$;

-- Kiểm tra lại
SELECT id, "sensor_name", type, status, farm_id, field_id FROM "Sensor" WHERE type IN ('Temperature', 'Humidity', 'Soil Moisture', 'Light');

