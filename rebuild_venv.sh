#!/bin/bash

# Script chỉ rebuild Python virtual environments (không rebuild Docker)
# Sử dụng: ./rebuild_venv.sh

set -e

echo "🐍 Bắt đầu rebuild Python virtual environments..."

# Màu sắc cho output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Đi đến thư mục project
cd ~/projects/SmartFarm || cd /root/projects/SmartFarm || exit 1

# Flask API service
if [ -d "SmartContract/flask-api" ]; then
    echo -e "${YELLOW}📦 Tạo .venv cho flask-api...${NC}"
    cd SmartContract/flask-api
    rm -rf .venv
    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    else
        pip install Flask==3.0.2 SQLAlchemy==2.0.30 psycopg2-binary==2.9.9 eth-utils==2.3.1 "eth-hash[pycryptodome]" python-dotenv==1.0.1 requests==2.32.3
    fi
    deactivate
    cd ../..
    echo -e "${GREEN}✅ flask-api .venv đã được tạo lại${NC}"
else
    echo -e "${RED}❌ Không tìm thấy SmartContract/flask-api${NC}"
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
else
    echo -e "${RED}❌ Không tìm thấy SmartContract/device${NC}"
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
else
    echo -e "${YELLOW}⚠️  Không tìm thấy RecommentCrop (có thể chạy trong Docker)${NC}"
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
else
    echo -e "${YELLOW}⚠️  Không tìm thấy PestAndDisease (có thể chạy trong Docker)${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Rebuild .venv hoàn tất!${NC}"

