#!/bin/bash

# Script tự động fix chatbot - kiểm tra và sửa tất cả vấn đề

set -e

echo "🔧 Script tự động fix Chatbot API Key"
echo "========================================"
echo ""

cd /opt/SmartFarm

# Bước 1: Kiểm tra file .env
echo "📋 Bước 1: Kiểm tra file .env..."
if [ -f .env ]; then
    API_KEY=$(grep "GOOGLE_GENAI_API_KEY" .env | cut -d'=' -f2 | tr -d '"' | tr -d "'")
    if [ -z "$API_KEY" ] || [ "$API_KEY" = "your-api-key" ]; then
        echo "❌ API key chưa được set trong .env"
        echo "   Cần set: GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw"
        exit 1
    else
        echo "✅ API key có trong .env: ${API_KEY:0:10}...${API_KEY: -4}"
    fi
else
    echo "❌ File .env không tồn tại!"
    exit 1
fi

# Bước 2: Pull code mới
echo ""
echo "📋 Bước 2: Pull code mới..."
git pull origin main || echo "⚠️ Không thể pull (có thể đã up-to-date)"

# Bước 3: Kiểm tra container
echo ""
echo "📋 Bước 3: Kiểm tra container..."
if docker ps -a | grep -q smartfarm-chatbot; then
    echo "✅ Container tồn tại"
    
    # Kiểm tra container có đang chạy không
    if docker ps | grep -q smartfarm-chatbot; then
        echo "✅ Container đang chạy"
        
        # Kiểm tra API key trong container
        echo ""
        echo "📋 Kiểm tra API key trong container..."
        CONTAINER_API_KEY=$(docker exec smartfarm-chatbot printenv GOOGLE_GENAI_API_KEY 2>/dev/null || echo "")
        
        if [ -z "$CONTAINER_API_KEY" ] || [ "$CONTAINER_API_KEY" = "your-api-key" ]; then
            echo "❌ API key KHÔNG có trong container hoặc là placeholder"
            echo "   Cần restart container để load env var mới"
            RESTART_NEEDED=1
        else
            echo "✅ API key có trong container: ${CONTAINER_API_KEY:0:10}...${CONTAINER_API_KEY: -4}"
            RESTART_NEEDED=0
        fi
    else
        echo "❌ Container KHÔNG đang chạy"
        echo "   Sẽ start container..."
        RESTART_NEEDED=1
    fi
else
    echo "❌ Container KHÔNG tồn tại"
    echo "   Sẽ tạo container mới..."
    RESTART_NEEDED=1
fi

# Bước 4: Rebuild và restart
echo ""
if [ "$RESTART_NEEDED" = "1" ] || [ "$1" = "--rebuild" ]; then
    echo "📋 Bước 4: Rebuild và restart chatbot..."
    
    # Stop container nếu đang chạy
    docker compose stop chatbot 2>/dev/null || true
    
    # Rebuild
    echo "   🔄 Rebuilding chatbot..."
    docker compose build chatbot
    
    # Start
    echo "   🚀 Starting chatbot..."
    docker compose up -d chatbot
    
    # Đợi container start
    echo "   ⏳ Đợi container start..."
    sleep 5
else
    echo "📋 Bước 4: Không cần rebuild (container đã có API key đúng)"
fi

# Bước 5: Kiểm tra lại
echo ""
echo "📋 Bước 5: Kiểm tra lại..."
sleep 3

# Kiểm tra container đang chạy
if docker ps | grep -q smartfarm-chatbot; then
    echo "✅ Container đang chạy"
    
    # Kiểm tra API key
    CONTAINER_API_KEY=$(docker exec smartfarm-chatbot printenv GOOGLE_GENAI_API_KEY 2>/dev/null || echo "")
    if [ -n "$CONTAINER_API_KEY" ] && [ "$CONTAINER_API_KEY" != "your-api-key" ]; then
        echo "✅ API key có trong container: ${CONTAINER_API_KEY:0:10}...${CONTAINER_API_KEY: -4}"
    else
        echo "❌ API key vẫn chưa có trong container"
        echo "   Có thể cần kiểm tra docker-compose.yml"
    fi
    
    # Xem logs
    echo ""
    echo "📋 Logs gần nhất (20 dòng):"
    echo "----------------------------------------"
    docker compose logs chatbot --tail=20 | grep -E "(API|Genkit|key|✅|❌|⚠️)" || docker compose logs chatbot --tail=20
else
    echo "❌ Container KHÔNG đang chạy!"
    echo ""
    echo "📋 Logs lỗi:"
    docker compose logs chatbot --tail=50
fi

echo ""
echo "✅ Hoàn tất!"
echo ""
echo "💡 Để test chatbot:"
echo "   1. Mở browser: http://109.205.180.72:9002"
echo "   2. Gửi một câu hỏi test"
echo "   3. Kiểm tra console - không còn lỗi API_KEY_NOT_CONFIGURED"
echo ""
echo "💡 Nếu vẫn lỗi, xem logs chi tiết:"
echo "   docker compose logs chatbot -f"
