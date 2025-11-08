#!/bin/bash

# Script export database từ local PostgreSQL
# Chạy trên máy local (Windows hoặc Linux)

echo "📤 Export database từ local..."
echo ""

# Kiểm tra xem có docker compose không
if command -v docker &> /dev/null; then
    # Nếu dùng Docker
    DB_CONTAINER=$(docker compose ps -q postgres 2>/dev/null || docker compose ps -q db 2>/dev/null)
    
    if [ -z "$DB_CONTAINER" ]; then
        echo "⚠️  Không tìm thấy PostgreSQL container trong Docker"
        echo "   Thử kết nối trực tiếp vào PostgreSQL..."
        
        # Kết nối trực tiếp
        DB_NAME="${DB_NAME:-smartfarm}"
        DB_USER="${DB_USER:-postgres}"
        DB_HOST="${DB_HOST:-localhost}"
        DB_PORT="${DB_PORT:-5432}"
        
        echo "📝 Sử dụng:"
        echo "   Database: $DB_NAME"
        echo "   User: $DB_USER"
        echo "   Host: $DB_HOST:$DB_PORT"
        echo ""
        
        OUTPUT_FILE="smartfarm-export-$(date +%Y%m%d-%H%M%S).sql"
        
        echo "🔄 Đang export..."
        pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -F p > "$OUTPUT_FILE"
        
        if [ $? -eq 0 ]; then
            echo "✅ Export thành công: $OUTPUT_FILE"
            echo ""
            echo "📦 File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
        else
            echo "❌ Export thất bại!"
            exit 1
        fi
    else
        # Dùng Docker
        echo "📦 PostgreSQL container: $DB_CONTAINER"
        echo ""
        
        DB_NAME="${DB_NAME:-smartfarm}"
        OUTPUT_FILE="smartfarm-export-$(date +%Y%m%d-%H%M%S).sql"
        
        echo "🔄 Đang export database '$DB_NAME'..."
        docker exec $DB_CONTAINER pg_dump -U postgres -d $DB_NAME -F p > "$OUTPUT_FILE"
        
        if [ $? -eq 0 ]; then
            echo "✅ Export thành công: $OUTPUT_FILE"
            echo ""
            echo "📦 File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
        else
            echo "❌ Export thất bại!"
            exit 1
        fi
    fi
else
    echo "❌ Không tìm thấy Docker hoặc pg_dump"
    echo "   Vui lòng cài đặt PostgreSQL client tools"
    exit 1
fi

echo ""
echo "📤 File đã sẵn sàng để upload lên VPS!"
echo "   Sử dụng: scp $OUTPUT_FILE user@vps:/path/to/"

