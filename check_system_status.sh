#!/bin/bash

# Script kiểm tra trạng thái hệ thống SmartFarm
# Sử dụng: ./check_system_status.sh

VPS_IP="173.249.48.25"

echo "🔍 Kiểm tra trạng thái hệ thống SmartFarm..."
echo "🌐 VPS IP: ${VPS_IP}"
echo ""

# 1. Kiểm tra Frontend
echo "📱 1. Kiểm tra Frontend (Port 80)..."
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://${VPS_IP}/ 2>/dev/null || echo "000")
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "   ✅ Frontend đang hoạt động (HTTP $FRONTEND_STATUS)"
elif [ "$FRONTEND_STATUS" = "000" ]; then
    echo "   ❌ Frontend không phản hồi (Timeout hoặc không kết nối được)"
else
    echo "   ⚠️  Frontend trả về HTTP $FRONTEND_STATUS"
fi

# 2. Kiểm tra Backend API
echo "🔧 2. Kiểm tra Backend API (Port 8080)..."
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://${VPS_IP}:8080/actuator/health 2>/dev/null || echo "000")
if [ "$BACKEND_STATUS" = "200" ]; then
    echo "   ✅ Backend đang hoạt động (HTTP $BACKEND_STATUS)"
    # Lấy thông tin health
    HEALTH=$(curl -s --max-time 5 http://${VPS_IP}:8080/actuator/health 2>/dev/null || echo "{}")
    echo "   📊 Health: $HEALTH"
elif [ "$BACKEND_STATUS" = "000" ]; then
    echo "   ❌ Backend không phản hồi (Timeout hoặc không kết nối được)"
else
    echo "   ⚠️  Backend trả về HTTP $BACKEND_STATUS"
fi

# 3. Kiểm tra API Alerts
echo "📢 3. Kiểm tra API Alerts..."
ALERTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://${VPS_IP}:8080/api/alerts 2>/dev/null || echo "000")
if [ "$ALERTS_STATUS" = "200" ] || [ "$ALERTS_STATUS" = "401" ]; then
    echo "   ✅ API Alerts đang hoạt động (HTTP $ALERTS_STATUS)"
elif [ "$ALERTS_STATUS" = "000" ]; then
    echo "   ❌ API Alerts không phản hồi"
else
    echo "   ⚠️  API Alerts trả về HTTP $ALERTS_STATUS"
fi

# 4. Kiểm tra Chatbot
echo "🤖 4. Kiểm tra Chatbot (Port 9002)..."
CHATBOT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://${VPS_IP}:9002 2>/dev/null || echo "000")
if [ "$CHATBOT_STATUS" = "200" ]; then
    echo "   ✅ Chatbot đang hoạt động (HTTP $CHATBOT_STATUS)"
elif [ "$CHATBOT_STATUS" = "000" ]; then
    echo "   ❌ Chatbot không phản hồi"
else
    echo "   ⚠️  Chatbot trả về HTTP $CHATBOT_STATUS"
fi

# 5. Kiểm tra Crop ML Service
echo "🌾 5. Kiểm tra Crop ML Service (Port 5000)..."
CROP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://${VPS_IP}:5000/health 2>/dev/null || echo "000")
if [ "$CROP_STATUS" = "200" ]; then
    echo "   ✅ Crop ML Service đang hoạt động (HTTP $CROP_STATUS)"
elif [ "$CROP_STATUS" = "000" ]; then
    echo "   ❌ Crop ML Service không phản hồi"
else
    echo "   ⚠️  Crop ML Service trả về HTTP $CROP_STATUS"
fi

# 6. Kiểm tra Pest ML Service
echo "🐛 6. Kiểm tra Pest ML Service (Port 5001)..."
PEST_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://${VPS_IP}:5001/health 2>/dev/null || echo "000")
if [ "$PEST_STATUS" = "200" ]; then
    echo "   ✅ Pest ML Service đang hoạt động (HTTP $PEST_STATUS)"
elif [ "$PEST_STATUS" = "000" ]; then
    echo "   ❌ Pest ML Service không phản hồi"
else
    echo "   ⚠️  Pest ML Service trả về HTTP $PEST_STATUS"
fi

echo ""
echo "📋 Tóm tắt:"
echo "   Frontend:  http://${VPS_IP}/"
echo "   Backend:   http://${VPS_IP}:8080/"
echo "   Chatbot:   http://${VPS_IP}:9002/"
echo "   Crop ML:   http://${VPS_IP}:5000/"
echo "   Pest ML:   http://${VPS_IP}:5001/"
echo ""
echo "💡 Để kiểm tra chi tiết trên VPS:"
echo "   ssh root@${VPS_IP}"
echo "   cd ~/projects/SmartFarm"
echo "   docker-compose ps"
echo "   docker-compose logs -f"

