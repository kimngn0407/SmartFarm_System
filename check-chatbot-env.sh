#!/bin/bash

# Script kiểm tra environment variables của chatbot container

echo "🔍 Kiểm tra Chatbot Environment Variables..."
echo ""

# Kiểm tra container có đang chạy không
if ! docker ps | grep -q smartfarm-chatbot; then
    echo "❌ Container smartfarm-chatbot không đang chạy!"
    echo "   Chạy: docker compose up -d chatbot"
    exit 1
fi

echo "✅ Container đang chạy"
echo ""

# Kiểm tra environment variables trong container
echo "📋 Environment Variables trong container:"
echo "----------------------------------------"
docker exec smartfarm-chatbot printenv | grep -E "(GOOGLE_GENAI_API_KEY|GOOGLE_API_KEY|PORT|NODE_ENV)" || echo "❌ Không tìm thấy environment variables!"

echo ""
echo "📋 Kiểm tra file .env trên host:"
echo "----------------------------------------"
if [ -f .env ]; then
    grep -E "GOOGLE_GENAI_API_KEY|GOOGLE_API_KEY" .env || echo "❌ Không tìm thấy GOOGLE_GENAI_API_KEY trong .env"
else
    echo "❌ File .env không tồn tại!"
fi

echo ""
echo "📋 Kiểm tra docker-compose.yml:"
echo "----------------------------------------"
grep -A 5 "chatbot:" docker-compose.yml | grep -E "GOOGLE_GENAI_API_KEY" || echo "❌ Không tìm thấy GOOGLE_GENAI_API_KEY trong docker-compose.yml"

echo ""
echo "💡 Nếu API key chưa được set:"
echo "   1. Kiểm tra file .env có GOOGLE_GENAI_API_KEY=..."
echo "   2. Restart container: docker compose restart chatbot"
echo "   3. Hoặc rebuild: docker compose build chatbot && docker compose up -d chatbot"
