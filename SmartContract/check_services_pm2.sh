#!/bin/bash
# Script kiểm tra nhanh với PM2 (nếu đã dùng PM2)

echo "============================================================"
echo "  🔍 Kiểm tra SmartContract Services (PM2)"
echo "============================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}❌ PM2 chưa được cài đặt${NC}"
    echo "   Cài đặt: sudo npm install -g pm2"
    exit 1
fi

echo "📦 PM2 Process List:"
echo "----------------------------------------"
pm2 list
echo ""

echo "📊 Chi tiết từng service:"
echo "----------------------------------------"

# Arduino Forwarder
if pm2 list | grep -q "arduino-forwarder"; then
    status=$(pm2 jlist | jq -r '.[] | select(.name=="arduino-forwarder") | .pm2_env.status' 2>/dev/null || echo "unknown")
    if [ "$status" = "online" ]; then
        echo -e "   ${GREEN}✅ arduino-forwarder: $status${NC}"
        pm2 info arduino-forwarder | grep -E "status|uptime|restarts|memory"
    else
        echo -e "   ${RED}❌ arduino-forwarder: $status${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  arduino-forwarder: NOT FOUND${NC}"
fi
echo ""

# Flask API
if pm2 list | grep -q "flask-api"; then
    status=$(pm2 jlist | jq -r '.[] | select(.name=="flask-api") | .pm2_env.status' 2>/dev/null || echo "unknown")
    if [ "$status" = "online" ]; then
        echo -e "   ${GREEN}✅ flask-api: $status${NC}"
        pm2 info flask-api | grep -E "status|uptime|restarts|memory"
    else
        echo -e "   ${RED}❌ flask-api: $status${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  flask-api: NOT FOUND${NC}"
fi
echo ""

# Oracle Node
if pm2 list | grep -q "oracle-node"; then
    status=$(pm2 jlist | jq -r '.[] | select(.name=="oracle-node") | .pm2_env.status' 2>/dev/null || echo "unknown")
    if [ "$status" = "online" ]; then
        echo -e "   ${GREEN}✅ oracle-node: $status${NC}"
        pm2 info oracle-node | grep -E "status|uptime|restarts|memory"
    else
        echo -e "   ${RED}❌ oracle-node: $status${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  oracle-node: NOT FOUND${NC}"
fi
echo ""

echo "📋 Logs (10 dòng cuối):"
echo "----------------------------------------"
echo "Arduino Forwarder:"
pm2 logs arduino-forwarder --lines 10 --nostream 2>/dev/null || echo "   No logs"
echo ""
echo "Flask API:"
pm2 logs flask-api --lines 10 --nostream 2>/dev/null || echo "   No logs"
echo ""
echo "Oracle Node:"
pm2 logs oracle-node --lines 10 --nostream 2>/dev/null || echo "   No logs"
echo ""

echo "🔌 Ports:"
echo "----------------------------------------"
echo -n "   Port 8000 (Flask API): "
if netstat -tuln 2>/dev/null | grep -q ":8000 " || ss -tuln 2>/dev/null | grep -q ":8000 "; then
    echo -e "${GREEN}✅ LISTENING${NC}"
else
    echo -e "${RED}❌ NOT LISTENING${NC}"
fi

echo -n "   Port 5001 (Oracle Node): "
if netstat -tuln 2>/dev/null | grep -q ":5001 " || ss -tuln 2>/dev/null | grep -q ":5001 "; then
    echo -e "${GREEN}✅ LISTENING${NC}"
else
    echo -e "${RED}❌ NOT LISTENING${NC}"
fi
echo ""

