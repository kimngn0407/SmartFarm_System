# 📥 Import DB_SM_ver1.sql Lên VPS

## 📋 File Database

File `DB_SM_ver1.sql` chứa đầy đủ dữ liệu:
- ✅ Accounts (13 accounts)
- ✅ Farms (3 farms)
- ✅ Fields (6 fields)
- ✅ Sensors (10 sensors)
- ✅ Sensor Data (326 records)
- ✅ Plants (6 plants)
- ✅ Crop Seasons (84 records)
- ✅ Alerts, Harvest, Irrigation History, etc.

## 🔄 Quy Trình Import

### Bước 1: Upload File Lên VPS

**Trên máy local:**

**Windows (PowerShell):**
```powershell
# Sử dụng SCP
scp DB_SM_ver1.sql root@173.249.48.25:~/projects/SmartFarm/
```

**Hoặc dùng WinSCP:**
1. Kết nối đến VPS: `173.249.48.25`
2. Upload file `DB_SM_ver1.sql` vào `/root/projects/SmartFarm/`

### Bước 2: Import Database

**Trên VPS:**
```bash
cd ~/projects/SmartFarm

# Pull latest code (có script import)
git pull origin main

# Chạy script import
chmod +x import-DB_SM_ver1.sh
./import-DB_SM_ver1.sh
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

# Drop và tạo lại
docker exec $DB_CONTAINER psql -U postgres -c "DROP DATABASE IF EXISTS smartfarm;"
docker exec $DB_CONTAINER psql -U postgres -c "CREATE DATABASE smartfarm;"

# Import
docker exec -i $DB_CONTAINER psql -U postgres -d smartfarm < DB_SM_ver1.sql
```

### Bước 3: Restart Backend

**Trên VPS:**
```bash
docker compose restart backend
```

### Bước 4: Kiểm Tra

1. **Test login:** `http://173.249.48.25/login`
   - Email: `admin@smartfarm.com` hoặc `admin.nguyen@smartfarm.com`
   - Password: `admin123` (có thể cần reset password)
2. **Check Dashboard:** `http://173.249.48.25/dashboard`
   - Sẽ thấy 3 Farms, 6 Fields, 10 Sensors
3. **Verify data:**
   ```bash
   docker exec $(docker compose ps -q postgres) psql -U postgres -d smartfarm -c "
   SELECT 'Accounts:' as info, COUNT(*) as count FROM account
   UNION ALL
   SELECT 'Farms:', COUNT(*) FROM farm
   UNION ALL
   SELECT 'Fields:', COUNT(*) FROM field
   UNION ALL
   SELECT 'Sensors:', COUNT(*) FROM sensor;
   "
   ```

## 📝 Lưu Ý

- **Database name:** Script sẽ tự động detect hoặc tạo database `smartfarm`
- **Backup:** Script sẽ tự động backup database hiện tại trước khi import
- **Password:** Một số accounts có password đã được hash, có thể cần reset
- **File size:** File có thể lớn, import có thể mất vài phút

## 🔍 Accounts Trong Database

Từ `DB_SM_ver1.sql`:
- `admin@smartfarm.com` (id: 44) - ADMIN
- `admin.nguyen@smartfarm.com` (id: 49) - ADMIN
- `test@test.com` (id: 46) - ADMIN
- `admin@example.com` (id: 1) - FARMER (nhưng có role ADMIN trong account_roles)

## 🔧 Reset Password Nếu Cần

Nếu không đăng nhập được, reset password:
```bash
# Reset password cho admin@smartfarm.com (BCrypt hash của "admin123")
docker exec $(docker compose ps -q postgres) psql -U postgres -d smartfarm -c "
UPDATE account 
SET password = '\$2a\$10\$XWiyRvBz/hLjXss0J9Nva.OQBMV8IclmnMX3sVY5ZS6VOPOTFz.nO' 
WHERE email = 'admin@smartfarm.com';
"
```

---

**Chúc bạn import thành công! 🎉**

