#!/bin/bash

# Script import database cuối cùng - xử lý đúng format COPY FROM stdin
# Usage: ./import-final.sh <dump_file.sql>

DUMP_FILE="$1"
if [ -z "$DUMP_FILE" ]; then
    echo "Usage: ./import-final.sh <dump_file.sql>"
    exit 1
fi

if [ ! -f "$DUMP_FILE" ]; then
    echo "❌ Error: File not found: $DUMP_FILE"
    exit 1
fi

echo "=== Import Database (Final) ==="
echo "File: $DUMP_FILE"
echo ""

# Terminate connections
echo "1. Terminating connections..."
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop database completely
echo "2. Dropping database..."
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true

# Create new database
echo "3. Creating database..."
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;" || {
    echo "❌ Failed to create database"
    exit 1
}

# Import trực tiếp từ file dump với disable foreign key
# QUAN TRỌNG: Dùng < thay vì -f để COPY FROM stdin hoạt động đúng
echo "4. Importing database (this may take a few minutes)..."
{
    echo "SET session_replication_role = 'replica';"
    cat "$DUMP_FILE"
    echo "SET session_replication_role = 'origin';"
} | docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off 2>&1 | grep -E "(ERROR|COPY|INSERT)" | tail -20

echo ""
echo "✅ Import completed!"
echo ""
echo "5. Verifying data..."
echo ""

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

if [ "$FARM_COUNT" -gt 0 ] && [ "$FIELD_COUNT" -gt 0 ]; then
    echo "✅ Import successful! Restart backend: docker compose restart backend"
else
    echo "⚠️  Import may have issues. Check logs above."
fi


