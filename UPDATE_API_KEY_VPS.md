# 🔑 Cập Nhật GOOGLE_GENAI_API_KEY Trên VPS

## ✅ API Key Đã Được Cung Cấp

```
AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw
```

## 🚀 Cách Cập Nhật (Chọn 1 trong 2 cách)

### Cách 1: Dùng Script Tự Động (Khuyến nghị)

**Trên VPS, chạy:**

```bash
cd ~/projects/SmartFarm

# Pull code mới (có script)
git pull origin main

# Chạy script
bash update-google-api-key.sh
```

Script sẽ:
- Tạo/cập nhật file `.env` với API key
- Thêm `.env` vào `.gitignore`
- Restart chatbot
- Kiểm tra env var

### Cách 2: Thủ Công

**Trên VPS, chạy:**

```bash
cd ~/projects/SmartFarm

# 1. Tạo file .env
echo "GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw" > .env

# 2. Thêm .env vào .gitignore (quan trọng!)
echo ".env" >> .gitignore

# 3. Restart chatbot
docker compose restart chatbot

# 4. Kiểm tra
docker exec smartfarm-chatbot env | grep GOOGLE_GENAI_API_KEY
# Phải hiển thị: GOOGLE_GENAI_API_KEY=AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw
```

## 🧪 Test Sau Khi Cập Nhật

1. **Clear browser cache** (Incognito mode hoặc Hard refresh)
2. Mở: `http://173.249.48.25`
3. Đăng nhập vào hệ thống
4. Click icon chatbot (góc dưới bên phải)
5. Gửi câu hỏi test: "Cách trồng lúa?"
6. **Chatbot sẽ trả lời** nếu API key đúng ✅

## 🔍 Kiểm Tra Nếu Vẫn Lỗi

### Kiểm tra env var:

```bash
docker exec smartfarm-chatbot env | grep GOOGLE
```

### Kiểm tra logs:

```bash
docker compose logs chatbot | tail -50
```

### Kiểm tra file .env:

```bash
cat .env | grep GOOGLE
```

## 📝 Lưu Ý

- ✅ File `.env` đã được thêm vào `.gitignore` (không commit lên Git)
- ✅ API key sẽ được load tự động khi restart chatbot
- ✅ Nếu vẫn lỗi, kiểm tra API key có đúng format không

---

**Sau khi cập nhật, chatbot sẽ hoạt động! 🎉**

