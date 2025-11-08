#!/bin/bash

# Script sửa tất cả lỗi: Frontend API URL và ML Services
# Usage: ./fix-all-services.sh

set -e

echo "🔧 Bắt đầu sửa lỗi Frontend API và ML Services..."
echo ""

cd ~/projects/SmartFarm

# 1. Kiểm tra backend có chạy không
echo "1. Kiểm tra Backend..."
if ! docker ps | grep -q smartfarm-backend; then
    echo "   ⚠️  Backend chưa chạy, đang start..."
    docker compose up -d backend
    sleep 10
else
    echo "   ✅ Backend đang chạy"
fi

# Kiểm tra backend health
if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
    echo "   ✅ Backend health check OK"
else
    echo "   ⚠️  Backend health check failed, đang restart..."
    docker compose restart backend
    sleep 15
fi

# 2. Kiểm tra và rebuild frontend
echo ""
echo "2. Rebuild Frontend với đúng API URL..."
docker compose stop frontend
docker compose build --no-cache frontend
docker compose up -d frontend
echo "   ✅ Frontend đã rebuild"

# 3. Kiểm tra Crop Service
echo ""
echo "3. Kiểm tra Crop Service..."
if ! docker ps | grep -q smartfarm-crop-service; then
    echo "   ⚠️  Crop service chưa chạy, đang start..."
    docker compose up -d crop-service
    sleep 15
else
    echo "   ✅ Crop service đang chạy"
fi

# Kiểm tra health
if curl -s http://localhost:5000/health > /dev/null 2>&1; then
    echo "   ✅ Crop service health check OK"
else
    echo "   ⚠️  Crop service health check failed, đang restart..."
    docker compose restart crop-service
    sleep 20
fi

# 4. Kiểm tra Pest Service
echo ""
echo "4. Kiểm tra Pest Service..."
if ! docker ps | grep -q smartfarm-pest-service; then
    echo "   ⚠️  Pest service chưa chạy, đang start..."
    docker compose up -d pest-service
    sleep 15
else
    echo "   ✅ Pest service đang chạy"
fi

# Kiểm tra health
if curl -s http://localhost:5001/health > /dev/null 2>&1; then
    echo "   ✅ Pest service health check OK"
else
    echo "   ⚠️  Pest service health check failed, đang restart..."
    docker compose restart pest-service
    sleep 20
fi

# 5. Tổng kết
echo ""
echo "=== Tổng Kết ==="
echo ""
docker compose ps
echo ""
echo "=== Health Checks ==="
echo "Backend:"
curl -s http://localhost:8080/actuator/health | head -3 || echo "   ❌ Backend không accessible"
echo ""
echo "Crop Service:"
curl -s http://localhost:5000/health | head -3 || echo "   ❌ Crop service không accessible"
echo ""
echo "Pest Service:"
curl -s http://localhost:5001/health | head -3 || echo "   ❌ Pest service không accessible"
echo ""
echo "✅ Hoàn thành! Vui lòng refresh browser và test lại."
echo ""
echo "📝 Nếu vẫn có lỗi, xem logs:"
echo "   docker compose logs backend | tail -50"
echo "   docker compose logs crop-service | tail -50"
echo "   docker compose logs pest-service | tail -50"
echo "   docker compose logs frontend | tail -50"


