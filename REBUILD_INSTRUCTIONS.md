# Hướng dẫn Rebuild SmartFarm

## Trên VPS (Linux)

### Option 1: Rebuild tất cả (Docker + Python .venv)

```bash
cd ~/projects/SmartFarm
chmod +x rebuild.sh
./rebuild.sh
```

Script này sẽ:
- Dừng và xóa các Docker containers cũ
- Build lại tất cả Docker images (no-cache)
- Tạo lại tất cả Python virtual environments (.venv)
- Khởi động lại các services
- Kiểm tra health của các services

### Option 2: Chỉ rebuild Python .venv (không rebuild Docker)

```bash
cd ~/projects/SmartFarm
chmod +x rebuild_venv.sh
./rebuild_venv.sh
```

Script này chỉ tạo lại các Python virtual environments:
- `SmartContract/flask-api/.venv`
- `SmartContract/device/venv`
- `RecommentCrop/.venv`
- `PestAndDisease/.venv`

### Option 3: Rebuild Docker thủ công

```bash
cd ~/projects/SmartFarm

# Dừng containers
docker-compose down

# Build lại (no-cache)
docker-compose build --no-cache

# Khởi động lại
docker-compose up -d

# Xem logs
docker-compose logs -f
```

### Option 4: Rebuild từng service Docker

```bash
cd ~/projects/SmartFarm

# Rebuild một service cụ thể
docker-compose build --no-cache [service_name]

# Restart service
docker-compose up -d [service_name]

# Ví dụ:
docker-compose build --no-cache backend
docker-compose up -d backend
```

## Trên Local (Windows)

### Rebuild Python .venv

#### Flask API:
```cmd
cd SmartContract\flask-api
rmdir /s /q .venv
python -m venv .venv
.venv\Scripts\activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate
```

#### Device Forwarder:
```cmd
cd SmartContract\device
rmdir /s /q venv
python -m venv venv
venv\Scripts\activate
pip install --upgrade pip
pip install pyserial requests
deactivate
```

## Kiểm tra sau khi rebuild

### Kiểm tra Docker containers:
```bash
docker-compose ps
docker-compose logs -f [service_name]
```

### Kiểm tra Python services:
```bash
# Flask API
cd SmartContract/flask-api
source .venv/bin/activate
python -c "import flask; print('Flask OK')"
deactivate

# Device Forwarder
cd SmartContract/device
source venv/bin/activate
python -c "import serial; print('Serial OK')"
deactivate
```

### Kiểm tra health endpoints:
```bash
# Backend
curl http://localhost:8080/actuator/health

# Crop Service
curl http://localhost:5000/health

# Pest Service
curl http://localhost:5001/health

# Frontend
curl http://localhost/
```

## Troubleshooting

### Nếu Docker build fail:
1. Kiểm tra logs: `docker-compose logs [service_name]`
2. Xóa cache: `docker system prune -a`
3. Build lại từng service một

### Nếu Python .venv fail:
1. Kiểm tra Python version: `python3 --version` (cần >= 3.8)
2. Kiểm tra pip: `pip --version`
3. Cài đặt dependencies thủ công từ requirements.txt

### Nếu services không start:
1. Kiểm tra ports đã được sử dụng: `netstat -tulpn | grep [port]`
2. Kiểm tra logs: `docker-compose logs -f`
3. Kiểm tra database connection

