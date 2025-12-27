# 🔧 Fix Chatbot Widget Iframe Error

## 🔍 Vấn Đề

**Lỗi trong chatbot widget:**
```
smartfarm.kimngn.cfd đã gửi ý kiến phản hồi không hợp lệ.
```

**Nguyên nhân:**
- Frontend đang load chatbot qua iframe với URL: `https://smartfarm.kimngn.cfd:9002`
- Port 9002 không được expose ra ngoài (chỉ Nginx có thể truy cập)
- Cần load qua Nginx path: `https://smartfarm.kimngn.cfd/chatbot`

---

## ✅ Giải Pháp: Sửa Chatbot URL

**Đã sửa `SmartFarmChatbot.js`:**

1. **Đổi từ port 9002 sang `/chatbot` path:**
   ```javascript
   // Cũ: `${protocol}//${hostname}:9002`
   // Mới: `${protocol}//${hostname}/chatbot`
   ```

2. **Thêm environment variable `REACT_APP_CHATBOT_URL`:**
   - Trong `Dockerfile`: `ARG REACT_APP_CHATBOT_URL`
   - Trong `docker-compose.yml`: `REACT_APP_CHATBOT_URL`

---

## 🔧 Áp Dụng Fix Trên VPS

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull code mới
git pull origin main --no-rebase --no-edit

# Rebuild frontend (QUAN TRỌNG - vì code đã thay đổi)
docker compose build frontend

# Recreate frontend container
docker compose up -d --force-recreate frontend

# Đợi frontend khởi động (30-60 giây)
sleep 45

# Test chatbot widget
# Truy cập: https://smartfarm.kimngn.cfd
# Mở chatbot widget → Phải load được
```

---

## 🎯 Kiểm Tra Sau Khi Fix

**Test từ browser:**
- Truy cập: https://smartfarm.kimngn.cfd
- Click vào chatbot icon (góc dưới bên phải)
- Chatbot widget phải load được (không còn lỗi)
- Phải hiển thị giao diện chatbot đầy đủ

---

## 📋 Checklist

- [ ] Đã pull code mới
- [ ] Đã rebuild frontend (`docker compose build frontend`)
- [ ] Đã recreate frontend container
- [ ] Đã test chatbot widget load được
- [ ] Đã kiểm tra không còn lỗi "phản hồi không hợp lệ"

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ Chatbot widget load được qua `/chatbot` path
- ✅ Không còn lỗi "phản hồi không hợp lệ"
- ✅ Chatbot hiển thị đầy đủ trong iframe
- ✅ Chatbot hoạt động bình thường

---

**Hãy rebuild frontend và test lại!** 🔧✨
