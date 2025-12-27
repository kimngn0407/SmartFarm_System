#!/bin/bash

# Quick Deployment Verification Script
# Run this on VPS after deployment

VPS_IP="109.205.180.72"

echo "🔍 SmartFarm Deployment Verification"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Docker Compose status
echo "📊 1. Docker Compose Status:"
docker compose ps
echo ""

# Check each service
echo "🏥 2. Health Checks:"
echo ""

check_service() {
    local name=$1
    local url=$2
    local response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" 2>/dev/null || echo "000")
    
    if [ "$response" = "200" ]; then
        echo -e "   ${GREEN}✅ $name: Healthy (HTTP $response)${NC}"
        return 0
    elif [ "$response" = "000" ]; then
        echo -e "   ${RED}❌ $name: Not responding${NC}"
        return 1
    else
        echo -e "   ${YELLOW}⚠️  $name: HTTP $response${NC}"
        return 1
    fi
}

check_service "Backend API" "http://localhost:8080/api/auth/health"
check_service "Frontend" "http://localhost/health"
check_service "Crop ML Service" "http://localhost:5000/health"
check_service "Pest ML Service" "http://localhost:5001/health"

echo ""
echo "📋 3. Service URLs:"
echo "   Frontend:  http://${VPS_IP}"
echo "   Backend:   http://${VPS_IP}:8080"
echo "   Chatbot:   http://${VPS_IP}:9002"
echo "   Crop ML:   http://${VPS_IP}:5000/health"
echo "   Pest ML:   http://${VPS_IP}:5001/health"
echo ""

# Check logs for errors
echo "📝 4. Recent Errors (if any):"
echo ""
docker compose logs --tail=20 2>&1 | grep -i error | tail -5 || echo "   No recent errors found"
echo ""

# Resource usage
echo "💻 5. Resource Usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | head -8
echo ""

echo "✅ Verification complete!"
echo ""
echo "💡 Useful commands:"
echo "   View logs:     docker compose logs -f"
echo "   Restart all:   docker compose restart"
echo "   Stop all:      docker compose down"
echo "   Start all:     docker compose up -d"





#!/bin/bash

# Quick Deployment Verification Script
# Run this on VPS after deployment

VPS_IP="109.205.180.72"

echo "🔍 SmartFarm Deployment Verification"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Docker Compose status
echo "📊 1. Docker Compose Status:"
docker compose ps
echo ""

# Check each service
echo "🏥 2. Health Checks:"
echo ""

check_service() {
    local name=$1
    local url=$2
    local response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" 2>/dev/null || echo "000")
    
    if [ "$response" = "200" ]; then
        echo -e "   ${GREEN}✅ $name: Healthy (HTTP $response)${NC}"
        return 0
    elif [ "$response" = "000" ]; then
        echo -e "   ${RED}❌ $name: Not responding${NC}"
        return 1
    else
        echo -e "   ${YELLOW}⚠️  $name: HTTP $response${NC}"
        return 1
    fi
}

check_service "Backend API" "http://localhost:8080/api/auth/health"
check_service "Frontend" "http://localhost/health"
check_service "Crop ML Service" "http://localhost:5000/health"
check_service "Pest ML Service" "http://localhost:5001/health"

echo ""
echo "📋 3. Service URLs:"
echo "   Frontend:  http://${VPS_IP}"
echo "   Backend:   http://${VPS_IP}:8080"
echo "   Chatbot:   http://${VPS_IP}:9002"
echo "   Crop ML:   http://${VPS_IP}:5000/health"
echo "   Pest ML:   http://${VPS_IP}:5001/health"
echo ""

# Check logs for errors
echo "📝 4. Recent Errors (if any):"
echo ""
docker compose logs --tail=20 2>&1 | grep -i error | tail -5 || echo "   No recent errors found"
echo ""

# Resource usage
echo "💻 5. Resource Usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | head -8
echo ""

echo "✅ Verification complete!"
echo ""
echo "💡 Useful commands:"
echo "   View logs:     docker compose logs -f"
echo "   Restart all:   docker compose restart"
echo "   Stop all:      docker compose down"
echo "   Start all:     docker compose up -d"





