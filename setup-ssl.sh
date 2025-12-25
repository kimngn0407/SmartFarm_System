#!/bin/bash

# Script để setup SSL certificate cho smartfarm.codex.io.vn
# Sử dụng Let's Encrypt với certbot

set -e

DOMAIN="smartfarm.codex.io.vn"
EMAIL="your-email@example.com"  # Thay bằng email của bạn
NGINX_CONTAINER="smartfarm-nginx"

echo "🔐 Setting up SSL certificate for $DOMAIN"
echo "=========================================="

# Kiểm tra certbot đã cài chưa
if ! command -v certbot &> /dev/null; then
    echo "📦 Installing certbot..."
    apt-get update
    apt-get install -y certbot python3-certbot-nginx
fi

# Tạo thư mục cho certbot
mkdir -p certbot/conf
mkdir -p certbot/www

# Tạm thời cấu hình Nginx để phục vụ ACME challenge (không redirect HTTPS)
echo "📝 Creating temporary Nginx config for ACME challenge..."

# Backup nginx.conf hiện tại
cp nginx/nginx.conf nginx/nginx.conf.backup

# Tạo config tạm thời cho ACME challenge
cat > nginx/nginx.conf.temp <<EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    server {
        listen 80;
        server_name $DOMAIN;
        
        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }
        
        location / {
            proxy_pass http://frontend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }
}
EOF

# Copy config tạm vào container
docker cp nginx/nginx.conf.temp $NGINX_CONTAINER:/etc/nginx/nginx.conf
docker exec $NGINX_CONTAINER nginx -s reload

# Chờ Nginx reload
sleep 2

# Lấy certificate
echo "🔒 Requesting SSL certificate from Let's Encrypt..."
certbot certonly \
    --webroot \
    --webroot-path=./certbot/www \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    --force-renewal \
    -d $DOMAIN

# Khôi phục nginx.conf gốc
cp nginx/nginx.conf.backup nginx/nginx.conf
rm nginx/nginx.conf.temp

# Copy certificate vào container
echo "📋 Copying certificates to Nginx container..."
docker cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem $NGINX_CONTAINER:/etc/letsencrypt/live/$DOMAIN/fullchain.pem
docker cp /etc/letsencrypt/live/$DOMAIN/privkey.pem $NGINX_CONTAINER:/etc/letsencrypt/live/$DOMAIN/privkey.pem

# Reload Nginx với config mới
echo "🔄 Reloading Nginx with SSL configuration..."
docker exec $NGINX_CONTAINER nginx -s reload

echo ""
echo "✅ SSL certificate setup complete!"
echo "🌐 Your site is now available at: https://$DOMAIN"
echo ""
echo "📝 Next steps:"
echo "   1. Update docker-compose.yml to mount Let's Encrypt certificates"
echo "   2. Update application configs to use https://$DOMAIN"
echo "   3. Set up auto-renewal: certbot renew --dry-run"
