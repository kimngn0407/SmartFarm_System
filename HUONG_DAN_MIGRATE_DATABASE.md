# 📘 HƯỚNG DẪN MIGRATE DATABASE TỪ LOCAL LÊN VPS

## 🎯 Mục tiêu
Export database từ máy local (Windows) và import lên VPS (Linux) một cách đơn giản, không lỗi.

---

## 📋 BƯỚC 1: Export Database từ Local (Windows)

### Cách 1: Dùng Docker Container (Khuyến nghị)

**Mở PowerShell và chạy:**

```powershell
# Di chuyển vào thư mục dự án
cd E:\SmartFarm

# Export database với format sạch (không lỗi khi import)
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 `
    --no-owner `
    --no-privileges `
    --clean `
    --if-exists `
    --create `
    --encoding=UTF8 `
    --format=plain > DB_SM_ver1_clean.sql
```

**Hoặc dùng script tự động:**

```powershell
cd E:\SmartFarm
.\export-database-clean.ps1
```

**Kiểm tra file đã tạo:**
```powershell
ls DB_SM_ver1_clean.sql
```

### Cách 2: Export đơn giản (Nếu không cần format sạch)

```powershell
cd E:\SmartFarm
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > DB_SM_ver1.sql
```

---

## 📤 BƯỚC 2: Upload File lên VPS

### ⚠️ QUAN TRỌNG: Phải chạy lệnh này trên máy LOCAL (Windows), KHÔNG phải trên VPS!

### Cách 1: Dùng SCP (Khuyến nghị)

**Mở PowerShell trên máy LOCAL (Windows) và chạy:**

```powershell
# Di chuyển vào thư mục chứa file
cd E:\SmartFarm

# Upload file lên VPS (chạy trên máy LOCAL)
scp DB_SM_ver1_clean.sql root@173.249.48.25:~/projects/SmartFarm/
```

**Hoặc với đường dẫn đầy đủ:**
```powershell
scp E:\SmartFarm\DB_SM_ver1_clean.sql root@173.249.48.25:~/projects/SmartFarm/
```

**Nhập password khi được hỏi.**

**❌ SAI:** Chạy `scp` trên VPS với đường dẫn Windows
**✅ ĐÚNG:** Chạy `scp` trên máy LOCAL (Windows) với đường dẫn Windows

### Cách 2: Dùng WinSCP (GUI - Dễ dùng hơn - Khuyến nghị cho người mới)

1. Download WinSCP: https://winscp.net/
2. Mở WinSCP và kết nối:
   - **Host:** `173.249.48.25`
   - **Username:** `root`
   - **Password:** (password VPS của bạn)
3. Kéo thả file `DB_SM_ver1_clean.sql` từ thư mục `E:\SmartFarm` (bên trái) vào thư mục `~/projects/SmartFarm/` trên VPS (bên phải)

### Cách 3: Kiểm tra file đã có trên VPS chưa

**Nếu bạn đã upload file trước đó, kiểm tra trên VPS:**

```bash
# SSH vào VPS
ssh root@173.249.48.25

# Kiểm tra file
cd ~/projects/SmartFarm
ls -lh DB_SM_ver1_clean.sql
```

**Nếu file đã có rồi, bỏ qua bước upload và chuyển sang BƯỚC 3.**

---

## 📥 BƯỚC 3: Restore Database trên VPS

### Cách 1: Chạy lệnh thủ công (Khuyến nghị - Đơn giản nhất)

**SSH vào VPS và chạy từng lệnh:**

```bash
# 1. Di chuyển vào thư mục dự án
cd ~/projects/SmartFarm

# 2. Kiểm tra file đã có chưa
ls -lh DB_SM_ver1_clean.sql

# 3. Ngắt tất cả kết nối đến database
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
"

# 4. Drop database cũ
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"

# 5. Tạo database mới
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# 6. Import database từ file dump
# Nếu file có --create, dùng lệnh này:
docker exec -i smartfarm-postgres psql -U postgres < DB_SM_ver1_clean.sql

# Hoặc nếu file không có --create, dùng lệnh này:
# docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off < DB_SM_ver1_clean.sql

# 7. Kiểm tra kết quả
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM farm;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM field;"

# 8. Restart backend
docker compose restart backend
```

### Cách 2: Tạo script trên VPS (Nếu muốn tự động)

**SSH vào VPS và copy toàn bộ đoạn này:**

```bash
cd ~/projects/SmartFarm

