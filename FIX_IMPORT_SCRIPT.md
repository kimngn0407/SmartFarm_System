# 🔧 Sửa Script Import Database

Script trên VPS của bạn thiếu bước import. Chạy lại script đầy đủ sau:

## Script đầy đủ (Copy toàn bộ và chạy)

**Trên VPS, chạy:**

```bash
cd ~/projects/SmartFarm

# Tạo lại script đầy đủ
cat > import-db-complete.sh << 'EOF'
#!/bin/bash
DUMP_FILE="$1"
if [ -z "$DUMP_FILE" ]; then
    echo "Usage: ./import-db-complete.sh <dump_file.sql>"
    exit 1
fi

echo "=== Import Database ==="
echo "File: $DUMP_FILE"

# Terminate connections
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop và tạo lại
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Tạo file import với disable foreign key
cat > /tmp/import_fixed.sql << 'IMPORT_EOF'
SET session_replication_role = 'replica';
IMPORT_EOF

cat "$DUMP_FILE" >> /tmp/import_fixed.sql
echo "SET session_replication_role = 'origin';" >> /tmp/import_fixed.sql

# Copy vào container
docker cp /tmp/import_fixed.sql smartfarm-postgres:/tmp/import_fixed.sql

# QUAN TRỌNG: Import file (bước này bị thiếu trong script cũ)
echo "Importing database..."
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -f /tmp/import_fixed.sql --set ON_ERROR_STOP=off > /dev/null 2>&1

# Cleanup
docker exec smartfarm-postgres rm /tmp/import_fixed.sql
rm /tmp/import_fixed.sql

echo "✅ Done!"
echo ""
echo "Verifying data..."
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM account;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM farm;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM field;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM sensor;" | xargs
EOF

chmod +x import-db-complete.sh

# Chạy lại
./import-db-complete.sh DB_SM_ver1.sql
```

## Hoặc chạy thủ công từng bước:

```bash
cd ~/projects/SmartFarm

# 1. Ngắt kết nối
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
"

# 2. Drop database
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"

# 3. Tạo database mới
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# 4. Tạo file import
cat > /tmp/import_fixed.sql << 'IMPORT_EOF'
SET session_replication_role = 'replica';
IMPORT_EOF

cat DB_SM_ver1.sql >> /tmp/import_fixed.sql
echo "SET session_replication_role = 'origin';" >> /tmp/import_fixed.sql

# 5. Copy vào container
docker cp /tmp/import_fixed.sql smartfarm-postgres:/tmp/import_fixed.sql

# 6. Import (BƯỚC QUAN TRỌNG - BỊ THIẾU)
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -f /tmp/import_fixed.sql --set ON_ERROR_STOP=off

# 7. Cleanup
docker exec smartfarm-postgres rm /tmp/import_fixed.sql
rm /tmp/import_fixed.sql

# 8. Kiểm tra
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM farm;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM field;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM sensor;"

# 9. Restart backend
docker compose restart backend
```


