# 📦 Hướng dẫn Migrate Database từ Local lên VPS

## 🎯 Mục tiêu
Export toàn bộ database từ máy local và import lên VPS.

---

## 🆕 BẠN ĐÃ CÓ FILE DUMP? (Restore từ file dump có sẵn)

Nếu bạn đã có file dump PostgreSQL (file `.sql`), làm theo các bước sau:

### Bước 1: Lưu file dump vào máy local

Lưu file dump của bạn (ví dụ: `database_dump.sql`) vào thư mục dự án:
```powershell
# Copy file dump vào thư mục SmartFarm
# Ví dụ: E:\SmartFarm\database_dump.sql
```

### Bước 2: Transfer file lên VPS

**Cách 1: Dùng SCP (Khuyến nghị)**
```powershell
# Trên máy local (PowerShell)
scp E:\SmartFarm\DB_SM_ver1.sql root@173.249.48.25:~/projects/SmartFarm/
```

**Cách 2: Dùng WinSCP (GUI)**
1. Mở WinSCP
2. Kết nối đến VPS: `173.249.48.25`
3. Kéo thả file `database_dump.sql` vào thư mục `~/projects/SmartFarm/`

### Bước 3: Restore database trên VPS

**Trên VPS, SSH vào và chạy:**

```bash
cd ~/projects/SmartFarm

# Kiểm tra file dump đã có chưa
ls -lh DB_SM_ver1.sql

# Backup database hiện tại (nếu có)
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > backup_before_import_$(date +%Y%m%d_%H%M%S).sql

# Ngắt tất cả kết nối đến database (nếu cần)
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1'
  AND pid <> pg_backend_pid();
"

# DROP và tạo lại database
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Import database từ file dump
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < DB_SM_ver1.sql

# Kiểm tra kết quả
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM farm;"
```

**⚠️ LƯU Ý: Trên VPS không có sẵn script, bạn có 3 cách:**

#### Cách A: Chạy lệnh thủ công (Khuyến nghị - Nhanh nhất)

Chạy từng lệnh ở trên là đủ, không cần script.

#### Cách B: Tạo script trực tiếp trên VPS

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
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
" 2>/dev/null || true

# Drop và tạo lại
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;" 2>/dev/null || true
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Import
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off < "$DUMP_FILE"

echo "✅ Done!"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM account;" | xargs
EOF

# Cho phép chạy và chạy
chmod +x restore-clean.sh
./restore-clean.sh DB_SM_ver1.sql
```

#### Cách C: Upload script từ local lên VPS

**Trên máy local (PowerShell):**
```powershell
scp restore-clean.sh root@173.249.48.25:~/projects/SmartFarm/
```

**Trên VPS:**
```bash
cd ~/projects/SmartFarm
chmod +x restore-clean.sh
./restore-clean.sh DB_SM_ver1.sql
```

### ⚠️ Lưu ý khi restore từ dump:

1. **File dump phải là format SQL thuần** (không phải custom format `.dump`)
2. **Đảm bảo PostgreSQL version tương thích** (dump từ PostgreSQL 17.5 có thể cần PostgreSQL 15+)
3. **Kiểm tra encoding:** File dump phải là UTF-8
4. **Sau khi restore, restart backend:**
   ```bash
   docker compose restart backend
   ```

### 🔧 Xử lý lỗi khi restore:

**Nếu gặp lỗi "relation already exists" hoặc "multiple primary keys":**

```bash
# Cách 1: Dùng script clean restore (xóa hết và tạo lại)
chmod +x restore-clean.sh
./restore-clean.sh DB_SM_ver1.sql

# Cách 2: Drop database hoàn toàn trước
# Lưu ý: PostgreSQL không hỗ trợ CASCADE với DROP DATABASE
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 --set ON_ERROR_STOP=off < DB_SM_ver1.sql

