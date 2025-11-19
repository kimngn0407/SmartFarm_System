#!/bin/bash

# Script kiểm tra dữ liệu sensor_data với thời gian thực tế
# Chạy trên VPS

echo "🔍 Kiểm tra dữ liệu sensor_data trong database..."
echo ""

# Kiểm tra container PostgreSQL
if ! docker ps | grep -q smartfarm-postgres; then
    echo "❌ Container smartfarm-postgres không chạy!"
    exit 1
fi

echo "📊 Dữ liệu mới nhất (20 bản ghi gần nhất):"
echo "=========================================="
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  id,
  sensor_id,
  CASE 
    WHEN sensor_id = 7 THEN '🌡️ Temperature'
    WHEN sensor_id = 8 THEN '💧 Humidity'
    WHEN sensor_id = 9 THEN '🌱 Soil'
    WHEN sensor_id = 10 THEN '💡 Light'
    ELSE '❓ Unknown'
  END as sensor_type,
  value,
  time,
  time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Ho_Chi_Minh' as time_gmt7
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10) 
ORDER BY time DESC 
LIMIT 20;
"

echo ""
echo "📅 Thống kê theo sensor:"
echo "=========================================="
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  sensor_id,
  CASE 
    WHEN sensor_id = 7 THEN 'Temperature'
    WHEN sensor_id = 8 THEN 'Humidity'
    WHEN sensor_id = 9 THEN 'Soil'
    WHEN sensor_id = 10 THEN 'Light'
  END as sensor_type,
  COUNT(*) as total_records,
  MIN(time) as earliest_time,
  MAX(time) as latest_time,
  MIN(value) as min_value,
  MAX(value) as max_value,
  ROUND(AVG(value)::numeric, 2) as avg_value
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10)
GROUP BY sensor_id
ORDER BY sensor_id;
"

echo ""
echo "⏰ Thời gian hiện tại (Server):"
echo "=========================================="
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  NOW() as server_time_utc,
  NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh' as server_time_gmt7;
"

echo ""
echo "📊 So sánh thời gian:"
echo "=========================================="
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  'Latest data time' as info,
  MAX(time) as time_utc,
  MAX(time) AT TIME ZONE 'Asia/Ho_Chi_Minh' as time_gmt7,
  NOW() - MAX(time) as age
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10);
"

