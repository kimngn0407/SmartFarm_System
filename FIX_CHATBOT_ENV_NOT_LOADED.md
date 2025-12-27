# 🔧 Fix Chatbot Không Load API Key Từ .env File

## 🔍 Vấn Đề

**Sau khi thêm API key vào `.env` và restart chatbot, vẫn báo lỗi:**
```
⚠️ API key không tìm thấy hoặc là placeholder
GOOGLE_GENAI_API_KEY: exists
❌ Lỗi khi định nghĩa flow: Error: API key chưa được cấu hình
```

**Nguyên nhân có thể:**
- Docker Compose không tự động load `.env` file
- API key trong `.env` vẫn là placeholder hoặc format sai
- Container cần được recreate thay vì chỉ restart

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra File .env

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra nội dung file .env
cat .env

# Phải thấy:
# GOOGLE_GENAI_API_KEY=AIzaSy... (API key thật, không phải your-api-key)
```

**Nếu thấy `your-api-key` hoặc giá trị rỗng:**
- Cần sửa lại file `.env` với API key thật

---

### Bước 2: Kiểm Tra Format API Key

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra API key có đúng format không
cat .env | grep GOOGLE_GENAI_API_KEY | head -c 50

# Phải thấy: GOOGLE_GENAI_API_KEY=AIza... (không có dấu ngoặc kép, không có khoảng trắng)
```

**Format đúng:**
```bash
GOOGLE_GENAI_API_KEY=AIzaSyAbc123def456ghi789jkl012mno345pqr
```

**Format sai:**
```bash
GOOGLE_GENAI_API_KEY="AIzaSy..."  # Có dấu ngoặc kép
GOOGLE_GENAI_API_KEY = AIzaSy...  # Có khoảng trắng
GOOGLE_GENAI_API_KEY=your-api-key  # Placeholder
```

---

### Bước 3: Kiểm Tra Docker Compose Load .env

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra docker-compose.yml có reference đến .env không
grep -i "env_file\|\.env" docker-compose.yml || echo "Không thấy env_file trong docker-compose.yml"

# Docker Compose tự động load .env file trong cùng thư mục
# Nhưng cần đảm bảo file .env ở đúng vị trí: /opt/SmartFarm/.env
```

---

### Bước 4: Recreate Container (Thay Vì Chỉ Restart)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Stop và remove container (không xóa image)
docker compose stop chatbot
docker compose rm -f chatbot

# Start lại container (sẽ load .env file mới)
docker compose up -d chatbot

# Đợi chatbot khởi động
sleep 45

# Kiểm tra logs
docker compose logs chatbot --tail=50 | grep -i "genkit\|api.*key"
```

**Hoặc dùng cách nhanh hơn:**
```bash
cd /opt/SmartFarm

# Recreate container (stop, remove, create, start)
docker compose up -d --force-recreate chatbot

# Đợi chatbot khởi động
sleep 45

# Kiểm tra logs
docker compose logs chatbot --tail=50 | grep -i "genkit\|api.*key"
```

---

### Bước 5: Kiểm Tra API Key Trong Container

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra API key trong container
docker compose exec chatbot env | grep GOOGLE_GENAI_API_KEY

# Phải thấy: GOOGLE_GENAI_API_KEY=AIza... (không phải your-api-key)

# Kiểm tra giá trị (chỉ hiện 10 ký tự đầu để không expose full key)
docker compose exec chatbot env | grep GOOGLE_GENAI_API_KEY | head -c 30
```

---

### Bước 6: Nếu Vẫn Không Hoạt Động - Set Trực Tiếp Trong docker-compose.yml

**Nếu Docker Compose không load `.env` file, có thể set trực tiếp:**

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Edit docker-compose.yml
nano docker-compose.yml

# Tìm phần chatbot environment:
#   environment:
#     GOOGLE_GENAI_API_KEY: ${GOOGLE_GENAI_API_KEY:-your-api-key}
#
# Thay thành (thay YOUR_ACTUAL_API_KEY bằng API key thật):
#   environment:
#     GOOGLE_GENAI_API_KEY: YOUR_ACTUAL_API_KEY

# Save và exit (Ctrl+X, Y, Enter)

# Recreate container
docker compose up -d --force-recreate chatbot

# Đợi chatbot khởi động
sleep 45

# Kiểm tra logs
docker compose logs chatbot --tail=50 | grep -i "genkit\|api.*key"
```

---

## 🔍 Debug Chi Tiết

**Nếu vẫn không hoạt động, kiểm tra:**

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# 1. Kiểm tra file .env có tồn tại không
ls -la .env

# 2. Kiểm tra quyền file .env
chmod 600 .env  # Chỉ owner mới đọc được

# 3. Kiểm tra nội dung file .env (không có ký tự đặc biệt)
cat .env | od -c | head -20

# 4. Kiểm tra Docker Compose có đọc được .env không
docker compose config | grep GOOGLE_GENAI_API_KEY

# 5. Kiểm tra environment variables trong container
docker compose exec chatbot printenv | grep GOOGLE
```

---

## 📋 Checklist

- [ ] Đã kiểm tra file `.env` có API key thật (không phải `your-api-key`)
- [ ] Đã kiểm tra format API key đúng (không có dấu ngoặc kép, không có khoảng trắng)
- [ ] Đã recreate container (không chỉ restart)
- [ ] Đã kiểm tra API key trong container (`docker compose exec chatbot env`)
- [ ] Đã kiểm tra logs thấy "✅ Genkit đã được khởi tạo thành công"
- [ ] Đã test chatbot hoạt động bình thường

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ File `.env` có API key thật
- ✅ Container load được API key từ `.env`
- ✅ Logs hiện: "✅ Genkit đã được khởi tạo thành công"
- ✅ Chatbot trả lời được câu hỏi (không còn 500)

---

**Hãy kiểm tra file .env và recreate container!** 🔧✨
