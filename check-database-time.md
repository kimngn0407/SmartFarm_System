# Kiểm tra thời gian dữ liệu trong database

Chạy các lệnh sau trên VPS:

```bash
# Xem dữ liệu mới nhất của từng sensor
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT sensor_id, COUNT(*), MIN(time) as earliest, MAX(time) as latest 
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10) 
GROUP BY sensor_id 
ORDER BY sensor_id;
"

# Xem tất cả dữ liệu mới nhất (không giới hạn thời gian)
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT sensor_id, value, time 
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10) 
ORDER BY time DESC 
LIMIT 20;
"
```

Sau đó sửa frontend để:
1. Query tất cả dữ liệu có sẵn (không giới hạn 12h)
2. Hoặc query từ thời điểm có dữ liệu
3. Hoặc lấy dữ liệu mới nhất (last N records)




