#!/bin/bash

# Script import database hoàn chỉnh - xóa hết và import lại
# Usage: ./import-db-complete.sh <dump_file.sql>

set -e

DUMP_FILE="$1"
if [ -z "$DUMP_FILE" ]; then
    echo "Usage: ./import-db-complete.sh <dump_file.sql>"
    exit 1
fi

if [ ! -f "$DUMP_FILE" ]; then
    echo "❌ Error: File not found: $DUMP_FILE"
    exit 1
fi

echo "=== Import Database (Complete) ==="
echo "File: $DUMP_FILE"
echo ""

# Terminate all connections
echo "1. Terminating all connections..."
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop database completely
echo "2. Dropping database completely..."
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true

# Create new database
echo "3. Creating new database..."
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;" || {
    echo "❌ Failed to create database"
    exit 1
}

# Tạo file import với disable foreign key và bỏ qua các lệnh SET không tương thích
echo "4. Preparing import file..."
TEMP_IMPORT_FILE="/tmp/import_$$.sql"

{
    # Disable foreign key checks
    echo "SET session_replication_role = 'replica';"
    echo ""
    # Bỏ qua các lệnh SET không tương thích và các lệnh CREATE/ALTER đã tồn tại
    grep -v "^SET transaction_timeout" "$DUMP_FILE" | \
    grep -v "^ERROR:" | \
    sed 's/^CREATE TABLE public\./CREATE TABLE IF NOT EXISTS public./g' | \
    sed 's/^CREATE SEQUENCE public\./CREATE SEQUENCE IF NOT EXISTS public./g' | \
    sed 's/^ALTER TABLE ONLY public\.\([^ ]*\) ALTER COLUMN id SET DEFAULT/-- ALTER TABLE ONLY public.\1 ALTER COLUMN id SET DEFAULT/g' | \
    sed 's/^ALTER SEQUENCE public\.\([^ ]*\) OWNER TO/-- ALTER SEQUENCE public.\1 OWNER TO/g' | \
    sed 's/^ALTER TABLE public\.\([^ ]*\) OWNER TO/-- ALTER TABLE public.\1 OWNER TO/g'
    echo ""
    # Re-enable foreign key checks
    echo "SET session_replication_role = 'origin';"
} > "$TEMP_IMPORT_FILE"

# Copy file vào container
echo "5. Copying file to container..."
docker cp "$TEMP_IMPORT_FILE" smartfarm-postgres:/tmp/import_fixed.sql

# Import
echo "6. Importing database (this may take a few minutes)..."
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -f /tmp/import_fixed.sql --set ON_ERROR_STOP=off > /dev/null 2>&1

# Cleanup
docker exec smartfarm-postgres rm /tmp/import_fixed.sql
rm -f "$TEMP_IMPORT_FILE"

echo ""
echo "✅ Import completed!"
echo ""
echo "7. Verifying data..."
echo ""

# Kiểm tra số lượng records
ACCOUNT_COUNT=$(docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM account;" 2>/dev/null | xargs)
FARM_COUNT=$(docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM farm;" 2>/dev/null | xargs)
FIELD_COUNT=$(docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM field;" 2>/dev/null | xargs)
SENSOR_COUNT=$(docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM sensor;" 2>/dev/null | xargs)
SENSOR_DATA_COUNT=$(docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM sensor_data;" 2>/dev/null | xargs)

echo "Account: $ACCOUNT_COUNT"
echo "Farm: $FARM_COUNT"
echo "Field: $FIELD_COUNT"
echo "Sensor: $SENSOR_COUNT"
echo "Sensor Data: $SENSOR_DATA_COUNT"
echo ""
echo "✅ Done! Restart backend: docker compose restart backend"


