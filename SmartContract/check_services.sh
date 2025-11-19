#!/bin/bash
# Script kiểm tra các service SmartContract đang chạy trên VPS

echo "============================================================"
echo "  🔍 Kiểm tra SmartContract Services trên VPS"
echo "============================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Kiểm tra PM2 processes
echo "📦 1. PM2 Processes:"
echo "----------------------------------------"
if command -v pm2 &> /dev/null; then
    pm2_status=$(pm2 list 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "$pm2_status"
        echo ""
        
        # Kiểm tra từng service
        echo "   Chi tiết từng service:"
        pm2 list | grep -E "arduino-forwarder|flask-api|oracle-node" | while read line; do
            if echo "$line" | grep -q "online"; then
                echo -e "   ${GREEN}✅ $line${NC}"
            elif echo "$line" | grep -q "errored\|stopped"; then
                echo -e "   ${RED}❌ $line${NC}"
            else
                echo -e "   ${YELLOW}⚠️  $line${NC}"
            fi
        done
    else
        echo -e "   ${YELLOW}⚠️  PM2 không chạy hoặc không có process nào${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  PM2 chưa được cài đặt${NC}"
fi
echo ""

# 2. Kiểm tra Systemd services
echo "🔧 2. Systemd Services:"
echo "----------------------------------------"
services=("arduino-forwarder" "flask-api" "oracle-node")
for service in "${services[@]}"; do
    if systemctl list-unit-files | grep -q "$service.service"; then
        status=$(systemctl is-active "$service.service" 2>/dev/null)
        if [ "$status" = "active" ]; then
            echo -e "   ${GREEN}✅ $service.service: ACTIVE${NC}"
        else
            echo -e "   ${RED}❌ $service.service: $status${NC}"
        fi
    fi
done
echo ""

# 3. Kiểm tra Ports đang listen
echo "🔌 3. Ports đang listen:"
echo "----------------------------------------"
ports=("8000:Flask API" "5001:Oracle Node" "8080:Backend API")
for port_info in "${ports[@]}"; do
    port=$(echo $port_info | cut -d: -f1)
    name=$(echo $port_info | cut -d: -f2)
    
    if netstat -tuln 2>/dev/null | grep -q ":$port " || ss -tuln 2>/dev/null | grep -q ":$port "; then
        process=$(lsof -i :$port 2>/dev/null | tail -1 | awk '{print $1, $2}' || echo "unknown")
        echo -e "   ${GREEN}✅ Port $port ($name): LISTENING${NC} - Process: $process"
    else
        echo -e "   ${RED}❌ Port $port ($name): NOT LISTENING${NC}"
    fi
done
echo ""

# 4. Kiểm tra Processes đang chạy
echo "🔄 4. Processes đang chạy:"
echo "----------------------------------------"
processes=("python.*app.py:Flask API" "node.*server.js:Oracle Node" "python.*forwarder:Arduino Forwarder")
for proc_info in "${processes[@]}"; do
    pattern=$(echo $proc_info | cut -d: -f1)
    name=$(echo $proc_info | cut -d: -f2)
    
    if pgrep -f "$pattern" > /dev/null; then
        pid=$(pgrep -f "$pattern" | head -1)
        echo -e "   ${GREEN}✅ $name: RUNNING (PID: $pid)${NC}"
    else
        echo -e "   ${RED}❌ $name: NOT RUNNING${NC}"
    fi
done
echo ""

# 5. Health Check - Test API endpoints
echo "🏥 5. Health Check - API Endpoints:"
echo "----------------------------------------"

# Flask API Health Check
echo -n "   Flask API (http://localhost:8000/api/sensors/latest): "
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/api/sensors/latest | grep -q "200\|401"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ FAILED${NC}"
fi

# Oracle Node Health Check
echo -n "   Oracle Node (http://localhost:5001/oracle/health): "
oracle_health=$(curl -s http://localhost:5001/oracle/health 2>/dev/null)
if [ $? -eq 0 ] && echo "$oracle_health" | grep -q "ok.*true"; then
    echo -e "${GREEN}✅ OK${NC}"
    echo "      Response: $oracle_health"
else
    echo -e "${RED}❌ FAILED${NC}"
fi

# Backend API Health Check
echo -n "   Backend API (http://localhost:8080/actuator/health): "
backend_health=$(curl -s http://localhost:8080/actuator/health 2>/dev/null)
if [ $? -eq 0 ] && echo "$backend_health" | grep -q "UP\|status"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ FAILED${NC}"
fi
echo ""

# 6. Kiểm tra Database connection (nếu có .env)
echo "💾 6. Database Connection:"
echo "----------------------------------------"
if [ -f "flask-api/.env" ]; then
    echo "   ✅ Found flask-api/.env"
    # Có thể thêm test connection ở đây nếu cần
else
    echo -e "   ${YELLOW}⚠️  flask-api/.env not found${NC}"
fi
echo ""

# 7. Kiểm tra Arduino/USB devices
echo "🔌 7. USB/Serial Devices:"
echo "----------------------------------------"
if ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null | head -1 > /dev/null; then
    devices=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null)
    echo -e "   ${GREEN}✅ Found USB devices:${NC}"
    for dev in $devices; do
        echo "      - $dev"
    done
else
    echo -e "   ${YELLOW}⚠️  No USB/Serial devices found${NC}"
fi
echo ""

# 8. Summary
echo "============================================================"
echo "  📊 Summary:"
echo "============================================================"

# Đếm số service đang chạy
running_count=0
total_count=0

# Check PM2
if command -v pm2 &> /dev/null; then
    pm2_running=$(pm2 list 2>/dev/null | grep -c "online" || echo "0")
    running_count=$((running_count + pm2_running))
fi

# Check systemd
for service in "${services[@]}"; do
    total_count=$((total_count + 1))
    if systemctl is-active "$service.service" &>/dev/null; then
        running_count=$((running_count + 1))
    fi
done

echo "   Services running: $running_count"
echo "   Total services checked: $total_count"
echo ""

# Recommendations
echo "💡 Recommendations:"
if [ $running_count -eq 0 ]; then
    echo -e "   ${RED}❌ Không có service nào đang chạy!${NC}"
    echo "   → Chạy: pm2 start ecosystem.config.js"
    echo "   → Hoặc: sudo systemctl start arduino-forwarder.service"
elif [ $running_count -lt 2 ]; then
    echo -e "   ${YELLOW}⚠️  Một số service chưa chạy${NC}"
    echo "   → Kiểm tra logs: pm2 logs hoặc journalctl -u <service>"
else
    echo -e "   ${GREEN}✅ Các service đang chạy tốt!${NC}"
fi
echo ""

