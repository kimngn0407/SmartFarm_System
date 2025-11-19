# Hướng dẫn Kiểm tra Dữ liệu Sensor

## Bước 1: Kiểm tra Backend có chạy không

```bash
docker-compose ps backend
docker-compose logs backend --tail=50
```

## Bước 2: Kiểm tra Database có dữ liệu không

```bash
# Vào PostgreSQL
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# Kiểm tra có dữ liệu với sensor_id 7, 8, 9, 10
SELECT COUNT(*) FROM sensor_data WHERE sensor_id IN (7, 8, 9, 10);

# Xem chi tiết
SELECT sensor_id, COUNT(*), MIN("time"), MAX("time") 
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10) 
GROUP BY sensor_id;

# Xem dữ liệu mới nhất
SELECT * FROM sensor_data 
WHERE sensor_id = 7 
ORDER BY "time" DESC 
LIMIT 10;
```

## Bước 3: Test API trực tiếp

```bash
# Lấy token từ browser localStorage
# Sau đó test API:

# Test với sensor_id = 7
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "http://localhost:8080/api/sensor-data?sensorId=7&from=2025-11-17T00:00:00&to=2025-11-18T23:59:59"

# Hoặc test không cần auth (nếu API cho phép)
curl "http://localhost:8080/api/sensor-data?sensorId=7&from=2025-11-17T00:00:00&to=2025-11-18T23:59:59"
```

## Bước 4: Kiểm tra Backend Repository Query

Kiểm tra xem query có đúng không trong SensorDataRepository.

## Bước 5: Kiểm tra Flask API có nhận dữ liệu không

```bash
# Xem logs Flask API (nếu có)
docker-compose logs | grep -i flask
```

## Bước 6: Kiểm tra trong Browser Console

Mở browser → F12 → Console → Xem logs:
- `📡 API Request:` - URL và params
- `✅ API Response:` - Response từ backend
- `❌ Error` - Nếu có lỗi