# Cách 3: Sửa file dump trước khi import
chmod +x fix-dump-format.sh
./fix-dump-format.sh DB_SM_ver1.sql DB_SM_ver1_fixed.sql
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < DB_SM_ver1_fixed.sql
```

---

## 🔄 CÁC CÁCH KHÁC ĐỂ RESTORE DATABASE

### Cách 1: Dùng Docker Volume Mount (Không cần copy file)

**Trên máy local:**
```powershell
# Mount file dump vào container và restore trực tiếp
docker run --rm -v E:\SmartFarm:/backup -v smartfarm_postgres_data:/var/lib/postgresql/data postgres:15-alpine sh -c "
  psql -U postgres -d SmartFarm1 < /backup/database_dump.sql
"
```

**Trên VPS:**
```bash
# Copy file vào Docker volume
docker cp database_dump.sql smartfarm-postgres:/tmp/backup.sql

# Restore từ trong container
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -f /tmp/backup.sql

# Xóa file tạm
docker exec smartfarm-postgres rm /tmp/backup.sql
```

### Cách 2: Dùng Streaming qua SSH Pipe (Không cần lưu file)

**Trên máy local (PowerShell):**
```powershell
# Stream file dump trực tiếp qua SSH mà không lưu file trên VPS
Get-Content database_dump.sql | ssh root@173.249.48.25 "docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1"
```

**Hoặc với cat/ssh:**
```bash
# Trên Linux/Mac hoặc WSL
cat database_dump.sql | ssh root@173.249.48.25 "docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1"
```

### Cách 3: Dùng rsync (Nhanh hơn SCP cho file lớn)

**Trên máy local:**
```powershell
# Cài rsync cho Windows hoặc dùng WSL
wsl rsync -avz --progress E:/SmartFarm/database_dump.sql root@173.249.48.25:~/projects/SmartFarm/
```

**Trên VPS:**
```bash
# Restore như bình thường
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < database_dump.sql
```

### Cách 4: Dùng Cloud Storage (Google Drive, Dropbox, S3)

**Bước 1: Upload file lên cloud**
- Upload `database_dump.sql` lên Google Drive/Dropbox/S3

**Bước 2: Download trên VPS**
```bash
# Với wget (nếu có public link)
wget -O database_dump.sql "https://drive.google.com/uc?export=download&id=YOUR_FILE_ID"

# Hoặc dùng curl
curl -L "https://drive.google.com/uc?export=download&id=YOUR_FILE_ID" -o database_dump.sql

# Với S3 (nếu dùng AWS)
aws s3 cp s3://your-bucket/database_dump.sql ./database_dump.sql
```

**Bước 3: Restore như bình thường**

### Cách 5: Dùng pg_restore (Cho file format custom .dump)

**Nếu file dump là format custom (`.dump`):**

**Trên VPS:**
```bash
# Copy file .dump vào container
docker cp database_dump.dump smartfarm-postgres:/tmp/backup.dump

# Restore với pg_restore
docker exec smartfarm-postgres pg_restore -U postgres -d SmartFarm1 -v /tmp/backup.dump

# Xóa file tạm
docker exec smartfarm-postgres rm /tmp/backup.dump
```

**Hoặc restore trực tiếp:**
```bash
docker exec -i smartfarm-postgres pg_restore -U postgres -d SmartFarm1 < database_dump.dump
```

### Cách 6: Dùng pgAdmin Web Interface

**Bước 1: Cài pgAdmin trên VPS hoặc dùng Docker:**
```bash
docker run -d \
  --name pgadmin \
  -p 5050:80 \
  -e PGADMIN_DEFAULT_EMAIL=admin@smartfarm.com \
  -e PGADMIN_DEFAULT_PASSWORD=admin \
  -d dpage/pgadmin4
```

**Bước 2: Truy cập pgAdmin:**
- Mở browser: `http://173.249.48.25:5050`
- Login với email/password trên
- Kết nối đến PostgreSQL server
- Right-click database → Restore → Chọn file dump

### Cách 7: Dùng DBeaver hoặc PostgreSQL Client Tools

**Trên máy local:**
1. Cài DBeaver: https://dbeaver.io/
2. Kết nối đến VPS PostgreSQL (port 5432)
3. Right-click database → Tools → Restore Database
4. Chọn file dump và restore

