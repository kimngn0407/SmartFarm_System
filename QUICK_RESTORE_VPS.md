# 🚀 Hướng dẫn Restore Database trên VPS (Nhanh)

## Cách 1: Chạy lệnh thủ công (Không cần script)

**SSH vào VPS và chạy từng lệnh:**

```bash
cd ~/projects/SmartFarm

# 1. Kiểm tra file dump
ls -lh DB_SM_ver1.sql

# 2. Ngắt tất cả kết nối
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
"

# 3. Drop database
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"

# 4. Tạo database mới
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# 5. Import database (bỏ qua lỗi nhỏ)
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off < DB_SM_ver1.sql

# 6. Kiểm tra kết quả
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM farm;"

# 7. Restart backend
docker compose restart backend
```

## Cách 2: Tạo script trên VPS

**SSH vào VPS và chạy:**

```bash
cd ~/projects/SmartFarm

# Tạo script restore
cat > restore-clean.sh << 'EOF'
#!/bin/bash
DUMP_FILE="$1"
if [ -z "$DUMP_FILE" ]; then
    echo "Usage: ./restore-clean.sh <dump_file.sql>"
    exit 1
fi

echo "=== Restore Database ==="
echo "File: $DUMP_FILE"

# Terminate connections
echo "Terminating connections..."
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop database
echo "Dropping database..."
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true

# Create database
echo "Creating database..."
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Import
echo "Importing..."
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off < "$DUMP_FILE"

echo "✅ Done!"
echo ""
echo "Verifying..."
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM account;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM farm;" | xargs
EOF

# Cho phép chạy
chmod +x restore-clean.sh

# Chạy script
./restore-clean.sh DB_SM_ver1.sql
```

## Cách 3: Upload script từ local lên VPS

**Trên máy local (PowerShell):**

```powershell
# Upload script lên VPS
scp restore-clean.sh root@173.249.48.25:~/projects/SmartFarm/
```

**Trên VPS:**

```bash
cd ~/projects/SmartFarm
chmod +x restore-clean.sh
./restore-clean.sh DB_SM_ver1.sql
```


