#!/bin/bash

# SmartFarm VPS Deployment Script
# Usage: ./deploy-vps.sh

set -e  # Exit on error

echo "🚀 SmartFarm VPS Deployment Script"
echo "=================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ File .env không tồn tại!${NC}"
    echo "Tạo file .env từ template:"
    echo "  cp env.vps.template .env"
    echo "Sau đó chỉnh sửa với thông tin thực tế."
    exit 1
fi

echo -e "${GREEN}✅ File .env đã tồn tại${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker chưa được cài đặt!${NC}"
    echo "Cài đặt Docker trước khi deploy."
    exit 1
fi

echo -e "${GREEN}✅ Docker đã được cài đặt${NC}"

# Check Docker Compose
if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose chưa được cài đặt!${NC}"
    echo "Cài đặt Docker Compose trước khi deploy."
    exit 1
fi

echo -e "${GREEN}✅ Docker Compose đã được cài đặt${NC}"

# Pull latest code (if git repo)
if [ -d .git ]; then
    echo ""
    echo -e "${YELLOW}📥 Pulling latest code...${NC}"
    git pull || echo "Warning: Could not pull latest code"
fi

# Build and start services
echo ""
echo -e "${YELLOW}🔨 Building and starting services...${NC}"
docker compose up -d --build

# Wait for services to be healthy
echo ""
echo -e "${YELLOW}⏳ Waiting for services to be healthy...${NC}"
sleep 10

# Check service status
echo ""
echo -e "${YELLOW}📊 Service Status:${NC}"
docker compose ps

# Health checks
echo ""
echo -e "${YELLOW}🏥 Running health checks...${NC}"

check_health() {
    local service=$1
    local url=$2
    if curl -f -s "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $service: Healthy${NC}"
        return 0
    else
        echo -e "${RED}❌ $service: Unhealthy${NC}"
        return 1
    fi
}

check_health "Backend" "http://localhost:8080/api/auth/health"
check_health "Frontend" "http://localhost/health" || true
check_health "Crop ML" "http://localhost:5000/health"
check_health "Pest ML" "http://localhost:5001/health"

echo ""
echo -e "${GREEN}🎉 Deployment completed!${NC}"
echo ""
echo "Services are available at:"
echo "  - Frontend: http://109.205.180.72"
echo "  - Backend: http://109.205.180.72:8080"
echo "  - Chatbot: http://109.205.180.72:9002"
echo ""
echo "View logs: docker compose logs -f"
echo "Stop services: docker compose down"





#!/bin/bash

# SmartFarm VPS Deployment Script
# Usage: ./deploy-vps.sh

set -e  # Exit on error

echo "🚀 SmartFarm VPS Deployment Script"
echo "=================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ File .env không tồn tại!${NC}"
    echo "Tạo file .env từ template:"
    echo "  cp env.vps.template .env"
    echo "Sau đó chỉnh sửa với thông tin thực tế."
    exit 1
fi

echo -e "${GREEN}✅ File .env đã tồn tại${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker chưa được cài đặt!${NC}"
    echo "Cài đặt Docker trước khi deploy."
    exit 1
fi

echo -e "${GREEN}✅ Docker đã được cài đặt${NC}"

# Check Docker Compose
if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose chưa được cài đặt!${NC}"
    echo "Cài đặt Docker Compose trước khi deploy."
    exit 1
fi

echo -e "${GREEN}✅ Docker Compose đã được cài đặt${NC}"

# Pull latest code (if git repo)
if [ -d .git ]; then
    echo ""
    echo -e "${YELLOW}📥 Pulling latest code...${NC}"
    git pull || echo "Warning: Could not pull latest code"
fi

# Build and start services
echo ""
echo -e "${YELLOW}🔨 Building and starting services...${NC}"
docker compose up -d --build

# Wait for services to be healthy
echo ""
echo -e "${YELLOW}⏳ Waiting for services to be healthy...${NC}"
sleep 10

# Check service status
echo ""
echo -e "${YELLOW}📊 Service Status:${NC}"
docker compose ps

# Health checks
echo ""
echo -e "${YELLOW}🏥 Running health checks...${NC}"

check_health() {
    local service=$1
    local url=$2
    if curl -f -s "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $service: Healthy${NC}"
        return 0
    else
        echo -e "${RED}❌ $service: Unhealthy${NC}"
        return 1
    fi
}

check_health "Backend" "http://localhost:8080/api/auth/health"
check_health "Frontend" "http://localhost/health" || true
check_health "Crop ML" "http://localhost:5000/health"
check_health "Pest ML" "http://localhost:5001/health"

echo ""
echo -e "${GREEN}🎉 Deployment completed!${NC}"
echo ""
echo "Services are available at:"
echo "  - Frontend: http://109.205.180.72"
echo "  - Backend: http://109.205.180.72:8080"
echo "  - Chatbot: http://109.205.180.72:9002"
echo ""
echo "View logs: docker compose logs -f"
echo "Stop services: docker compose down"





