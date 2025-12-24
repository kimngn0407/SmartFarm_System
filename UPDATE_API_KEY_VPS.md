# 🔑 Cách Sửa API Key trên VPS

## Bước 1: SSH vào VPS

```bash
ssh root@109.205.180.72
cd /opt/SmartFarm
```

## Bước 2: Kiểm tra API key hiện tại

```bash
# Xem API key hiện tại trong .env
cat .env | grep GOOGLE_GENAI_API_KEY

# Xem API key trong container (nếu đang chạy)
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY
```

## Bước 3: Sửa API key trong file .env

### Cách 1: Dùng nano (khuyến nghị)

```bash
nano .env
```

Tìm dòng:
```
GOOGLE_GENAI_API_KEY=API_KEY_CŨ
```

Sửa thành:
```
GOOGLE_GENAI_API_KEY=API_KEY_MỚI
```

**Lưu file:**
- Nhấn `Ctrl + O` (Save)
- Nhấn `Enter` (Confirm)
- Nhấn `Ctrl + X` (Exit)

### Cách 2: Dùng sed (nhanh hơn)

```bash
# Xóa dòng cũ (nếu có nhiều dòng)
sed -i '/^GOOGLE_GENAI_API_KEY=/d' .env

# Thêm API key mới
echo "GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY_HERE" >> .env
```

### Cách 3: Dùng vi/vim

```bash
vi .env
```

- Nhấn `i` để vào chế độ insert
- Tìm và sửa dòng `GOOGLE_GENAI_API_KEY`
- Nhấn `Esc` để thoát chế độ insert
- Gõ `:wq` và nhấn `Enter` để lưu và thoát

## Bước 4: Kiểm tra không có duplicate

```bash
# Kiểm tra số dòng GOOGLE_GENAI_API_KEY
cat .env | grep GOOGLE_GENAI_API_KEY | wc -l

# Phải chỉ có 1 dòng!
# Nếu có nhiều hơn 1, xóa hết và thêm lại:
sed -i '/^GOOGLE_GENAI_API_KEY=/d' .env
echo "GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY_HERE" >> .env
```

## Bước 5: Recreate container để load API key mới

⚠️ **QUAN TRỌNG:** Phải recreate container, không chỉ restart!

```bash
# Dừng container
docker compose stop chatbot

# Xóa container (không xóa image)
docker compose rm -f chatbot

# Tạo lại container với env mới
docker compose up -d chatbot

# Kiểm tra logs
docker compose logs chatbot --tail=20
```

## Bước 6: Kiểm tra API key đã được load

```bash
# 1. Kiểm tra trong container
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY

# Phải thấy: GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY_HERE

# 2. Kiểm tra logs chatbot
docker compose logs chatbot --tail=30 | grep -E "API key|Genkit"

# Phải thấy:
# ✅ API key found: AIzaSy...xxxx (length: 39)
# ✅ Genkit đã được khởi tạo thành công
```

## Bước 7: Test chatbot

1. Mở browser: http://109.205.180.72:9002
2. Gửi một câu hỏi test
3. Kiểm tra console (F12) xem còn lỗi không

## ⚠️ Lưu ý quan trọng

### ❌ SAI - Chỉ restart container:
```bash
docker compose restart chatbot
# → Container không load env mới!
```

### ✅ ĐÚNG - Recreate container:
```bash
docker compose stop chatbot
docker compose rm -f chatbot
docker compose up -d chatbot
# → Container load env mới từ .env
```

## 🔍 Troubleshooting

### Nếu API key vẫn cũ trong container:

1. **Kiểm tra duplicate trong .env:**
   ```bash
   cat .env | grep GOOGLE_GENAI_API_KEY
   # Phải chỉ có 1 dòng
   ```

2. **Kiểm tra .env có đúng format không:**
   ```bash
   # Phải là: GOOGLE_GENAI_API_KEY=API_KEY (không có dấu cách quanh =)
   cat .env | grep GOOGLE_GENAI_API_KEY
   ```

3. **Force recreate:**
   ```bash
   docker compose stop chatbot
   docker compose rm -f chatbot
   docker compose up -d --force-recreate chatbot
   ```

### Nếu vẫn lỗi "API key not configured":

1. **Kiểm tra API key có hợp lệ không:**
   - Phải bắt đầu bằng `AIzaSy`
   - Độ dài khoảng 39 ký tự
   - Không có khoảng trắng ở đầu/cuối

2. **Kiểm tra logs chi tiết:**
   ```bash
   docker compose logs chatbot -f
   ```

3. **Kiểm tra API key có bị leaked không:**
   - Nếu thấy lỗi "403 Forbidden - Your API key was reported as leaked"
   - → Cần tạo API key mới từ https://aistudio.google.com/

## 📝 Script tự động (nhanh)

Tạo file `update-api-key.sh`:

```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "❌ Usage: ./update-api-key.sh YOUR_NEW_API_KEY"
    exit 1
fi

NEW_API_KEY=$1

cd /opt/SmartFarm

# Xóa API key cũ
sed -i '/^GOOGLE_GENAI_API_KEY=/d' .env

# Thêm API key mới
echo "GOOGLE_GENAI_API_KEY=$NEW_API_KEY" >> .env

# Recreate container
docker compose stop chatbot
docker compose rm -f chatbot
docker compose up -d chatbot

# Kiểm tra
echo "✅ Đã cập nhật API key"
echo "📋 Kiểm tra:"
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY
```

**Sử dụng:**
```bash
chmod +x update-api-key.sh
./update-api-key.sh YOUR_NEW_API_KEY_HERE
```

## 🔒 Bảo mật

- ✅ **KHÔNG** commit file `.env` vào Git
- ✅ **KHÔNG** chia sẻ API key trong chat/email
- ✅ **KHÔNG** log API key ra console
- ✅ Chỉ lưu API key trong file `.env` trên VPS