# Tạo script restore
cat > restore-db.sh << 'EOF'
#!/bin/bash
DUMP_FILE="$1"
if [ -z "$DUMP_FILE" ]; then
    echo "Usage: ./restore-db.sh <dump_file.sql>"
    exit 1
fi

echo "=== Restore Database ==="
echo "File: $DUMP_FILE"

# Terminate connections
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop và tạo lại
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;" 2>/dev/null || true

# Import
docker exec -i smartfarm-postgres psql -U postgres < "$DUMP_FILE"

echo "✅ Done!"
echo ""
echo "Verifying..."
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM account;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM farm;" | xargs
EOF

# Cho phép chạy
chmod +x restore-db.sh

# Chạy script
./restore-db.sh DB_SM_ver1_clean.sql
```

---

## ✅ KIỂM TRA SAU KHI RESTORE

**Trên VPS, chạy các lệnh sau để kiểm tra:**

```bash
# Kiểm tra số lượng records trong tất cả các bảng chính
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as account_count FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as farm_count FROM farm;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as field_count FROM field;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as sensor_count FROM sensor;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as sensor_data_count FROM sensor_data;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as plant_count FROM plant;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as crop_season_count FROM crop_season;"

# Xem danh sách users
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT id, email, full_name FROM account LIMIT 10;"

# Kiểm tra số lượng records thực tế trong các bảng
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
    'account' as table_name, COUNT(*) as row_count FROM account
UNION ALL
SELECT 'farm', COUNT(*) FROM farm
UNION ALL
SELECT 'field', COUNT(*) FROM field
UNION ALL
SELECT 'sensor', COUNT(*) FROM sensor
UNION ALL
SELECT 'sensor_data', COUNT(*) FROM sensor_data
UNION ALL
SELECT 'plant', COUNT(*) FROM plant
UNION ALL
SELECT 'crop_season', COUNT(*) FROM crop_season
UNION ALL
SELECT 'alert', COUNT(*) FROM alert
ORDER BY row_count DESC;
"

# Restart backend
docker compose restart backend

# Kiểm tra logs backend
docker compose logs -f backend
```

### ⚠️ Nếu dữ liệu không đầy đủ (ví dụ: farm = 0, field = 0):

**Nguyên nhân có thể:**
1. File dump không có đầy đủ dữ liệu (chỉ có schema)
2. File dump bị lỗi khi import
3. Export với option `--clean` đã xóa dữ liệu

**Kiểm tra file dump có dữ liệu không:**

```bash
# Kiểm tra file dump có lệnh COPY (dữ liệu) không
grep -c "COPY public" DB_SM_ver1_clean.sql

# Kiểm tra file dump có lệnh INSERT không
grep -c "INSERT INTO" DB_SM_ver1_clean.sql

# Nếu cả 2 đều = 0 → File dump không có dữ liệu
```

**Giải pháp: Export lại từ local với đầy đủ dữ liệu**

**Trên máy LOCAL (Windows PowerShell):**

```powershell
cd E:\SmartFarm

# Export lại với đầy đủ dữ liệu (KHÔNG dùng --clean)
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 `
    --no-owner `
    --no-privileges `
    --if-exists `
    --create `
    --encoding=UTF8 `
    --format=plain > DB_SM_ver1_FULL.sql

# Kiểm tra file có dữ liệu không (số lượng COPY phải > 0)
Select-String -Path DB_SM_ver1_FULL.sql -Pattern "COPY public" | Measure-Object | Select-Object -ExpandProperty Count
```

**Sau đó upload và import lại:**

```bash
# 1. Upload file mới lên VPS (từ máy local PowerShell)
# scp E:\SmartFarm\DB_SM_ver1_FULL.sql root@173.249.48.25:~/projects/SmartFarm/

# 2. Trên VPS, import lại
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
"

docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"
docker exec -i smartfarm-postgres psql -U postgres < DB_SM_ver1_FULL.sql

# 3. Kiểm tra lại
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM farm;"
```

**Hoặc nếu file dump gốc (DB_SM_ver1.sql) có dữ liệu nhưng bị lỗi foreign key:**

```bash
# Kiểm tra file gốc có dữ liệu không
grep -c "COPY public" DB_SM_ver1.sql

# Cách 1: Import hoàn chỉnh với script tự động (Khuyến nghị - Xử lý tất cả lỗi)

**Tạo script trên VPS:**

