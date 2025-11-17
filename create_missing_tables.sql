-- Script tạo bảng Sensor và Sensor_data nếu chưa có
-- Chạy: docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < create_missing_tables.sql

-- Kiểm tra và tạo bảng Sensor (với quotes để case-sensitive)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Sensor') THEN
        CREATE TABLE "Sensor" (
            id BIGSERIAL PRIMARY KEY,
            farm_id BIGINT,
            field_id BIGINT,
            "sensor_name" VARCHAR(255),
            lat DOUBLE PRECISION,
            lng DOUBLE PRECISION,
            "point_order" INTEGER,
            status VARCHAR(255) DEFAULT 'Active',
            type VARCHAR(255),
            installation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            CONSTRAINT sensor_status_check CHECK (status IN ('Active', 'Inactive', 'Under_Maintenance')),
            CONSTRAINT sensor_type_check CHECK (type IN ('Temperature', 'Humidity', 'Soil Moisture', 'Light'))
        );
        
        -- Tạo sequence
        CREATE SEQUENCE IF NOT EXISTS sensor_id_seq;
        ALTER TABLE "Sensor" ALTER COLUMN id SET DEFAULT nextval('sensor_id_seq');
        ALTER SEQUENCE sensor_id_seq OWNED BY "Sensor".id;
        
        RAISE NOTICE 'Table Sensor created successfully';
    ELSE
        RAISE NOTICE 'Table Sensor already exists';
    END IF;
END $$;

-- Kiểm tra và tạo bảng Sensor_data
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Sensor_data') THEN
        CREATE TABLE "Sensor_data" (
            id BIGSERIAL PRIMARY KEY,
            sensor_id BIGINT,
            value DOUBLE PRECISION NOT NULL,
            "time" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            CONSTRAINT fk_sensor_data_sensor FOREIGN KEY (sensor_id) REFERENCES "Sensor"(id) ON DELETE CASCADE
        );
        
        -- Tạo sequence
        CREATE SEQUENCE IF NOT EXISTS sensor_data_id_seq;
        ALTER TABLE "Sensor_data" ALTER COLUMN id SET DEFAULT nextval('sensor_data_id_seq');
        ALTER SEQUENCE sensor_data_id_seq OWNED BY "Sensor_data".id;
        
        -- Tạo indexes
        CREATE INDEX IF NOT EXISTS idx_sensor_data_sensor_id ON "Sensor_data"(sensor_id);
        CREATE INDEX IF NOT EXISTS idx_sensor_data_time ON "Sensor_data"("time");
        CREATE INDEX IF NOT EXISTS idx_sensor_type ON "Sensor"(type);
        CREATE INDEX IF NOT EXISTS idx_sensor_field_id ON "Sensor"(field_id);
        
        RAISE NOTICE 'Table Sensor_data created successfully';
    ELSE
        RAISE NOTICE 'Table Sensor_data already exists';
    END IF;
END $$;

-- Kiểm tra lại
SELECT 'Sensor' as table_name, COUNT(*) as row_count FROM "Sensor"
UNION ALL
SELECT 'Sensor_data', COUNT(*) FROM "Sensor_data";

-- Hiển thị thông tin bảng
SELECT 
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
AND table_name IN ('Sensor', 'Sensor_data')
ORDER BY table_name;

