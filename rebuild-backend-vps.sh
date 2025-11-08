#!/bin/bash

echo "🚀 Rebuild Backend trên VPS..."
echo ""

# 1. Pull code mới nhất
echo "1. Pulling latest code..."
cd ~/projects/SmartFarm
git pull origin main

# 2. Rebuild backend
echo ""
echo "2. Rebuilding backend..."
docker compose stop backend
docker compose build --no-cache backend
docker compose up -d backend

# 3. Đợi service khởi động
echo ""
echo "3. Waiting for backend to start..."
sleep 15

# 4. Kiểm tra logs
echo ""
echo "4. Checking backend logs..."
docker compose logs backend | tail -30

# 5. Kiểm tra health
echo ""
echo "5. Checking backend health..."
curl -s http://localhost:8080/actuator/health || echo "Backend chưa sẵn sàng, đợi thêm..."

echo ""
echo "✅ Rebuild completed!"
echo ""
echo "📝 Để xem logs real-time:"
echo "   docker compose logs -f backend"

