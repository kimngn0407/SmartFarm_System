-- Kiểm tra các bảng có sẵn trong database
-- Chạy: docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < check_database_tables.sql

-- 1. Liệt kê tất cả các bảng
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2. Kiểm tra bảng sensor (các biến thể tên)
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name ILIKE '%sensor%'
ORDER BY table_name;

-- 3. Kiểm tra bảng sensor_data (các biến thể tên)
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND (table_name ILIKE '%sensor%data%' OR table_name ILIKE '%sensor_data%')
ORDER BY table_name;

-- 4. Xem tất cả các bảng và số dòng
SELECT 
    schemaname,
    tablename,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.tablename) as column_count
FROM pg_tables t
WHERE schemaname = 'public'
ORDER BY tablename;

