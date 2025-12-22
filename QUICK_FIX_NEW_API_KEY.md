# 🚀 Quick Fix - API Key Mới

## ⚠️ QUAN TRỌNG: API Key đã bị leak trên Git!

**API key trong file này đã bị GitHub phát hiện và đánh dấu là leaked.**
**Cần tạo API key MỚI và KHÔNG commit lên Git!**

## Các bước fix:

## Các bước fix:

### Bước 1: Đảm bảo API key mới trong file .env

```bash
cd /opt/SmartFarm

# Kiểm tra
cat .env | grep GOOGLE_GENAI_API_KEY

# Phải thấy: GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY_HERE

# Nếu chưa có, cập nhật:
nano .env
# Tìm và sửa: GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY_HERE
# ⚠️ KHÔNG dùng API key cũ - đã bị leak!
# Lưu: Ctrl+O, Enter, Ctrl+X
```

### Bước 2: Pull code mới (có error handling cải thiện)

```bash
git pull origin main
```

### Bước 3: Rebuild chatbot với code mới

```bash
# Stop container
docker compose stop chatbot

# Rebuild (quan trọng: để áp dụng code fix mới)
docker compose build chatbot

# Start lại
docker compose up -d chatbot
```

### Bước 4: Kiểm tra API key trong container

```bash
# Kiểm tra API key có trong container không
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY

# Phải thấy: GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY_HERE
```

### Bước 5: Kiểm tra logs

```bash
# Xem logs
docker compose logs chatbot --tail=30

# Tìm các dòng:
# ✅ API key found: AIzaSyA9...MaU (length: 39)
# ✅ Genkit đã được khởi tạo thành công
```

### Bước 6: Test chatbot

1. Mở browser: `http://109.205.180.72:9002`
2. **Hard refresh:** `Ctrl + Shift + R` (hoặc mở Incognito window)
3. Gửi câu hỏi test: "Cách trồng lúa?"
4. Kiểm tra console - không còn lỗi

## Nếu vẫn lỗi

### Kiểm tra chi tiết:

```bash
# 1. Xác nhận API key trong .env
cat .env | grep GOOGLE_GENAI_API_KEY

# 2. Xác nhận API key trong container
docker exec smartfarm-chatbot printenv GOOGLE_GENAI_API_KEY

# 3. Xem logs real-time
docker compose logs chatbot -f

# 4. Trong khi test, xem có lỗi gì không
```

### Force rebuild hoàn toàn:

```bash
cd /opt/SmartFarm

# Stop và remove
docker compose stop chatbot
docker compose rm -f chatbot

# Rebuild từ đầu
docker compose build --no-cache chatbot

# Start
docker compose up -d chatbot

# Đợi 10 giây
sleep 10

# Kiểm tra logs
docker compose logs chatbot --tail=30
```

## Lưu ý

- **Phải rebuild** container để áp dụng code fix mới (có error handling cải thiện)
- **Phải restart** container để load API key mới từ .env
- **Clear browser cache** hoặc dùng Incognito window để test
