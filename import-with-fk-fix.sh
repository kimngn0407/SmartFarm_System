#!/bin/bash

# Script import database với xử lý foreign key constraint
# Usage: ./import-with-fk-fix.sh <dump_file.sql>

set -e

DUMP_FILE="$1"
if [ -z "$DUMP_FILE" ]; then
    echo "Usage: ./import-with-fk-fix.sh <dump_file.sql>"
    exit 1
fi

if [ ! -f "$DUMP_FILE" ]; then
    echo "❌ Error: File not found: $DUMP_FILE"
    exit 1
fi

echo "=== Import Database với xử lý Foreign Key ==="
echo "File: $DUMP_FILE"
echo ""

# Terminate connections
echo "Terminating connections..."
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop database
echo "Dropping database..."
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true

# Create database
echo "Creating database..."
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;" || {
    echo "❌ Failed to create database"
    exit 1
}

# Import với xử lý foreign key:
# 1. Tắt foreign key check tạm thời
# 2. Import dữ liệu
# 3. Bật lại foreign key check

echo "Importing database (this may take a few minutes)..."
echo ""

# Tạo file import với xử lý foreign key
TEMP_IMPORT_FILE="/tmp/import_$$.sql"

# Copy file dump và thêm lệnh disable/enable foreign key
{
    echo "-- Disable foreign key checks temporarily"
    echo "SET session_replication_role = 'replica';"
    echo ""
    cat "$DUMP_FILE"
    echo ""
    echo "-- Re-enable foreign key checks"
    echo "SET session_replication_role = 'origin';"
} > "$TEMP_IMPORT_FILE"

# Copy file vào container
docker cp "$TEMP_IMPORT_FILE" smartfarm-postgres:/tmp/import_fixed.sql

# Import file đã sửa
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -f /tmp/import_fixed.sql --set ON_ERROR_STOP=off 2>&1 | grep -E "(ERROR|WARNING|COPY|INSERT)" | tail -30

# Xóa file tạm
docker exec smartfarm-postgres rm /tmp/import_fixed.sql
rm -f "$TEMP_IMPORT_FILE"

echo ""
echo "✅ Import completed!"
echo ""
echo "Verifying data..."
echo ""

# Kiểm tra số lượng records
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM account;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM farm;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM field;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM sensor;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM sensor_data;" | xargs

echo ""
echo "✅ Done! Restart backend: docker compose restart backend"

