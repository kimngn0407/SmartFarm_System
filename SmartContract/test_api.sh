#!/bin/bash
# Test script để kiểm tra Flask API có nhận và lưu đúng soil_pct và light_pct

echo "============================================================"
echo "  🧪 Test Flask API với dữ liệu IoT thật"
echo "============================================================"
echo ""

API_URL="http://173.249.48.25:8000/api/sensors"
API_KEY="MY_API_KEY"

# Test data từ IoT
TEST_DATA='{
  "time": 26,
  "sensorId": 0,
  "temperature": 24.50,
  "humidity": 28.00,
  "light_raw": 197,
  "light_pct": 12,
  "soil_raw": 1022,
  "soil_pct": 0
}'

echo "📤 Sending test data to Flask API..."
echo "Data: $TEST_DATA"
echo ""

RESPONSE=$(curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $API_KEY" \
  -d "$TEST_DATA")

echo "📥 Response from Flask API:"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
echo ""

# Kiểm tra database
echo "🔍 Checking database..."
echo "Querying sensor_data for sensor_id 7, 8, 9, 10..."
echo ""

# Lệnh này cần chạy trên VPS với quyền truy cập database
echo "Run on VPS:"
echo "psql \$DB_URL -c \"SELECT sensor_id, value, time FROM sensor_data WHERE sensor_id IN (7,8,9,10) ORDER BY time DESC LIMIT 10;\""
echo ""

echo "✅ Expected results:"
echo "  - sensor_id = 7: temperature = 24.50"
echo "  - sensor_id = 8: humidity = 28.00"
echo "  - sensor_id = 9: soil_pct = 0"
echo "  - sensor_id = 10: light_pct = 12"

