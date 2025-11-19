#!/bin/bash
# Script setup tự động: Arduino USB → Database → PioneChain

echo "============================================================"
echo "  🚀 Setup Tự động IoT: Arduino → Database → PioneChain"
echo "============================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Kiểm tra PM2
echo "📦 1. Kiểm tra PM2..."
if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}❌ PM2 chưa được cài đặt${NC}"
    echo "   Đang cài đặt PM2..."
    sudo npm install -g pm2
else
    echo -e "${GREEN}✅ PM2 đã được cài đặt${NC}"
fi
echo ""

# 2. Kiểm tra Python và dependencies
echo "🐍 2. Kiểm tra Python và dependencies..."
cd device
if [ ! -d "venv" ]; then
    echo "   Tạo virtual environment..."
    python3 -m venv venv
fi

source venv/bin/activate
pip install -q pyserial requests
echo -e "${GREEN}✅ Python dependencies OK${NC}"
deactivate
cd ..
echo ""

# 3. Tạo thư mục logs
echo "📁 3. Tạo thư mục logs..."
mkdir -p device/logs
echo -e "${GREEN}✅ Thư mục logs đã tạo${NC}"
echo ""

# 4. Chỉnh sửa ecosystem config
echo "⚙️  4. Cấu hình ecosystem config..."
echo "   Đang kiểm tra ecosystem config..."

# Kiểm tra cả .cjs và .json
CONFIG_FILE=""
if [ -f "device/ecosystem.config.cjs" ]; then
    CONFIG_FILE="device/ecosystem.config.cjs"
elif [ -f "device/ecosystem.config.json" ]; then
    CONFIG_FILE="device/ecosystem.config.json"
elif [ -f "device/ecosystem.config.js" ]; then
    CONFIG_FILE="device/ecosystem.config.js"
else
    echo -e "${RED}❌ Không tìm thấy ecosystem config file${NC}"
    exit 1
fi

# Lấy đường dẫn hiện tại
CURRENT_DIR=$(pwd)
echo "   Current directory: $CURRENT_DIR"
echo "   Config file: $CONFIG_FILE"
echo "   Vui lòng chỉnh sửa $CONFIG_FILE:"
echo "   - cwd: '$CURRENT_DIR/device'"
echo "   - FLASK_URL: 'http://173.249.48.25:8000/api/sensors'"
echo "   - API_KEY: 'MY_API_KEY' (phải khớp với flask-api/.env)"
echo ""
read -p "   Đã chỉnh sửa chưa? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "   Vui lòng chỉnh sửa $CONFIG_FILE trước khi tiếp tục"
    exit 1
fi
echo ""

# 5. Cấp quyền USB
echo "🔌 5. Cấp quyền truy cập USB..."
if ! groups | grep -q dialout; then
    echo "   Thêm user vào dialout group..."
    sudo usermod -a -G dialout $USER
    echo -e "${YELLOW}⚠️  Cần logout và login lại để áp dụng quyền${NC}"
    echo "   Hoặc chạy: newgrp dialout"
else
    echo -e "${GREEN}✅ User đã có quyền truy cập USB${NC}"
fi
echo ""

# 6. Start Arduino Forwarder với PM2
echo "🚀 6. Start Arduino Forwarder với PM2..."
cd device

# Kiểm tra xem đã chạy chưa
if pm2 list | grep -q "arduino-forwarder"; then
    echo "   Arduino Forwarder đã chạy, đang restart..."
    pm2 restart arduino-forwarder
else
    echo "   Đang start Arduino Forwarder..."
    # Dùng config file đã tìm thấy
    if [ -f "ecosystem.config.cjs" ]; then
        pm2 start ecosystem.config.cjs
    elif [ -f "ecosystem.config.json" ]; then
        pm2 start ecosystem.config.json
    else
        pm2 start ecosystem.config.js
    fi
fi

# Save PM2 process list
pm2 save
echo -e "${GREEN}✅ Arduino Forwarder đã được start${NC}"
cd ..
echo ""

# 7. Setup auto-start khi boot
echo "🔄 7. Setup auto-start khi boot..."
if ! pm2 startup | grep -q "already"; then
    echo "   PM2 startup chưa được setup"
    STARTUP_CMD=$(pm2 startup | grep "sudo")
    if [ -n "$STARTUP_CMD" ]; then
        echo "   Chạy lệnh sau để setup auto-start:"
        echo "   $STARTUP_CMD"
        echo ""
        read -p "   Chạy lệnh này ngay? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            eval $STARTUP_CMD
        fi
    fi
else
    echo -e "${GREEN}✅ PM2 startup đã được setup${NC}"
fi
echo ""

# 8. Kiểm tra services
echo "✅ 8. Kiểm tra tất cả services..."
echo ""
pm2 status
echo ""

# 9. Test flow
echo "🧪 9. Test flow..."
echo "   Đang kiểm tra các service..."

# Test Flask API
echo -n "   Flask API (port 8000): "
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/api/sensors/latest | grep -q "200\|401"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ FAILED${NC}"
fi

# Test Oracle Node
echo -n "   Oracle Node (port 5001): "
ORACLE_HEALTH=$(curl -s http://localhost:5001/oracle/health 2>/dev/null)
if [ $? -eq 0 ] && echo "$ORACLE_HEALTH" | grep -q "ok.*true\|status.*running"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ FAILED${NC}"
    echo "      Response: $ORACLE_HEALTH"
    echo "      Kiểm tra: pm2 logs oracle-node"
fi

# Test Arduino Forwarder
echo -n "   Arduino Forwarder: "
if pm2 list | grep "arduino-forwarder" | grep -q "online"; then
    echo -e "${GREEN}✅ RUNNING${NC}"
else
    echo -e "${RED}❌ NOT RUNNING${NC}"
fi
echo ""

# 10. Hướng dẫn
echo "============================================================"
echo "  📋 Hướng dẫn sử dụng:"
echo "============================================================"
echo ""
echo "1. Cắm USB Arduino vào VPS"
echo "2. Arduino Forwarder sẽ tự động tìm và kết nối"
echo "3. Data flow:"
echo "   Arduino → Forwarder → Flask API → PostgreSQL → Oracle Node → PioneChain"
echo ""
echo "📊 Kiểm tra:"
echo "   pm2 status              # Xem tất cả services"
echo "   pm2 logs arduino-forwarder  # Xem logs Arduino Forwarder"
echo "   pm2 logs flask-api      # Xem logs Flask API"
echo "   pm2 logs oracle-node    # Xem logs Oracle Node"
echo ""
echo "🔍 Test endpoints:"
echo "   curl http://localhost:8000/api/sensors/latest"
echo "   curl http://localhost:5001/oracle/health"
echo ""
echo "💾 Kiểm tra database:"
echo "   psql \$DB_URL -c \"SELECT COUNT(*) FROM sensor_data;\""
echo ""
echo -e "${GREEN}✅ Setup hoàn tất!${NC}"
echo ""

