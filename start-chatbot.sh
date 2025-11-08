#!/bin/bash

echo "🤖 Starting Chatbot Service"
echo "============================"
echo ""

# 1. Kiểm tra chatbot có đang chạy không
echo "1️⃣ Kiểm tra chatbot status:"
docker compose ps | grep chatbot
echo ""

# 2. Kiểm tra GOOGLE_GENAI_API_KEY
echo "2️⃣ Kiểm tra GOOGLE_GENAI_API_KEY:"
if [ -f .env ]; then
    echo "File .env tồn tại:"
    cat .env | grep GOOGLE_GENAI_API_KEY || echo "⚠️ GOOGLE_GENAI_API_KEY chưa có trong .env"
else
    echo "⚠️ File .env không tồn tại"
    echo "Tạo file .env với API key..."
    echo "GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw" > .env
    echo "✅ Đã tạo file .env"
fi
echo ""

# 3. Start chatbot
echo "3️⃣ Starting chatbot..."
docker compose up -d chatbot

# 4. Đợi 30 giây
echo "4️⃣ Đợi 30 giây để chatbot khởi động..."
sleep 30

# 5. Kiểm tra status
echo "5️⃣ Kiểm tra chatbot status:"
docker compose ps | grep chatbot
echo ""

# 6. Kiểm tra logs
echo "6️⃣ Chatbot logs (last 20 lines):"
docker compose logs chatbot | tail -20
echo ""

# 7. Test chatbot endpoint
echo "7️⃣ Test chatbot endpoint:"
curl -s -I http://localhost:9002/ | head -1 || echo "❌ Chatbot không accessible"
echo ""

echo "✅ Hoàn tất!"
echo ""
echo "📝 Kiểm tra:"
echo "  - Chatbot phải Running và Healthy"
echo "  - GOOGLE_GENAI_API_KEY phải được set"
echo "  - Chatbot endpoint phải accessible"

