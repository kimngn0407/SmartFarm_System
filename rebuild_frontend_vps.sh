#!/bin/bash

# Script để rebuild frontend trên VPS sau khi fix lỗi API duplicate

echo "🔄 Rebuilding Frontend trên VPS..."

# Vào thư mục project
cd /opt/SmartFarm || cd ~/SmartFarm || exit 1

# Pull code mới nhất
echo "📥 Pulling latest code..."
git pull origin main || git pull origin master

# Rebuild frontend
echo "🔨 Building frontend..."
docker compose build frontend --no-cache

# Restart frontend container
echo "🚀 Restarting frontend container..."
docker compose up -d --force-recreate frontend

# Đợi container khởi động
echo "⏳ Waiting for container to start..."
sleep 30

# Kiểm tra logs
echo "📋 Frontend logs (last 30 lines):"
docker compose logs frontend --tail=30

# Kiểm tra status
echo ""
echo "📊 Container status:"
docker compose ps frontend

echo ""
echo "✅ Rebuild completed!"
echo "💡 Tip: Clear browser cache (Ctrl+Shift+R) or use incognito mode to see changes"


