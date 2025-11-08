#!/bin/bash

# Script rebuild toàn bộ hệ thống sau khi fix
# Chạy trên VPS: bash rebuild-all-fix.sh

set -e  # Dừng nếu có lỗi

echo "🚀 Bắt đầu rebuild toàn bộ hệ thống..."

cd ~/projects/SmartFarm || exit 1

# 1. Pull code mới nhất
echo "📥 Pulling code mới nhất..."
git pull origin main

# 2. Rebuild frontend
echo "🔨 Rebuilding frontend..."
docker compose stop frontend
docker compose rm -f frontend
docker rmi smartfarm-frontend 2>/dev/null || true
docker compose build --no-cache frontend
docker compose up -d frontend

# 3. Rebuild chatbot
echo "🔨 Rebuilding chatbot..."
docker compose stop chatbot
docker compose rm -f chatbot
docker rmi smartfarm-chatbot 2>/dev/null || true
docker compose build --no-cache chatbot
docker compose up -d chatbot

# 4. Đợi services khởi động
echo "⏳ Đợi services khởi động (30 giây)..."
sleep 30

# 5. Kiểm tra services
echo "✅ Kiểm tra services..."
docker compose ps

# 6. Kiểm tra GOOGLE_GENAI_API_KEY
echo ""
echo "🔍 Kiểm tra GOOGLE_GENAI_API_KEY..."
GOOGLE_KEY=$(docker exec smartfarm-chatbot env | grep GOOGLE_GENAI_API_KEY | cut -d'=' -f2)
if [ -z "$GOOGLE_KEY" ] || [ "$GOOGLE_KEY" = "your-api-key" ]; then
    echo "⚠️  GOOGLE_GENAI_API_KEY chưa được set hoặc là giá trị mặc định!"
    echo "   Cần set API key trong docker-compose.yml hoặc .env file"
    echo "   Lấy API key từ: https://aistudio.google.com/"
else
    echo "✅ GOOGLE_GENAI_API_KEY đã được set"
fi

# 7. Kiểm tra logs
echo ""
echo "📋 Xem logs chatbot (10 dòng cuối)..."
docker compose logs chatbot | tail -10

echo ""
echo "✅ Rebuild hoàn tất!"
echo ""
echo "📝 Bước tiếp theo:"
echo "   1. Clear browser cache (Incognito mode)"
echo "   2. Mở: http://173.249.48.25"
echo "   3. Kiểm tra Console (F12) - không được có lỗi"
echo "   4. Test chatbot - gửi câu hỏi"
echo ""

