# 🔧 Fix API Key Trong Container

## Vấn đề

Container vẫn đang dùng API key cũ thay vì API key mới trong `.env`.

## Nguyên nhân

- File `.env` có duplicate API key
- Container đã được tạo với env var cũ, chỉ restart không đủ
- Cần recreate container để load env var mới

## Giải pháp

### Bước 1: Fix duplicate trong .env

```bash
cd /opt/SmartFarm

# Option 1: Chạy script tự động
git pull origin main
chmod +x fix-duplicate-api-key.sh
./fix-duplicate-api-key.sh

# Option 2: Sửa thủ công
nano .env
# Xóa tất cả dòng GOOGLE_GENAI_API_KEY
# Thêm lại 1 dòng duy nhất:
# GOOGLE_GENAI_API_KEY=AIzaSyBWiRYGV-m-9khCxAUFEQ62Rd-w6GOFcYs
# Lưu: Ctrl+O, Enter, Ctrl+X

# Kiểm tra lại
cat .env | grep GOOGLE_GENAI_API_KEY
# Phải chỉ thấy 1 dòng: GOOGLE_GENAI_API_KEY=AIzaSyBWiRYGV-m-9khCxAUFEQ62Rd-w6GOFcYs
```

### Bước 2: Recreate container (QUAN TRỌNG)

```bash
# Stop và remove container
docker compose stop chatbot
docker compose rm -f chatbot

# Tạo lại container với env var mới từ .env
docker compose up -d chatbot

# Đợi container start
sleep 5
```

### Bước 3: Kiểm tra API key trong container

```bash
# Kiểm tra API key
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY

# Phải thấy: GOOGLE_GENAI_API_KEY=AIzaSyBWiRYGV-m-9khCxAUFEQ62Rd-w6GOFcYs
# (API key mới, không phải key cũ)
```

### Bước 4: Kiểm tra logs

```bash
docker compose logs chatbot --tail=20

# Phải thấy:
# ✅ API key found: AIzaSyBWi...FcYs (API key mới)
# ✅ Genkit đã được khởi tạo thành công
```

## Nếu vẫn thấy API key cũ

### Force recreate hoàn toàn

```bash
cd /opt/SmartFarm

# 1. Đảm bảo .env chỉ có 1 dòng API key mới
cat .env | grep GOOGLE_GENAI_API_KEY
# Phải chỉ thấy 1 dòng với API key mới

# 2. Stop và remove container
docker compose stop chatbot
docker compose rm -f chatbot

# 3. Rebuild (nếu cần)
docker compose build chatbot

# 4. Create và start với env var mới
docker compose up -d chatbot

# 5. Kiểm tra
sleep 5
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY
docker compose logs chatbot --tail=20
```

## Quick Fix (Tất cả trong một)

```bash
cd /opt/SmartFarm

# 1. Fix duplicate
./fix-duplicate-api-key.sh

# 2. Recreate container
docker compose stop chatbot && \
docker compose rm -f chatbot && \
docker compose up -d chatbot && \
sleep 5 && \
docker exec smartfarm-chatbot printenv | grep GOOGLE_GENAI_API_KEY && \
docker compose logs chatbot --tail=20
```

## Lưu ý

- **Restart không đủ** - cần recreate container để load env var mới
- **File .env chỉ nên có 1 dòng** GOOGLE_GENAI_API_KEY
- **API key mới:** `AIzaSyBWiRYGV-m-9khCxAUFEQ62Rd-w6GOFcYs`
