#!/bin/bash

# 🚀 SmartFarm Deployment Script
# Tự động deploy SmartFarm lên VPS

set -e  # Exit on error

echo "🌾 SmartFarm Deployment Script"
echo "================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Please run as root (use sudo)${NC}"
    exit 1
fi

# Check Docker
echo -e "${YELLOW}📦 Checking Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker not found. Installing...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
    echo -e "${GREEN}✅ Docker installed${NC}"
else
    echo -e "${GREEN}✅ Docker is installed${NC}"
fi

# Check Docker Compose
if ! command -v docker compose &> /dev/null; then
    echo -e "${YELLOW}Docker Compose not found. Installing...${NC}"
    apt update
    apt install docker-compose-plugin -y
    echo -e "${GREEN}✅ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✅ Docker Compose is installed${NC}"
fi

# Check .env file
echo -e "${YELLOW}📝 Checking .env file...${NC}"
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file from template...${NC}"
    cat > .env << EOF
# Database
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=$(openssl rand -base64 32)

# JWT
JWT_SECRET=$(openssl rand -base64 32)
JWT_EXPIRATION=86400000

# VPS IP - CHANGE THIS!
FRONTEND_ORIGINS=http://YOUR_VPS_IP,http://YOUR_VPS_IP:80,http://localhost:3000

# Google Gemini API
GOOGLE_GENAI_API_KEY=your-google-gemini-api-key

# Next.js API URL
NEXT_PUBLIC_API_URL=http://YOUR_VPS_IP:8080
EOF
    echo -e "${GREEN}✅ .env file created${NC}"
    echo -e "${RED}⚠️  IMPORTANT: Edit .env file and set YOUR_VPS_IP!${NC}"
    echo -e "${YELLOW}Press Enter to continue after editing .env...${NC}"
    read
else
    echo -e "${GREEN}✅ .env file exists${NC}"
fi

# Stop existing containers
echo -e "${YELLOW}🛑 Stopping existing containers...${NC}"
docker compose down 2>/dev/null || true

# Build images
echo -e "${YELLOW}🏗️  Building Docker images...${NC}"
echo -e "${YELLOW}This may take 10-20 minutes on first build...${NC}"
docker compose build --no-cache

# Start services
echo -e "${YELLOW}🚀 Starting services...${NC}"
docker compose up -d

# Wait for services to be healthy
echo -e "${YELLOW}⏳ Waiting for services to start...${NC}"
sleep 30

# Check services
echo -e "${YELLOW}✅ Checking services status...${NC}"
docker compose ps

# Check health
echo -e "${YELLOW}🏥 Checking service health...${NC}"

# Check backend
if curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend is healthy${NC}"
else
    echo -e "${RED}❌ Backend health check failed${NC}"
fi

# Check frontend
if curl -f http://localhost:80 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend is healthy${NC}"
else
    echo -e "${RED}❌ Frontend health check failed${NC}"
fi

# Check database
if docker exec smartfarm-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Database is healthy${NC}"
else
    echo -e "${RED}❌ Database health check failed${NC}"
fi

# Get VPS IP
VPS_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip || hostname -I | awk '{print $1}')

echo ""
echo -e "${GREEN}🎉 Deployment completed!${NC}"
echo ""
echo "📊 Services:"
echo "  - Frontend:    http://${VPS_IP}"
echo "  - Backend API: http://${VPS_IP}:8080"
echo "  - Chatbot:     http://${VPS_IP}:9002"
echo ""
echo "📝 Useful commands:"
echo "  - View logs:    docker compose logs -f"
echo "  - Stop all:     docker compose down"
echo "  - Restart:      docker compose restart"
echo "  - Status:       docker compose ps"
echo ""

