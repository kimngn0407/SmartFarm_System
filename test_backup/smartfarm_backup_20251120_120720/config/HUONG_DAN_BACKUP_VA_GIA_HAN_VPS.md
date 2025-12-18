# 💾 Hướng Dẫn Backup và Gia Hạn VPS - Không Mất Dữ Liệu

> **⚠️ QUAN TRỌNG:** Làm theo hướng dẫn này để backup toàn bộ hệ thống trước khi gia hạn VPS, tránh mất dữ liệu.

---

## 📋 Tổng Quan

Khi gia hạn VPS trên Toolowx (hoặc các nhà cung cấp khác), có thể:
- VPS bị reset về trạng thái ban đầu
- Mất toàn bộ dữ liệu và cấu hình
- Phải setup lại từ đầu

**Giải pháp:** Backup toàn bộ hệ thống trước khi gia hạn!

---

## 🚀 QUY TRÌNH BACKUP VÀ GIA HẠN

### **Bước 1: Backup Toàn Bộ Hệ Thống (TRƯỚC KHI GIA HẠN)**

#### Cách 1: Sử dụng Script Tự Động (Khuyến nghị)

```bash
# SSH vào VPS
ssh root@your-vps-ip
cd ~/projects/SmartFarm

# Chạy script backup
chmod +x backup_system.sh
./backup_system.sh
```

Script sẽ tự động backup:
- ✅ Database PostgreSQL (file .sql)
- ✅ Source code (file .tar.gz)
- ✅ Docker volumes (nếu có)
- ✅ Configuration files (docker-compose.yml, .env, nginx)
- ✅ Scripts và documentation

**Kết quả:**
- Thư mục backup: `./backups/smartfarm_backup_YYYYMMDD_HHMMSS/`
- File nén: `./backups/smartfarm_backup_YYYYMMDD_HHMMSS.tar.gz`

#### Cách 2: Backup Thủ Công

##### 1. Backup Database

```bash
# Backup database
docker-compose exec postgres pg_dump -U postgres SmartFarm1 > backup_db_$(date +%Y%m%d).sql

# Hoặc backup từ bên ngoài container
docker-compose exec -T postgres pg_dump -U postgres SmartFarm1 > backup_db_$(date +%Y%m%d).sql
```

##### 2. Backup Code

```bash
# Tạo thư mục backup
mkdir -p ~/backup_smartfarm

# Backup code (loại trừ node_modules, .git, etc.)
tar -czf ~/backup_smartfarm/source_code_$(date +%Y%m%d).tar.gz \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.venv' \
    --exclude='target' \
    --exclude='build' \
    demoSmartFarm/ J2EE_Frontend/ AI_SmartFarm_CHatbot/ RecommentCrop/ PestAndDisease/ SmartContract/
```

##### 3. Backup Configuration

```bash
# Backup docker-compose.yml và .env
cp docker-compose.yml ~/backup_smartfarm/
cp .env ~/backup_smartfarm/ 2>/dev/null || true

# Backup nginx config (nếu có)
cp -r nginx/ ~/backup_smartfarm/ 2>/dev/null || true
```

##### 4. Backup Docker Volumes (Optional)

```bash
# Backup postgres volume
docker run --rm \
    -v smartfarm_postgres_data:/data \
    -v ~/backup_smartfarm:/backup \
    alpine tar czf /backup/postgres_data_$(date +%Y%m%d).tar.gz -C /data .
```

---

### **Bước 2: Tải Backup Về Local**

**QUAN TRỌNG:** Tải file backup về máy local trước khi gia hạn VPS!

```bash
# Từ máy local (Windows/Mac/Linux)
scp root@your-vps-ip:~/projects/SmartFarm/backups/smartfarm_backup_*.tar.gz ./

# Hoặc tải thư mục backup
scp -r root@your-vps-ip:~/projects/SmartFarm/backups ./
```

**Lưu ý:**
- File backup có thể lớn (vài GB), đảm bảo có đủ dung lượng
- Nên lưu ở nhiều nơi: local, cloud (Google Drive, Dropbox), USB

---

### **Bước 3: Gia Hạn VPS**

1. Đăng nhập vào Toolowx
2. Vào phần quản lý VPS
3. Chọn gia hạn VPS
4. Thanh toán

**⚠️ LƯU Ý:**
- Sau khi gia hạn, VPS có thể bị reset
- Đảm bảo đã tải backup về local trước khi gia hạn
- Ghi lại IP mới của VPS (nếu có thay đổi)

---

### **Bước 4: Setup Lại VPS (Sau Khi Gia Hạn)**

#### 4.1. Setup Cơ Bản

```bash
# SSH vào VPS mới (hoặc VPS đã reset)
ssh root@your-vps-ip

# Cài đặt Docker và Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Cài Docker Compose
apt-get update
apt-get install -y docker-compose-plugin

# Hoặc cài Docker Compose standalone
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

#### 4.2. Upload Backup Lên VPS

```bash
# Từ máy local
scp smartfarm_backup_*.tar.gz root@your-vps-ip:~/

