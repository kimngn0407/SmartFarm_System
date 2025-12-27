#!/bin/bash

# Fix Nginx Default Page - Kiểm tra và sửa lỗi Nginx hiển thị trang mặc định
# Chạy trên VPS: bash fix-nginx-default-page.sh

echo "🔧 Fix Nginx Default Page Issue"
echo "==============================="
echo ""

cd /opt/SmartFarm

# 1. Kiểm tra Nginx trên host
echo "📋 1. Kiểm tra Nginx trên host:"
if systemctl is-active --quiet nginx; then
    echo "   ⚠️  Nginx đang chạy trên host (có thể chiếm port 80)"
    echo "   Status: $(systemctl is-active nginx)"
else
    echo "   ✅ Nginx không chạy trên host"
fi

# 2. Kiểm tra port 80
echo ""
echo "📋 2. Kiểm tra port 80:"
PORT80=$(netstat -tuln | grep ':80 ' || ss -tuln | grep ':80 ')
if [ -n "$PORT80" ]; then
    echo "   Port 80 đang được sử dụng:"
    echo "   $PORT80"
else
    echo "   ✅ Port 80 không bị chiếm"
fi

# 3. Kiểm tra Docker containers
echo ""
echo "📋 3. Kiểm tra Docker containers:"
if docker ps | grep -q smartfarm-frontend; then
    echo "   ✅ Frontend container đang chạy"
    FRONTEND_IP=$(docker inspect smartfarm-frontend | grep -i ipaddress | head -1 | awk '{print $2}' | tr -d '",')
    echo "   IP: $FRONTEND_IP"
else
    echo "   ❌ Frontend container KHÔNG chạy!"
    echo "   Chạy: docker compose up -d frontend"
fi

if docker ps | grep -q smartfarm-nginx; then
    echo "   ✅ Nginx proxy container đang chạy"
else
    echo "   ⚠️  Nginx proxy container không chạy (có thể không cần thiết)"
fi

