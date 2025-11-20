# Hướng dẫn Migration Alert Table

## Vấn đề
Bảng `alert` thiếu các cột để lưu giá trị sensor và threshold, khiến UI không hiển thị được thông tin chi tiết.

## Giải pháp
Thêm các cột: `type`, `value`, `threshold_min`, `threshold_max` vào bảng `alert`.

## Cách thực hiện trên VPS

### Cách 1: Chạy SQL trực tiếp
```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
ALTER TABLE public.alert 
ADD COLUMN IF NOT EXISTS type VARCHAR(255),
ADD COLUMN IF NOT EXISTS value DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS threshold_min DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS threshold_max DOUBLE PRECISION;
"
```

### Cách 2: Copy file SQL vào container và chạy
```bash
# Copy file vào container
docker cp add_alert_columns.sql smartfarm-postgres:/tmp/

# Chạy SQL
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -f /tmp/add_alert_columns.sql
```

### Cách 3: Chạy từ local file
```bash
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < add_alert_columns.sql
```

## Kiểm tra kết quả
```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "\d alert"
```

Bạn sẽ thấy các cột mới:
- `type`
- `value`
- `threshold_min`
- `threshold_max`

## Lưu ý
- Các alerts cũ sẽ có giá trị NULL cho các cột mới (điều này là bình thường)
- Các alerts mới được tạo sẽ có đầy đủ thông tin
- Frontend đã được cập nhật để xử lý trường hợp NULL

## Sau khi migration
1. Rebuild backend: `docker-compose build --no-cache backend`
2. Restart backend: `docker-compose up -d backend`
3. Rebuild frontend: `docker-compose build --no-cache frontend`
4. Restart frontend: `docker-compose up -d frontend`

