# 🚀 Quick Fix Chatbot - Deploy Code Mới

## API Key đã được cấu hình ✅

API key đã có trên VPS:
```
GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw
```

## Các lỗi đã được sửa ✅

1. ✅ **MutationObserver error**: Sửa script trong `layout.tsx` để kiểm tra body tồn tại trước khi observe
2. ✅ **Server Components render error**: Lazy load AI flow và prompt để tránh lỗi khi import module
3. ✅ **Error handling**: Cải thiện error handling trong genkit initialization

## Các bước deploy fix

### Bước 1: Pull code mới

```bash
cd /opt/SmartFarm
git pull origin main
```

### Bước 2: Rebuild chatbot với code mới

```bash
docker compose build chatbot
```

### Bước 3: Restart chatbot

```bash
docker compose up -d chatbot
```

### Bước 4: Kiểm tra logs

```bash
# Xem logs để kiểm tra
docker compose logs chatbot --tail=50

# Tìm các dòng:
# ✅ "Genkit đã được khởi tạo thành công" - OK
# ✅ "✅ Genkit đã được khởi tạo thành công" - OK
```

### Bước 6: Test chatbot

1. Mở browser: `http://109.205.180.72:9002`
2. Gửi một câu hỏi test (ví dụ: "Cách trồng lúa?")
3. Kiểm tra xem có còn lỗi không
4. **Kiểm tra console**: Không còn lỗi MutationObserver

## Nếu vẫn còn lỗi

### Kiểm tra logs chi tiết

```bash
# Xem logs real-time
docker compose logs chatbot -f

# Trong khi test, gửi một câu hỏi và xem logs
```

### Kiểm tra container status

```bash
docker compose ps chatbot
```

### Restart toàn bộ services (nếu cần)

```bash
docker compose restart chatbot
```

## Lưu ý

- Sau khi pull code, **phải rebuild** chatbot để áp dụng code mới
- API key đã được cấu hình đúng, không cần thay đổi
- Nếu vẫn lỗi, kiểm tra logs để xem chi tiết lỗi
