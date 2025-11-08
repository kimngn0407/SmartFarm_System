#!/bin/bash

echo "🔍 Test Backend Connection"
echo "=========================="
echo ""

VPS_IP="173.249.48.25"
BACKEND_PORT="8080"

echo "1️⃣ Test Backend từ VPS (localhost):"
curl -v http://localhost:${BACKEND_PORT}/api/auth/health 2>&1 | head -20
echo ""
echo ""

echo "2️⃣ Test Backend từ VPS (external IP):"
curl -v http://${VPS_IP}:${BACKEND_PORT}/api/auth/health 2>&1 | head -20
echo ""
echo ""

echo "3️⃣ Test Backend Login Endpoint (POST):"
curl -v -X POST http://localhost:${BACKEND_PORT}/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test"}' 2>&1 | head -30
echo ""
echo ""

echo "4️⃣ Kiểm tra Backend Logs:"
docker compose logs backend | tail -20
echo ""
echo ""

echo "5️⃣ Kiểm tra Backend Status:"
docker compose ps | grep backend
echo ""
echo ""

echo "✅ Test hoàn tất!"
echo ""
echo "📝 Kiểm tra:"
echo "  - Backend phải trả về response (không phải connection refused)"
echo "  - CORS headers phải có trong response"
echo "  - Backend phải Running và Healthy"

