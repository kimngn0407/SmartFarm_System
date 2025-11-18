#!/bin/bash

# Script cập nhật SmartFarm trên VPS
# Sử dụng: ./update.sh

set -e

echo "🔄 Bắt đầu cập nhật SmartFarm..."

# Màu sắc cho output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Kiểm tra Docker và Docker Compose
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker chưa được cài đặt!${NC}"
    exit 1
fi

# Pull code mới (nếu dùng Git)
if [ -d ".git" ]; then
    echo -e "${YELLOW}📥 Pull code mới từ Git...${NC}"
    git pull || echo -e "${YELLOW}⚠️  Không thể pull, có thể đã có thay đổi local${NC}"
fi

# Rebuild frontend (vì đã sửa Dashboard.js)
echo -e "${YELLOW}🔨 Rebuild frontend với code mới...${NC}"
docker-compose build --no-cache frontend

# Restart frontend
echo -e "${YELLOW}🔄 Restart frontend...${NC}"
docker-compose up -d frontend

# Nếu có thay đổi backend, rebuild backend
read -p "Có thay đổi backend không? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🔨 Rebuild backend...${NC}"
    docker-compose build --no-cache backend
    docker-compose up -d backend
fi

# Đợi services khởi động
echo -e "${YELLOW}⏳ Đợi services khởi động (10 giây)...${NC}"
sleep 10

# Kiểm tra trạng thái
echo -e "${YELLOW}📊 Kiểm tra trạng thái...${NC}"
docker-compose ps

# Kiểm tra frontend
if curl -f http://localhost/ > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend: Đang chạy${NC}"
else
    echo -e "${YELLOW}⏳ Frontend: Đang khởi động...${NC}"
fi

echo ""
echo -e "${GREEN}✅ Cập nhật hoàn tất!${NC}"
echo ""
echo "📝 Xem logs frontend:"
echo "  docker-compose logs -f frontend"
echo ""
echo "🌐 Truy cập: http://173.249.48.25"

