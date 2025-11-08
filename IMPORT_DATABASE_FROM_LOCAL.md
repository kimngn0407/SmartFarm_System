# 📤 Import Database Từ Local Lên VPS

## 🔄 Quy Trình

### Bước 1: Export Database Từ Local

**Trên máy local (Windows/Linux):**

#### Option A: Dùng Docker (Nếu có)

```bash
# Chạy script export
chmod +x export-local-db.sh
./export-local-db.sh
```

Script sẽ tạo file: `smartfarm-export-YYYYMMDD-HHMMSS.sql`

#### Option B: Export Thủ Công

**Windows (PowerShell):**
```powershell
# Nếu dùng Docker
docker exec smartfarm-postgres pg_dump -U postgres -d smartfarm > smartfarm-export.sql

# Hoặc nếu PostgreSQL cài trực tiếp
pg_dump -h localhost -U postgres -d smartfarm > smartfarm-export.sql
```

**Linux/Mac:**
```bash
# Nếu dùng Docker
docker exec smartfarm-postgres pg_dump -U postgres -d smartfarm > smartfarm-export.sql

# Hoặc nếu PostgreSQL cài trực tiếp
pg_dump -h localhost -U postgres -d smartfarm > smartfarm-export.sql
```

### Bước 2: Upload File Lên VPS

**Trên máy local:**

```bash
# Sử dụng SCP để upload
scp smartfarm-export.sql root@173.249.48.25:~/projects/SmartFarm/

# Hoặc dùng SFTP
sftp root@173.249.48.25
put smartfarm-export.sql ~/projects/SmartFarm/
```

**Hoặc dùng WinSCP (Windows):**
1. Kết nối đến VPS: `173.249.48.25`
2. Upload file `smartfarm-export.sql` vào `/root/projects/SmartFarm/`

### Bước 3: Import Database Lên VPS

**Trên VPS:**

```bash
cd ~/projects/SmartFarm

# Pull latest code (có script import)
git pull origin main

# Chạy script import
chmod +x import-to-vps.sh
./import-to-vps.sh smartfarm-export.sql
```

**Hoặc import thủ công:**

```bash
# Lấy database container
DB_CONTAINER=$(docker compose ps -q postgres)

# Terminate connections
docker exec $DB_CONTAINER psql -U postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'smartfarm' AND pid <> pg_backend_pid();
"

# Drop và tạo lại database
docker exec $DB_CONTAINER psql -U postgres -c "DROP DATABASE IF EXISTS smartfarm;"
docker exec $DB_CONTAINER psql -U postgres -c "CREATE DATABASE smartfarm;"

# Import
docker exec -i $DB_CONTAINER psql -U postgres -d smartfarm < smartfarm-export.sql
```

### Bước 4: Restart Backend

**Trên VPS:**

```bash
docker compose restart backend
```

### Bước 5: Kiểm Tra

1. **Test login:** `http://173.249.48.25/login`
2. **Check Dashboard:** `http://173.249.48.25/dashboard`
3. **Verify data:**
   ```bash
   docker exec $(docker compose ps -q postgres) psql -U postgres -d smartfarm -c "
   SELECT 'Accounts:' as info, COUNT(*) as count FROM account
   UNION ALL
   SELECT 'Farms:', COUNT(*) FROM \"Farm\"
   UNION ALL
   SELECT 'Fields:', COUNT(*) FROM \"Field\"
   UNION ALL
   SELECT 'Sensors:', COUNT(*) FROM \"Sensor\";
   "
   ```

## 📝 Lưu Ý

- **Database name:** Đảm bảo tên database trên VPS khớp với local (thường là `smartfarm`)
- **File size:** Nếu file SQL lớn, có thể mất vài phút để upload/import
- **Backup:** Nên backup database trên VPS trước khi import:
  ```bash
  docker exec $(docker compose ps -q postgres) pg_dump -U postgres -d smartfarm > backup-before-import.sql
  ```

## 🔍 Troubleshooting

### Lỗi: "database does not exist"
```bash
# Tạo database trước
docker exec $(docker compose ps -q postgres) psql -U postgres -c "CREATE DATABASE smartfarm;"
```

### Lỗi: "permission denied"
```bash
# Kiểm tra quyền file
chmod 644 smartfarm-export.sql
```

### Lỗi: "connection refused"
```bash
# Kiểm tra PostgreSQL container
docker compose ps postgres
docker compose logs postgres
```

---

**Chúc bạn import thành công! 🎉**

