#!/bin/bash

# Script cập nhật SmartFarm từ Git trên VPS
# Sử dụng: ./update-from-git.sh

set -e

echo "🔄 Cập nhật SmartFarm từ Git..."

# Màu sắc
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Kiểm tra đang ở đúng thư mục
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Không tìm thấy docker-compose.yml. Đảm bảo đang ở thư mục SmartFarm${NC}"
    exit 1
fi

# Pull code mới
echo -e "${YELLOW}📥 Pulling code from Git...${NC}"
if git pull; then
    echo -e "${GREEN}✅ Pull thành công${NC}"
else
    echo -e "${RED}❌ Pull thất bại. Kiểm tra lại Git repository${NC}"
    exit 1
fi

# Hỏi có rebuild backend không
read -p "Có thay đổi backend không? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🔨 Rebuilding backend...${NC}"
    docker-compose build --no-cache backend
    docker-compose up -d backend
fi

# Rebuild frontend (luôn rebuild vì thường có thay đổi)
echo -e "${YELLOW}🔨 Rebuilding frontend...${NC}"
docker-compose build --no-cache frontend

# Restart frontend
echo -e "${YELLOW}🚀 Restarting frontend...${NC}"
docker-compose up -d frontend

# Đợi 5 giây
echo -e "${YELLOW}⏳ Đợi services khởi động...${NC}"
sleep 5

# Kiểm tra status
echo -e "${YELLOW}📊 Checking status...${NC}"
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
echo "📝 Xem logs:"
echo "  docker-compose logs -f frontend"
echo ""
echo "🌐 Truy cập: http://173.249.48.25"

