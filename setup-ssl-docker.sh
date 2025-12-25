#!/bin/bash

# Script để setup SSL certificate cho smartfarm.codex.io.vn
# Sử dụng Let's Encrypt với certbot trong Docker

set -e

DOMAIN="smartfarm.codex.io.vn"
EMAIL="your-email@example.com"  # Thay bằng email của bạn
PROJECT_DIR="/opt/SmartFarm"

echo "🔐 Setting up SSL certificate for $DOMAIN (Docker method)"
echo "========================================================="

cd $PROJECT_DIR

# Tạo thư mục cho certbot
mkdir -p certbot/conf
mkdir -p certbot/www

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