### Cách 8: Split File cho File Lớn (>100MB)

**Trên máy local (PowerShell):**
```powershell
# Chia file dump thành các phần nhỏ (mỗi phần 50MB)
$file = "database_dump.sql"
$chunkSize = 50MB
$part = 1
$reader = [System.IO.File]::OpenRead($file)
$buffer = New-Object byte[] $chunkSize

while ($reader.Read($buffer, 0, $chunkSize) -gt 0) {
    $chunkFile = "database_dump_part$part.sql"
    [System.IO.File]::WriteAllBytes($chunkFile, $buffer)
    $part++
}
$reader.Close()
```

**Trên VPS:**
```bash
# Upload tất cả các phần
scp database_dump_part*.sql root@173.249.48.25:~/projects/SmartFarm/

# Nối các phần lại
cat database_dump_part*.sql > database_dump.sql

# Restore
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < database_dump.sql
```

### Cách 9: Dùng Base64 Encoding (Cho file nhỏ <10MB)

**Trên máy local (PowerShell):**
```powershell
# Encode file thành base64
$content = [Convert]::ToBase64String([IO.File]::ReadAllBytes("database_dump.sql"))
$content | Out-File -Encoding UTF8 database_dump_base64.txt
```

**Trên VPS:**
```bash
# Decode và restore
base64 -d database_dump_base64.txt | docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1
```

### Cách 10: Dùng Git LFS (Cho file lớn trong Git)

**Trên máy local:**
```powershell
# Cài Git LFS
git lfs install

# Track file SQL lớn
git lfs track "*.sql"

# Commit và push
git add .gitattributes database_dump.sql
git commit -m "Add database dump"
git push origin main
```

**Trên VPS:**
```bash
# Pull về
git pull origin main

# Restore
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < database_dump.sql
```

### Cách 11: Dùng PostgreSQL Replication (Cho production)

**Nếu muốn sync real-time giữa local và VPS:**
```bash
# Trên VPS, cấu hình PostgreSQL làm replica
# (Cần cấu hình postgresql.conf và pg_hba.conf)
# Phương pháp này phức tạp hơn, chỉ dùng cho production
```

### Cách 12: Dùng Docker Compose với Init Script

**Tạo file `init-db.sql` trong thư mục dự án:**
```bash
# Copy dump vào file init
cp database_dump.sql init-db.sql
```

**Cập nhật `docker-compose.yml`:**
```yaml
postgres:
  image: postgres:15-alpine
  volumes:
    - postgres_data:/var/lib/postgresql/data
    - ./init-db.sql:/docker-entrypoint-initdb.d/init-db.sql
```

**Restart container:**
```bash
docker compose down -v  # Xóa volume cũ
docker compose up -d postgres  # Tạo lại với init script
```

⚠️ **Lưu ý:** Cách này chỉ chạy khi database mới được tạo lần đầu.

---

## 📊 SO SÁNH CÁC PHƯƠNG PHÁP

| Phương pháp | Tốc độ | Độ khó | Kích thước file | Khuyến nghị |
|------------|--------|--------|-----------------|-------------|
| **SCP + Restore** | ⭐⭐⭐ | ⭐ | < 500MB | ✅ Phổ biến nhất |
| **SSH Streaming** | ⭐⭐⭐⭐ | ⭐⭐ | < 100MB | ✅ Nhanh, không lưu file |
| **rsync** | ⭐⭐⭐⭐⭐ | ⭐⭐ | Bất kỳ | ✅ Tốt cho file lớn |
| **Cloud Storage** | ⭐⭐ | ⭐ | Bất kỳ | ✅ Tiện lợi |
| **pgAdmin Web** | ⭐⭐ | ⭐ | < 200MB | ✅ GUI dễ dùng |
| **Docker Volume** | ⭐⭐⭐ | ⭐⭐ | Bất kỳ | ✅ Tích hợp Docker |
| **Split File** | ⭐⭐ | ⭐⭐⭐ | > 100MB | ⚠️ Khi file quá lớn |
| **Git LFS** | ⭐⭐ | ⭐⭐ | Bất kỳ | ⚠️ Nếu dùng Git |
| **Base64** | ⭐ | ⭐⭐ | < 10MB | ❌ Không khuyến nghị |

