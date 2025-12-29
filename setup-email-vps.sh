#!/bin/bash

# Script để setup Email Alert trên VPS
# Sử dụng file .env để cấu hình email

echo "========================================="
echo "  Setup Email Alert trên VPS"
echo "========================================="
echo ""

# Kiểm tra đang ở đúng thư mục
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Lỗi: Không tìm thấy docker-compose.yml"
    echo "   Vui lòng chạy script trong thư mục /opt/SmartFarm"
    exit 1
fi

# Kiểm tra file .env đã tồn tại chưa
if [ -f ".env" ]; then
    echo "⚠️  File .env đã tồn tại"
    read -p "Bạn có muốn cập nhật thông tin email? (y/n): " update_env
    if [ "$update_env" != "y" ] && [ "$update_env" != "Y" ]; then
        echo "Đã hủy."
        exit 0
    fi
    # Backup file .env cũ
    cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ Đã backup file .env cũ"
fi

echo ""
echo "Nhập thông tin Email Configuration:"
echo ""

# Nhập MAIL_HOST
read -p "MAIL_HOST [smtp.gmail.com]: " mail_host
mail_host=${mail_host:-smtp.gmail.com}

# Nhập MAIL_PORT
read -p "MAIL_PORT [587]: " mail_port
mail_port=${mail_port:-587}

# Nhập MAIL_USERNAME
read -p "MAIL_USERNAME (email của bạn): " mail_username
if [ -z "$mail_username" ]; then
    echo "❌ MAIL_USERNAME không được để trống!"
    exit 1
fi

# Nhập MAIL_PASSWORD (App Password cho Gmail)
read -sp "MAIL_PASSWORD (Gmail App Password - 16 ký tự): " mail_password
echo ""
if [ -z "$mail_password" ]; then
    echo "❌ MAIL_PASSWORD không được để trống!"
    exit 1
fi

# Nhập MAIL_FROM
read -p "MAIL_FROM [$mail_username]: " mail_from
mail_from=${mail_from:-$mail_username}

echo ""
echo "========================================="
echo "Thông tin đã nhập:"
echo "========================================="
echo "MAIL_HOST: $mail_host"
echo "MAIL_PORT: $mail_port"
echo "MAIL_USERNAME: $mail_username"
echo "MAIL_PASSWORD: ********"
echo "MAIL_FROM: $mail_from"
echo ""

read -p "Xác nhận các thông tin trên đúng? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Đã hủy."
    exit 0
fi

# Đọc file .env hiện tại (nếu có)
if [ -f ".env" ]; then
    # Giữ lại các biến khác, chỉ cập nhật/cập nhật email config
    grep -v "^MAIL_" .env > .env.tmp 2>/dev/null || touch .env.tmp
else
    # Tạo file .env mới từ template nếu có
    if [ -f "env.vps.template" ]; then
        cp env.vps.template .env.tmp
    else
        touch .env.tmp
    fi
fi

# Thêm email config vào file .env
echo "" >> .env.tmp
echo "# Email Configuration - Added by setup-email-vps.sh" >> .env.tmp
echo "MAIL_HOST=$mail_host" >> .env.tmp
echo "MAIL_PORT=$mail_port" >> .env.tmp
echo "MAIL_USERNAME=$mail_username" >> .env.tmp
echo "MAIL_PASSWORD=$mail_password" >> .env.tmp
echo "MAIL_FROM=$mail_from" >> .env.tmp

# Di chuyển file tạm thành .env
mv .env.tmp .env

# Set permission bảo mật
chmod 600 .env

echo ""
echo "✅ Đã tạo/cập nhật file .env"
echo ""

# Hỏi có muốn rebuild backend không
read -p "Bạn có muốn rebuild và restart backend ngay? (y/n): " rebuild_now
if [ "$rebuild_now" = "y" ] || [ "$rebuild_now" = "Y" ]; then
    echo ""
    echo "Đang pull code mới từ git..."
    git pull origin main
    
    echo ""
    echo "Đang rebuild backend..."
    docker compose build backend
    
    echo ""
    echo "Đang restart backend..."
    docker compose up -d backend
    
    echo ""
    echo "✅ Hoàn tất! Đang kiểm tra logs..."
    echo ""
    echo "Để xem logs: docker compose logs -f backend | grep -i 'email\|alert'"
    echo ""
    
    # Hiển thị logs trong 10 giây
    timeout 10 docker compose logs --tail=50 backend | grep -i "email\|alert" || echo "Chưa thấy log email (có thể đang start)..."
else
    echo ""
    echo "📋 Các bước tiếp theo:"
    echo "   1. Pull code: git pull origin main"
    echo "   2. Rebuild: docker compose build backend"
    echo "   3. Restart: docker compose up -d backend"
    echo "   4. Check logs: docker compose logs -f backend | grep -i 'email\|alert'"
fi

echo ""
echo "========================================="
echo "  Setup hoàn tất!"
echo "========================================="

