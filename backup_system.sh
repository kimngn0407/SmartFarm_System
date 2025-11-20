#!/bin/bash

# Script backup toàn bộ hệ thống SmartFarm trước khi gia hạn VPS
# Sử dụng: ./backup_system.sh

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="smartfarm_backup_${TIMESTAMP}"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

echo "💾 Bắt đầu backup hệ thống SmartFarm..."
echo "📁 Thư mục backup: ${BACKUP_PATH}"
echo ""

# Tạo thư mục backup
mkdir -p "${BACKUP_PATH}"
mkdir -p "${BACKUP_PATH}/database"
mkdir -p "${BACKUP_PATH}/code"
mkdir -p "${BACKUP_PATH}/docker"
mkdir -p "${BACKUP_PATH}/config"

# 1. Backup Database
echo "📊 Bước 1: Backup Database..."
if docker-compose ps postgres | grep -q "Up"; then
    docker-compose exec -T postgres pg_dump -U postgres SmartFarm1 > "${BACKUP_PATH}/database/smartfarm_db_${TIMESTAMP}.sql"
    echo "✅ Đã backup database: ${BACKUP_PATH}/database/smartfarm_db_${TIMESTAMP}.sql"
else
    echo "⚠️  PostgreSQL container không chạy, bỏ qua backup database"
fi

# 2. Backup Code
echo "📝 Bước 2: Backup Code..."
tar -czf "${BACKUP_PATH}/code/source_code_${TIMESTAMP}.tar.gz" \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.venv' \
    --exclude='venv' \
    --exclude='target' \
    --exclude='build' \
    --exclude='dist' \
    demoSmartFarm/ J2EE_Frontend/ AI_SmartFarm_CHatbot/ RecommentCrop/ PestAndDisease/ SmartContract/ 2>/dev/null || true
echo "✅ Đã backup code: ${BACKUP_PATH}/code/source_code_${TIMESTAMP}.tar.gz"

# 3. Backup Docker Volumes (nếu có)
echo "🐳 Bước 3: Backup Docker Volumes..."
if docker volume ls | grep -q "smartfarm"; then
    docker run --rm -v smartfarm_postgres_data:/data -v $(pwd)/${BACKUP_PATH}/docker:/backup alpine tar czf /backup/postgres_data_${TIMESTAMP}.tar.gz -C /data . 2>/dev/null || echo "⚠️  Không thể backup postgres volume"
    echo "✅ Đã backup docker volumes"
else
    echo "⚠️  Không tìm thấy docker volumes"
fi

# 4. Backup Configuration Files
echo "⚙️  Bước 4: Backup Configuration Files..."
cp docker-compose.yml "${BACKUP_PATH}/config/" 2>/dev/null || true
cp .env "${BACKUP_PATH}/config/" 2>/dev/null || true
cp -r nginx/ "${BACKUP_PATH}/config/" 2>/dev/null || true
echo "✅ Đã backup configuration files"

# 5. Backup Scripts
echo "📜 Bước 5: Backup Scripts..."
cp *.sh "${BACKUP_PATH}/config/" 2>/dev/null || true
cp *.md "${BACKUP_PATH}/config/" 2>/dev/null || true
echo "✅ Đã backup scripts"

# 6. Tạo file thông tin
echo "📋 Bước 6: Tạo file thông tin..."
cat > "${BACKUP_PATH}/BACKUP_INFO.txt" << EOF
SmartFarm System Backup
=======================
Backup Date: $(date)
Backup Name: ${BACKUP_NAME}
VPS IP: $(hostname -I | awk '{print $1}')

Contents:
- Database: database/smartfarm_db_${TIMESTAMP}.sql
- Source Code: code/source_code_${TIMESTAMP}.tar.gz
- Docker Volumes: docker/postgres_data_${TIMESTAMP}.tar.gz
- Configuration: config/

To Restore:
1. Extract source code: tar -xzf code/source_code_${TIMESTAMP}.tar.gz
2. Restore database: psql -U postgres SmartFarm1 < database/smartfarm_db_${TIMESTAMP}.sql
3. Restore volumes: docker run --rm -v smartfarm_postgres_data:/data -v \$(pwd)/docker:/backup alpine tar xzf /backup/postgres_data_${TIMESTAMP}.tar.gz -C /data

Docker Compose Services:
$(docker-compose ps)

Git Status:
$(git status --short 2>/dev/null || echo "Not a git repository")

EOF
echo "✅ Đã tạo file thông tin"

# 7. Tạo file nén tổng
echo "📦 Bước 7: Tạo file nén tổng..."
cd "${BACKUP_DIR}"
tar -czf "${BACKUP_NAME}.tar.gz" "${BACKUP_NAME}/"
cd ..
echo "✅ Đã tạo file nén: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"

# 8. Tính kích thước
BACKUP_SIZE=$(du -sh "${BACKUP_PATH}" | cut -f1)
ARCHIVE_SIZE=$(du -sh "${BACKUP_DIR}/${BACKUP_NAME}.tar.gz" | cut -f1)

echo ""
echo "✅ Hoàn tất backup!"
echo ""
echo "📊 Thông tin backup:"
echo "   - Thư mục: ${BACKUP_PATH}"
echo "   - Kích thước: ${BACKUP_SIZE}"
echo "   - File nén: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz (${ARCHIVE_SIZE})"
echo ""
echo "📥 Để tải về local:"
echo "   scp root@your-vps-ip:~/projects/SmartFarm/${BACKUP_DIR}/${BACKUP_NAME}.tar.gz ./"
echo ""
echo "💡 Lưu ý:"
echo "   - Backup database có thể lớn, kiểm tra dung lượng trước khi tải"
echo "   - Nên tải file nén về local trước khi gia hạn VPS"
echo "   - Giữ file backup ở nhiều nơi (local, cloud, USB)"

