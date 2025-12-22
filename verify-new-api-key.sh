#!/bin/bash

# Script kiểm tra API key mới có trong container không

echo "🔍 Kiểm tra API key mới trong container..."
echo ""

cd /opt/SmartFarm

# 1. Kiểm tra API key trong file .env
echo "📋 Bước 1: Kiểm tra file .env..."
if [ -f .env ]; then
    ENV_API_KEY=$(grep "GOOGLE_GENAI_API_KEY" .env | cut -d'=' -f2 | tr -d '"' | tr -d "'" | xargs)
    if [ -n "$ENV_API_KEY" ]; then
        echo "✅ API key trong .env: ${ENV_API_KEY:0:10}...${ENV_API_KEY: -4} (length: ${#ENV_API_KEY})"
    else
        echo "❌ Không tìm thấy API key trong .env"
        exit 1
    fi
else
    echo "❌ File .env không tồn tại!"
    exit 1
fi

# 2. Kiểm tra container có đang chạy không
echo ""
echo "📋 Bước 2: Kiểm tra container..."
if ! docker ps | grep -q smartfarm-chatbot; then
    echo "❌ Container không đang chạy!"
    echo "   Chạy: docker compose up -d chatbot"
    exit 1
fi

echo "✅ Container đang chạy"

# 3. Kiểm tra API key trong container
echo ""
echo "📋 Bước 3: Kiểm tra API key trong container..."
CONTAINER_API_KEY=$(docker exec smartfarm-chatbot printenv GOOGLE_GENAI_API_KEY 2>/dev/null || echo "")

if [ -z "$CONTAINER_API_KEY" ]; then
    echo "❌ API key KHÔNG có trong container!"
    echo "   Cần restart container để load env var mới"
    RESTART_NEEDED=1
elif [ "$CONTAINER_API_KEY" = "$ENV_API_KEY" ]; then
    echo "✅ API key trong container KHỚP với .env"
    echo "   API key: ${CONTAINER_API_KEY:0:10}...${CONTAINER_API_KEY: -4} (length: ${#CONTAINER_API_KEY})"
    RESTART_NEEDED=0
else
    echo "⚠️ API key trong container KHÁC với .env!"
    echo "   Container: ${CONTAINER_API_KEY:0:10}...${CONTAINER_API_KEY: -4}"
    echo "   .env:      ${ENV_API_KEY:0:10}...${ENV_API_KEY: -4}"
    echo "   Cần restart container để load env var mới"
    RESTART_NEEDED=1
fi

# 4. Restart nếu cần
if [ "$RESTART_NEEDED" = "1" ]; then
    echo ""
    echo "📋 Bước 4: Restart container để load API key mới..."
    docker compose restart chatbot
    
    echo "   ⏳ Đợi container start..."
    sleep 5
    
    # Kiểm tra lại
    CONTAINER_API_KEY=$(docker exec smartfarm-chatbot printenv GOOGLE_GENAI_API_KEY 2>/dev/null || echo "")
    if [ "$CONTAINER_API_KEY" = "$ENV_API_KEY" ]; then
        echo "✅ API key đã được load vào container"
    else
        echo "❌ API key vẫn chưa được load"
        echo "   Có thể cần rebuild container"
    fi
fi

# 5. Kiểm tra logs
echo ""
echo "📋 Bước 5: Kiểm tra logs..."
docker compose logs chatbot --tail=10 | grep -E "(API key|Genkit|✅|❌)" || docker compose logs chatbot --tail=10

echo ""
echo "✅ Hoàn tất!"
