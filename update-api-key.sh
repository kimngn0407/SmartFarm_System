#!/bin/bash

# Script tự động cập nhật API key trên VPS
# Usage: ./update-api-key.sh YOUR_NEW_API_KEY

set -e

if [ -z "$1" ]; then
    echo "❌ Usage: ./update-api-key.sh YOUR_NEW_API_KEY"
    echo ""
    echo "Ví dụ:"
    echo "  ./update-api-key.sh AIzaSyBWiRYGV-m-9khCxAUFEQ62Rd-w6GOFcYs"
    exit 1
fi

NEW_API_KEY=$1

# Validate API key format
if [[ ! "$NEW_API_KEY" =~ ^AIzaSy[A-Za-z0-9_-]{35}$ ]]; then
    echo "⚠️  Cảnh báo: API key không đúng format (phải bắt đầu bằng AIzaSy và dài ~39 ký tự)"
    read -p "Bạn có muốn tiếp tục? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

cd /opt/SmartFarm

echo "🔑 Đang cập nhật API key..."
echo ""

# Backup .env
if [ -f .env ]; then
    cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ Đã backup .env"
fi

# Xóa API key cũ
if grep -q "^GOOGLE_GENAI_API_KEY=" .env 2>/dev/null; then
    sed -i '/^GOOGLE_GENAI_API_KEY=/d' .env
    echo "✅ Đã xóa API key cũ"
fi

# Thêm API key mới
echo "GOOGLE_GENAI_API_KEY=$NEW_API_KEY" >> .env
echo "✅ Đã thêm API key mới"

# Kiểm tra không có duplicate
DUPLICATE_COUNT=$(grep -c "^GOOGLE_GENAI_API_KEY=" .env 2>/dev/null || echo "0")
if [ "$DUPLICATE_COUNT" -gt 1 ]; then
    echo "⚠️  Cảnh báo: Tìm thấy $DUPLICATE_COUNT dòng GOOGLE_GENAI_API_KEY"
    echo "   Đang xóa duplicate..."
    sed -i '/^GOOGLE_GENAI_API_KEY=/d' .env
    echo "GOOGLE_GENAI_API_KEY=$NEW_API_KEY" >> .env
fi

echo ""
echo "🔄 Đang recreate container chatbot..."

# Recreate container
docker compose stop chatbot 2>/dev/null || true
docker compose rm -f chatbot 2>/dev/null || true
docker compose up -d chatbot

echo ""
echo "⏳ Đợi container khởi động (10 giây)..."
sleep 10

echo ""
echo "📋 Kiểm tra API key trong container:"
CONTAINER_KEY=$(docker exec smartfarm-chatbot printenv GOOGLE_GENAI_API_KEY 2>/dev/null || echo "")

if [ -z "$CONTAINER_KEY" ]; then
    echo "❌ Không tìm thấy API key trong container!"
    echo "   Kiểm tra logs: docker compose logs chatbot --tail=20"
    exit 1
fi

if [ "$CONTAINER_KEY" = "$NEW_API_KEY" ]; then
    echo "✅ API key đã được load đúng: ${CONTAINER_KEY:0:10}...${CONTAINER_KEY: -4}"
else
    echo "⚠️  API key trong container khác với .env!"
    echo "   .env: ${NEW_API_KEY:0:10}...${NEW_API_KEY: -4}"
    echo "   container: ${CONTAINER_KEY:0:10}...${CONTAINER_KEY: -4}"
    echo "   → Thử recreate lại: docker compose stop chatbot && docker compose rm -f chatbot && docker compose up -d chatbot"
fi

echo ""
echo "📊 Logs chatbot (10 dòng cuối):"
docker compose logs chatbot --tail=10 | grep -E "API key|Genkit|Error" || docker compose logs chatbot --tail=10

echo ""
echo "✅ Hoàn tất!"
echo ""
echo "🧪 Test chatbot: http://109.205.180.72:9002"
