# 🔧 Recreate Chatbot Container Để Load API Key Mới

## ✅ API Key Đã Được Cấu Hình Đúng

**File `.env` có API key hợp lệ:**
```
GOOGLE_GENAI_API_KEY=AIzaSyAIhjPn_H2v0B_o020S56k-Y6K_-f4vYX4
```

**Format đúng:** ✅ Không có dấu ngoặc kép, không có khoảng trắng

---

## 🔧 Recreate Container Để Load API Key

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Recreate container (stop, remove, create, start) - sẽ load .env file mới
docker compose up -d --force-recreate chatbot

# Đợi chatbot khởi động (30-60 giây)
sleep 45

# Kiểm tra logs
docker compose logs chatbot --tail=50 | grep -i "genkit\|api.*key"
```

**Phải thấy:**
```
✅ API key found: AIzaSyAIh... (length: 39)
✅ Genkit đã được khởi tạo thành công
```

**KHÔNG còn thấy:**
```
⚠️ API key không tìm thấy hoặc là placeholder
❌ GOOGLE_GENAI_API_KEY chưa được cấu hình
```

---

## 🔍 Kiểm Tra API Key Trong Container

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra API key trong container
docker compose exec chatbot env | grep GOOGLE_GENAI_API_KEY

# Phải thấy: GOOGLE_GENAI_API_KEY=AIzaSyAIhjPn_H2v0B_o020S56k-Y6K_-f4vYX4

# Kiểm tra giá trị (chỉ hiện 10 ký tự đầu để không expose full key)
docker compose exec chatbot env | grep GOOGLE_GENAI_API_KEY | head -c 30

# Phải thấy: GOOGLE_GENAI_API_KEY=AIzaSyAIh...
```

---

## 🎯 Kiểm Tra Sau Khi Recreate

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

- [x] File `.env` có API key hợp lệ
- [x] Format API key đúng (không có dấu ngoặc kép, không có khoảng trắng)
- [ ] Đã recreate container (`docker compose up -d --force-recreate chatbot`)
- [ ] Đã kiểm tra API key trong container (`docker compose exec chatbot env`)
- [ ] Đã kiểm tra logs thấy "✅ Genkit đã được khởi tạo thành công"
- [ ] Đã test chatbot hoạt động bình thường (không còn 500)

---

## 🎯 Kết Quả Mong Đợi

**Sau khi recreate container:**
- ✅ Container load được API key từ `.env`
- ✅ Logs hiện: "✅ Genkit đã được khởi tạo thành công"
- ✅ Chatbot trả lời được câu hỏi (không còn 500)

---

**Hãy recreate container để load API key mới!** 🔧✨
