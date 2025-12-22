# 🔧 Fix Lỗi Chatbot - Server Components Render Error

## Vấn đề

Chatbot hiển thị lỗi: **"An error occurred in the Server Components render"**

## Nguyên nhân

1. **API key chưa được cấu hình**: `GOOGLE_GENAI_API_KEY` chưa được set hoặc là placeholder `your-api-key`
2. **Lỗi khởi tạo genkit**: Genkit không thể khởi tạo với API key không hợp lệ
3. **Lỗi trong Server Action**: Flow `generateInsightsFromExcel` throw error khi render

## Giải pháp đã áp dụng

### 1. Cải thiện Error Handling trong `genkit.ts`

- Thêm try-catch khi khởi tạo genkit
- Tạo fallback instance nếu khởi tạo thất bại
- Không throw error khi khởi tạo, để app vẫn chạy được

### 2. Thêm Error Boundaries

- **`error.tsx`**: Bắt lỗi trong route/page
- **`global-error.tsx`**: Bắt lỗi toàn cục

### 3. Cải thiện Error Messages

- Thêm `digest` vào error để Next.js hiển thị tốt hơn
- Error messages rõ ràng hơn cho user

## Các bước kiểm tra và sửa

### Bước 1: Kiểm tra API Key trên VPS

```bash
# SSH vào VPS
ssh root@109.205.180.72

# Kiểm tra file .env
cd /opt/SmartFarm
cat .env | grep GOOGLE_GENAI_API_KEY
```

**Nếu chưa có hoặc là `your-api-key`**, cần cập nhật:

```bash
# Mở file .env
nano .env

# Tìm dòng GOOGLE_GENAI_API_KEY và cập nhật:
GOOGLE_GENAI_API_KEY=your-actual-api-key-here

# Lưu: Ctrl+O, Enter, Ctrl+X
```

### Bước 2: Lấy Google Gemini API Key

1. Truy cập: https://aistudio.google.com/
2. Đăng nhập với Google account
3. Vào **Get API Key**
4. Tạo API key mới hoặc copy API key có sẵn
5. Copy và paste vào file `.env`

### Bước 3: Rebuild và restart chatbot

```bash
cd /opt/SmartFarm

# Pull code mới (nếu đã commit)
git pull origin main

# Rebuild chatbot
docker compose build chatbot

# Restart chatbot
docker compose up -d chatbot

# Xem logs để kiểm tra
docker compose logs chatbot --tail=50
```

### Bước 4: Kiểm tra logs

```bash
# Xem logs chatbot
docker compose logs chatbot --tail=100

# Tìm các dòng:
# ✅ "Genkit đã được khởi tạo thành công" - OK
# ❌ "GOOGLE_GENAI_API_KEY chưa được cấu hình" - Cần set API key
# ❌ "Lỗi khởi tạo genkit" - API key không hợp lệ
```

### Bước 5: Test chatbot

1. Mở browser: `http://109.205.180.72:9002`
2. Gửi một câu hỏi test
3. Kiểm tra xem có lỗi không

## Nếu vẫn còn lỗi

### Kiểm tra API key có hợp lệ không

```bash
# Test API key từ VPS
curl -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Hello"}]}]}' \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=YOUR_API_KEY"
```

Thay `YOUR_API_KEY` bằng API key thực tế.

### Kiểm tra network connectivity

```bash
# Test kết nối đến Google API
curl -I https://generativelanguage.googleapis.com
```

### Xem logs chi tiết

```bash
# Xem logs real-time
docker compose logs chatbot -f

# Trong khi test, gửi một câu hỏi và xem logs
```

## Lưu ý

- API key phải được set trong file `.env` trên VPS
- Sau khi cập nhật `.env`, cần **restart chatbot container** để áp dụng thay đổi
- API key không được commit lên Git (đã có trong `.gitignore`)
- Nếu API key hết hạn hoặc bị revoke, cần tạo key mới

## Commit và Deploy fix

```bash
# Trên máy local
cd E:\SmartFarm

# Add các file đã sửa
git add AI_SmartFarm_CHatbot/src/ai/genkit.ts
git add AI_SmartFarm_CHatbot/src/app/error.tsx
git add AI_SmartFarm_CHatbot/src/app/global-error.tsx
git add AI_SmartFarm_CHatbot/src/ai/flows/generate-insights-from-excel.ts

# Commit
git commit -m "Fix: Cải thiện error handling cho Chatbot - Server Components render error"

# Push
git push origin main
```

```bash
# Trên VPS
cd /opt/SmartFarm

# Pull code mới
git pull origin main

# Rebuild và restart chatbot
docker compose build chatbot
docker compose up -d chatbot

# Kiểm tra
docker compose logs chatbot --tail=50
```
