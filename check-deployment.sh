#!/bin/bash

# ✅ SmartFarm Deployment Checker
# Kiểm tra tất cả services sau khi deploy

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 SmartFarm Deployment Checker${NC}"
echo "=================================="
echo ""

# Check Docker
echo -e "${YELLOW}1. Checking Docker...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}   ✅ Docker: $(docker --version)${NC}"
else
    echo -e "${RED}   ❌ Docker not installed${NC}"
    exit 1
fi

# Check Docker Compose
if command -v docker compose &> /dev/null; then
    echo -e "${GREEN}   ✅ Docker Compose: $(docker compose version)${NC}"
else
    echo -e "${RED}   ❌ Docker Compose not installed${NC}"
    exit 1
fi

# Check containers
echo ""
echo -e "${YELLOW}2. Checking containers...${NC}"
docker compose ps

# Check services health
echo ""
echo -e "${YELLOW}3. Checking service health...${NC}"

# Backend
echo -n "   Backend API (8080): "
if curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Healthy${NC}"
else
    echo -e "${RED}❌ Unhealthy${NC}"
    echo -e "${YELLOW}   Logs: docker compose logs backend${NC}"
fi

# Frontend
echo -n "   Frontend (80): "
if curl -f http://localhost:80 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Healthy${NC}"
else
    echo -e "${RED}❌ Unhealthy${NC}"
    echo -e "${YELLOW}   Logs: docker compose logs frontend${NC}"
fi

# Database
echo -n "   Database (5432): "
if docker exec smartfarm-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Healthy${NC}"
else
    echo -e "${RED}❌ Unhealthy${NC}"
    echo -e "${YELLOW}   Logs: docker compose logs postgres${NC}"
fi

# Crop Service
echo -n "   Crop ML Service (5000): "
if curl -f http://localhost:5000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Healthy${NC}"
else
    echo -e "${YELLOW}⚠️  Not responding (may be starting)${NC}"
fi

# Pest Service
echo -n "   Pest ML Service (5001): "
if curl -f http://localhost:5001/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Healthy${NC}"
else
    echo -e "${YELLOW}⚠️  Not responding (may be starting)${NC}"
fi

# Chatbot
echo -n "   Chatbot (9002): "
if curl -f http://localhost:9002 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Healthy${NC}"
else
    echo -e "${YELLOW}⚠️  Not responding (may be starting)${NC}"
fi

# Check resources
echo ""
echo -e "${YELLOW}4. Resource usage:${NC}"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Check ports
echo ""
echo -e "${YELLOW}5. Checking ports...${NC}"
PORTS=(80 8080 5000 5001 9002 5432)
for port in "${PORTS[@]}"; do
    if netstat -tuln | grep -q ":$port "; then
        echo -e "${GREEN}   ✅ Port $port is open${NC}"
    else
        echo -e "${RED}   ❌ Port $port is not open${NC}"
    fi
done

# Get VPS IP
VPS_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || hostname -I | awk '{print $1}')

echo ""
echo -e "${BLUE}📊 Access URLs:${NC}"
echo -e "   Frontend:    ${GREEN}http://${VPS_IP}${NC}"
echo -e "   Backend:     ${GREEN}http://${VPS_IP}:8080${NC}"
echo -e "   Chatbot:     ${GREEN}http://${VPS_IP}:9002${NC}"
echo ""

# Final status
echo -e "${YELLOW}6. Overall Status:${NC}"
ALL_HEALTHY=true

if ! curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; then
    ALL_HEALTHY=false
fi
if ! curl -f http://localhost:80 > /dev/null 2>&1; then
    ALL_HEALTHY=false
fi
if ! docker exec smartfarm-postgres pg_isready -U postgres > /dev/null 2>&1; then
    ALL_HEALTHY=false
fi

if [ "$ALL_HEALTHY" = true ]; then
    echo -e "${GREEN}   ✅ All critical services are healthy!${NC}"
    echo ""
    echo -e "${GREEN}🎉 Deployment successful!${NC}"
else
    echo -e "${RED}   ❌ Some services are not healthy${NC}"
    echo ""
    echo -e "${YELLOW}💡 Troubleshooting:${NC}"
    echo "   1. Check logs: docker compose logs -f"
    echo "   2. Restart services: docker compose restart"
    echo "   3. Rebuild: docker compose build && docker compose up -d"
fi

echo ""