### 🎯 Khuyến nghị theo tình huống:

- **File < 50MB:** Dùng **SSH Streaming** (Cách 2) - Nhanh nhất
- **File 50-200MB:** Dùng **SCP + Restore** (Cách cơ bản) - Đơn giản nhất
- **File > 200MB:** Dùng **rsync** (Cách 3) - Nhanh và ổn định
- **Không có SSH:** Dùng **Cloud Storage** (Cách 4) - Tiện lợi
- **Muốn dùng GUI:** Dùng **pgAdmin** (Cách 6) - Dễ dùng
- **File rất lớn (>500MB):** Dùng **Split File** (Cách 8) - Chia nhỏ

---

## ⚡ CÁCH NHANH NHẤT (Khuyến nghị)

### Sử dụng Script Tự Động

**Trên máy local (PowerShell):**
```powershell
# Tự động export và transfer lên VPS
.\migrate-to-vps.ps1 -AutoTransfer

# Hoặc chỉ export (sau đó transfer thủ công)
.\migrate-to-vps.ps1
```

**Trên VPS (Bash):**
```bash
cd ~/projects/SmartFarm
chmod +x import-database.sh
./import-database.sh
```

Script sẽ tự động:
- ✅ Kiểm tra Docker và container
- ✅ Export/Import database
- ✅ Backup database hiện tại trước khi import
- ✅ Kiểm tra kết quả import

**📖 Xem hướng dẫn nhanh:** [QUICK_MIGRATE.md](./QUICK_MIGRATE.md)

---

## 📋 BƯỚC 1: Export Database từ Local

### ⚠️ QUAN TRỌNG: Export đúng cách để không lỗi khi import

Để tránh lỗi khi import lên VPS, cần export với các options đặc biệt:

### Cách 1: Export với format sạch (Khuyến nghị)

**Trên máy local (Windows PowerShell):**

```powershell
# Export với các options để tạo file dump sạch, tương thích
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 `
    --no-owner `
    --no-privileges `
    --clean `
    --if-exists `
    --create `
    --encoding=UTF8 `
    --format=plain > smartfarm_backup_clean_$(Get-Date -Format "yyyyMMdd_HHmmss").sql
```

**Hoặc dùng script tự động:**
```powershell
.\export-database-clean.ps1
```

**Trên Linux/Mac:**
```bash
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 \
    --no-owner \
    --no-privileges \
    --clean \
    --if-exists \
    --create \
    --encoding=UTF8 \
    --format=plain > smartfarm_backup_clean_$(date +%Y%m%d_%H%M%S).sql
```

**Giải thích các options:**
- `--no-owner`: Bỏ lệnh `ALTER TABLE ... OWNER TO` (tránh lỗi permission)
- `--no-privileges`: Bỏ lệnh `GRANT/REVOKE` (không cần thiết)
- `--clean`: Thêm `DROP` statements trước `CREATE` (xóa sạch trước khi tạo)
- `--if-exists`: Dùng `IF EXISTS` với `DROP` (tránh lỗi nếu không tồn tại)
- `--create`: Thêm `CREATE DATABASE` statement (tự động tạo DB)
- `--encoding=UTF8`: Đảm bảo encoding đúng
- `--format=plain`: Format SQL thuần (dễ import)

### Cách 2: Export đơn giản (Có thể gặp lỗi)

**Trên máy local (Windows PowerShell):**

```powershell
# Export database từ container (có thể gặp lỗi khi import)
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > smartfarm_backup_$(Get-Date -Format "yyyyMMdd_HHmmss").sql

# Hoặc export với format custom (nén, nhanh hơn)
docker exec smartfarm-postgres pg_dump -U postgres -Fc -d SmartFarm1 > smartfarm_backup_$(Get-Date -Format "yyyyMMdd_HHmmss").dump
```

### Cách 2: Export trực tiếp từ PostgreSQL (Nếu cài trực tiếp)

```powershell
# Nếu có pg_dump trong PATH
pg_dump -U postgres -h localhost -d SmartFarm1 > smartfarm_backup_$(Get-Date -Format "yyyyMMdd_HHmmss").sql

