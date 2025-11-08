#!/bin/bash

# Script nhanh để sửa lỗi pest detection load quá lâu
# Usage: ./QUICK_FIX_PEST_SLOW.sh

echo "🔧 Sửa lỗi Pest Detection Load Quá Lâu..."
echo ""

cd ~/projects/SmartFarm

# 1. Kiểm tra model đã load chưa
echo "1. Kiểm tra model đã load..."
HEALTH=$(curl -s http://localhost:5001/health)
echo "$HEALTH" | grep -q "model_loaded.*true"

if [ $? -ne 0 ]; then
    echo "   ⚠️  Model chưa load, đang restart service..."
    docker compose restart pest-service
    echo "   ⏳ Đợi 90 giây để model load (ViT model rất lớn)..."
    sleep 90
    
    # Kiểm tra lại
    HEALTH=$(curl -s http://localhost:5001/health)
    if echo "$HEALTH" | grep -q "model_loaded.*true"; then
        echo "   ✅ Model đã load thành công"
    else
        echo "   ❌ Model vẫn chưa load, kiểm tra logs:"
        echo "      docker compose logs pest-service | tail -50"
    fi
else
    echo "   ✅ Model đã load"
fi

# 2. Kiểm tra backend timeout
echo ""
echo "2. Kiểm tra backend..."
echo "   ⚠️  Cần sửa file: demoSmartFarm/demo/src/main/java/com/example/demo/Services/PestDiseaseService.java"
echo "   Thêm timeout: setReadTimeout(120000) // 120 giây"
echo ""

# 3. Test performance
echo "3. Test performance..."
echo "   Test trực tiếp ML service:"
echo "   time curl -X POST http://localhost:5001/api/detect -F \"image=@test_image.jpg\""
echo ""

# 4. Kiểm tra resource
echo "4. Kiểm tra resource usage:"
docker stats --no-stream smartfarm-pest-service | tail -1
echo ""

echo "✅ Hoàn thành!"
echo ""
echo "📝 Nếu vẫn chậm:"
echo "   1. Kiểm tra logs: docker compose logs pest-service | tail -50"
echo "   2. Tăng memory trong docker-compose.yml"
echo "   3. Xem chi tiết: cat FIX_PEST_DETECTION_SLOW.md"


