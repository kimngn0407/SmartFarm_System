#!/bin/bash

# Script kiểm tra trạng thái chatbot container

echo "🔍 Kiểm tra Chatbot Container Status..."
echo ""

# Kiểm tra container có tồn tại không
if docker ps -a | grep -q smartfarm-chatbot; then
    echo "✅ Container smartfarm-chatbot tồn tại"
    echo ""
    
    # Kiểm tra status
    echo "📋 Container Status:"
    docker ps -a | grep smartfarm-chatbot
    echo ""
    
    # Kiểm tra có đang chạy không
    if docker ps | grep -q smartfarm-chatbot; then
        echo "✅ Container đang chạy"
        echo ""
        echo "📋 Port mapping:"
        docker port smartfarm-chatbot
        echo ""
    else
        echo "❌ Container KHÔNG đang chạy!"
        echo ""
        echo "📋 Lý do dừng (nếu có):"
        docker inspect smartfarm-chatbot --format='{{.State.Status}} - {{.State.Error}}' 2>/dev/null || echo "Không thể lấy thông tin"
        echo ""
        echo "💡 Để start container:"
        echo "   docker compose up -d chatbot"
        echo ""
    fi
else
    echo "❌ Container smartfarm-chatbot KHÔNG tồn tại!"
    echo ""
    echo "💡 Để tạo và start container:"
    echo "   docker compose up -d chatbot"
    echo ""
fi

# Kiểm tra logs (nếu container đã từng chạy)
if docker ps -a | grep -q smartfarm-chatbot; then
    echo "📋 Logs gần nhất (20 dòng):"
    echo "----------------------------------------"
    docker compose logs chatbot --tail=20 2>/dev/null || docker logs smartfarm-chatbot --tail=20 2>/dev/null || echo "Không có logs"
    echo ""
fi

# Kiểm tra docker-compose.yml
echo "📋 Kiểm tra docker-compose.yml:"
if grep -q "chatbot:" docker-compose.yml; then
    echo "✅ Chatbot service có trong docker-compose.yml"
    echo ""
    echo "📋 Chatbot service config:"
    grep -A 15 "chatbot:" docker-compose.yml | head -20
else
    echo "❌ Chatbot service KHÔNG có trong docker-compose.yml!"
fi
