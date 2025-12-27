#!/bin/bash

# Check Database Status trên VPS
# Script để kiểm tra database và schema

echo "🔍 Checking Database Status"
echo "==========================="
echo ""

cd /opt/SmartFarm

# Get database credentials from .env or docker-compose
DB_NAME="${POSTGRES_DB:-SmartFarm1}"
DB_USER="${POSTGRES_USER:-postgres}"
DB_PASSWORD="${POSTGRES_PASSWORD:-Ngan0407@!}"

echo "📊 1. Database Connection:"
docker compose exec -T postgres psql -U $DB_USER -d $DB_NAME -c "SELECT version();" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "   ✅ Database connection OK"
else
    echo "   ❌ Cannot connect to database"
    exit 1
fi

echo ""
echo "📋 2. Database Tables:"
TABLE_COUNT=$(docker compose exec -T postgres psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')

echo "   Found $TABLE_COUNT tables"
echo ""

if [ "$TABLE_COUNT" -eq "0" ] || [ -z "$TABLE_COUNT" ]; then
    echo "⚠️  WARNING: No tables found in database!"
    echo "   Database schema needs to be deployed."
    echo ""
    echo "   Options:"
    echo "   1. Wait for Spring Boot to auto-create tables (ddl-auto=update)"
    echo "   2. Manually import schema from DB_SM_ver1.sql"
    echo ""
else
    echo "✅ Database has $TABLE_COUNT tables"
    echo ""
    echo "📋 List of tables:"
    docker compose exec -T postgres psql -U $DB_USER -d $DB_NAME -c "\dt" 2>/dev/null
fi

echo ""
echo "🔍 3. Backend Logs (checking for database errors):"
docker compose logs backend --tail=20 | grep -i -E "(database|schema|table|error|exception)" | tail -5 || echo "   No recent database-related logs"

echo ""
echo "✅ Check complete!"





#!/bin/bash

# Check Database Status trên VPS
# Script để kiểm tra database và schema

echo "🔍 Checking Database Status"
echo "==========================="
echo ""

cd /opt/SmartFarm

# Get database credentials from .env or docker-compose
DB_NAME="${POSTGRES_DB:-SmartFarm1}"
DB_USER="${POSTGRES_USER:-postgres}"
DB_PASSWORD="${POSTGRES_PASSWORD:-Ngan0407@!}"

echo "📊 1. Database Connection:"
docker compose exec -T postgres psql -U $DB_USER -d $DB_NAME -c "SELECT version();" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "   ✅ Database connection OK"
else
    echo "   ❌ Cannot connect to database"
    exit 1
fi

echo ""
echo "📋 2. Database Tables:"
TABLE_COUNT=$(docker compose exec -T postgres psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')

echo "   Found $TABLE_COUNT tables"
echo ""

if [ "$TABLE_COUNT" -eq "0" ] || [ -z "$TABLE_COUNT" ]; then
    echo "⚠️  WARNING: No tables found in database!"
    echo "   Database schema needs to be deployed."
    echo ""
    echo "   Options:"
    echo "   1. Wait for Spring Boot to auto-create tables (ddl-auto=update)"
    echo "   2. Manually import schema from DB_SM_ver1.sql"
    echo ""
else
    echo "✅ Database has $TABLE_COUNT tables"
    echo ""
    echo "📋 List of tables:"
    docker compose exec -T postgres psql -U $DB_USER -d $DB_NAME -c "\dt" 2>/dev/null
fi

echo ""
echo "🔍 3. Backend Logs (checking for database errors):"
docker compose logs backend --tail=20 | grep -i -E "(database|schema|table|error|exception)" | tail -5 || echo "   No recent database-related logs"

echo ""
echo "✅ Check complete!"





