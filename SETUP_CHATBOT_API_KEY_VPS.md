# 🔧 Setup Chatbot API Key Trên VPS

## 🔍 Vấn Đề

**Kết quả kiểm tra:**
```
GOOGLE_GENAI_API_KEY=your-api-key  ← Placeholder, không hợp lệ
No .env file  ← Chưa có file .env
```

**Vấn đề:** API key chưa được cấu hình, chatbot không thể hoạt động.

---

## ✅ Giải Pháp: Tạo .env File Và Cấu Hình API Key

### Bước 1: Lấy Google AI API Key

**Nếu chưa có API key:**

1. **Vào:** https://aistudio.google.com/
2. **Click:** "Get API Key" hoặc "Create API Key"
3. **Tạo API key mới** (nếu chưa có)
4. **Copy API key** (dạng: `AIza...`)

---

### Bước 2: Tạo .env File Trên VPS

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Tạo file .env
nano .env
```

**Trong file `.env`, thêm dòng sau (thay `YOUR_ACTUAL_API_KEY` bằng API key thật):**
```bash
GOOGLE_GENAI_API_KEY=YOUR_ACTUAL_API_KEY
```

**Ví dụ:**
```bash
GOOGLE_GENAI_API_KEY=AIzaSyAbc123def456ghi789jkl012mno345pqr
```

**Save và exit:**
- Nhấn `Ctrl+X`
- Nhấn `Y` để confirm
- Nhấn `Enter` để save

---

### Bước 3: Kiểm Tra .env File

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra file .env đã được tạo
cat .env | grep GOOGLE_GENAI_API_KEY

# Phải thấy: GOOGLE_GENAI_API_KEY=AIza... (không phải your-api-key)
```

---

### Bước 4: Restart Chatbot Container

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Restart chatbot để load API key mới từ .env
docker compose restart chatbot

# Đợi chatbot khởi động (30-60 giây)
sleep 45

# Kiểm tra logs
docker compose logs chatbot --tail=50 | grep -i "genkit\|api.*key"
```

**Phải thấy:**
```
✅ API key found: AIzaSyAbc... (length: 39)
✅ Genkit đã được khởi tạo thành công
```

**KHÔNG còn thấy:**
```
⚠️ API key không tìm thấy hoặc là placeholder
❌ GOOGLE_GENAI_API_KEY chưa được cấu hình
```

---

### Bước 5: Kiểm Tra API Key Trong Container

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra API key trong container (chỉ hiện 10 ký tự đầu)
docker compose exec chatbot env | grep GOOGLE_GENAI_API_KEY | head -c 30

# Phải thấy: GOOGLE_GENAI_API_KEY=AIza... (không phải your-api-key)
```

---

## 🎯 Kiểm Tra Sau Khi Fix

**Test từ browser:**
- Truy cập: https://smartfarm.kimngn.cfd/chatbot
- Gửi một câu hỏi (ví dụ: "Cách trồng lúa?")
- Phải nhận được phản hồi từ AI (không còn lỗi 500)

**Test từ VPS:**
```bash
# Kiểm tra logs không còn lỗi API key
docker compose logs chatbot --tail=100 | grep -i "error\|api.*key" | grep -v "✅" || echo "✅ Không còn lỗi"

# Test chatbot endpoint
curl http://localhost:9002/chatbot/ 2>/dev/null | head -20
```

---

## 📋 Checklist

- [ ] Đã lấy Google AI API key từ https://aistudio.google.com/
- [ ] Đã tạo file `.env` trong `/opt/SmartFarm/`
- [ ] Đã thêm `GOOGLE_GENAI_API_KEY=YOUR_ACTUAL_API_KEY` vào `.env`
- [ ] Đã kiểm tra `.env` file có API key đúng (không phải `your-api-key`)
- [ ] Đã restart chatbot container
- [ ] Đã kiểm tra logs thấy "✅ Genkit đã được khởi tạo thành công"
- [ ] Đã test chatbot hoạt động bình thường (không còn 500)

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ File `.env` được tạo với API key hợp lệ
- ✅ Chatbot container load API key từ `.env`
- ✅ Logs hiện: "✅ Genkit đã được khởi tạo thành công"
- ✅ Chatbot trả lời được câu hỏi (không còn 500)
- ✅ Không còn lỗi "API key chưa được cấu hình"

---

## ⚠️ Lưu Ý

**Bảo mật file `.env`:**
- File `.env` chứa API key nhạy cảm
- Không commit file `.env` vào Git (đã có trong `.gitignore`)
- Chỉ người quản trị mới có quyền đọc file này

---

**Hãy tạo file .env và thêm API key thật!** 🔧✨
