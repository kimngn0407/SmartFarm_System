# 🔧 Debug Chatbot 500 Error

## 🔍 Vấn Đề

**Lỗi trong browser console:**
```
chatbot/:1 Failed to load resource: the server responded with a status of 500
Error generating insights: Error: An error occurred in the Server Components render.
```

**Nguyên nhân có thể:**
- Lỗi trong Next.js Server Component
- Lỗi khi gọi AI service (genkit)
- Lỗi trong chatbot code
- Missing environment variables (API keys)

---

## ✅ Giải Pháp: Kiểm Tra Logs

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Xem logs chatbot container
docker compose logs chatbot --tail=100

# Xem logs real-time
docker compose logs -f chatbot

# Tìm lỗi cụ thể
docker compose logs chatbot --tail=200 | grep -i "error\|exception\|failed\|500"
```

---

## 🔍 Kiểm Tra Environment Variables

**Trên VPS, chạy:**
```bash
# Kiểm tra chatbot container có environment variables không
docker compose exec chatbot env | grep -i "api\|key\|genkit"

# Kiểm tra .env file (nếu có)
cat AI_SmartFarm_CHatbot/.env 2>/dev/null || echo "No .env file"
```

---

## 🔧 Kiểm Tra Chatbot Service

**Trên VPS, chạy:**
```bash
# Test chatbot service trực tiếp
curl -I http://localhost:9002/chatbot/

# Test chatbot health endpoint (nếu có)
curl http://localhost:9002/api/health

# Xem chatbot container status
docker compose ps chatbot

# Xem chatbot container logs
docker compose logs chatbot --tail=50
```

---

## 🎯 Các Nguyên Nhân Thường Gặp

### 1. Missing API Keys
- Google AI API key không được set
- Genkit không thể kết nối đến Google AI

### 2. Server Component Error
- Lỗi trong `generateInsightsFromExcel` function
- Lỗi khi đọc file Excel
- Lỗi khi gọi AI service

### 3. Next.js Build Issue
- Code chưa được build đúng
- Missing dependencies

---

## 📋 Checklist Debug

- [ ] Đã xem chatbot logs (`docker compose logs chatbot`)
- [ ] Đã kiểm tra environment variables
- [ ] Đã test chatbot service trực tiếp
- [ ] Đã kiểm tra chatbot container status
- [ ] Đã tìm thấy lỗi cụ thể trong logs

---

## 🎯 Kết Quả Mong Đợi

**Sau khi debug:**
- ✅ Tìm được lỗi cụ thể trong logs
- ✅ Fix được lỗi (API key, code, etc.)
- ✅ Chatbot hoạt động bình thường

---

**Hãy xem chatbot logs để tìm lỗi cụ thể!** 🔧✨
