#!/bin/bash

# Script restore database với clean hoàn toàn (xóa hết và tạo lại)
# Usage: ./restore-clean.sh <dump_file.sql>

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=== Clean Restore Database ===${NC}"
echo ""

if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Please provide dump file path${NC}"
    echo "Usage: ./restore-clean.sh <dump_file.sql>"
    exit 1
fi

DUMP_FILE="$1"

if [ ! -f "$DUMP_FILE" ]; then
    echo -e "${RED}❌ Error: File not found: $DUMP_FILE${NC}"
    exit 1
fi

echo -e "${CYAN}Dump file:${NC} $DUMP_FILE"
FILE_SIZE=$(du -h "$DUMP_FILE" | cut -f1)
echo -e "${CYAN}File size:${NC} $FILE_SIZE"
echo ""

# Check Docker container
if ! docker ps | grep -q smartfarm-postgres; then
    echo -e "${RED}❌ Error: PostgreSQL container is not running${NC}"
    exit 1
fi

echo -e "${YELLOW}⚠️  This will COMPLETELY DELETE the database and recreate it!${NC}"
read -p "Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo -e "${RED}❌ Cancelled${NC}"
    exit 0
fi

# Backup current database if exists
echo ""
echo -e "${CYAN}Backing up current database...${NC}"
CURRENT_BACKUP="backup_before_clean_restore_$(date +%Y%m%d_%H%M%S).sql"
if docker exec smartfarm-postgres psql -U postgres -lqt | cut -d \| -f 1 | grep -qw SmartFarm1; then
    docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > "$CURRENT_BACKUP" 2>/dev/null || true
    if [ -f "$CURRENT_BACKUP" ] && [ -s "$CURRENT_BACKUP" ]; then
        echo -e "${GREEN}✅ Backup saved: $CURRENT_BACKUP${NC}"
    fi
fi

# Terminate all connections
echo ""
echo -e "${CYAN}Terminating all connections...${NC}"
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1'
  AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop database completely (PostgreSQL không hỗ trợ CASCADE với DROP DATABASE)
echo ""
echo -e "${CYAN}Dropping database completely...${NC}"
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true

# Create new empty database
echo -e "${CYAN}Creating new database...${NC}"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;" || {
    echo -e "${RED}❌ Failed to create database${NC}"
    exit 1
}

# Import with ON_ERROR_STOP disabled to continue on errors
echo ""
echo -e "${CYAN}Importing database...${NC}"
echo -e "${YELLOW}This may take a few minutes...${NC}"

START_TIME=$(date +%s)

# Import với --set ON_ERROR_STOP=off để bỏ qua lỗi và tiếp tục
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off < "$DUMP_FILE" 2>&1 | grep -v "ERROR:" | grep -v "NOTICE:" | tail -20

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo -e "${GREEN}✅ Import completed! (took ${DURATION}s)${NC}"
echo ""

# Verify
echo -e "${CYAN}Verifying data...${NC}"
echo ""

echo -e "${CYAN}Account count:${NC}"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM account;" 2>/dev/null | xargs

echo -e "${CYAN}Farm count:${NC}"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM farm;" 2>/dev/null | xargs

echo -e "${CYAN}Field count:${NC}"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM field;" 2>/dev/null | xargs

echo -e "${CYAN}Sensor count:${NC}"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM sensor;" 2>/dev/null | xargs

echo ""
echo -e "${GREEN}✅ Restore completed!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart backend: docker compose restart backend"
echo "2. Check logs: docker compose logs -f backend"

