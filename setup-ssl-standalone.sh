#!/bin/bash

# Script để setup SSL certificate cho smartfarm.kimngn.cfd
# Sử dụng Let's Encrypt với certbot trong Docker (Standalone mode)
# Standalone mode không cần Nginx phải serve file challenge

set -e

DOMAIN="smartfarm.kimngn.cfd"
EMAIL="your-email@example.com"  # Thay bằng email của bạn
PROJECT_DIR="/opt/SmartFarm"

echo "🔐 Setting up SSL certificate for $DOMAIN (Standalone mode)"
echo "==========================================================="

cd $PROJECT_DIR

# Kiểm tra DNS trước
echo "🔍 Checking DNS configuration..."
DNS_IP=$(dig +short $DOMAIN A | head -n1)
if [ -z "$DNS_IP" ]; then
    echo "❌ ERROR: No A record found for $DOMAIN"
    echo "   Please add A record: smartfarm → 109.205.180.72"
    exit 1
fi

echo "✅ DNS A record found: $DOMAIN → $DNS_IP"

if [ "$DNS_IP" != "109.205.180.72" ]; then
    echo "⚠️  WARNING: DNS points to $DNS_IP, expected 109.205.180.72"
    echo "   Please verify DNS configuration"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Tạo thư mục cho certbot
mkdir -p certbot/conf

# Kiểm tra docker compose command
if command -v docker &> /dev/null && docker compose version &> /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
elif command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "❌ ERROR: docker compose not found!"
    echo "   Please install docker-compose"
    exit 1
fi

echo "📦 Using: $DOCKER_COMPOSE"

# Dừng Nginx tạm thời để certbot dùng port 80
echo "🛑 Stopping Nginx temporarily..."

# Kiểm tra port 80 đang được dùng bởi process nào
PORT80_PID=$(lsof -ti :80 2>/dev/null || echo "")
if [ -n "$PORT80_PID" ]; then
    echo "⚠️  Port 80 is in use by PID: $PORT80_PID"
    echo "   Stopping Nginx and killing process..."
    $DOCKER_COMPOSE stop nginx 2>/dev/null || true
    sleep 3
    
    # Kill process nếu vẫn còn
    if lsof -ti :80 > /dev/null 2>&1; then
        echo "🔪 Killing process on port 80..."
        kill -9 $(lsof -ti :80) 2>/dev/null || true
        sleep 2
    fi
else
    $DOCKER_COMPOSE stop nginx 2>/dev/null || true
fi

# Đợi Nginx dừng hoàn toàn
sleep 3

# Kiểm tra lại port 80
if lsof -ti :80 > /dev/null 2>&1; then
    echo "❌ ERROR: Port 80 is still in use!"
    echo "   Please manually stop the process:"
    lsof -i :80 || netstat -tulpn | grep :80
    exit 1
fi

echo "✅ Port 80 is free"

# Chạy certbot trong Docker với standalone mode
echo "🔒 Requesting SSL certificate from Let's Encrypt (Standalone mode)..."
echo "   This will temporarily use port 80..."

docker run -it --rm \
    -p 80:80 \
    -v "$PROJECT_DIR/certbot/conf:/etc/letsencrypt" \
    certbot/certbot certonly \
    --standalone \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAIN

echo ""
echo "✅ SSL certificate obtained!"

# Kiểm tra certificate đã được tạo
if [ -f "$PROJECT_DIR/certbot/conf/live/$DOMAIN/fullchain.pem" ]; then
    echo "📋 Certificate location: $PROJECT_DIR/certbot/conf/live/$DOMAIN/"
    echo "   - fullchain.pem"
    echo "   - privkey.pem"
else
    echo "❌ ERROR: Certificate files not found!"
    echo "   Expected: $PROJECT_DIR/certbot/conf/live/$DOMAIN/fullchain.pem"
    exit 1
fi

# Khởi động lại Nginx
echo "🔄 Starting Nginx..."
$DOCKER_COMPOSE start nginx

# Đợi Nginx khởi động
sleep 3

# Kiểm tra Nginx đang chạy
if $DOCKER_COMPOSE ps nginx | grep -q "Up"; then
    echo "✅ Nginx is running"
else
    echo "⚠️  WARNING: Nginx might not be running properly"
    echo "   Check with: $DOCKER_COMPOSE ps"
fi

echo ""
echo "✅ SSL setup complete!"
echo "🌐 Your site is now available at: https://$DOMAIN"
echo ""
echo "📝 Next steps:"
echo "   1. Test HTTPS: curl -I https://$DOMAIN"
echo "   2. Restart all services: $DOCKER_COMPOSE restart"
echo "   3. Set up auto-renewal (see script comments)"
echo ""
echo "📝 To set up auto-renewal, add to crontab:"
echo "   0 0 * * * cd $PROJECT_DIR && docker run --rm -v $PROJECT_DIR/certbot/conf:/etc/letsencrypt -p 80:80 certbot/certbot renew --standalone && $DOCKER_COMPOSE restart nginx"
