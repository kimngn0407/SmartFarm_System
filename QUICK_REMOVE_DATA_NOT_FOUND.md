# 🚀 Quick Fix - Xóa "(không tìm thấy trong dữ liệu)"

## Vấn đề

Chatbot vẫn hiển thị "(không tìm thấy trong dữ liệu)" trong câu trả lời.

## Nguyên nhân

Code đã được sửa nhưng chưa được rebuild và deploy trên VPS.

## Giải pháp

### Bước 1: Pull code mới trên VPS

```bash
cd /opt/SmartFarm
git pull origin main
```

### Bước 2: Rebuild chatbot

```bash
# Rebuild với code mới
docker compose build chatbot

# Restart chatbot
docker compose restart chatbot

# Hoặc recreate để chắc chắn
docker compose stop chatbot
docker compose rm -f chatbot
docker compose up -d chatbot
```

### Bước 3: Kiểm tra logs

```bash
docker compose logs chatbot --tail=20

# Phải thấy:
# ✅ Genkit đã được khởi tạo thành công
```

### Bước 4: Test chatbot

1. **Mở browser mới hoặc Incognito/Private window**
   - URL: `http://109.205.180.72:9002`

2. **Hard refresh:**
   - Windows/Linux: `Ctrl + Shift + R`
   - Mac: `Cmd + Shift + R`

3. **Gửi câu hỏi test:**
   - Ví dụ: "Cách trồng lúa?"
   - Câu trả lời sẽ KHÔNG còn "(không tìm thấy trong dữ liệu)"

## Nếu vẫn thấy

### Clear browser cache hoàn toàn

**Chrome/Edge:**
1. Mở DevTools (F12)
2. Right-click vào nút Refresh
3. Chọn "Empty Cache and Hard Reload"

**Hoặc:**
1. Settings → Privacy → Clear browsing data
2. Chọn "Cached images and files"
3. Clear data

### Kiểm tra code đã được deploy chưa

```bash
# Kiểm tra file trong container
docker exec smartfarm-chatbot cat /app/.next/server/chunks/61.js | grep -i "không tìm thấy" || echo "✅ Đã xóa"

# Nếu vẫn thấy, cần rebuild lại
docker compose build --no-cache chatbot
docker compose up -d chatbot
```

## Quick Fix (Tất cả trong một)

```bash
cd /opt/SmartFarm && \
git pull origin main && \
docker compose build chatbot && \
docker compose stop chatbot && \
docker compose rm -f chatbot && \
docker compose up -d chatbot && \
sleep 5 && \
docker compose logs chatbot --tail=20
```

Sau đó:
- Mở Incognito window
- Truy cập: `http://109.205.180.72:9002`
- Test lại
