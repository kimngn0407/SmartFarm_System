# 🚀 Start Chatbot Container

## Vấn đề

Chatbot container không chạy sau khi `docker compose up`

## Giải pháp

### Bước 1: Kiểm tra trạng thái chatbot

```bash
cd /opt/SmartFarm

# Kiểm tra container có tồn tại không
docker ps -a | grep chatbot

# Hoặc chạy script kiểm tra
chmod +x check-chatbot-status.sh
./check-chatbot-status.sh
```

### Bước 2: Start chatbot

```bash
# Start chatbot container
docker compose up -d chatbot

# Hoặc start tất cả services (nếu chưa start)
docker compose up -d
```

### Bước 3: Kiểm tra logs

```bash
# Xem logs để kiểm tra
docker compose logs chatbot --tail=50

# Xem logs real-time
docker compose logs chatbot -f
```

### Bước 4: Kiểm tra status

```bash
# Kiểm tra container đang chạy
docker compose ps chatbot

# Hoặc
docker ps | grep chatbot
```

## Nếu chatbot không start được

### Kiểm tra lỗi build

```bash
# Xem logs build
docker compose logs chatbot --tail=100

# Rebuild chatbot
docker compose build chatbot

# Start lại
docker compose up -d chatbot
```

### Kiểm tra port conflict

```bash
# Kiểm tra port 9002 có đang được dùng không
netstat -tuln | grep 9002
# hoặc
ss -tuln | grep 9002

# Nếu có process khác đang dùng port, cần stop nó
```

### Force rebuild và start

```bash
cd /opt/SmartFarm

# Stop và remove container
docker compose stop chatbot
docker compose rm -f chatbot

# Rebuild
docker compose build --no-cache chatbot

# Start
docker compose up -d chatbot

# Kiểm tra
docker compose ps chatbot
docker compose logs chatbot --tail=50
```

## Kiểm tra nhanh

```bash
# Tất cả trong một lệnh
cd /opt/SmartFarm && \
docker compose ps chatbot && \
docker compose logs chatbot --tail=20
```

## Lưu ý

- Chatbot có thể mất thời gian để build (đặc biệt lần đầu)
- Kiểm tra logs để xem có lỗi gì không
- Port 9002 phải available
