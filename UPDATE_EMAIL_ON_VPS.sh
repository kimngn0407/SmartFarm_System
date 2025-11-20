#!/bin/bash

# Script để cập nhật email config trên VPS
# Sử dụng: ./UPDATE_EMAIL_ON_VPS.sh

echo "📧 Cập nhật Email Configuration trên VPS"
echo "=========================================="
echo ""

# Đọc password từ user (ẩn input)
read -sp "Nhập Gmail App Password (16 ký tự, không dấu cách): " MAIL_PASSWORD
echo ""
read -p "Nhập Gmail address (ví dụ: your-email@gmail.com): " MAIL_USERNAME
echo ""

# Set default values
MAIL_HOST=${MAIL_HOST:-smtp.gmail.com}
MAIL_PORT=${MAIL_PORT:-587}
MAIL_FROM=${MAIL_FROM:-$MAIL_USERNAME}

echo ""
echo "🔧 Cấu hình Email:"
echo "  MAIL_HOST: $MAIL_HOST"
echo "  MAIL_PORT: $MAIL_PORT"
echo "  MAIL_USERNAME: $MAIL_USERNAME"
echo "  MAIL_FROM: $MAIL_FROM"
echo "  MAIL_PASSWORD: [HIDDEN]"
echo ""

read -p "Xác nhận cập nhật? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "❌ Đã hủy"
    exit 1
fi

# Backup docker-compose.yml
echo "💾 Đang backup docker-compose.yml..."
cp docker-compose.yml docker-compose.yml.backup

# Tìm và cập nhật email config trong docker-compose.yml
echo "✏️  Đang cập nhật docker-compose.yml..."

# Tạo temp file với email config mới
cat > /tmp/email_config.txt << EOF
      # Email Configuration
      MAIL_HOST: $MAIL_HOST
      MAIL_PORT: $MAIL_PORT
      MAIL_USERNAME: $MAIL_USERNAME
      MAIL_PASSWORD: $MAIL_PASSWORD
      MAIL_FROM: $MAIL_FROM
EOF

# Sử dụng sed để thay thế hoặc thêm email config
# Tìm dòng FRONTEND_ORIGINS và thêm email config sau nó
if grep -q "MAIL_HOST" docker-compose.yml; then
    # Nếu đã có email config, thay thế
    sed -i '/MAIL_HOST/,/MAIL_FROM/c\
      # Email Configuration\
      MAIL_HOST: '"$MAIL_HOST"'\
      MAIL_PORT: '"$MAIL_PORT"'\
      MAIL_USERNAME: '"$MAIL_USERNAME"'\
      MAIL_PASSWORD: '"$MAIL_PASSWORD"'\
      MAIL_FROM: '"$MAIL_FROM" docker-compose.yml
else
    # Nếu chưa có, thêm sau FRONTEND_ORIGINS
    sed -i '/FRONTEND_ORIGINS/a\
      # Email Configuration\
      MAIL_HOST: '"$MAIL_HOST"'\
      MAIL_PORT: '"$MAIL_PORT"'\
      MAIL_USERNAME: '"$MAIL_USERNAME"'\
      MAIL_PASSWORD: '"$MAIL_PASSWORD"'\
      MAIL_FROM: '"$MAIL_FROM" docker-compose.yml
fi

echo "✅ Đã cập nhật docker-compose.yml"
echo ""
echo "🔄 Đang restart backend..."
docker-compose stop backend
docker-compose up -d --build backend

echo ""
echo "✅ Hoàn tất!"
echo ""
echo "📋 Kiểm tra:"
echo "  docker-compose logs -f backend | grep -i mail"
echo "  docker exec smartfarm-backend env | grep MAIL"