# 4. Kiểm tra frontend có hoạt động không
echo ""
echo "📋 4. Kiểm tra frontend container:"
if docker ps | grep -q smartfarm-frontend; then
    echo "   Testing frontend container..."
    FRONTEND_TEST=$(docker exec smartfarm-frontend wget -qO- http://localhost/ 2>/dev/null | head -20)
    if echo "$FRONTEND_TEST" | grep -q "SmartFarm\|React\|index.html"; then
        echo "   ✅ Frontend container hoạt động tốt"
    else
        echo "   ⚠️  Frontend container có thể có vấn đề"
        echo "   Response: $FRONTEND_TEST"
    fi
fi

# 5. Kiểm tra Nginx config trên host
echo ""
echo "📋 5. Kiểm tra Nginx config trên host:"
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "   ⚠️  Tìm thấy file default site config"
    echo "   File: /etc/nginx/sites-enabled/default"
    echo ""
    echo "   Nội dung (20 dòng đầu):"
    head -20 /etc/nginx/sites-enabled/default
    echo ""
    echo "   💡 Có thể cần disable site này:"
    echo "      sudo rm /etc/nginx/sites-enabled/default"
    echo "      sudo systemctl reload nginx"
fi

# 6. Giải pháp
echo ""
echo "🔧 Giải pháp:"
echo "============="
echo ""

# Option 1: Stop Nginx trên host
if systemctl is-active --quiet nginx; then
    echo "1. Dừng Nginx trên host (nếu không cần):"
    echo "   sudo systemctl stop nginx"
    echo "   sudo systemctl disable nginx"
    echo ""
fi

# Option 2: Disable default site
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "2. Disable default Nginx site:"
    echo "   sudo rm /etc/nginx/sites-enabled/default"
    echo "   sudo systemctl reload nginx"
    echo ""
fi

# Option 3: Restart frontend
echo "3. Restart frontend container:"
echo "   docker compose restart frontend"
echo ""

# Option 4: Kiểm tra firewall
echo "4. Kiểm tra firewall (nếu cần):"
echo "   sudo ufw status"
echo "   sudo ufw allow 80/tcp"
echo ""

echo "✅ Sau khi fix, truy cập lại: http://109.205.180.72"
echo ""

#!/bin/bash

# Fix Nginx Default Page - Kiểm tra và sửa lỗi Nginx hiển thị trang mặc định
# Chạy trên VPS: bash fix-nginx-default-page.sh

echo "🔧 Fix Nginx Default Page Issue"
echo "==============================="
echo ""

cd /opt/SmartFarm

# 1. Kiểm tra Nginx trên host
echo "📋 1. Kiểm tra Nginx trên host:"
if systemctl is-active --quiet nginx; then
    echo "   ⚠️  Nginx đang chạy trên host (có thể chiếm port 80)"
    echo "   Status: $(systemctl is-active nginx)"
else
    echo "   ✅ Nginx không chạy trên host"
fi

# 2. Kiểm tra port 80
echo ""
echo "📋 2. Kiểm tra port 80:"
PORT80=$(netstat -tuln | grep ':80 ' || ss -tuln | grep ':80 ')
if [ -n "$PORT80" ]; then
    echo "   Port 80 đang được sử dụng:"
    echo "   $PORT80"
else
    echo "   ✅ Port 80 không bị chiếm"
fi

# 3. Kiểm tra Docker containers
echo ""
echo "📋 3. Kiểm tra Docker containers:"
if docker ps | grep -q smartfarm-frontend; then
    echo "   ✅ Frontend container đang chạy"
    FRONTEND_IP=$(docker inspect smartfarm-frontend | grep -i ipaddress | head -1 | awk '{print $2}' | tr -d '",')
    echo "   IP: $FRONTEND_IP"
else
    echo "   ❌ Frontend container KHÔNG chạy!"
    echo "   Chạy: docker compose up -d frontend"
fi

if docker ps | grep -q smartfarm-nginx; then
    echo "   ✅ Nginx proxy container đang chạy"
else
    echo "   ⚠️  Nginx proxy container không chạy (có thể không cần thiết)"
fi

# 4. Kiểm tra frontend có hoạt động không
echo ""
echo "📋 4. Kiểm tra frontend container:"
if docker ps | grep -q smartfarm-frontend; then
    echo "   Testing frontend container..."
    FRONTEND_TEST=$(docker exec smartfarm-frontend wget -qO- http://localhost/ 2>/dev/null | head -20)
    if echo "$FRONTEND_TEST" | grep -q "SmartFarm\|React\|index.html"; then
        echo "   ✅ Frontend container hoạt động tốt"
    else
        echo "   ⚠️  Frontend container có thể có vấn đề"
        echo "   Response: $FRONTEND_TEST"
    fi
fi

# 5. Kiểm tra Nginx config trên host
echo ""
echo "📋 5. Kiểm tra Nginx config trên host:"
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "   ⚠️  Tìm thấy file default site config"
    echo "   File: /etc/nginx/sites-enabled/default"
    echo ""
    echo "   Nội dung (20 dòng đầu):"
    head -20 /etc/nginx/sites-enabled/default
    echo ""
    echo "   💡 Có thể cần disable site này:"
    echo "      sudo rm /etc/nginx/sites-enabled/default"
    echo "      sudo systemctl reload nginx"
fi

# 6. Giải pháp
echo ""
echo "🔧 Giải pháp:"
echo "============="
echo ""

# Option 1: Stop Nginx trên host
if systemctl is-active --quiet nginx; then
    echo "1. Dừng Nginx trên host (nếu không cần):"
    echo "   sudo systemctl stop nginx"
    echo "   sudo systemctl disable nginx"
    echo ""
fi

# Option 2: Disable default site
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "2. Disable default Nginx site:"
    echo "   sudo rm /etc/nginx/sites-enabled/default"
    echo "   sudo systemctl reload nginx"
    echo ""
fi

# Option 3: Restart frontend
echo "3. Restart frontend container:"
echo "   docker compose restart frontend"
echo ""

# Option 4: Kiểm tra firewall
echo "4. Kiểm tra firewall (nếu cần):"
echo "   sudo ufw status"
echo "   sudo ufw allow 80/tcp"
echo ""

echo "✅ Sau khi fix, truy cập lại: http://109.205.180.72"
echo ""

