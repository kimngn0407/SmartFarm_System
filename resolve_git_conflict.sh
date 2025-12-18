#!/bin/bash

# Script để giải quyết conflict git cho file deploy.sh
# Chạy trên VPS

echo "🔧 Giải quyết conflict git..."

# Xóa file deploy.sh (vì đã bị xóa trên remote)
if [ -f "deploy.sh" ]; then
    echo "📝 Xóa file deploy.sh (đã bị xóa trên remote)..."
    rm deploy.sh
    echo "✅ Đã xóa deploy.sh"
else
    echo "⚠️  File deploy.sh không tồn tại"
fi

# Xóa file deploy.sh khỏi git staging
git rm deploy.sh 2>/dev/null || echo "⚠️  File đã được xóa khỏi git"

# Commit để hoàn tất merge
echo ""
echo "📝 Commit để hoàn tất merge..."
git add .
git commit -m "Resolve conflict: remove deploy.sh (deleted on remote)"

echo ""
echo "✅ Đã giải quyết conflict!"
echo ""
echo "📋 Tiếp theo, bạn có thể:"
echo "   1. Rebuild backend: docker-compose up -d --build backend"
echo "   2. Kiểm tra logs: docker-compose logs -f backend"

