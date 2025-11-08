# 🔧 Giải pháp cuối cùng - Import Database

## Vấn đề: Database vẫn còn schema cũ sau khi DROP

## Giải pháp: Force drop và import lại

**Trên VPS, chạy từng lệnh:**

```bash
cd ~/projects/SmartFarm

# 1. Kiểm tra database có tồn tại không
docker exec -it smartfarm-postgres psql -U postgres -c "\l" | grep SmartFarm1

# 2. Force terminate TẤT CẢ connections (kể cả từ postgres user)
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'SmartFarm1';
"

# 3. Đợi 2 giây
sleep 2

# 4. Drop database (force)
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"

# 5. Kiểm tra lại database đã bị xóa chưa
docker exec -it smartfarm-postgres psql -U postgres -c "\l" | grep SmartFarm1
# Nếu không có output → Database đã bị xóa thành công

# 6. Tạo database mới
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# 7. Import với pipe (xử lý COPY FROM stdin đúng cách)
{
    echo "SET session_replication_role = 'replica';"
    cat DB_SM_ver1.sql
    echo "SET session_replication_role = 'origin';"
} | docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off 2>&1 | grep -v "ERROR:" | grep -v "invalid command" | tail -20

# 8. Kiểm tra kết quả
echo ""
echo "=== Kiểm tra dữ liệu ==="
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as account_count FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as farm_count FROM farm;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as field_count FROM field;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as sensor_count FROM sensor;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as sensor_data_count FROM sensor_data;"

# 9. Restart backend
docker compose restart backend
```

## Nếu vẫn không được, thử cách này:

```bash
# Xóa toàn bộ và tạo lại từ đầu
docker exec -it smartfarm-postgres psql -U postgres << 'SQL'
-- Force terminate all connections
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'SmartFarm1';

-- Drop database
DROP DATABASE IF EXISTS SmartFarm1;

-- Tạo lại
CREATE DATABASE SmartFarm1;
SQL

# Import
{
    echo "SET session_replication_role = 'replica';"
    cat DB_SM_ver1.sql
    echo "SET session_replication_role = 'origin';"
} | docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off
```


