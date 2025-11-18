#!/bin/bash

# Script deploy SmartFarm lên VPS
# Sử dụng: ./deploy.sh

set -e

echo "🚀 Bắt đầu deploy SmartFarm lên VPS..."

# Màu sắc cho output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Kiểm tra Docker và Docker Compose
echo -e "${YELLOW}📦 Kiểm tra Docker và Docker Compose...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker chưa được cài đặt!${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose chưa được cài đặt!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker và Docker Compose đã sẵn sàng${NC}"

# Dừng các container cũ (nếu có)
echo -e "${YELLOW}🛑 Dừng các container cũ...${NC}"
docker-compose down || true

# Xóa images cũ (optional - comment nếu muốn giữ cache)
# echo -e "${YELLOW}🗑️  Xóa images cũ...${NC}"
# docker-compose rm -f || true

# Build và start các services
echo -e "${YELLOW}🔨 Build và start các services...${NC}"
docker-compose build --no-cache

echo -e "${YELLOW}🚀 Khởi động các services...${NC}"
docker-compose up -d

# Đợi các services khởi động
echo -e "${YELLOW}⏳ Đợi các services khởi động (30 giây)...${NC}"
sleep 30

# Kiểm tra trạng thái các services
echo -e "${YELLOW}📊 Kiểm tra trạng thái các services...${NC}"
docker-compose ps

# Kiểm tra health của các services
echo -e "${YELLOW}🏥 Kiểm tra health của các services...${NC}"

# Check PostgreSQL
if docker exec smartfarm-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo -e "${GREEN}✅ PostgreSQL: Healthy${NC}"
else
    echo -e "${RED}❌ PostgreSQL: Unhealthy${NC}"
fi

# Check Backend
if curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend API: Healthy${NC}"
else
    echo -e "${YELLOW}⏳ Backend API: Đang khởi động...${NC}"
fi

# Check Frontend
if curl -f http://localhost/ > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend: Healthy${NC}"
else
    echo -e "${YELLOW}⏳ Frontend: Đang khởi động...${NC}"
fi

# Check Crop Service
if curl -f http://localhost:5000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Crop Service: Healthy${NC}"
else
    echo -e "${YELLOW}⏳ Crop Service: Đang khởi động...${NC}"
fi

# Check Pest Service
if curl -f http://localhost:5001/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Pest Service: Healthy${NC}"
else
    echo -e "${YELLOW}⏳ Pest Service: Đang khởi động...${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Deploy hoàn tất!${NC}"
echo ""
echo "📋 Thông tin truy cập:"
echo "  - Frontend: http://173.249.48.25"
echo "  - Backend API: http://173.249.48.25:8080"
echo "  - Chatbot: http://173.249.48.25:9002"
echo ""
echo "📝 Xem logs:"
echo "  - docker-compose logs -f [service_name]"
echo "  - docker-compose logs -f backend"
echo "  - docker-compose logs -f frontend"
echo ""
echo "🛑 Dừng services:"
echo "  - docker-compose down"
echo ""
echo "🔄 Restart services:"
echo "  - docker-compose restart [service_name]"

