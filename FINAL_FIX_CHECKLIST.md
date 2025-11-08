# ✅ Checklist Fix Toàn Bộ Hệ Thống

## 📋 Tổng Hợp Các Vấn Đề Đã Fix

### 1. ✅ Frontend - API URL
- **Vấn đề:** Frontend gọi `localhost:8080` thay vì VPS IP
- **Fix:** Auto-detect VPS IP từ `window.location.hostname`
- **File:** `J2EE_Frontend/src/config/api.config.js`

### 2. ✅ Frontend - Vercel References
- **Vấn đề:** Vẫn còn reference đến Vercel
- **Fix:** Xóa hoàn toàn tất cả Vercel URLs
- **Files:** 
  - `J2EE_Frontend/src/config/api.config.js`
  - `J2EE_Frontend/src/components/SmartFarmChatbot.js`

### 3. ✅ Chatbot - Vercel Redirect
- **Vấn đề:** Chatbot redirect đến Vercel
- **Fix:** Xóa `vercel.json`, hardcode VPS URL
- **Files:**
  - `AI_SmartFarm_CHatbot/vercel.json` (đã xóa)
  - `AI_SmartFarm_CHatbot/Dockerfile`
  - `J2EE_Frontend/src/components/SmartFarmChatbot.js`

### 4. ✅ Chatbot - crypto.randomUUID
- **Vấn đề:** `crypto.randomUUID is not a function`
- **Fix:** Tạo `generateUUID()` với fallback
- **Files:**
  - `AI_SmartFarm_CHatbot/src/lib/uuid.ts` (mới)
  - `AI_SmartFarm_CHatbot/src/app/page.tsx`
  - `AI_SmartFarm_CHatbot/src/app/embed/page.tsx`
  - `AI_SmartFarm_CHatbot/src/components/chatbot-widget.tsx`

### 5. ✅ Chatbot - AI Service Error
- **Vấn đề:** Server Components error mơ hồ
- **Fix:** Thêm error handling và logging chi tiết
- **Files:**
  - `AI_SmartFarm_CHatbot/src/ai/flows/generate-insights-from-excel.ts`
  - `AI_SmartFarm_CHatbot/src/app/page.tsx`
  - `AI_SmartFarm_CHatbot/src/components/chatbot-widget.tsx`
  - `AI_SmartFarm_CHatbot/Dockerfile` (copy Excel file)

## 🔨 Rebuild Toàn Bộ (Trên VPS)

```bash
cd ~/projects/SmartFarm

# 1. Pull code mới nhất
git pull origin main

# 2. Rebuild frontend
docker compose stop frontend
docker compose rm -f frontend
docker rmi smartfarm-frontend 2>/dev/null || true
docker compose build --no-cache frontend
docker compose up -d frontend

# 3. Rebuild chatbot
docker compose stop chatbot
docker compose rm -f chatbot
docker rmi smartfarm-chatbot 2>/dev/null || true
docker compose build --no-cache chatbot
docker compose up -d chatbot

# 4. Đợi 30 giây
sleep 30

# 5. Kiểm tra tất cả services
docker compose ps
```

## 🔍 Kiểm Tra Sau Khi Rebuild

### 1. Kiểm Tra Services

```bash
# Trên VPS
docker compose ps

# Tất cả services phải "healthy" hoặc "running"
```

### 2. Kiểm Tra GOOGLE_GENAI_API_KEY

```bash
# Trên VPS (KHÔNG trong container)
docker exec smartfarm-chatbot env | grep GOOGLE

# Nếu chưa có hoặc là "your-api-key":
# 1. Lấy API key từ: https://aistudio.google.com/
# 2. Cập nhật docker-compose.yml:
#    GOOGLE_GENAI_API_KEY: ${GOOGLE_GENAI_API_KEY:-your-actual-api-key}
# 3. Restart: docker compose restart chatbot
```

### 3. Test Frontend

1. **Clear browser cache** (Incognito mode hoặc Hard refresh)
2. Mở: `http://173.249.48.25`
3. Mở Console (F12)
4. **Phải thấy:**
   ```
   🔧 API Configuration:
     API Base URL: http://173.249.48.25:8080
     ✅ Vercel URLs đã được loại bỏ hoàn toàn
   ```
5. **KHÔNG được có:**
   - Lỗi `localhost:8080`
   - Lỗi Vercel 404
   - Lỗi `crypto.randomUUID`

### 4. Test Chatbot

1. Đăng nhập vào hệ thống
2. Click icon chatbot (góc dưới bên phải)
3. **Console phải thấy:**
   ```
   🤖 Chatbot URL (VPS hardcoded): http://173.249.48.25:9002
   ✅ Chatbot iframe loaded from: http://173.249.48.25:9002
   ```
4. Gửi một câu hỏi test
5. **Kiểm tra:**
   - Nếu có GOOGLE_GENAI_API_KEY: Chatbot trả lời
   - Nếu không có: Hiển thị error message rõ ràng (không phải Server Components error mơ hồ)

## 🐛 Debug Nếu Vẫn Lỗi

### Kiểm Tra Logs

```bash
# Frontend logs
docker compose logs frontend | tail -50

# Chatbot logs
docker compose logs chatbot | tail -50

# Backend logs
docker compose logs backend | tail -50
```

### Kiểm Tra Network

1. Mở Developer Tools (F12)
2. Tab **Network**
3. Filter: `vercel` hoặc `hackathon`
4. **KHÔNG được có request nào** đến Vercel

### Kiểm Tra Console

```javascript
// Chạy trong Console
console.log('API_BASE_URL:', window.location.origin.replace(':80', ':8080'));

// Kiểm tra chatbot iframe
const iframe = document.querySelector('iframe[title="Smart Farm AI Chatbot"]');
if (iframe) {
  console.log('Chatbot URL:', iframe.src);
  // Phải là: http://173.249.48.25:9002
}
```

## ✅ Checklist Cuối Cùng

- [ ] Đã pull code mới nhất (`git pull origin main`)
- [ ] Đã rebuild frontend với `--no-cache`
- [ ] Đã rebuild chatbot với `--no-cache`
- [ ] Tất cả services đang healthy/running
- [ ] GOOGLE_GENAI_API_KEY đã được set (nếu muốn chatbot hoạt động)
- [ ] Đã clear browser cache (Incognito mode)
- [ ] Frontend không còn lỗi `localhost:8080`
- [ ] Frontend không còn lỗi Vercel 404
- [ ] Chatbot không còn lỗi `crypto.randomUUID`
- [ ] Chatbot load từ VPS: `http://173.249.48.25:9002`
- [ ] Network tab không có request đến Vercel
- [ ] Console không có lỗi màu đỏ

## 📝 Lưu Ý Quan Trọng

1. **Browser cache** là nguyên nhân phổ biến nhất
   - Luôn test ở **Incognito mode** sau khi rebuild
   - Hoặc clear cache hoàn toàn

2. **GOOGLE_GENAI_API_KEY** là bắt buộc để chatbot trả lời
   - Nếu không có, chatbot sẽ hiển thị error message rõ ràng
   - Không còn lỗi Server Components mơ hồ

3. **Build cache** có thể giữ code cũ
   - Phải dùng `--no-cache` khi rebuild
   - Xóa image cũ trước khi rebuild

---

**Chúc bạn fix thành công! 🎉**

