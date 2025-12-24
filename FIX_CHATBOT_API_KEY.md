# 🔧 Fix Chatbot - API Key Not Configured

## Vấn đề

Lỗi: `API_KEY_NOT_CONFIGURED` - API key không được load vào container

## Nguyên nhân

Environment variable `GOOGLE_GENAI_API_KEY` không được pass vào container đúng cách, hoặc container chưa được restart sau khi set env var.

## Giải pháp

### Bước 1: Kiểm tra file .env trên VPS

```bash
cd /opt/SmartFarm
cat .env | grep GOOGLE_GENAI_API_KEY
```

**Phải thấy:**
```
GOOGLE_GENAI_API_KEY=YOUR_API_KEY_HERE
```

**Nếu không có hoặc là `your-api-key`**, cần cập nhật:

```bash
nano .env
# Tìm và sửa:
GOOGLE_GENAI_API_KEY=YOUR_API_KEY_HERE
# Lưu: Ctrl+O, Enter, Ctrl+X
```

### Bước 2: Kiểm tra environment variable trong container

```bash
# Kiểm tra env var trong container
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY
```

**Nếu không thấy hoặc là `your-api-key`**, cần restart container:

```bash
# Restart để load env var mới
docker compose restart chatbot

# Hoặc rebuild nếu cần
docker compose build chatbot
docker compose up -d chatbot
```

### Bước 3: Kiểm tra lại

```bash
# Chạy script kiểm tra
chmod +x check-chatbot-env.sh
./check-chatbot-env.sh
```

### Bước 4: Xem logs để xác nhận

```bash
docker compose logs chatbot --tail=50 | grep -E "(Genkit|API|key)"
```

**Phải thấy:**
```
✅ Genkit đã được khởi tạo thành công
```

**Nếu thấy:**
```
⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình
❌ GOOGLE_GENAI_API_KEY chưa được cấu hình!
```

→ Cần kiểm tra lại bước 1 và 2.

## Nếu vẫn không hoạt động

### Kiểm tra docker-compose.yml

```bash
cat docker-compose.yml | grep -A 10 "chatbot:" | grep GOOGLE_GENAI_API_KEY
```

**Phải thấy:**
```yaml
GOOGLE_GENAI_API_KEY: ${GOOGLE_GENAI_API_KEY:-your-api-key}
```

### Force rebuild và restart

```bash
cd /opt/SmartFarm

# Stop container
docker compose stop chatbot

# Remove container
docker compose rm -f chatbot

# Rebuild
docker compose build --no-cache chatbot

# Start với env vars mới
docker compose up -d chatbot

# Kiểm tra logs
docker compose logs chatbot --tail=50
```

### Kiểm tra network và connectivity

```bash
# Test API key từ trong container
docker exec smartfarm-chatbot sh -c 'echo $GOOGLE_GENAI_API_KEY'

# Nếu thấy API key, test kết nối
docker exec smartfarm-chatbot sh -c 'curl -I https://generativelanguage.googleapis.com'
```

## Lưu ý quan trọng

1. **Sau khi sửa .env, PHẢI restart container** để load env var mới
2. **Không commit .env lên Git** (đã có trong .gitignore)
3. **API key phải được set trong .env trên VPS**, không phải trong code
4. **Nếu rebuild, env vars từ .env sẽ được load tự động**

## Quick Fix Command

```bash
cd /opt/SmartFarm

# 1. Đảm bảo .env có API key
echo "GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw" >> .env

# 2. Restart container
docker compose restart chatbot

# 3. Kiểm tra
docker compose logs chatbot --tail=20 | grep -i "genkit\|api"
```


