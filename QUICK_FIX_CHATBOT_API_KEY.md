# 🚀 Quick Fix Chatbot API Key - VPS

## Vấn đề

Lỗi: `API_KEY_NOT_CONFIGURED` - API key không được load vào container

## Giải pháp nhanh

### Bước 1: Pull code mới và kiểm tra

```bash
cd /opt/SmartFarm
git pull origin main
```

### Bước 2: Kiểm tra API key trong container

```bash
# Kiểm tra env var trong container
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY
```

**Kết quả mong đợi:**
```
GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw
```

**Nếu không thấy hoặc là `your-api-key`:**

```bash
# 1. Kiểm tra file .env
cat .env | grep GOOGLE_GENAI_API_KEY

# 2. Nếu chưa có, thêm vào
echo "GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw" >> .env

# 3. Restart container để load env var mới
docker compose restart chatbot

# 4. Kiểm tra lại
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY
```

### Bước 3: Rebuild chatbot với code mới

```bash
# Rebuild để áp dụng code fix mới
docker compose build chatbot

# Restart
docker compose up -d chatbot
```

### Bước 4: Kiểm tra logs

```bash
# Xem logs để kiểm tra
docker compose logs chatbot --tail=100

# Tìm các dòng:
# ✅ "API key found: AIzaSyCHb8..." - OK
# ✅ "Genkit đã được khởi tạo thành công" - OK
# ❌ "API key không tìm thấy" - Cần restart container
```

### Bước 5: Test chatbot

1. Mở browser: `http://109.205.180.72:9002`
2. Gửi một câu hỏi test
3. Kiểm tra console - không còn lỗi `API_KEY_NOT_CONFIGURED`

## Nếu vẫn lỗi

### Force rebuild hoàn toàn

```bash
cd /opt/SmartFarm

# Stop và remove container
docker compose stop chatbot
docker compose rm -f chatbot

# Rebuild từ đầu
docker compose build --no-cache chatbot

# Start lại
docker compose up -d chatbot

# Kiểm tra logs
docker compose logs chatbot --tail=100 | grep -i "api\|genkit\|key"
```

### Kiểm tra chi tiết

```bash
# Chạy script kiểm tra
chmod +x check-chatbot-env.sh
./check-chatbot-env.sh

# Xem logs real-time
docker compose logs chatbot -f
```

## Lưu ý

- **Sau khi sửa .env, PHẢI restart container**
- **Sau khi pull code mới, PHẢI rebuild container**
- **API key phải được set trong .env trên VPS**
