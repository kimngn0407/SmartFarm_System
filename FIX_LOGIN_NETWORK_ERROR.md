# 🔧 Fix Login Network Error

## ❌ Vấn Đề

```
Network Error: ERR_NETWORK
Login không thể kết nối đến backend
```

## 🔍 Nguyên Nhân

Frontend có thể đang gọi `localhost:8080` thay vì VPS IP `173.249.48.25:8080`.

## ✅ Giải Pháp

### Bước 1: Rebuild Frontend với Code Mới

**Trên VPS, chạy:**

```bash
cd ~/projects/SmartFarm

# 1. Pull code mới
git pull origin main

# 2. Rebuild frontend
docker compose stop frontend
docker compose rm -f frontend
docker rmi smartfarm-frontend 2>/dev/null || true
docker compose build --no-cache frontend
docker compose up -d frontend

# 3. Đợi 30 giây
sleep 30

# 4. Kiểm tra
docker compose ps | grep frontend
```

### Bước 2: Clear Browser Cache (QUAN TRỌNG!)

**Cách 1: Incognito/Private Mode (Khuyến nghị)**
- Mở browser ở chế độ **Incognito/Private**
- Truy cập: `http://173.249.48.25`

**Cách 2: Hard Refresh**
- Windows/Linux: `Ctrl + Shift + R` hoặc `Ctrl + F5`
- Mac: `Cmd + Shift + R`

**Cách 3: Clear Service Worker**
1. Mở Developer Tools (F12)
2. Vào tab **Application**
3. Click **Service Workers** ở sidebar trái
4. Click **Unregister** cho tất cả service workers
5. Refresh trang

### Bước 3: Kiểm Tra API URL

**Sau khi clear cache, mở Console (F12) và kiểm tra:**

```javascript
// Phải thấy:
🔧 API Configuration:
  Environment: production
  API Base URL: http://173.249.48.25:8080
  Window location: http://173.249.48.25/
  ✅ Vercel URLs đã được loại bỏ hoàn toàn
```

**KHÔNG được thấy:**
- `API Base URL: http://localhost:8080`

### Bước 4: Test Login

1. Mở: `http://173.249.48.25` (Incognito mode)
2. Mở Console (F12)
3. Thử đăng nhập
4. Kiểm tra Network tab:
   - Request phải đến: `http://173.249.48.25:8080/api/auth/login`
   - **KHÔNG được** đến `localhost:8080`

## 🔍 Debug Nếu Vẫn Lỗi

### Kiểm tra Backend

```bash
# Trên VPS, kiểm tra backend có chạy không
docker compose ps | grep backend

# Test backend endpoint
curl http://localhost:8080/api/auth/health

# Hoặc từ browser
# http://173.249.48.25:8080/api/auth/health
```

### Kiểm tra Network Tab

1. Mở Developer Tools (F12)
2. Vào tab **Network**
3. Thử đăng nhập
4. Xem request đến URL nào:
   - ✅ Đúng: `http://173.249.48.25:8080/api/auth/login`
   - ❌ Sai: `http://localhost:8080/api/auth/login`

### Kiểm tra CORS

Nếu backend trả về CORS error, cần kiểm tra backend config.

## 📝 Lưu Ý

1. **Browser cache** là nguyên nhân phổ biến nhất
2. **Luôn test ở Incognito mode** sau khi rebuild
3. **Frontend phải rebuild** với code mới (auto-detect VPS IP)
4. **Backend phải chạy** và accessible từ frontend

---

**Chúc bạn fix thành công! 🎉**

