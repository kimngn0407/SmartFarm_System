# Hướng dẫn Deploy SmartFarm lên VPS

## Yêu cầu hệ thống

- VPS với Ubuntu 20.04+ hoặc tương đương
- Docker và Docker Compose đã được cài đặt
- Tối thiểu 4GB RAM, 20GB disk space
- Ports cần mở: 80, 443, 8080, 5000, 5001, 9002, 5432

## Bước 1: Cài đặt Docker và Docker Compose (nếu chưa có)

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Cài đặt Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Thêm user vào docker group (để không cần sudo)
sudo usermod -aG docker $USER

# Cài đặt Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Logout và login lại để áp dụng thay đổi
```

## Bước 2: Upload code lên VPS

### Cách 1: Sử dụng Git (khuyến nghị)

```bash
# Trên VPS
cd ~
git clone <your-repo-url> SmartFarm
cd SmartFarm
```

### Cách 2: Sử dụng SCP/SFTP

```bash
# Từ máy local
scp -r SmartFarm user@173.249.48.25:~/
```

## Bước 3: Cấu hình Environment Variables

Tạo file `.env` trong thư mục gốc (nếu cần thay đổi mặc định):

```bash
cd ~/SmartFarm
nano .env
```

Nội dung `.env` (tùy chọn - có thể dùng giá trị mặc định):

```env
# Database
POSTGRES_DB=SmartFarm1
POSTGRES_USER=postgres
POSTGRES_PASSWORD=Ngan0407@!

# JWT
JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRATION=86400000

# Frontend Origins (thêm domain của bạn nếu có)
FRONTEND_ORIGINS=http://173.249.48.25,http://173.249.48.25:80,http://localhost:3000,http://localhost:80

# Google GenAI API Key (cho chatbot)
GOOGLE_GENAI_API_KEY=your-api-key
```

## Bước 4: Deploy

### Cách 1: Sử dụng script tự động (khuyến nghị)

```bash
cd ~/SmartFarm
chmod +x deploy.sh
./deploy.sh
```

### Cách 2: Deploy thủ công

```bash
cd ~/SmartFarm

# Dừng containers cũ (nếu có)
docker-compose down

# Build và start
docker-compose build
docker-compose up -d

# Xem logs
docker-compose logs -f
```

## Bước 5: Kiểm tra

### Kiểm tra các services đang chạy

```bash
docker-compose ps
```

### Kiểm tra logs

```bash
# Xem tất cả logs
docker-compose logs -f

# Xem logs của từng service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres
```

### Kiểm tra health

```bash
# Backend
curl http://localhost:8080/actuator/health

# Frontend
curl http://localhost/

# Crop Service
curl http://localhost:5000/health

# Pest Service
curl http://localhost:5001/health
```

## Bước 6: Truy cập ứng dụng

- **Frontend**: http://173.249.48.25
- **Backend API**: http://173.249.48.25:8080
- **Chatbot**: http://173.249.48.25:9002

## Các lệnh hữu ích

### Xem logs real-time
```bash
docker-compose logs -f [service_name]
```

### Restart một service
```bash
docker-compose restart [service_name]
```

### Dừng tất cả services
```bash
docker-compose down
```

### Dừng và xóa volumes (xóa database)
```bash
docker-compose down -v
```

### Rebuild một service cụ thể
```bash
docker-compose build [service_name]
docker-compose up -d [service_name]
```

### Xem resource usage
```bash
docker stats
```

## Troubleshooting

### Lỗi: Port đã được sử dụng

```bash
# Kiểm tra port nào đang được sử dụng
sudo netstat -tulpn | grep :8080

# Hoặc
sudo lsof -i :8080

# Dừng process đang sử dụng port
sudo kill -9 <PID>
```

### Lỗi: Database connection failed

```bash
# Kiểm tra PostgreSQL container
docker-compose logs postgres

# Restart PostgreSQL
docker-compose restart postgres
```

### Lỗi: Frontend không load được

```bash
# Kiểm tra frontend logs
docker-compose logs frontend

# Rebuild frontend
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

### Lỗi: Out of memory

```bash
# Xem memory usage
docker stats

# Tăng swap space (nếu cần)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Xóa tất cả và deploy lại từ đầu

```bash
docker-compose down -v
docker system prune -a
./deploy.sh
```

## Cập nhật code mới

```bash
cd ~/SmartFarm

# Pull code mới (nếu dùng Git)
git pull

# Rebuild và restart
docker-compose build
docker-compose up -d

# Hoặc chỉ rebuild service thay đổi
docker-compose build frontend
docker-compose up -d frontend
```

## Backup Database

```bash
# Backup
docker exec smartfarm-postgres pg_dump -U postgres SmartFarm1 > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore
docker exec -i smartfarm-postgres psql -U postgres SmartFarm1 < backup_20240101_120000.sql
```

## Monitoring

### Xem resource usage
```bash
docker stats
```

### Xem disk usage
```bash
docker system df
```

### Clean up unused resources
```bash
docker system prune -a
```

