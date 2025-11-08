#!/bin/bash

# Script restore database từ file dump PostgreSQL
# Usage: ./restore-from-dump.sh <dump_file.sql>

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=== Restore Database from Dump File ===${NC}"
echo ""

# Check if dump file is provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Please provide dump file path${NC}"
    echo "Usage: ./restore-from-dump.sh <dump_file.sql>"
    exit 1
fi

DUMP_FILE="$1"

# Check if file exists
if [ ! -f "$DUMP_FILE" ]; then
    echo -e "${RED}❌ Error: File not found: $DUMP_FILE${NC}"
    exit 1
fi

echo -e "${CYAN}Dump file:${NC} $DUMP_FILE"
FILE_SIZE=$(du -h "$DUMP_FILE" | cut -f1)
echo -e "${CYAN}File size:${NC} $FILE_SIZE"
echo ""

# Check if Docker container exists
if ! docker ps | grep -q smartfarm-postgres; then
    echo -e "${RED}❌ Error: PostgreSQL container 'smartfarm-postgres' is not running${NC}"
    echo "Please start the container first: docker compose up -d postgres"
    exit 1
fi

echo -e "${YELLOW}⚠️  This will REPLACE the current database!${NC}"
read -p "Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo -e "${RED}❌ Cancelled${NC}"
    exit 0
fi

# Backup current database
echo ""
echo -e "${CYAN}Creating backup of current database...${NC}"
CURRENT_BACKUP="backup_before_restore_$(date +%Y%m%d_%H%M%S).sql"
if docker exec smartfarm-postgres psql -U postgres -lqt | cut -d \| -f 1 | grep -qw SmartFarm1; then
    docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > "$CURRENT_BACKUP" 2>/dev/null || true
    if [ -f "$CURRENT_BACKUP" ] && [ -s "$CURRENT_BACKUP" ]; then
        echo -e "${GREEN}✅ Current database backed up to: $CURRENT_BACKUP${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not backup current database (may be empty)${NC}"
        rm -f "$CURRENT_BACKUP"
    fi
else
    echo -e "${YELLOW}⚠️  Database SmartFarm1 does not exist yet${NC}"
fi

# Terminate all connections to database
echo ""
echo -e "${CYAN}Terminating existing connections...${NC}"
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1'
  AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop and recreate database
echo ""
echo -e "${CYAN}Dropping existing database...${NC}"
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true

echo -e "${CYAN}Creating new database...${NC}"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;" || {
    echo -e "${RED}❌ Failed to create database${NC}"
    exit 1
}

# Import database
echo ""
echo -e "${CYAN}Importing database from $DUMP_FILE...${NC}"
echo -e "${YELLOW}This may take a few minutes...${NC}"

START_TIME=$(date +%s)
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < "$DUMP_FILE"
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Import successful! (took ${DURATION}s)${NC}"
    echo ""
    
    # Verify import
    echo -e "${CYAN}Verifying import...${NC}"
    echo ""
    
    echo -e "${CYAN}Account count:${NC}"
    docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as count FROM account;" 2>/dev/null || echo "N/A"
    
    echo ""
    echo -e "${CYAN}Farm count:${NC}"
    docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as count FROM farm;" 2>/dev/null || echo "N/A"
    
    echo ""
    echo -e "${CYAN}Field count:${NC}"
    docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as count FROM field;" 2>/dev/null || echo "N/A"
    
    echo ""
    echo -e "${CYAN}Sensor count:${NC}"
    docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as count FROM sensor;" 2>/dev/null || echo "N/A"
    
    echo ""
    echo -e "${CYAN}Sensor data count:${NC}"
    docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as count FROM sensor_data;" 2>/dev/null || echo "N/A"
    
    echo ""
    echo -e "${GREEN}✅ Database restore completed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Restart backend: docker compose restart backend"
    echo "2. Check backend logs: docker compose logs -f backend"
    
else
    echo ""
    echo -e "${RED}❌ Import failed!${NC}"
    echo ""
    echo -e "${YELLOW}If you have a backup, you can restore it:${NC}"
    if [ -f "$CURRENT_BACKUP" ]; then
        echo "  docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < $CURRENT_BACKUP"
    fi
    exit 1
fi
