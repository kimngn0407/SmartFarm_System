#!/bin/bash

# Script để reset database và fix backend crash

echo "🛑 Đang stop tất cả services..."
docker compose down

echo "🗑️ Đang xóa postgres volume (CẢNH BÁO: Mất dữ liệu!)..."
docker volume rm smartfarm_postgres_data 2>/dev/null || echo "Volume không tồn tại hoặc đã bị xóa"

echo "🚀 Đang start lại tất cả services..."
docker compose up -d

echo "⏳ Đợi 60 giây để services khởi động..."
sleep 60

echo "🔍 Kiểm tra backend status..."
docker compose ps | grep backend

echo "🧪 Test backend API..."
curl -s http://localhost:8080/actuator/health || echo "Backend chưa sẵn sàng, đợi thêm..."

echo ""
echo "✅ Hoàn tất! Kiểm tra backend logs:"
echo "   docker compose logs backend | tail -50"

