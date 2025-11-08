#!/bin/bash

# Script để cập nhật GOOGLE_GENAI_API_KEY

API_KEY="AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw"

echo "🔑 Đang cập nhật GOOGLE_GENAI_API_KEY..."

# Tạo file .env nếu chưa có
if [ ! -f .env ]; then
    echo "📝 Tạo file .env mới..."
    touch .env
fi

# Kiểm tra xem GOOGLE_GENAI_API_KEY đã có trong .env chưa
if grep -q "GOOGLE_GENAI_API_KEY" .env; then
    # Cập nhật giá trị hiện có
    sed -i "s/GOOGLE_GENAI_API_KEY=.*/GOOGLE_GENAI_API_KEY=$API_KEY/" .env
    echo "✅ Đã cập nhật GOOGLE_GENAI_API_KEY trong .env"
else
    # Thêm mới
    echo "GOOGLE_GENAI_API_KEY=$API_KEY" >> .env
    echo "✅ Đã thêm GOOGLE_GENAI_API_KEY vào .env"
fi

# Đảm bảo .env trong .gitignore
if ! grep -q "^\.env$" .gitignore 2>/dev/null; then
    echo ".env" >> .gitignore
    echo "✅ Đã thêm .env vào .gitignore"
fi

# Kiểm tra kết quả
echo ""
echo "📋 Nội dung file .env:"
cat .env | grep GOOGLE_GENAI_API_KEY

echo ""
echo "🔄 Đang restart chatbot..."
docker compose restart chatbot

echo ""
echo "⏳ Đợi 10 giây để chatbot khởi động..."
sleep 10

echo ""
echo "🔍 Kiểm tra env var trong container:"
docker exec smartfarm-chatbot env | grep GOOGLE_GENAI_API_KEY

echo ""
echo "✅ Hoàn tất! Chatbot đã được cập nhật với API key mới."
echo "🧪 Hãy test chatbot trong browser: http://173.249.48.25"

