#!/bin/bash

# Script để sửa file dump PostgreSQL - loại bỏ các lệnh CREATE nếu đã tồn tại
# Usage: ./fix-dump-format.sh <input_file.sql> <output_file.sql>

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./fix-dump-format.sh <input_file.sql> <output_file.sql>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"

echo "Fixing dump file format..."
echo "Input: $INPUT_FILE"
echo "Output: $OUTPUT_FILE"

# Sửa các vấn đề:
# 1. Thêm IF NOT EXISTS cho CREATE TABLE
# 2. Thêm OR REPLACE cho các lệnh khác
# 3. Bỏ qua các lệnh SET không cần thiết

sed -E '
    # Thêm IF NOT EXISTS cho CREATE TABLE
    s/CREATE TABLE public\.([a-z_]+) \(/CREATE TABLE IF NOT EXISTS public.\1 (/g
    
    # Thêm IF NOT EXISTS cho CREATE SEQUENCE
    s/CREATE SEQUENCE public\.([a-z_]+_id_seq)/CREATE SEQUENCE IF NOT EXISTS public.\1/g
    
    # Bỏ qua các lệnh SET transaction_timeout (không hỗ trợ trong PostgreSQL 15)
    /^SET transaction_timeout/d
    
    # Thay thế ALTER TABLE ... OWNER TO thành -- (comment)
    s/^ALTER TABLE.*OWNER TO postgres;/-- &/g
    s/^ALTER SEQUENCE.*OWNER TO postgres;/-- &/g
    
    # Bỏ qua các lệnh ALTER TABLE ... ALTER COLUMN id SET DEFAULT (đã là identity)
    /^ALTER TABLE.*ALTER COLUMN id SET DEFAULT/d
' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "✅ Fixed dump file created: $OUTPUT_FILE"
echo ""
echo "Now you can restore with:"
echo "  docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < $OUTPUT_FILE"


