# 🔍 Kiểm Tra Chatbot Logs Trên VPS

## 🎯 Mục Đích

**Kiểm tra logs chatbot để tìm nguyên nhân lỗi 500.**

---

## ✅ Bước 1: Xem Logs Chatbot

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Xem logs chatbot container (100 dòng cuối)
docker compose logs chatbot --tail=100

# Hoặc xem logs real-time
docker compose logs -f chatbot
```

---

## 🔍 Tìm Lỗi Cụ Thể

**Trên VPS, chạy:**
```bash
# Tìm lỗi về API key
docker compose logs chatbot --tail=200 | grep -i "api.*key\|GOOGLE_GENAI"

# Tìm tất cả lỗi
docker compose logs chatbot --tail=200 | grep -i "error\|exception\|failed\|500"

# Tìm lỗi genkit
docker compose logs chatbot --tail=200 | grep -i "genkit\|ai.*instance"
```

---

## 📋 Các Lỗi Thường Gặp

### 1. API Key Chưa Được Cấu Hình
```
⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình
❌ GOOGLE_GENAI_API_KEY chưa được cấu hình!
```

**Giải pháp:** Thêm `GOOGLE_GENAI_API_KEY` vào `.env` file hoặc `docker-compose.yml`

---

### 2. API Key Không Hợp Lệ
```
❌ Lỗi khởi tạo genkit: ...
Error: Invalid API key
```

**Giải pháp:** Kiểm tra API key có đúng không, lấy lại từ https://aistudio.google.com/

---

### 3. Server Component Error
```
Error: An error occurred in the Server Components render
```

**Giải pháp:** Xem logs chi tiết để tìm lỗi cụ thể

---

## 🎯 Sau Khi Tìm Được Lỗi

**Nếu là API key:**
- Thêm `GOOGLE_GENAI_API_KEY` vào `.env` file
- Restart chatbot: `docker compose restart chatbot`

**Nếu là lỗi khác:**
- Gửi logs cho tôi để phân tích thêm

---

**Hãy xem chatbot logs để tìm lỗi cụ thể!** 🔧✨
