#!/bin/bash

echo "🔍 Debug Login Network Error"
echo "================================"
echo ""

# 1. Kiểm tra backend
echo "1️⃣ Kiểm tra Backend:"
docker compose ps | grep backend
echo ""

# 2. Test backend endpoint
echo "2️⃣ Test Backend Health:"
curl -s http://localhost:8080/api/auth/health || echo "❌ Backend không accessible"
echo ""
echo ""

# 3. Kiểm tra frontend
echo "3️⃣ Kiểm tra Frontend:"
docker compose ps | grep frontend
echo ""

# 4. Test frontend
echo "4️⃣ Test Frontend:"
curl -s -I http://localhost/ | head -1 || echo "❌ Frontend không accessible"
echo ""
echo ""

# 5. Kiểm tra network connectivity
echo "5️⃣ Kiểm tra Network:"
echo "Backend port 8080:"
netstat -tuln | grep 8080 || echo "❌ Port 8080 không mở"
echo ""
echo "Frontend port 80:"
netstat -tuln | grep ":80 " || echo "❌ Port 80 không mở"
echo ""

# 6. Kiểm tra logs backend
echo "6️⃣ Backend Logs (last 20 lines):"
docker compose logs backend | tail -20
echo ""

# 7. Kiểm tra logs frontend
echo "7️⃣ Frontend Logs (last 20 lines):"
docker compose logs frontend | tail -20
echo ""

echo "✅ Debug hoàn tất!"
echo ""
echo "📝 Kiểm tra:"
echo "  - Backend phải Running và Healthy"
echo "  - Frontend phải Running và Healthy"
echo "  - Port 8080 và 80 phải mở"
echo "  - Không có lỗi trong logs"

