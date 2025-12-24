# ✅ Kiểm tra Chatbot đã được Fix

## Bước 1: Kiểm tra Container Status

```bash
# Kiểm tra frontend đang chạy
docker compose ps frontend

# Phải thấy: Status = "Up" hoặc "Running"
```

## Bước 2: Kiểm tra Logs

```bash
# Xem logs frontend
docker compose logs frontend --tail=20

# Phải thấy: Không có lỗi
```

## Bước 3: Test trên Browser

1. **Mở browser:** http://109.205.180.72
2. **Clear cache** (nếu cần): `Ctrl + Shift + R` hoặc `Ctrl + F5`
3. **Click vào nút chatbot** (góc phải dưới màn hình - icon 🌾)
4. **Kiểm tra:**
   - ✅ Chatbot xuất hiện ở **góc phải màn hình**
   - ✅ Chatbot **KHÔNG thể kéo thả** (không có cursor "grab")
   - ✅ Vị trí cố định: `right: 24px`, `bottom: 24px`

## Bước 4: Test Chatbot Functionality

1. Gửi một câu hỏi test: "Cách trồng lúa?"
2. Kiểm tra chatbot trả lời
3. Kiểm tra không có lỗi trong console (F12)

## ✅ Kết quả mong đợi

- ✅ Chatbot cố định ở góc phải màn hình
- ✅ Không thể kéo thả
- ✅ Chatbot hoạt động bình thường
- ✅ Không có lỗi trong console

## 🔧 Nếu vẫn còn vấn đề

### Nếu chatbot vẫn có thể kéo thả:

1. **Clear browser cache:**
   ```bash
   # Trên browser: Ctrl + Shift + Delete
   # Hoặc: Ctrl + Shift + R (hard refresh)
   ```

2. **Kiểm tra code đã được build:**
   ```bash
   # Xem file đã được copy vào container chưa
   docker exec smartfarm-frontend ls -la /usr/share/nginx/html/static/js/ | head -5
   ```

3. **Force rebuild:**
   ```bash
   docker compose stop frontend
   docker compose rm -f frontend
   docker compose build --no-cache frontend
   docker compose up -d frontend
   ```

### Nếu chatbot không hiển thị:

1. **Kiểm tra logs:**
   ```bash
   docker compose logs frontend -f
   ```

2. **Kiểm tra nginx:**
   ```bash
   docker compose exec frontend nginx -t
   ```

3. **Kiểm tra port:**
   ```bash
   netstat -tuln | grep 80
   ```
