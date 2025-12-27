# 🔧 Fix Chatbot 500 Error - API Key Issue

## 🔍 Vấn Đề

**Lỗi trong browser console:**
```
chatbot/:1 Failed to load resource: the server responded with a status of 500
Error generating insights: Error: An error occurred in the Server Components render.
```

**Nguyên nhân:**
- `GOOGLE_GENAI_API_KEY` chưa được cấu hình hoặc không hợp lệ
- Chatbot không thể kết nối đến Google AI service

---

## ✅ Giải Pháp: Kiểm Tra Và Cấu Hình API Key

### Bước 1: Kiểm Tra Logs Chatbot

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Xem logs chatbot container
docker compose logs chatbot --tail=100

# Tìm lỗi về API key
docker compose logs chatbot --tail=200 | grep -i "api.*key\|GOOGLE_GENAI\|error\|exception"
```

**Phải thấy một trong các lỗi:**
- `⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình`
- `❌ GOOGLE_GENAI_API_KEY chưa được cấu hình!`
- `API_KEY_NOT_CONFIGURED`

---

### Bước 2: Kiểm Tra Environment Variable

**Trên VPS, chạy:**
```bash
# Kiểm tra chatbot container có API key không
docker compose exec chatbot env | grep -i "GOOGLE_GENAI_API_KEY"

# Kiểm tra .env file (nếu có)
cat .env 2>/dev/null | grep -i "GOOGLE_GENAI_API_KEY" || echo "No .env file or no API key found"
```

---

### Bước 3: Cấu Hình API Key

**Option 1: Thêm Vào .env File (Khuyên Dùng)**

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Tạo hoặc edit .env file
nano .env

# Thêm dòng:
GOOGLE_GENAI_API_KEY=your-actual-api-key-here

# Save và exit (Ctrl+X, Y, Enter)
```

**Option 2: Set Trực Tiếp Trong docker-compose.yml**

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Edit docker-compose.yml
nano docker-compose.yml

# Tìm phần chatbot environment và thay:
# GOOGLE_GENAI_API_KEY: ${GOOGLE_GENAI_API_KEY:-your-api-key}
# Thành:
# GOOGLE_GENAI_API_KEY: your-actual-api-key-here

# Save và exit
```

---

### Bước 4: Restart Chatbot Container

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Restart chatbot để load API key mới
docker compose restart chatbot

# Đợi chatbot khởi động (30-60 giây)
sleep 45

# Kiểm tra logs
docker compose logs chatbot --tail=50 | grep -i "genkit\|api.*key"

# Phải thấy: "✅ Genkit đã được khởi tạo thành công"
```

---

## 🔑 Lấy Google AI API Key

**Nếu chưa có API key:**

1. **Vào:** https://aistudio.google.com/
2. **Click:** "Get API Key"
3. **Tạo API key mới**
4. **Copy API key**
5. **Thêm vào .env file trên VPS**

---

## 🎯 Kiểm Tra Sau Khi Fix

**Test từ browser:**
- Truy cập: https://smartfarm.kimngn.cfd/chatbot
- Gửi một câu hỏi
- Phải nhận được phản hồi từ AI (không còn 500)

**Test từ VPS:**
```bash
# Test chatbot health (nếu có endpoint)
curl http://localhost:9002/api/health

# Xem logs khi có request
docker compose logs -f chatbot
```

---

## 📋 Checklist

- [ ] Đã xem chatbot logs để xác nhận lỗi API key
- [ ] Đã kiểm tra environment variable
- [ ] Đã thêm GOOGLE_GENAI_API_KEY vào .env hoặc docker-compose.yml
- [ ] Đã restart chatbot container
- [ ] Đã kiểm tra logs không còn lỗi API key
- [ ] Đã test chatbot hoạt động bình thường

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ Chatbot logs không còn lỗi API key
- ✅ Logs hiện: "✅ Genkit đã được khởi tạo thành công"
- ✅ Chatbot trả lời được câu hỏi (không còn 500)
- ✅ Không còn lỗi trong browser console

---

**Hãy kiểm tra logs và cấu hình API key!** 🔧✨
