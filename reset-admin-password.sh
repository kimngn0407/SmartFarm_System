#!/bin/bash

# Script reset password cho admin.nguyen@smartfarm.com
# Chạy trên VPS, kết nối trực tiếp vào database

echo "🔧 Reset password cho admin.nguyen@smartfarm.com"
echo ""

# Lấy database credentials từ docker-compose
DB_CONTAINER=$(docker compose ps -q postgres 2>/dev/null || docker compose ps -q db 2>/dev/null)

if [ -z "$DB_CONTAINER" ]; then
    echo "❌ Không tìm thấy PostgreSQL container"
    exit 1
fi

echo "📦 PostgreSQL container: $DB_CONTAINER"
echo ""

# Generate BCrypt hash cho password "admin123"
# BCrypt hash: $2a$10$... (cần generate từ Spring Boot hoặc online tool)
# Tạm thời dùng hash có sẵn từ database dump
NEW_PASSWORD_HASH='$2a$10$XWiyRvBz/hLjXss0J9Nva.OQBMV8IclmnMX3sVY5ZS6VOPOTFz.nO'  # admin123

echo "🔄 Updating password..."
docker exec -i $DB_CONTAINER psql -U postgres -d smartfarm <<EOF
-- Update password cho admin.nguyen@smartfarm.com
UPDATE account 
SET password = '$NEW_PASSWORD_HASH' 
WHERE email = 'admin.nguyen@smartfarm.com';

-- Kiểm tra role
SELECT a.id, a.email, a.full_name, ar.role 
FROM account a 
LEFT JOIN account_roles ar ON a.id = ar.account_id 
WHERE a.email = 'admin.nguyen@smartfarm.com';

EOF

echo ""
echo "✅ Password đã được reset!"
echo ""
echo "📝 Thông tin đăng nhập:"
echo "   Email: admin.nguyen@smartfarm.com"
echo "   Password: admin123"
echo ""
echo "🧪 Test login:"
echo "   curl -X POST http://173.249.48.25:8080/api/auth/login \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"email\":\"admin.nguyen@smartfarm.com\",\"password\":\"admin123\"}'"

