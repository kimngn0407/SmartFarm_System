#!/bin/bash

# Script fix duplicate API key trong .env

echo "🔧 Fix duplicate API key trong .env..."
echo ""

cd /opt/SmartFarm

# Backup file .env
if [ -f .env ]; then
    cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ Đã backup .env"
fi

# Kiểm tra duplicate
DUPLICATE_COUNT=$(grep -c "GOOGLE_GENAI_API_KEY" .env 2>/dev/null || echo "0")

if [ "$DUPLICATE_COUNT" -gt 1 ]; then
    echo "⚠️ Phát hiện $DUPLICATE_COUNT dòng GOOGLE_GENAI_API_KEY trong .env"
    echo ""
    
    # Lấy API key đầu tiên (giả sử là key mới)
    API_KEY=$(grep "GOOGLE_GENAI_API_KEY" .env | head -1 | cut -d'=' -f2 | tr -d '"' | tr -d "'" | xargs)
    
    if [ -n "$API_KEY" ]; then
        echo "📋 API key sẽ được giữ lại: ${API_KEY:0:10}...${API_KEY: -4}"
        echo ""
        
        # Xóa tất cả dòng GOOGLE_GENAI_API_KEY
        sed -i '/^GOOGLE_GENAI_API_KEY=/d' .env
        
        # Thêm lại 1 dòng duy nhất
        echo "GOOGLE_GENAI_API_KEY=$API_KEY" >> .env
        
        echo "✅ Đã xóa duplicate, chỉ giữ lại 1 dòng"
    else
        echo "❌ Không thể lấy API key"
        exit 1
    fi
else
    echo "✅ Không có duplicate"
fi

# Kiểm tra lại
echo ""
echo "📋 Kiểm tra lại file .env:"
grep "GOOGLE_GENAI_API_KEY" .env

echo ""
echo "✅ Hoàn tất!"
echo ""
echo "💡 Bây giờ restart container:"
echo "   docker compose restart chatbot"
