#!/bin/bash

# Script để áp dụng các thay đổi tắt cảnh báo và email lên VPS
# Sử dụng: ./apply_disable_alerts_vps.sh

set -e

echo "🛑 Áp dụng tắt cảnh báo và email lên VPS..."
echo ""

# Kiểm tra xem có đang ở thư mục project không
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Không tìm thấy docker-compose.yml"
    echo "   Vui lòng chạy script này trong thư mục gốc của project"
    exit 1
fi

# 1. Pull code mới từ git (nếu có)
echo "📥 Bước 1: Pull code mới từ git (nếu có)..."
if [ -d ".git" ]; then
    git pull origin main || git pull origin master || echo "⚠️  Không thể pull từ git, tiếp tục với code hiện tại..."
else
    echo "⚠️  Không phải git repository, bỏ qua pull"
fi

# 2. Kiểm tra các file đã được sửa
echo ""
echo "📝 Bước 2: Kiểm tra các file đã được sửa..."

ALERT_SERVICE="demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java"
ALERT_CONTROLLER="demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java"
EMAIL_SERVICE="demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java"
APP_PROD="demoSmartFarm/demo/src/main/resources/application-prod.properties"

if [ ! -f "$ALERT_SERVICE" ]; then
    echo "❌ Không tìm thấy file: $ALERT_SERVICE"
    exit 1
fi

if [ ! -f "$ALERT_CONTROLLER" ]; then
    echo "❌ Không tìm thấy file: $ALERT_CONTROLLER"
    exit 1
fi

if [ ! -f "$EMAIL_SERVICE" ]; then
    echo "❌ Không tìm thấy file: $EMAIL_SERVICE"
    exit 1
fi

echo "✅ Tất cả các file cần thiết đã có"

# 3. Rebuild backend service
echo ""
echo "🔨 Bước 3: Rebuild backend service..."
echo "   (Quá trình này có thể mất vài phút...)"

docker-compose up -d --build backend

# 4. Kiểm tra logs
echo ""
echo "📊 Bước 4: Kiểm tra logs backend..."
echo "   (Nhấn Ctrl+C để thoát khỏi logs)"
sleep 3

docker-compose logs --tail=50 backend

echo ""
echo "✅ Hoàn tất!"
echo ""
echo "📋 Tóm tắt các thay đổi:"
echo "   ✅ Alert Scheduler đã tắt (đã có sẵn)"
echo "   ✅ API endpoints tạo cảnh báo đã bị vô hiệu hóa"
echo "   ✅ Logic tạo cảnh báo trong AlertService đã bị vô hiệu hóa"
echo "   ✅ EmailService đã bị vô hiệu hóa"
echo "   ✅ Cấu hình email đã bị comment"
echo ""
echo "🔍 Để xem logs realtime:"
echo "   docker-compose logs -f backend"
echo ""
echo "🧪 Để kiểm tra hệ thống không tạo cảnh báo:"
echo "   # Đợi 5-10 phút và kiểm tra logs, không thấy dòng '🔄 Bắt đầu tạo alerts'"
echo "   docker-compose logs backend | grep -i alert"

