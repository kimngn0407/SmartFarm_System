# 🔧 Sửa Lỗi 500 - Chatbot Service

## 🐛 Vấn Đề

Chatbot service trả về lỗi 500 Internal Server Error:
```
POST http://173.249.48.25:9002/ 500 (Internal Server Error)
Error generating insights: Error: An error occurred in the Server Components render.
```

**Nguyên nhân:**
- `GOOGLE_GENAI_API_KEY` chưa được cấu hình hoặc sai
- Genkit không thể kết nối đến Google AI service
- File `sample-data.xlsx` không tồn tại (đã có fallback nhưng có thể vẫn lỗi)

## ✅ Giải Pháp

### Bước 1: Lấy Google AI API Key

1. Truy cập: **https://aistudio.google.com/**
2. Đăng nhập bằng tài khoản Google
3. Click **"Get API Key"** → **"Create API Key"**
4. Copy API Key (dạng: `AIzaSy...`)

### Bước 2: Set Environment Variable trên VPS

**Option 1: Set trong docker-compose.yml (tạm thời)**

```bash
cd ~/projects/SmartFarm
nano docker-compose.yml
```

Tìm dòng:
```yaml
GOOGLE_GENAI_API_KEY: ${GOOGLE_GENAI_API_KEY:-your-api-key}
```

Thay thành:
```yaml
GOOGLE_GENAI_API_KEY: AIzaSy...  # Paste API key của bạn
```

**Option 2: Set trong .env file (khuyến nghị)**

```bash
cd ~/projects/SmartFarm
nano .env
```

Thêm dòng:
```
GOOGLE_GENAI_API_KEY=AIzaSy...  # Paste API key của bạn
```

Sau đó trong `docker-compose.yml` giữ nguyên:
```yaml
GOOGLE_GENAI_API_KEY: ${GOOGLE_GENAI_API_KEY:-your-api-key}
```

### Bước 3: Rebuild Chatbot Service

```bash
cd ~/projects/SmartFarm

# Stop chatbot
docker compose stop chatbot

# Remove old container
docker compose rm -f chatbot

# Rebuild với no cache
docker compose build --no-cache chatbot

# Start chatbot
docker compose up -d chatbot

# Kiểm tra logs
docker compose logs -f chatbot
```

### Bước 4: Kiểm Tra Logs

```bash
# Xem logs chatbot
docker compose logs chatbot | tail -50

# Tìm lỗi:
# - "API key" → Chưa set hoặc sai
# - "ENOENT" → File không tồn tại
# - "network" → Lỗi kết nối
```

## 🔍 Kiểm Tra Chi Tiết

### 1. Kiểm Tra Environment Variable

```bash
# Kiểm tra trong container
docker exec smartfarm-chatbot env | grep GOOGLE

# Kết quả mong đợi:
# GOOGLE_GENAI_API_KEY=AIzaSy...
```

### 2. Test Chatbot API Trực Tiếp

```bash
# Test từ VPS
curl -X POST http://localhost:9002/api/chat \
  -H "Content-Type: application/json" \
  -d '{"query": "Cách trồng lúa?"}'

# Hoặc test health
curl http://localhost:9002/health
```

### 3. Kiểm Tra File Data

```bash
# Kiểm tra file sample-data.xlsx có tồn tại không
docker exec smartfarm-chatbot ls -la /app/src/data/

# Kết quả mong đợi:
# sample-data.xlsx
```

## 📝 Lưu Ý

- **API Key bảo mật:** Không commit API key vào Git
- **Quota:** Google AI có quota miễn phí, có thể hết
- **Fallback:** Code đã có fallback data nếu file không tồn tại

## ✅ Kết Quả Mong Đợi

Sau khi set API key và rebuild, chatbot sẽ:
- ✅ Không còn lỗi 500
- ✅ Trả lời được câu hỏi từ user
- ✅ Logs không có lỗi API key

---

**Sau khi set GOOGLE_GENAI_API_KEY và rebuild, test lại chatbot! 🎉**