# Hoặc với password
$env:PGPASSWORD="Ngan0407@!"
pg_dump -U postgres -h localhost -d SmartFarm1 > smartfarm_backup_$(Get-Date -Format "yyyyMMdd_HHmmss").sql
```

### Cách 3: Export từ Docker với file output trong container

```powershell
# Export vào trong container
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > backup.sql

# Copy file từ container ra ngoài
docker cp smartfarm-postgres:/backup.sql ./smartfarm_backup_$(Get-Date -Format "yyyyMMdd_HHmmss").sql
```

**Hoặc export trực tiếp ra file:**

```powershell
# Export vào file trong container, sau đó copy ra
docker exec smartfarm-postgres sh -c "pg_dump -U postgres -d SmartFarm1" > smartfarm_backup_$(Get-Date -Format "yyyyMMdd_HHmmss").sql
```

---

## 📤 BƯỚC 2: Transfer File lên VPS

### Cách 1: Dùng SCP (Secure Copy)

**Trên máy local (PowerShell hoặc CMD):**

```powershell
# Nếu dùng OpenSSH (Windows 10+)
scp smartfarm_backup_*.sql root@173.249.48.25:~/projects/SmartFarm/

# Hoặc với đường dẫn đầy đủ
scp E:\SmartFarm\smartfarm_backup_*.sql root@173.249.48.25:~/projects/SmartFarm/
```

**Nếu chưa có SSH key, sẽ hỏi password.**

### Cách 2: Dùng WinSCP (GUI - Dễ dùng hơn)

1. Download WinSCP: https://winscp.net/
2. Kết nối đến VPS:
   - Host: `173.249.48.25`
   - Username: `root`
   - Password: (password VPS của bạn)
3. Kéo thả file `.sql` từ local vào thư mục `~/projects/SmartFarm/` trên VPS

### Cách 3: Dùng FileZilla (FTP/SFTP)

1. Download FileZilla: https://filezilla-project.org/
2. Kết nối SFTP đến VPS
3. Upload file `.sql` lên VPS

### Cách 4: Dùng Git (Nếu file không quá lớn)

```powershell
# Commit file backup vào git (tạm thời)
git add smartfarm_backup_*.sql
git commit -m "Database backup for migration"
git push origin main

# Trên VPS, pull về
cd ~/projects/SmartFarm
git pull origin main
```

**⚠️ Lưu ý:** Sau khi import xong, nên xóa file backup khỏi git để không làm repo nặng.

---

## 📥 BƯỚC 3: Import Database lên VPS

### Cách 1: Import file dump có --create (Tự động tạo DB)

**Nếu file dump được export với `--create` option:**

```bash
cd ~/projects/SmartFarm

# Kiểm tra file backup
ls -lh smartfarm_backup_clean_*.sql

# Import trực tiếp (sẽ tự động DROP và CREATE database)
docker exec -i smartfarm-postgres psql -U postgres < smartfarm_backup_clean_*.sql
```

### Cách 2: Import file dump thông thường

**Trên VPS, SSH vào và chạy:**

```bash
cd ~/projects/SmartFarm

# Kiểm tra file backup đã có chưa
ls -lh smartfarm_backup_*.sql

# Backup database hiện tại (để phòng hờ)
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > backup_before_import_$(date +%Y%m%d_%H%M%S).sql

# Ngắt tất cả kết nối
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1' AND pid <> pg_backend_pid();
"

# DROP database cũ (nếu muốn import hoàn toàn mới)
# ⚠️ CẨN THẬN: Lệnh này sẽ xóa toàn bộ data hiện tại!
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Import database từ file backup
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < smartfarm_backup_*.sql

