#!/bin/bash

# Script để bật lại hệ thống cảnh báo và email cho ngày thi
# Sử dụng: ./enable_alerts_for_demo.sh

set -e

echo "🎯 Bật lại hệ thống cảnh báo và email cho ngày thi..."
echo ""

# 1. Bật Alert Scheduler
echo "📝 Bước 1: Bật Alert Scheduler..."
ALERT_FILE="demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java"

if [ -f "$ALERT_FILE" ]; then
    # Uncomment @Scheduled
    sed -i 's|// @Scheduled(fixedRate = 300000)|@Scheduled(fixedRate = 300000)|' "$ALERT_FILE"
    sed -i 's|// import org.springframework.scheduling.annotation.Scheduled;|import org.springframework.scheduling.annotation.Scheduled;|' "$ALERT_FILE"
    echo "✅ Đã bật Alert Scheduler"
else
    echo "❌ Không tìm thấy file: $ALERT_FILE"
    exit 1
fi

# 2. Bật Email Configuration
echo "📝 Bước 2: Bật Email Configuration..."
COMPOSE_FILE="docker-compose.yml"

if [ -f "$COMPOSE_FILE" ]; then
    # Uncomment các dòng email
    sed -i 's/# MAIL_HOST: ${MAIL_HOST:-}/MAIL_HOST: smtp.gmail.com/' "$COMPOSE_FILE"
    sed -i 's/# MAIL_PORT: ${MAIL_PORT:-587}/MAIL_PORT: 587/' "$COMPOSE_FILE"
    sed -i 's/# MAIL_USERNAME: ${MAIL_USERNAME:-}/MAIL_USERNAME: lovengan0407@gmail.com/' "$COMPOSE_FILE"
    sed -i 's/# MAIL_PASSWORD: ${MAIL_PASSWORD:-}/MAIL_PASSWORD: bjjd yvqw rrmq dicg/' "$COMPOSE_FILE"
    sed -i 's/# MAIL_FROM: ${MAIL_FROM:-alerts@smartfarm.com}/MAIL_FROM: alerts@smartfarm.com/' "$COMPOSE_FILE"
    echo "✅ Đã bật Email Configuration"
else
    echo "❌ Không tìm thấy file: $COMPOSE_FILE"
    exit 1
fi

# 3. Rebuild và restart backend
echo "📝 Bước 3: Rebuild và restart backend service..."
docker-compose up -d --build backend

echo ""
echo "✅ Hoàn tất! Hệ thống cảnh báo và email đã được bật."
echo ""
echo "📊 Kiểm tra logs:"
echo "   docker-compose logs -f backend"
echo ""
echo "🧪 Test tạo alerts thủ công:"
echo "   curl -X POST http://localhost:8080/api/alerts/generate/now"

