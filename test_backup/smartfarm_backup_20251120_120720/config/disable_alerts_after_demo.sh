#!/bin/bash

# Script để tắt lại hệ thống cảnh báo và email sau khi thi xong
# Sử dụng: ./disable_alerts_after_demo.sh

set -e

echo "🛑 Tắt hệ thống cảnh báo và email..."
echo ""

# 1. Tắt Alert Scheduler
echo "📝 Bước 1: Tắt Alert Scheduler..."
ALERT_SCHEDULER="demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertSchedulerService.java"

if [ -f "$ALERT_SCHEDULER" ]; then
    # Comment @Scheduled
    sed -i 's|@Scheduled(fixedRate = 300000)|// @Scheduled(fixedRate = 300000) // ĐÃ TẮT|' "$ALERT_SCHEDULER"
    sed -i 's|import org.springframework.scheduling.annotation.Scheduled;|// import org.springframework.scheduling.annotation.Scheduled; // Đã tắt|' "$ALERT_SCHEDULER"
    echo "✅ Đã tắt Alert Scheduler"
else
    echo "❌ Không tìm thấy file: $ALERT_SCHEDULER"
    exit 1
fi

# 2. Tắt AlertService (thêm early return và comment code)
echo "📝 Bước 2: Tắt AlertService..."
ALERT_SERVICE="demoSmartFarm/demo/src/main/java/com/example/demo/Services/AlertService.java"

if [ -f "$ALERT_SERVICE" ]; then
    # Tìm dòng public List<AlertResponseDTO> createAlertsFromSensorData
    # Thêm early return sau dòng List<AlertResponseDTO> alerts = new ArrayList<>();
    sed -i '/public List<AlertResponseDTO> createAlertsFromSensorData/,/List<AlertResponseDTO> alerts = new ArrayList<>();/{
        /List<AlertResponseDTO> alerts = new ArrayList<>();/a\
\
        // ⚠️ TẠM TẮT - Không tạo cảnh báo tự động\
        // Để bật lại, xóa hoặc comment dòng return bên dưới\
        return alerts;\
\
        /* ĐÃ TẮT - Uncomment để bật lại
    }' "$ALERT_SERVICE"
    
    # Thêm comment đóng ở cuối method (trước return alerts cuối cùng)
    sed -i '/return alerts;$/{
        i\
        */
        :a; n; ba
    }' "$ALERT_SERVICE"
    
    echo "✅ Đã tắt AlertService"
else
    echo "❌ Không tìm thấy file: $ALERT_SERVICE"
    exit 1
fi

# 3. Tắt API endpoints
echo "📝 Bước 3: Tắt API endpoints..."
ALERT_CONTROLLER="demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/AlertController.java"

if [ -f "$ALERT_CONTROLLER" ]; then
    # Comment API endpoints
    sed -i '/@PostMapping("\/generate")/,/@PostMapping("\/generate\/now")/{
        s|@PostMapping|// ⚠️ ĐÃ TẮT - Để bật lại, uncomment các endpoint này\n    /*\n    @PostMapping|
    }' "$ALERT_CONTROLLER"
    
    # Thêm comment đóng sau method cuối cùng
    sed -i '/generateAlertsNow()$/,/^    }$/{
        /^    }$/a\
    */
    }' "$ALERT_CONTROLLER"
    
    echo "✅ Đã tắt API endpoints"
else
    echo "❌ Không tìm thấy file: $ALERT_CONTROLLER"
    exit 1
fi

# 4. Tắt EmailService
echo "📝 Bước 4: Tắt EmailService..."
EMAIL_SERVICE="demoSmartFarm/demo/src/main/java/com/example/demo/Services/EmailService.java"

if [ -f "$EMAIL_SERVICE" ]; then
    # Comment @Service
    sed -i 's|@Service|// @Service - ĐÃ TẮT|' "$EMAIL_SERVICE"
    # Thêm early return trong sendAlertEmail
    sed -i '/public void sendAlertEmail(List<String> to/,/Map<String, Object> templateVariables) {/{
        /templateVariables) {/a\
        // ⚠️ ĐÃ TẮT - Không gửi email\
        logger.warn("Email service is disabled. Skipping email to: {}", to);\
        return;\
        \
        /* ĐÃ TẮT - Uncomment để bật lại
    }' "$EMAIL_SERVICE"
    
    # Thêm comment đóng ở cuối method
    sed -i '/^    }$/{
        i\
        */
    }' "$EMAIL_SERVICE"
    
    echo "✅ Đã tắt EmailService"
else
    echo "❌ Không tìm thấy file: $EMAIL_SERVICE"
    exit 1
fi

# 5. Tắt email config trong application-prod.properties
echo "📝 Bước 5: Tắt email config trong application-prod.properties..."
APP_PROD="demoSmartFarm/demo/src/main/resources/application-prod.properties"

if [ -f "$APP_PROD" ]; then
    # Comment email config
    sed -i 's|^spring.mail|#spring.mail|g' "$APP_PROD"
    sed -i 's|^app.mail|#app.mail|' "$APP_PROD"
    echo "✅ Đã tắt email config trong application-prod.properties"
else
    echo "❌ Không tìm thấy file: $APP_PROD"
    exit 1
fi

# 6. Tắt Email Configuration trong docker-compose.yml
echo "📝 Bước 6: Tắt Email Configuration trong docker-compose.yml..."
COMPOSE_FILE="docker-compose.yml"

if [ -f "$COMPOSE_FILE" ]; then
    # Comment các dòng email
    sed -i 's|^      MAIL_HOST: smtp.gmail.com|      # MAIL_HOST: ${MAIL_HOST:-}|' "$COMPOSE_FILE"
    sed -i 's|^      MAIL_PORT: 587|      # MAIL_PORT: ${MAIL_PORT:-587}|' "$COMPOSE_FILE"
    sed -i 's|^      MAIL_USERNAME: lovengan0407@gmail.com|      # MAIL_USERNAME: ${MAIL_USERNAME:-}|' "$COMPOSE_FILE"
    sed -i 's|^      MAIL_PASSWORD: bjjd yvqw rrmq dicg|      # MAIL_PASSWORD: ${MAIL_PASSWORD:-}|' "$COMPOSE_FILE"
    sed -i 's|^      MAIL_FROM: alerts@smartfarm.com|      # MAIL_FROM: ${MAIL_FROM:-alerts@smartfarm.com}|' "$COMPOSE_FILE"
    echo "✅ Đã tắt Email Configuration trong docker-compose.yml"
else
    echo "❌ Không tìm thấy file: $COMPOSE_FILE"
    exit 1
fi

# 7. Rebuild backend
echo "📝 Bước 7: Rebuild backend service..."
docker-compose up -d --build backend

echo ""
echo "✅ Hoàn tất! Hệ thống cảnh báo và email đã được tắt."
echo ""
echo "📋 Kiểm tra logs:"
echo "   docker-compose logs -f backend"

