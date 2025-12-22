# 🔧 Fix Chatbot - API Key Bị Leaked

## Vấn đề

Lỗi từ Google API:
```
[403 Forbidden] Your API key was reported as leaked. Please use another API key.
```

**Nguyên nhân:** API key đã bị Google đánh dấu là "leaked" (bị lộ) vì có thể đã được commit lên Git hoặc public ở đâu đó.

## Giải pháp

### Bước 1: Tạo API key mới

1. **Truy cập Google AI Studio:**
   - URL: https://aistudio.google.com/
   - Đăng nhập với Google account

2. **Tạo API key mới:**
   - Vào **Get API Key** hoặc **API Keys**
   - Click **Create API Key**
   - Chọn project hoặc tạo project mới
   - Copy API key mới

3. **Lưu ý:**
   - ⚠️ **KHÔNG commit API key lên Git**
   - ⚠️ **Chỉ set trong file .env trên VPS**
   - ⚠️ **Không share API key công khai**

### Bước 2: Cập nhật API key trên VPS

```bash
cd /opt/SmartFarm

# 1. Backup file .env cũ (nếu cần)
cp .env .env.backup

# 2. Cập nhật API key mới
nano .env

# Tìm dòng:
# GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw

# Thay bằng API key mới:
# GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY_HERE

# Lưu: Ctrl+O, Enter, Ctrl+X
```

### Bước 3: Restart chatbot

```bash
# Restart để load API key mới
docker compose restart chatbot

# Kiểm tra logs
docker compose logs chatbot --tail=20

# Phải thấy:
# ✅ API key found: ...
# ✅ Genkit đã được khởi tạo thành công
```

### Bước 4: Test chatbot

1. Mở browser: `http://109.205.180.72:9002`
2. Gửi câu hỏi test
3. Kiểm tra console - không còn lỗi 403

## Nếu vẫn lỗi

### Kiểm tra API key có đúng không

```bash
# Kiểm tra API key trong container
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY

# Phải thấy API key mới (không phải key cũ)
```

### Revoke API key cũ (nếu cần)

1. Vào Google AI Studio: https://aistudio.google.com/
2. Vào **API Keys**
3. Tìm API key cũ và **Delete** hoặc **Revoke**

## Lưu ý quan trọng

1. **API key mới phải được giữ bí mật**
2. **Không commit .env lên Git** (đã có trong .gitignore)
3. **Nếu API key bị leaked lại, cần tạo key mới**

## Quick Fix

```bash
cd /opt/SmartFarm

# 1. Cập nhật API key mới trong .env
nano .env
# Sửa: GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY

# 2. Restart chatbot
docker compose restart chatbot

# 3. Kiểm tra
docker compose logs chatbot --tail=20 | grep -E "(API|Genkit|✅|❌)"
```
