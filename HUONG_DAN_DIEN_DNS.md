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

   **Nếu DNS server nội bộ timeout, dùng Google DNS:**
   ```powershell
   nslookup smartfarm.kimngn.cfd 8.8.8.8
   ```
   
   **Hoặc Cloudflare DNS:**
   ```powershell
   nslookup smartfarm.kimngn.cfd 1.1.1.1
   ```
   
   **Kết quả mong đợi:**
   ```
   Name:    smartfarm.kimngn.cfd
   Address: 109.205.180.72
   ```
   
   **Hoặc kiểm tra online (không phụ thuộc DNS server):**
   - https://dnschecker.org/#A/smartfarm.kimngn.cfd
   - https://www.whatsmydns.net/#A/smartfarm.kimngn.cfd

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