# Hoặc upload qua SFTP/FTP client
```

#### 4.3. Restore Hệ Thống

##### Cách 1: Sử dụng Script Tự Động

```bash
# SSH vào VPS
ssh root@your-vps-ip

# Tạo thư mục project
mkdir -p ~/projects/SmartFarm
cd ~/projects/SmartFarm

# Giải nén backup
tar -xzf ~/smartfarm_backup_*.tar.gz -C ./backups/

# Upload script restore (hoặc clone từ git)
# Chạy script restore
chmod +x restore_system.sh
./restore_system.sh smartfarm_backup_YYYYMMDD_HHMMSS
```

##### Cách 2: Restore Thủ Công

```bash
# 1. Giải nén code
cd ~/projects/SmartFarm
tar -xzf ~/backup_smartfarm/source_code_*.tar.gz

# 2. Restore configuration
cp ~/backup_smartfarm/docker-compose.yml ./
cp ~/backup_smartfarm/.env ./ 2>/dev/null || true

# 3. Khởi động PostgreSQL
docker-compose up -d postgres
sleep 10

# 4. Restore database
docker-compose exec -T postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;" 2>/dev/null || true
docker-compose exec -T postgres psql -U postgres SmartFarm1 < ~/backup_smartfarm/backup_db_*.sql

# 5. Restore volumes (nếu có)
docker-compose stop postgres
docker run --rm \
    -v smartfarm_postgres_data:/data \
    -v ~/backup_smartfarm:/backup \
    alpine tar xzf /backup/postgres_data_*.tar.gz -C /data
docker-compose up -d postgres

# 6. Build và start tất cả services
docker-compose up -d --build
```

---

## ✅ CHECKLIST TRƯỚC KHI GIA HẠN

- [ ] Đã backup database
- [ ] Đã backup source code
- [ ] Đã backup configuration files
- [ ] Đã backup docker volumes (nếu cần)
- [ ] Đã tải backup về local
- [ ] Đã lưu backup ở nhiều nơi (local, cloud, USB)
- [ ] Đã ghi lại IP VPS và thông tin đăng nhập
- [ ] Đã test restore trên môi trường test (nếu có)

---

## 🔄 SAU KHI GIA HẠN VÀ RESTORE

### Kiểm Tra Hệ Thống

```bash
# 1. Kiểm tra services đang chạy
docker-compose ps

# 2. Kiểm tra logs
docker-compose logs -f

# 3. Kiểm tra database
docker-compose exec postgres psql -U postgres -c "\l"

# 4. Kiểm tra frontend
curl http://localhost:80

# 5. Kiểm tra backend API
curl http://localhost:8080/api/alerts
```

### Cấu Hình Lại (Nếu Cần)

```bash
# Cập nhật IP trong docker-compose.yml (nếu IP thay đổi)
nano docker-compose.yml

# Cập nhật FRONTEND_ORIGINS nếu cần
# Cập nhật các biến môi trường khác

# Restart services
docker-compose restart
```

---

## 🆘 TROUBLESHOOTING

### Database không restore được

```bash
# Kiểm tra file backup có đúng không
head -20 backup_db_*.sql

# Tạo database thủ công
docker-compose exec postgres psql -U postgres -c "CREATE DATABASE SmartFarm1;"

# Restore lại
docker-compose exec -T postgres psql -U postgres SmartFarm1 < backup_db_*.sql
```

### Docker volumes không restore được

```bash
# Xóa volume cũ và tạo mới
docker volume rm smartfarm_postgres_data
docker volume create smartfarm_postgres_data

# Restore lại
docker run --rm \
    -v smartfarm_postgres_data:/data \
    -v $(pwd):/backup \
    alpine tar xzf /backup/postgres_data_*.tar.gz -C /data
```

### Services không start

```bash
# Kiểm tra logs
docker-compose logs backend
docker-compose logs postgres

# Rebuild từ đầu
docker-compose down
docker-compose up -d --build
```

---

## 💡 LƯU Ý QUAN TRỌNG

1. **Backup thường xuyên:** Nên backup định kỳ (hàng tuần/tháng)
2. **Test restore:** Nên test restore trên môi trường test trước
3. **Lưu nhiều nơi:** Backup ở local, cloud, và USB
4. **Ghi lại thông tin:** IP, password, cấu hình quan trọng
5. **Kiểm tra dung lượng:** Đảm bảo có đủ dung lượng để backup

---

## 📞 HỖ TRỢ

Nếu gặp vấn đề:
1. Kiểm tra logs: `docker-compose logs -f`
2. Kiểm tra file backup có đầy đủ không
3. Thử restore từng phần (database, code, config riêng biệt)

---

**Chúc bạn backup và restore thành công! 🎉**

