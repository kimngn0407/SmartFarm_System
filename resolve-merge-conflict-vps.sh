#!/bin/bash

# Script để giải quyết merge conflict trên VPS

cd /opt/SmartFarm

echo "🔧 Đang giải quyết merge conflict..."

# 1. Kiểm tra conflict markers
echo "📋 Kiểm tra conflict markers..."

if grep -q "<<<<<<< HEAD" AI_SmartFarm_CHatbot/next.config.ts 2>/dev/null; then
    echo "⚠️  Tìm thấy conflict trong next.config.ts"
    echo "📝 Giữ version từ remote (origin/main)..."
    # Giữ version từ remote (origin/main)
    git checkout --theirs AI_SmartFarm_CHatbot/next.config.ts
    git add AI_SmartFarm_CHatbot/next.config.ts
    echo "✅ Đã resolve conflict trong next.config.ts"
else
    echo "✅ next.config.ts không có conflict"
fi

if grep -q "<<<<<<< HEAD" nginx/nginx.conf 2>/dev/null; then
    echo "⚠️  Tìm thấy conflict trong nginx.conf"
    echo "📝 Giữ version từ remote (origin/main)..."
    # Giữ version từ remote (origin/main)
    git checkout --theirs nginx/nginx.conf
    git add nginx/nginx.conf
    echo "✅ Đã resolve conflict trong nginx.conf"
else
    echo "✅ nginx.conf không có conflict"
fi

# 2. Kiểm tra status
echo ""
echo "📊 Git status:"
git status

# 3. Nếu còn conflict, hướng dẫn manual
if [ -n "$(git diff --check)" ]; then
    echo ""
    echo "⚠️  Vẫn còn conflict. Hãy resolve thủ công:"
    echo "1. Mở file có conflict:"
    echo "   nano AI_SmartFarm_CHatbot/next.config.ts"
    echo "   nano nginx/nginx.conf"
    echo ""
    echo "2. Tìm các dòng:"
    echo "   <<<<<<< HEAD"
    echo "   ======="
    echo "   >>>>>>> origin/main"
    echo ""
    echo "3. Xóa conflict markers và giữ code đúng"
    echo "4. Sau đó chạy: git add <file>"
    echo "5. Cuối cùng: git commit"
else
    echo ""
    echo "✅ Tất cả conflict đã được resolve!"
    echo "📝 Đang commit..."
    git commit -m "Resolve merge conflict - keep remote version for next.config.ts and nginx.conf"
    echo "✅ Đã commit thành công!"
fi
