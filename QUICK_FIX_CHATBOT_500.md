# 🚨 Quick Fix - Chatbot 500 Error

## Bước 1: Kiểm tra Logs trên VPS

```bash
ssh root@109.205.180.72
cd /opt/SmartFarm

# Xem logs chatbot
docker compose logs chatbot --tail=50
```

## Bước 2: Xác định nguyên nhân

### Nếu thấy lỗi "leaked" hoặc "403 Forbidden":
```
[403 Forbidden] Your API key was reported as leaked. Please use another API key.
```

**→ API key đã bị Google đánh dấu là leaked**

**Giải pháp:**
1. Tạo API key mới từ https://aistudio.google.com/
2. Cập nhật trong `.env`:
   ```bash
   # Xóa dòng cũ (nếu có nhiều dòng)
   sed -i '/GOOGLE_GENAI_API_KEY/d' .env
   
   # Thêm API key mới
   echo "GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY" >> .env
   ```
3. **Recreate container** (quan trọng!):
   ```bash
   docker compose stop chatbot
   docker compose rm -f chatbot
   docker compose up -d chatbot
   ```
4. Kiểm tra:
   ```bash
   docker compose logs chatbot --tail=20
   # Phải thấy: ✅ API key found: ...
   # Phải thấy: ✅ Genkit đã được khởi tạo thành công
   ```

### Nếu thấy lỗi "API_KEY_NOT_CONFIGURED":
```
⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình!
```

**Giải pháp:**
1. Kiểm tra `.env`:
   ```bash
   cat .env | grep GOOGLE_GENAI_API_KEY
   ```
2. Nếu không có hoặc là placeholder, thêm API key:
   ```bash
   echo "GOOGLE_GENAI_API_KEY=YOUR_API_KEY" >> .env
   ```
3. Recreate container:
   ```bash
   docker compose stop chatbot
   docker compose rm -f chatbot
   docker compose up -d chatbot
   ```

### Nếu thấy lỗi khác:
- Kiểm tra logs chi tiết:
  ```bash
  docker compose logs chatbot -f
  ```
- Kiểm tra container status:
  ```bash
  docker compose ps chatbot
  ```

## Bước 3: Test lại

1. Mở browser: http://109.205.180.72:9002
2. Gửi một câu hỏi test
3. Kiểm tra console (F12) xem còn lỗi không

## Script tự động kiểm tra

```bash
# Chạy script kiểm tra
chmod +x check-chatbot-error.sh
./check-chatbot-error.sh
```

## Lưu ý quan trọng

⚠️ **Khi update API key, PHẢI recreate container**, không chỉ restart:
```bash
# ❌ SAI - restart không load env mới
docker compose restart chatbot

# ✅ ĐÚNG - recreate để load env mới
docker compose stop chatbot
docker compose rm -f chatbot
docker compose up -d chatbot
```

## Nếu vẫn lỗi

1. Kiểm tra duplicate API key trong `.env`:
   ```bash
   cat .env | grep GOOGLE_GENAI_API_KEY
   # Nếu có nhiều dòng, xóa hết và thêm lại 1 dòng
   ```

2. Kiểm tra API key trong container:
   ```bash
   docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY
   # Phải khớp với .env
   ```

3. Xem logs chi tiết:
   ```bash
   docker compose logs chatbot -f
   ```
