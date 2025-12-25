# 📝 Hướng Dẫn Điền DNS Record

## 🎯 Thông Tin Cần Điền

**Trong form DNS bạn đang mở:**

### 1. Type
- ✅ Đã chọn: **A - Address record**

### 2. Host
- ✅ Đã điền: **`smartfarm`**
- Domain sẽ là: `smartfarm.kimngn.cfd`

### 3. Answer / Value
- ⚠️ **CẦN ĐIỀN:** `109.205.180.72`
- Đây là IP của VPS

### 4. TTL
- ✅ Đã có: `600` (10 phút)
- Có thể để 600 hoặc đổi thành 3600 (1 giờ)

### 5. Priority
- ✅ Để trống (không cần cho A record)

### 6. Notes
- ✅ Tùy chọn, có thể ghi: "SmartFarm VPS"

---

## ✅ Sau Khi Điền Xong

1. Click nút **Add** (hoặc **Save**)
2. Đợi 5-15 phút để DNS propagate
3. Kiểm tra:
   ```powershell
   nslookup smartfarm.kimngn.cfd
   ```
   **Kết quả mong đợi:**
   ```
   Address: 109.205.180.72
   ```

---

## 🚀 Bước Tiếp Theo

Sau khi DNS đã trỏ đúng, trên VPS:

```bash
cd /opt/SmartFarm
git pull origin main
chmod +x setup-ssl-docker.sh
# Chỉnh sửa email trong script
nano setup-ssl-docker.sh
./setup-ssl-docker.sh
```

---

**Hãy điền `109.205.180.72` vào ô "Answer / Value" và click Add!** 📝✨
