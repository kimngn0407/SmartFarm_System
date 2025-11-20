#!/bin/bash

# Script restore hệ thống SmartFarm sau khi gia hạn VPS
# Sử dụng: ./restore_system.sh <backup_name>

set -e

if [ -z "$1" ]; then
    echo "❌ Vui lòng cung cấp tên backup"
    echo "   Sử dụng: ./restore_system.sh smartfarm_backup_YYYYMMDD_HHMMSS"
    exit 1
fi

BACKUP_NAME="$1"
BACKUP_DIR="./backups"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

echo "🔄 Bắt đầu restore hệ thống SmartFarm..."
echo "📁 Thư mục backup: ${BACKUP_PATH}"
echo ""

# Kiểm tra backup có tồn tại không
if [ ! -d "${BACKUP_PATH}" ]; then
    echo "❌ Không tìm thấy backup: ${BACKUP_PATH}"
    echo "   Vui lòng giải nén file backup trước:"
    echo "   tar -xzf ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz -C ${BACKUP_DIR}/"
    exit 1
fi

# 1. Restore Code
echo "📝 Bước 1: Restore Code..."
if [ -f "${BACKUP_PATH}/code/source_code_"*.tar.gz ]; then
    CODE_FILE=$(ls ${BACKUP_PATH}/code/source_code_*.tar.gz | head -1)
    echo "   Giải nén: ${CODE_FILE}"
    tar -xzf "${CODE_FILE}"
    echo "✅ Đã restore code"
else
    echo "⚠️  Không tìm thấy file backup code"
fi

# 2. Restore Configuration
echo "⚙️  Bước 2: Restore Configuration..."
if [ -d "${BACKUP_PATH}/config" ]; then
    cp "${BACKUP_PATH}/config/docker-compose.yml" . 2>/dev/null || true
    cp "${BACKUP_PATH}/config/.env" . 2>/dev/null || true
    cp -r "${BACKUP_PATH}/config/nginx/" . 2>/dev/null || true
    echo "✅ Đã restore configuration"
else
    echo "⚠️  Không tìm thấy configuration backup"
fi

# 3. Start Docker Services
echo "🐳 Bước 3: Khởi động Docker Services..."
docker-compose up -d postgres
echo "   Đợi PostgreSQL khởi động..."
sleep 10

# 4. Restore Database
echo "📊 Bước 4: Restore Database..."
if [ -f "${BACKUP_PATH}/database/"*.sql ]; then
    DB_FILE=$(ls ${BACKUP_PATH}/database/*.sql | head -1)
    echo "   Restore từ: ${DB_FILE}"
    
    # Tạo database nếu chưa có
    docker-compose exec -T postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;" 2>/dev/null || true
    
    # Restore database
    docker-compose exec -T postgres psql -U postgres SmartFarm1 < "${DB_FILE}"
    echo "✅ Đã restore database"
else
    echo "⚠️  Không tìm thấy file backup database"
fi

# 5. Restore Docker Volumes (nếu có)
echo "💾 Bước 5: Restore Docker Volumes..."
if [ -f "${BACKUP_PATH}/docker/"*.tar.gz ]; then
    VOLUME_FILE=$(ls ${BACKUP_PATH}/docker/*.tar.gz | head -1)
    echo "   Restore volume từ: ${VOLUME_FILE}"
    
    # Stop postgres trước khi restore volume
    docker-compose stop postgres
    
    # Restore volume
    docker run --rm -v smartfarm_postgres_data:/data -v $(pwd)/${BACKUP_PATH}/docker:/backup alpine tar xzf /backup/$(basename ${VOLUME_FILE}) -C /data
    echo "✅ Đã restore docker volumes"
    
    # Start lại postgres
    docker-compose up -d postgres
    sleep 10
else
    echo "⚠️  Không tìm thấy file backup volumes"
fi

# 6. Build và Start All Services
echo "🚀 Bước 6: Build và Start All Services..."
docker-compose up -d --build

echo ""
echo "✅ Hoàn tất restore!"
echo ""
echo "📋 Kiểm tra services:"
docker-compose ps
echo ""
echo "📊 Kiểm tra logs:"
echo "   docker-compose logs -f"

