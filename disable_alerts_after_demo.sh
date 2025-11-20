#!/bin/bash

# Script để tắt lại hệ thống cảnh báo và email sau khi thi xong
# Sử dụng: ./disable_alerts_after_demo.sh

set -e

echo "🛑 Tắt hệ thống cảnh báo và email..."
echo ""

# 1. Tắt Alert Scheduler
echo "📝 Bước 1: Tắt Alert Scheduler..."
ALERT_FILE="demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java"

if [ -f "$ALERT_FILE" ]; then
    # Comment @Scheduled
    sed -i 's|@Scheduled(fixedRate = 300000)|// @Scheduled(fixedRate = 300000) // ĐÃ TẮT|' "$ALERT_FILE"
    sed -i 's|import org.springframework.scheduling.annotation.Scheduled;|// import org.springframework.scheduling.annotation.Scheduled; // Đã tắt|' "$ALERT_FILE"
    echo "✅ Đã tắt Alert Scheduler"
else
    echo "❌ Không tìm thấy file: $ALERT_FILE"
    exit 1
fi

# 2. Tắt Email Configuration
echo "📝 Bước 2: Tắt Email Configuration..."
COMPOSE_FILE="docker-compose.yml"

if [ -f "$COMPOSE_FILE" ]; then
    # Comment các dòng email
    sed -i 's/^      MAIL_HOST: smtp.gmail.com/      # MAIL_HOST: ${MAIL_HOST:-}/' "$COMPOSE_FILE"
    sed -i 's/^      MAIL_PORT: 587/      # MAIL_PORT: ${MAIL_PORT:-587}/' "$COMPOSE_FILE"
    sed -i 's/^      MAIL_USERNAME: lovengan0407@gmail.com/      # MAIL_USERNAME: ${MAIL_USERNAME:-}/' "$COMPOSE_FILE"
    sed -i 's/^      MAIL_PASSWORD: bjjd yvqw rrmq dicg/      # MAIL_PASSWORD: ${MAIL_PASSWORD:-}/' "$COMPOSE_FILE"
    sed -i 's/^      MAIL_FROM: alerts@smartfarm.com/      # MAIL_FROM: ${MAIL_FROM:-alerts@smartfarm.com}/' "$COMPOSE_FILE"
    echo "✅ Đã tắt Email Configuration"
else
    echo "❌ Không tìm thấy file: $COMPOSE_FILE"
    exit 1
fi

# 3. Restart backend
echo "📝 Bước 3: Restart backend service..."
docker-compose restart backend

echo ""
echo "✅ Hoàn tất! Hệ thống cảnh báo và email đã được tắt."

