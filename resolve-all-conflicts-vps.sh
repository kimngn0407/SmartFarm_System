#!/bin/bash

# Script để resolve tất cả merge conflicts bằng cách giữ version từ remote

cd /opt/SmartFarm

echo "🔧 Đang resolve tất cả merge conflicts..."

# Danh sách files có conflict
CONFLICT_FILES=(
    "Arduino_SmartFarm_IoT.ino"
    "HUONG_DAN_DIEN_DNS.md"
    "IOT_SEND_DATA_GUIDE.md"
    "README.md"
    "RecommentCrop/Dockerfile"
    "RecommentCrop/requirements.txt"
    "check-esp32-tools.ps1"
    "demoSmartFarm/demo/src/main/java/com/example/demo/Services/AIRecommendationService.java"
    "demoSmartFarm/demo/src/main/java/com/example/demo/Services/PestDiseaseService.java"
    "demoSmartFarm/demo/src/main/resources/application.properties"
    "nginx/nginx.conf"
    "setup-ssl-standalone.sh"
)

# Giữ version từ remote cho tất cả files
for file in "${CONFLICT_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "📝 Resolving conflict in: $file"
        git checkout --theirs "$file" 2>/dev/null || echo "⚠️  Could not resolve $file"
        git add "$file" 2>/dev/null || echo "⚠️  Could not add $file"
    else
        echo "⚠️  File not found: $file"
    fi
done

# Xử lý README.md (modify/delete conflict)
if [ -f "README.md" ]; then
    echo "📝 Resolving README.md (modify/delete conflict)"
    # Giữ version từ remote (xóa file)
    git rm README.md 2>/dev/null || echo "⚠️  Could not remove README.md"
fi

# Kiểm tra status
echo ""
echo "📊 Git status sau khi resolve:"
git status

# Nếu còn conflicts, hướng dẫn manual
if [ -n "$(git diff --check 2>/dev/null)" ]; then
    echo ""
    echo "⚠️  Vẫn còn conflicts. Hãy resolve thủ công:"
    echo "1. Xem files có conflict: git status"
    echo "2. Mở file và tìm: <<<<<<< HEAD"
    echo "3. Xóa conflict markers và giữ code đúng"
    echo "4. git add <file>"
    echo "5. git commit"
else
    echo ""
    echo "✅ Tất cả conflicts đã được resolve!"
    echo "📝 Đang commit..."
    git commit -m "Resolve merge conflicts - keep remote version for all files"
    echo "✅ Đã commit thành công!"
fi