```bash
cd ~/projects/SmartFarm

cat > import-db-complete.sh << 'EOF'
#!/bin/bash
DUMP_FILE="$1"
if [ -z "$DUMP_FILE" ]; then
    echo "Usage: ./import-db-complete.sh <dump_file.sql>"
    exit 1
fi

echo "=== Import Database ==="
echo "File: $DUMP_FILE"

# Terminate connections
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop và tạo lại
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Tạo file import với disable foreign key
cat > /tmp/import_fixed.sql << 'IMPORT_EOF'
SET session_replication_role = 'replica';
IMPORT_EOF

cat "$DUMP_FILE" >> /tmp/import_fixed.sql
echo "SET session_replication_role = 'origin';" >> /tmp/import_fixed.sql

# Copy vào container
docker cp /tmp/import_fixed.sql smartfarm-postgres:/tmp/import_fixed.sql

# QUAN TRỌNG: Import file (bước này không được bỏ qua!)
echo "Importing database..."
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -f /tmp/import_fixed.sql --set ON_ERROR_STOP=off > /dev/null 2>&1

# Cleanup
docker exec smartfarm-postgres rm /tmp/import_fixed.sql
rm /tmp/import_fixed.sql

echo "✅ Done!"
echo ""
echo "Verifying data..."
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM account;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM farm;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM field;" | xargs
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM sensor;" | xargs
EOF

chmod +x import-db-complete.sh
./import-db-complete.sh DB_SM_ver1.sql
```

# Cách 2: Import thủ công - ĐÚNG CÁCH (Xử lý COPY FROM stdin)

```bash
# Ngắt kết nối
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
"

# Drop và tạo lại (QUAN TRỌNG: Phải drop trước)
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Import trực tiếp với pipe (QUAN TRỌNG: Dùng < thay vì -f để COPY FROM stdin hoạt động)
{
    echo "SET session_replication_role = 'replica';"
    cat DB_SM_ver1.sql
    echo "SET session_replication_role = 'origin';"
} | docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off

# Kiểm tra
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM farm;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM field;"
```

# Cách 2: Dùng script tự động
chmod +x import-with-fk-fix.sh
./import-with-fk-fix.sh DB_SM_ver1.sql

# Cách 3: Import đơn giản với bỏ qua lỗi (có thể mất một số dữ liệu)
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off < DB_SM_ver1.sql
```

---

## 🔧 XỬ LÝ LỖI

### Lỗi: "pg_dump: command not found"

**Nguyên nhân:** Bạn đang chạy `pg_dump` trực tiếp trên Windows, không có trong PATH.

**Giải pháp:** Phải chạy qua Docker container:
```powershell
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > backup.sql
```

### Lỗi: "relation already exists"

**Nguyên nhân:** Database đã có bảng từ trước.

**Giải pháp:** Drop database trước khi import:
```bash
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"
```

### Lỗi: "database is being accessed by other users"

**Nguyên nhân:** Có kết nối đang sử dụng database.

**Giải pháp:** Ngắt tất cả kết nối:
```bash
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
"
```

### Lỗi: "syntax error" hoặc "unrecognized configuration parameter"

**Nguyên nhân:** File dump có các lệnh không tương thích với PostgreSQL version trên VPS.

**Giải pháp:** Export lại với format sạch (dùng `--no-owner`, `--clean`, `--if-exists`)

---

## 📝 TÓM TẮT QUY TRÌNH

1. **Trên Local (Windows):**
   ```powershell
   cd E:\SmartFarm
   docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 --no-owner --no-privileges --clean --if-exists --create --encoding=UTF8 --format=plain > DB_SM_ver1_clean.sql
   scp DB_SM_ver1_clean.sql root@173.249.48.25:~/projects/SmartFarm/
   ```

2. **Trên VPS (Linux):**
   ```bash
   cd ~/projects/SmartFarm
   docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"
   docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"
   docker exec -i smartfarm-postgres psql -U postgres < DB_SM_ver1_clean.sql
   docker compose restart backend
   ```

---

## 🎉 HOÀN THÀNH!

Sau khi restore xong, database trên VPS sẽ giống hệt database trên local.

**Lưu ý:**
- Luôn backup database hiện tại trên VPS trước khi restore
- Kiểm tra kết quả sau khi restore
- Restart backend để đảm bảo kết nối mới

**Chúc bạn migrate thành công! 🚀**

---

## 🚀 BƯỚC TIẾP THEO: Chạy Toàn Bộ Ứng Dụng

Sau khi database đã được import thành công, chạy toàn bộ ứng dụng:

```bash
cd ~/projects/SmartFarm

# Start tất cả services
docker compose up -d --build

# Kiểm tra services đã chạy
docker compose ps

# Xem logs
docker compose logs -f
```

**Xem hướng dẫn chi tiết:** [START_APPLICATION.md](./START_APPLICATION.md)

