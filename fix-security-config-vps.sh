#!/bin/bash
# Script để fix SecurityConfig trên VPS

cd /opt/SmartFarm

FILE_PATH="demoSmartFarm/demo/src/main/java/com/example/demo/Security/SecurityConfig.java"

echo "🔧 Fixing SecurityConfig.java..."

# Backup file
cp "$FILE_PATH" "$FILE_PATH.backup.$(date +%Y%m%d_%H%M%S)"

# Sửa file: thay .anyRequest().authenticated() bằng .anyRequest().permitAll()
sed -i 's/\.anyRequest()\.authenticated()/\.anyRequest()\.permitAll()/g' "$FILE_PATH"

# Kiểm tra đã sửa chưa
if grep -q "\.anyRequest()\.permitAll()" "$FILE_PATH"; then
    echo "✅ File đã được sửa thành công!"
    echo "📝 Đã thay .anyRequest().authenticated() bằng .anyRequest().permitAll()"
else
    echo "❌ Lỗi: Không tìm thấy .anyRequest().permitAll()"
    exit 1
fi

# Kiểm tra không còn .authenticated()
if grep -q "\.anyRequest()\.authenticated()" "$FILE_PATH"; then
    echo "⚠️  WARNING: Vẫn còn .anyRequest().authenticated() trong file"
    echo "   Có thể có trong comment, kiểm tra lại:"
    grep -n "\.anyRequest()\.authenticated()" "$FILE_PATH"
else
    echo "✅ Không còn .anyRequest().authenticated()"
fi

# Xem phần authorizeHttpRequests
echo ""
echo "📄 Phần authorizeHttpRequests sau khi sửa:"
grep -A 5 "authorizeHttpRequests" "$FILE_PATH" | head -10

echo ""
echo "✅ File đã được sửa thành công!"
echo "📝 Bước tiếp theo: Rebuild backend"
echo "   docker compose build --no-cache backend"
echo "   docker compose up -d --force-recreate backend"
