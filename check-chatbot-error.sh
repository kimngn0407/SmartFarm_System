#!/bin/bash

# Script để kiểm tra lỗi chatbot trên VPS
# Kiểm tra API key và logs

echo "🔍 Kiểm tra Chatbot Error"
echo "=========================="
echo ""

cd /opt/SmartFarm

echo "1️⃣ Kiểm tra API key trong .env:"
echo "-------------------------------"
cat .env | grep GOOGLE_GENAI_API_KEY | head -1
echo ""

echo "2️⃣ Kiểm tra API key trong container:"
echo "-------------------------------------"
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY | head -1
echo ""

echo "3️⃣ Logs chatbot (20 dòng gần nhất):"
echo "-------------------------------------"
docker compose logs chatbot --tail=20
echo ""

echo "4️⃣ Kiểm tra lỗi API key leaked:"
echo "--------------------------------"
docker compose logs chatbot --tail=50 | grep -i "leaked\|403\|forbidden" || echo "   Không thấy lỗi leaked"
echo ""

echo "5️⃣ Kiểm tra lỗi API key not configured:"
echo "----------------------------------------"
docker compose logs chatbot --tail=50 | grep -i "API_KEY_NOT_CONFIGURED\|not configured" || echo "   Không thấy lỗi not configured"
echo ""

echo "✅ Kiểm tra hoàn tất!"
echo ""
echo "💡 Nếu thấy lỗi 'leaked' hoặc '403 Forbidden':"
echo "   → API key đã bị Google đánh dấu là leaked"
echo "   → Cần tạo API key mới từ https://aistudio.google.com/"
echo "   → Xem hướng dẫn: cat FIX_LEAKED_API_KEY.md"
