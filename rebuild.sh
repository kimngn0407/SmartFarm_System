#!/bin/bash

# Script rebuild SmartFarm trên VPS
# Sử dụng: ./rebuild.sh

set -e

echo "🔨 Bắt đầu rebuild SmartFarm..."

# Màu sắc cho output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. Rebuild Docker containers
echo -e "${YELLOW}🐳 Bước 1: Rebuild Docker containers...${NC}"
cd ~/projects/SmartFarm || cd /root/projects/SmartFarm || exit 1

# Dừng containers
echo -e "${YELLOW}🛑 Dừng các container cũ...${NC}"
docker-compose down || true

# Xóa images cũ để build lại từ đầu
echo -e "${YELLOW}🗑️  Xóa images cũ...${NC}"
docker-compose rm -f || true
docker system prune -f || true

# Build lại tất cả services
echo -e "${YELLOW}🔨 Build lại các services (no-cache)...${NC}"
docker-compose build --no-cache

# Khởi động lại
echo -e "${YELLOW}🚀 Khởi động các services...${NC}"
docker-compose up -d

# 2. Rebuild Python virtual environments
echo ""
echo -e "${YELLOW}🐍 Bước 2: Tạo lại Python virtual environments...${NC}"

# Flask API service
if [ -d "SmartContract/flask-api" ]; then
    echo -e "${YELLOW}📦 Tạo .venv cho flask-api...${NC}"
    cd SmartContract/flask-api
    rm -rf .venv
    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    deactivate
    cd ../..
    echo -e "${GREEN}✅ flask-api .venv đã được tạo lại${NC}"
fi

# Device forwarder service
if [ -d "SmartContract/device" ]; then
    echo -e "${YELLOW}📦 Tạo venv cho device forwarder...${NC}"
    cd SmartContract/device
    rm -rf venv
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install pyserial requests
    deactivate
    cd ../..
    echo -e "${GREEN}✅ device venv đã được tạo lại${NC}"
fi

# Crop Recommendation service
if [ -d "RecommentCrop" ]; then
    echo -e "${YELLOW}📦 Tạo .venv cho RecommentCrop...${NC}"
    cd RecommentCrop
    rm -rf .venv
    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    fi
    deactivate
    cd ..
    echo -e "${GREEN}✅ RecommentCrop .venv đã được tạo lại${NC}"
fi

# Pest and Disease service
if [ -d "PestAndDisease" ]; then
    echo -e "${YELLOW}📦 Tạo .venv cho PestAndDisease...${NC}"
    cd PestAndDisease
    rm -rf .venv
    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    fi
    deactivate
    cd ..
    echo -e "${GREEN}✅ PestAndDisease .venv đã được tạo lại${NC}"
fi

# 3. Đợi services khởi động
echo ""
echo -e "${YELLOW}⏳ Đợi các services khởi động (30 giây)...${NC}"
sleep 30

# 4. Kiểm tra trạng thái
echo ""
echo -e "${YELLOW}📊 Kiểm tra trạng thái các services...${NC}"
docker-compose ps

# Kiểm tra health
echo ""
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
echo -e "${GREEN}🎉 Rebuild hoàn tất!${NC}"
echo ""
echo "📋 Thông tin truy cập:"
echo "  - Frontend: http://173.249.48.25"
echo "  - Backend API: http://173.249.48.25:8080"
echo "  - Chatbot: http://173.249.48.25:9002"
echo ""
echo "📝 Xem logs:"
echo "  - docker-compose logs -f [service_name]"
echo ""
echo "🔄 Nếu cần restart services:"
echo "  - docker-compose restart [service_name]"

