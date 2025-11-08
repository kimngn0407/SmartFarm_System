#!/bin/bash

# Script import database lên VPS
# Chạy trên VPS sau khi đã upload file SQL

DUMP_FILE="$1"

if [ -z "$DUMP_FILE" ]; then
    echo "❌ Usage: ./import-to-vps.sh <dump_file.sql>"
    echo ""
    echo "📝 Ví dụ:"
    echo "   ./import-to-vps.sh smartfarm-export-20250108-120000.sql"
    exit 1
fi

if [ ! -f "$DUMP_FILE" ]; then
    echo "❌ File không tồn tại: $DUMP_FILE"
    exit 1
fi

echo "📥 Import database lên VPS..."
echo "File: $DUMP_FILE"
echo ""

# Lấy database container
DB_CONTAINER=$(docker compose ps -q postgres 2>/dev/null || docker compose ps -q db 2>/dev/null)

if [ -z "$DB_CONTAINER" ]; then
    echo "❌ Không tìm thấy PostgreSQL container"
    exit 1
fi

echo "📦 PostgreSQL container: $DB_CONTAINER"
echo ""

# Lấy database name từ docker-compose hoặc dùng default
DB_NAME="${DB_NAME:-smartfarm}"

# Terminate connections
echo "1. Terminating existing connections..."
docker exec $DB_CONTAINER psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = '$DB_NAME' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop database
echo "2. Dropping existing database..."
docker exec $DB_CONTAINER psql -U postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true

# Create new database
echo "3. Creating new database..."
docker exec $DB_CONTAINER psql -U postgres -c "CREATE DATABASE $DB_NAME;" || {
    echo "❌ Failed to create database"
    exit 1
}

# Import database
echo "4. Importing database (this may take a few minutes)..."
docker exec -i $DB_CONTAINER psql -U postgres -d $DB_NAME < "$DUMP_FILE" 2>&1 | grep -E "(ERROR|COPY|INSERT)" | tail -20

echo ""
echo "✅ Import completed!"
echo ""

# Verify data
echo "5. Verifying data..."
ACCOUNT_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d $DB_NAME -t -c "SELECT COUNT(*) FROM account;" 2>/dev/null | xargs)
FARM_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d $DB_NAME -t -c "SELECT COUNT(*) FROM \"Farm\";" 2>/dev/null | xargs)
FIELD_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d $DB_NAME -t -c "SELECT COUNT(*) FROM \"Field\";" 2>/dev/null | xargs)
SENSOR_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d $DB_NAME -t -c "SELECT COUNT(*) FROM \"Sensor\";" 2>/dev/null | xargs)

echo ""
echo "📊 Data summary:"
echo "   Accounts: $ACCOUNT_COUNT"
echo "   Farms: $FARM_COUNT"
echo "   Fields: $FIELD_COUNT"
echo "   Sensors: $SENSOR_COUNT"
echo ""

if [ "$ACCOUNT_COUNT" -gt "0" ]; then
    echo "✅ Database imported successfully!"
    echo ""
    echo "🧪 Next steps:"
    echo "   1. Restart backend: docker compose restart backend"
    echo "   2. Test login: http://173.249.48.25/login"
    echo "   3. Check Dashboard: http://173.249.48.25/dashboard"
else
    echo "⚠️  Database imported but no accounts found"
    echo "   Please check the dump file"
fi

