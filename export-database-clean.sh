#!/bin/bash

# Script export database PostgreSQL với format sạch, tương thích với VPS
# Usage: ./export-database-clean.sh

CONTAINER_NAME="${CONTAINER_NAME:-smartfarm-postgres}"
DATABASE="${DATABASE:-SmartFarm1}"
USER="${USER:-postgres}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="smartfarm_backup_clean_${TIMESTAMP}.sql"

echo "=== Export Database (Clean Format) ==="
echo ""
echo "Container: $CONTAINER_NAME"
echo "Database: $DATABASE"
echo "Output file: $OUTPUT_FILE"
echo ""

# Check if container exists
if ! docker ps -a --format "{{.Names}}" | grep -q "$CONTAINER_NAME"; then
    echo "❌ Error: Container '$CONTAINER_NAME' not found!"
    exit 1
fi

echo "🔄 Exporting database..."

# Export với các options để tạo file dump sạch:
# --no-owner: Bỏ lệnh ALTER TABLE ... OWNER TO
# --no-privileges: Bỏ lệnh GRANT/REVOKE
# --clean: Thêm DROP statements trước CREATE
# --if-exists: Dùng IF EXISTS với DROP
# --create: Thêm CREATE DATABASE statement
# --encoding=UTF8: Đảm bảo encoding đúng
docker exec "$CONTAINER_NAME" pg_dump -U "$USER" -d "$DATABASE" \
    --no-owner \
    --no-privileges \
    --clean \
    --if-exists \
    --create \
    --encoding=UTF8 \
    --format=plain \
    --verbose > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo ""
    echo "✅ Export successful!"
    echo "   File: $OUTPUT_FILE"
    echo "   Size: $FILE_SIZE"
    echo ""
    echo "Next steps:"
    echo "1. Transfer to VPS: scp $OUTPUT_FILE root@173.249.48.25:~/projects/SmartFarm/"
    echo "2. On VPS, restore: docker exec -i smartfarm-postgres psql -U postgres < $OUTPUT_FILE"
else
    echo ""
    echo "❌ Export failed!"
    exit 1
fi


