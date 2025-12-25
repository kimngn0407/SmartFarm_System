#!/bin/bash

# Script để setup SSL certificate cho smartfarm.codex.io.vn
# Sử dụng Let's Encrypt với certbot trong Docker

set -e

DOMAIN="smartfarm.kimngn.cfd"
EMAIL="your-email@example.com"  # Thay bằng email của bạn
PROJECT_DIR="/opt/SmartFarm"

echo "🔐 Setting up SSL certificate for $DOMAIN (Docker method)"
echo "========================================================="

cd $PROJECT_DIR

# Kiểm tra DNS trước
echo "🔍 Checking DNS configuration..."
DNS_IP=$(dig +short $DOMAIN A | head -n1)
if [ -z "$DNS_IP" ]; then
    echo "❌ ERROR: No A record found for $DOMAIN"
    echo "   Please add A record: smartfarm → 109.205.180.72"
    echo "   And disable Cloudflare Proxy (if using Cloudflare)"
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
mkdir -p certbot/www/.well-known/acme-challenge

# Đảm bảo Nginx đang chạy và đã reload config
echo "🔄 Ensuring Nginx is running and ready..."
docker-compose up -d nginx
sleep 3

# Test ACME challenge path
echo "🧪 Testing ACME challenge path..."
echo "test" > certbot/www/.well-known/acme-challenge/test.txt
sleep 2

# Test từ bên ngoài
TEST_RESULT=$(curl -s -o /dev/null -w "%{http_code}" http://$DOMAIN/.well-known/acme-challenge/test.txt || echo "000")
if [ "$TEST_RESULT" != "200" ]; then
    echo "⚠️  WARNING: Cannot access ACME challenge path (HTTP $TEST_RESULT)"
    echo "   This might be due to:"
    echo "   1. Nginx not running or not reloaded"
    echo "   2. Firewall blocking port 80"
    echo "   3. DNS not fully propagated"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ ACME challenge path is accessible"
fi

# Chạy certbot trong Docker để lấy certificate
echo "🔒 Requesting SSL certificate from Let's Encrypt..."

docker run -it --rm \
    -v "$PROJECT_DIR/certbot/conf:/etc/letsencrypt" \
    -v "$PROJECT_DIR/certbot/www:/var/www/certbot" \
    certbot/certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAIN

echo ""
echo "✅ SSL certificate obtained!"
echo "📋 Certificate location: $PROJECT_DIR/certbot/conf/live/$DOMAIN/"

# Reload Nginx
echo "🔄 Reloading Nginx..."
docker compose restart nginx

echo ""
echo "✅ SSL setup complete!"
echo "🌐 Your site is now available at: https://$DOMAIN"
echo ""
echo "📝 To set up auto-renewal, add to crontab:"
echo "   0 0 * * * cd $PROJECT_DIR && docker run --rm -v $PROJECT_DIR/certbot/conf:/etc/letsencrypt certbot/certbot renew && docker compose restart nginx"