# Hoặc nếu file trong container
docker cp smartfarm_backup_*.sql smartfarm-postgres:/tmp/backup.sql
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -f /tmp/backup.sql
docker exec smartfarm-postgres rm /tmp/backup.sql
```

---

## 🔄 BƯỚC 4: Kiểm tra Import thành công

```bash
# Kiểm tra số lượng records trong các bảng chính
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM account;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM farm;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM field;"
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM sensor;"

# Xem danh sách users
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT id, email, full_name FROM account LIMIT 10;"
```

---

## 🚀 Script Tự Động (All-in-one)

### Script trên Local (PowerShell): `export-database.ps1`

```powershell
# Export Database từ Local
Write-Host "=== Exporting Database ===" -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "smartfarm_backup_$timestamp.sql"

Write-Host "Exporting to: $backupFile" -ForegroundColor Yellow

# Export từ Docker container
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > $backupFile

if (Test-Path $backupFile) {
    $fileSize = (Get-Item $backupFile).Length / 1MB
    Write-Host "✅ Export successful! File size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Transfer file to VPS: scp $backupFile root@173.249.48.25:~/projects/SmartFarm/" -ForegroundColor White
    Write-Host "2. On VPS, run: docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < $backupFile" -ForegroundColor White
} else {
    Write-Host "❌ Export failed!" -ForegroundColor Red
}
```

### Script trên VPS (Bash): `import-database.sh`

```bash
#!/bin/bash

echo "=== Importing Database to VPS ==="

# Tìm file backup mới nhất
BACKUP_FILE=$(ls -t smartfarm_backup_*.sql 2>/dev/null | head -1)

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ No backup file found!"
    exit 1
fi

echo "Found backup file: $BACKUP_FILE"
echo "File size: $(du -h "$BACKUP_FILE" | cut -f1)"

# Backup database hiện tại
echo ""
echo "Creating backup of current database..."
CURRENT_BACKUP="backup_before_import_$(date +%Y%m%d_%H%M%S).sql"
docker exec smartfarm-postgres pg_dump -U postgres -d SmartFarm1 > "$CURRENT_BACKUP"
echo "✅ Current database backed up to: $CURRENT_BACKUP"

# Confirm before dropping
read -p "⚠️  This will REPLACE current database. Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "❌ Cancelled"
    exit 1
fi

# Drop and recreate database
echo ""
echo "Dropping existing database..."
docker exec -it smartfarm-postgres psql -U postgres -c "DROP DATABASE IF EXISTS SmartFarm1;"
docker exec -it smartfarm-postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Import database
echo ""
echo "Importing database from $BACKUP_FILE..."
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Import successful!"
    echo ""
    echo "Verifying import..."
    docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as account_count FROM account;"
    docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) as farm_count FROM farm;"
else
    echo "❌ Import failed!"
    exit 1
fi
```

**Chạy script trên VPS:**
```bash
chmod +x import-database.sh
./import-database.sh
```

---

## ⚠️ LƯU Ý QUAN TRỌNG

1. **Backup trước khi import:** Luôn backup database hiện tại trên VPS trước khi import
2. **Kiểm tra kích thước file:** Nếu file quá lớn (>100MB), có thể cần dùng format custom (`.dump`)
3. **Thời gian import:** Database lớn có thể mất vài phút
4. **Restart backend:** Sau khi import, nên restart backend để đảm bảo kết nối mới:
   ```bash
   docker compose restart backend
   ```

---

## 🔧 Troubleshooting

### Lỗi: "database is being accessed by other users"

```bash
# Force disconnect all connections
docker exec -it smartfarm-postgres psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'SmartFarm1'
  AND pid <> pg_backend_pid();
"
```

### Lỗi: "permission denied"

```bash
# Đảm bảo file có quyền đọc
chmod 644 smartfarm_backup_*.sql
```

### Import với format custom (.dump)

```bash
# Export với format custom
docker exec smartfarm-postgres pg_dump -U postgres -Fc -d SmartFarm1 > backup.dump

# Import format custom
docker exec -i smartfarm-postgres pg_restore -U postgres -d SmartFarm1 < backup.dump
```

---

**Chúc bạn migrate thành công! 🚀**


