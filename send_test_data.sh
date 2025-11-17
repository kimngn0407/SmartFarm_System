#!/bin/bash

# Script gửi dữ liệu test lên Flask API
# Sử dụng để test dashboard hiển thị dữ liệu IoT

VPS_IP="YOUR_VPS_IP"  # Thay bằng IP VPS của bạn
FLASK_API_URL="http://${VPS_IP}:8000/api/sensors"
API_KEY="MY_API_KEY"

# Lấy thời gian hiện tại (Unix timestamp)
TIMESTAMP=$(date +%s)

echo "📤 Sending test sensor data to Flask API..."
echo "URL: ${FLASK_API_URL}"
echo ""

# Gửi 5 lần dữ liệu test
for i in {1..5}; do
    # Tạo dữ liệu ngẫu nhiên
    TEMP=$(awk "BEGIN {printf \"%.2f\", 25 + rand() * 10}")  # 25-35°C
    HUMIDITY=$(awk "BEGIN {printf \"%.2f\", 60 + rand() * 20}")  # 60-80%
    SOIL=$(awk "BEGIN {printf \"%.2f\", 40 + rand() * 30}")  # 40-70%
    LIGHT=$(awk "BEGIN {printf \"%.2f\", 50 + rand() * 30}")  # 50-80%
    
    # Tạo JSON payload
    JSON_DATA=$(cat <<EOF
{
    "sensorId": 1,
    "time": ${TIMESTAMP},
    "temperature": ${TEMP},
    "humidity": ${HUMIDITY},
    "soil_pct": ${SOIL},
    "light": ${LIGHT}
}
EOF
)
    
    echo "📊 Sending data #${i}:"
    echo "   Temperature: ${TEMP}°C"
    echo "   Humidity: ${HUMIDITY}%"
    echo "   Soil: ${SOIL}%"
    echo "   Light: ${LIGHT}%"
    
    # Gửi POST request
    RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" \
        -X POST \
        -H "Content-Type: application/json" \
        -H "x-api-key: ${API_KEY}" \
        -d "${JSON_DATA}" \
        "${FLASK_API_URL}")
    
    HTTP_CODE=$(echo "${RESPONSE}" | grep "HTTP_CODE" | cut -d: -f2)
    BODY=$(echo "${RESPONSE}" | sed '/HTTP_CODE/d')
    
    if [ "${HTTP_CODE}" = "200" ]; then
        echo "   ✅ Success (HTTP ${HTTP_CODE})"
    else
        echo "   ❌ Failed (HTTP ${HTTP_CODE})"
        echo "   Response: ${BODY}"
    fi
    
    echo ""
    
    # Đợi 2 giây trước khi gửi tiếp
    sleep 2
    TIMESTAMP=$((TIMESTAMP + 2))
done

echo "✅ Test data sent!"
echo ""
echo "💡 Next steps:"
echo "   1. Check database: docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c \"SELECT COUNT(*) FROM \\\"Sensor_data\\\";\""
echo "   2. Refresh dashboard in browser"
echo "   3. Check if data appears on dashboard"

