#!/bin/bash

# Script để bật lại hệ thống cảnh báo và email cho ngày thi
# Sử dụng: ./enable_alerts_for_demo.sh

set -e

echo "🎯 Bật lại hệ thống cảnh báo và email cho ngày thi..."
echo ""

# Kiểm tra xem có đang ở thư mục project không
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Không tìm thấy docker-compose.yml"
    echo "   Vui lòng chạy script này trong thư mục gốc của project"
    exit 1
fi

# 1. Bật Alert Scheduler
echo "📝 Bước 1: Bật Alert Scheduler..."
ALERT_SCHEDULER="demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java"

if [ -f "$ALERT_SCHEDULER" ]; then
    # Uncomment @Scheduled
    sed -i 's|// @Scheduled(fixedRate = 300000)|@Scheduled(fixedRate = 300000)|' "$ALERT_SCHEDULER"
    sed -i 's|// import org.springframework.scheduling.annotation.Scheduled;|import org.springframework.scheduling.annotation.Scheduled;|' "$ALERT_SCHEDULER"
    echo "✅ Đã bật Alert Scheduler"
else
    echo "❌ Không tìm thấy file: $ALERT_SCHEDULER"
    exit 1
fi

# 2. Bật AlertService (xóa early return và uncomment code)
echo "📝 Bước 2: Bật AlertService..."
ALERT_SERVICE="demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java"

if [ -f "$ALERT_SERVICE" ]; then
    # Xóa early return
    sed -i '/⚠️ TẠM TẮT - Không tạo cảnh báo tự động/,/return alerts;/d' "$ALERT_SERVICE"
    # Uncomment code tạo cảnh báo
    sed -i 's|/\* ĐÃ TẮT - Uncomment để bật lại||' "$ALERT_SERVICE"
    sed -i 's|\*/||' "$ALERT_SERVICE"
    echo "✅ Đã bật AlertService"
else
    echo "❌ Không tìm thấy file: $ALERT_SERVICE"
    exit 1
fi

# 3. Bật API endpoints
echo "📝 Bước 3: Bật API endpoints..."
ALERT_CONTROLLER="demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java"

if [ -f "$ALERT_CONTROLLER" ]; then
    # Xóa comment mở đầu
    sed -i '/⚠️ ĐÃ TẮT - Để bật lại, uncomment các endpoint này/d' "$ALERT_CONTROLLER"
    # Uncomment endpoints
    sed -i 's|/\*||' "$ALERT_CONTROLLER"
    sed -i 's|\*/||' "$ALERT_CONTROLLER"
    echo "✅ Đã bật API endpoints"
else
    echo "❌ Không tìm thấy file: $ALERT_CONTROLLER"
    exit 1
fi

# 4. Bật EmailService
echo "📝 Bước 4: Bật EmailService..."
EMAIL_SERVICE="demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java"

if [ -f "$EMAIL_SERVICE" ]; then
    # Bật @Service
    sed -i 's|// @Service - ĐÃ TẮT|@Service|' "$EMAIL_SERVICE"
    # Xóa early return
    sed -i '/⚠️ ĐÃ TẮT - Không gửi email/,/return;/d' "$EMAIL_SERVICE"
    # Uncomment code gửi email
    sed -i 's|/\* ĐÃ TẮT - Uncomment để bật lại||' "$EMAIL_SERVICE"
    sed -i 's|\*/||' "$EMAIL_SERVICE"
    echo "✅ Đã bật EmailService"
else
    echo "❌ Không tìm thấy file: $EMAIL_SERVICE"
    exit 1
fi

# 5. Bật email config trong application-prod.properties
echo "📝 Bước 5: Bật email config trong application-prod.properties..."
APP_PROD="demoSmartFarm/demo/src/main/resources/application-prod.properties"

if [ -f "$APP_PROD" ]; then
    # Uncomment email config
    sed -i 's|#spring.mail|spring.mail|g' "$APP_PROD"
    sed -i 's|#app.mail|app.mail|' "$APP_PROD"
    echo "✅ Đã bật email config trong application-prod.properties"
else
    echo "❌ Không tìm thấy file: $APP_PROD"
    exit 1
fi

# 6. Bật Email Configuration trong docker-compose.yml
echo "📝 Bước 6: Bật Email Configuration trong docker-compose.yml..."
COMPOSE_FILE="docker-compose.yml"

if [ -f "$COMPOSE_FILE" ]; then
    # Uncomment và set các biến email
    sed -i 's|# MAIL_HOST: ${MAIL_HOST:-}|MAIL_HOST: smtp.gmail.com|' "$COMPOSE_FILE"
    sed -i 's|# MAIL_PORT: ${MAIL_PORT:-587}|MAIL_PORT: 587|' "$COMPOSE_FILE"
    sed -i 's|# MAIL_USERNAME: ${MAIL_USERNAME:-}|MAIL_USERNAME: lovengan0407@gmail.com|' "$COMPOSE_FILE"
    sed -i 's|# MAIL_PASSWORD: ${MAIL_PASSWORD:-}|MAIL_PASSWORD: bjjd yvqw rrmq dicg|' "$COMPOSE_FILE"
    sed -i 's|# MAIL_FROM: ${MAIL_FROM:-alerts@smartfarm.com}|MAIL_FROM: alerts@smartfarm.com|' "$COMPOSE_FILE"
    echo "✅ Đã bật Email Configuration trong docker-compose.yml"
else
    echo "❌ Không tìm thấy file: $COMPOSE_FILE"
    exit 1
fi

echo ""
echo "✅ Hoàn tất! Tất cả các thay đổi đã được áp dụng."
echo ""
echo "📋 Tiếp theo:"
echo "   1. Rebuild backend: docker-compose up -d --build backend"
echo "   2. Kiểm tra logs: docker-compose logs -f backend"
echo ""
echo "🧪 Test tạo alerts thủ công:"
echo "   curl -X POST http://your-vps-ip:8080/api/alerts/generate/now"
