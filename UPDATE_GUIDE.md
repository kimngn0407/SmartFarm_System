# Hướng dẫn Cập nhật Code Mới lên VPS

## Tình huống: Đã deploy rồi, chỉ cần cập nhật code mới

### Cách 1: Cập nhật Frontend (Dashboard đã sửa)

Vì bạn đã sửa Dashboard.js để lấy dữ liệu thật từ IoT, chỉ cần rebuild frontend:

```bash
cd ~/projects/SmartFarm

# Rebuild frontend với code mới
docker-compose build --no-cache frontend

# Restart frontend
docker-compose up -d frontend

# Xem logs để kiểm tra
docker-compose logs -f frontend
```

### Cách 2: Sử dụng script tự động

```bash
cd ~/projects/SmartFarm
chmod +x update.sh
./update.sh
```

### Cách 3: Cập nhật từ Git (nếu dùng Git)

```bash
cd ~/projects/SmartFarm

# Pull code mới
git pull

# Rebuild frontend
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

### Cách 4: Upload code mới từ máy local

Nếu bạn đã sửa code trên máy local và muốn upload lên VPS:

```bash
# Từ máy local (Windows)
# Upload chỉ thư mục J2EE_Frontend/src (nơi có Dashboard.js)
scp -r E:\SmartFarm\J2EE_Frontend\src user@173.249.48.25:~/projects/SmartFarm/J2EE_Frontend/

# Sau đó trên VPS, rebuild frontend
cd ~/projects/SmartFarm
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

## Kiểm tra sau khi cập nhật

### 1. Kiểm tra frontend đang chạy

```bash
docker-compose ps frontend
```

### 2. Xem logs

```bash
docker-compose logs -f frontend
```

### 3. Kiểm tra trong browser

Truy cập: http://173.249.48.25

- Mở Developer Tools (F12)
- Vào tab Console
- Kiểm tra xem có log "🔍 Fetching real sensor data from IoT..." không
- Kiểm tra xem có lỗi API nào không

### 4. Test API trực tiếp

```bash
# Test backend API
curl http://localhost:8080/api/sensors

# Test sensor data API (cần token)
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8080/api/sensor-data?sensorId=1&from=2024-01-01T00:00:00&to=2024-01-02T00:00:00
```

## Troubleshooting

### Lỗi: Frontend không build được

```bash
# Xem logs chi tiết
docker-compose build --no-cache frontend 2>&1 | tee build.log

# Kiểm tra lỗi trong build.log
cat build.log
```

### Lỗi: Frontend không load được sau khi rebuild

```bash
# Xem logs
docker-compose logs frontend

# Restart lại
docker-compose restart frontend

# Hoặc rebuild lại
docker-compose down frontend
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

### Lỗi: Dashboard không lấy được dữ liệu

1. **Kiểm tra backend API có hoạt động không:**
   ```bash
   curl http://localhost:8080/actuator/health
   ```

2. **Kiểm tra database có dữ liệu không:**
   ```bash
   docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1
   # Trong psql:
   SELECT COUNT(*) FROM "Sensor_data";
   SELECT * FROM "Sensor_data" ORDER BY time DESC LIMIT 10;
   ```

3. **Kiểm tra sensors có trong database không:**
   ```bash
   # Trong psql:
   SELECT * FROM "Sensor";
   ```

4. **Kiểm tra logs backend:**
   ```bash
   docker-compose logs -f backend
   ```

5. **Kiểm tra CORS và API URL:**
   - Mở browser console (F12)
   - Xem Network tab
   - Kiểm tra các request API có bị lỗi CORS không
   - Kiểm tra API URL có đúng không

### Clear cache browser

Nếu dashboard vẫn hiển thị code cũ, clear cache browser:
- Chrome/Edge: Ctrl + Shift + Delete
- Hoặc mở Incognito/Private mode

## Các lệnh hữu ích

### Xem logs real-time
```bash
docker-compose logs -f frontend
docker-compose logs -f backend
```

### Restart một service
```bash
docker-compose restart frontend
docker-compose restart backend
```

### Xem resource usage
```bash
docker stats
```

### Xem disk usage
```bash
docker system df
```

## Checklist sau khi cập nhật

- [ ] Frontend build thành công
- [ ] Frontend container đang chạy
- [ ] Truy cập được http://173.249.48.25
- [ ] Dashboard hiển thị được
- [ ] Console không có lỗi JavaScript
- [ ] API calls thành công (xem Network tab)
- [ ] Dữ liệu sensor hiển thị trên dashboard (nếu có dữ liệu trong DB)

