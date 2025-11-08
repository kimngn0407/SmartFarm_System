#!/bin/bash

# Script import DB_SM_ver1.sql lên VPS
# File này chứa đầy đủ dữ liệu: accounts, farms, fields, sensors, etc.

DUMP_FILE="DB_SM_ver1.sql"

if [ ! -f "$DUMP_FILE" ]; then
    echo "❌ File không tồn tại: $DUMP_FILE"
    echo "   Vui lòng đảm bảo file DB_SM_ver1.sql có trong thư mục hiện tại"
    exit 1
fi

echo "📥 Import database DB_SM_ver1.sql lên VPS..."
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
# Kiểm tra xem database nào đang được dùng
DB_NAME="smartfarm"  # Default, có thể cần đổi thành SmartFarm1

# Kiểm tra xem database có tồn tại không
EXISTING_DB=$(docker exec $DB_CONTAINER psql -U postgres -t -c "SELECT datname FROM pg_database WHERE datname IN ('smartfarm', 'SmartFarm1', 'SmartFarm');" 2>/dev/null | xargs | head -1)

if [ ! -z "$EXISTING_DB" ]; then
    DB_NAME="$EXISTING_DB"
    echo "🔍 Tìm thấy database: $DB_NAME"
else
    echo "⚠️  Không tìm thấy database, sẽ tạo mới: $DB_NAME"
fi

echo ""

# Backup database hiện tại (nếu có)
if docker exec $DB_CONTAINER psql -U postgres -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
    echo "💾 Backup database hiện tại..."
    BACKUP_FILE="backup-${DB_NAME}-$(date +%Y%m%d-%H%M%S).sql"
    docker exec $DB_CONTAINER pg_dump -U postgres -d "$DB_NAME" > "$BACKUP_FILE" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "   ✅ Backup saved: $BACKUP_FILE"
    fi
    echo ""
fi

# Terminate connections
echo "1. Terminating existing connections..."
docker exec $DB_CONTAINER psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = '$DB_NAME' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop database
echo "2. Dropping existing database..."
docker exec $DB_CONTAINER psql -U postgres -c "DROP DATABASE IF EXISTS \"$DB_NAME\";" 2>/dev/null || true

# Create new database
echo "3. Creating new database..."
docker exec $DB_CONTAINER psql -U postgres -c "CREATE DATABASE \"$DB_NAME\";" || {
    echo "❌ Failed to create database"
    exit 1
}

# Import database
# QUAN TRỌNG: Dùng < để COPY FROM stdin hoạt động đúng
echo "4. Importing database (this may take a few minutes)..."
echo "   Đang xử lý COPY FROM stdin..."

{
    # Disable foreign key checks để tránh lỗi thứ tự import
    echo "SET session_replication_role = 'replica';"
    echo ""
    # Import file
    cat "$DUMP_FILE"
    echo ""
    # Re-enable foreign key checks
    echo "SET session_replication_role = 'origin';"
} | docker exec -i $DB_CONTAINER psql -U postgres -d "$DB_NAME" --set ON_ERROR_STOP=off 2>&1 | grep -E "(ERROR|COPY|INSERT|SET)" | tail -30

echo ""
echo "✅ Import completed!"
echo ""

# Verify data
echo "5. Verifying data..."
ACCOUNT_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM account;" 2>/dev/null | xargs)
FARM_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM farm;" 2>/dev/null | xargs)
FIELD_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM field;" 2>/dev/null | xargs)
SENSOR_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM sensor;" 2>/dev/null | xargs)
SENSOR_DATA_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM sensor_data;" 2>/dev/null | xargs)
PLANT_COUNT=$(docker exec $DB_CONTAINER psql -U postgres -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM plant;" 2>/dev/null | xargs)

echo ""
echo "📊 Data summary:"
echo "   Accounts: $ACCOUNT_COUNT"
echo "   Farms: $FARM_COUNT"
echo "   Fields: $FIELD_COUNT"
echo "   Sensors: $SENSOR_COUNT"
echo "   Sensor Data: $SENSOR_DATA_COUNT"
echo "   Plants: $PLANT_COUNT"
echo ""

if [ "$ACCOUNT_COUNT" -gt "0" ] && [ "$FARM_COUNT" -gt "0" ]; then
    echo "✅ Database imported successfully!"
    echo ""
    echo "🧪 Next steps:"
    echo "   1. Restart backend: docker compose restart backend"
    echo "   2. Test login: http://173.249.48.25/login"
    echo "   3. Check Dashboard: http://173.249.48.25/dashboard"
    echo ""
    echo "📝 Available accounts (from DB_SM_ver1.sql):"
    echo "   - admin@smartfarm.com (ADMIN)"
    echo "   - admin.nguyen@smartfarm.com (ADMIN)"
    echo "   - admin@example.com (FARMER - nhưng có role ADMIN trong account_roles)"
else
    echo "⚠️  Database imported but some data may be missing"
    echo "   Please check the import logs above"
fi

