#!/bin/bash

# Script nhanh để deploy SmartFarm lên VPS Contabo
# IP VPS: 109.205.180.72

echo "🚀 Bắt đầu deploy SmartFarm lên VPS Contabo..."
echo "📍 IP VPS: 109.205.180.72"
echo ""

# Kiểm tra Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker chưa được cài đặt. Đang cài đặt..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Kiểm tra Docker Compose
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose chưa được cài đặt. Đang cài đặt..."
    apt install docker-compose-plugin -y
fi

echo "✅ Docker và Docker Compose đã sẵn sàng"
echo ""

# Kiểm tra file .env
if [ ! -f .env ]; then
    echo "⚠️  File .env chưa tồn tại. Đang tạo file mẫu..."
    cat > .env << EOF
# Database Configuration
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=YOUR_STRONG_PASSWORD_HERE

# JWT Configuration
JWT_SECRET=$(openssl rand -base64 32)
JWT_EXPIRATION=86400000

# VPS Configuration
VPS_IP=109.205.180.72

# Frontend Origins (CORS)
FRONTEND_ORIGINS=http://109.205.180.72,http://109.205.180.72:80,http://localhost:3000,http://localhost:80

# Google GenAI API Key
GOOGLE_GENAI_API_KEY=your-google-genai-api-key-here

# API URLs
NEXT_PUBLIC_API_URL=http://109.205.180.72:8080
EOF
    echo "✅ Đã tạo file .env. Vui lòng chỉnh sửa với thông tin của bạn:"
    echo "   - POSTGRES_PASSWORD: Đặt mật khẩu mạnh"
    echo "   - GOOGLE_GENAI_API_KEY: Thêm API key từ Google AI Studio"
    echo ""
    echo "Sau đó chạy lại script này."
    exit 1
fi

# Cấu hình firewall
echo "🔥 Đang cấu hình firewall..."
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8080/tcp  # Backend
ufw allow 9002/tcp  # Chatbot
ufw allow 5000/tcp  # Crop ML
ufw allow 5001/tcp  # Pest ML
ufw --force enable
echo "✅ Firewall đã được cấu hình"
echo ""

# Build và start services
echo "🏗️  Đang build và khởi động services..."
docker compose down 2>/dev/null  # Dừng containers cũ nếu có
docker compose up -d --build

echo ""
echo "⏳ Đang chờ services khởi động..."
sleep 10

# Kiểm tra trạng thái
echo ""
echo "📊 Trạng thái services:"
docker compose ps

echo ""
echo "📋 Logs (10 dòng cuối):"
docker compose logs --tail=10

echo ""
echo "✅ Deploy hoàn tất!"
echo ""
echo "🌐 Truy cập ứng dụng:"
echo "   - Frontend:    http://109.205.180.72"
echo "   - Backend API: http://109.205.180.72:8080"
echo "   - Chatbot:     http://109.205.180.72:9002"
echo "   - Crop ML:     http://109.205.180.72:5000"
echo "   - Pest ML:     http://109.205.180.72:5001"
echo ""
echo "📝 Xem logs: docker compose logs -f"
echo "🛑 Dừng services: docker compose down"
echo "🔄 Restart: docker compose restart"

