# ✅ Test Sau Khi Rebuild Frontend

## 🎉 Rebuild Thành Công!

Logs cho thấy frontend container đã start thành công:
- ✅ Nginx đang chạy
- ✅ Container healthy

---

## 🧪 Test Lỗi API Đã Được Sửa

### 1. Clear Browser Cache

**QUAN TRỌNG:** Phải clear cache để load code mới!

- **Windows/Linux:** `Ctrl + Shift + R` hoặc `Ctrl + F5`
- **Mac:** `Cmd + Shift + R`
- **Hoặc dùng Incognito/Private mode** (khuyến nghị)

### 2. Mở Developer Tools

1. Mở browser: `https://smartfarm.kimngn.cfd`
2. Nhấn `F12` để mở Developer Tools
3. Chuyển sang tab **Console**

### 3. Kiểm Tra Lỗi

**Trước khi fix (SAI):**
```
❌ GET https://smartfarm.kimngn.cfd/api/api/sensor-data 404
❌ Error: /api/api/sensor-data
```

**Sau khi fix (ĐÚNG):**
```
✅ GET https://smartfarm.kimngn.cfd/api/sensor-data 200 OK
✅ GET https://smartfarm.kimngn.cfd/api/farms 200 OK
```

### 4. Test API Trong Console

Paste vào Console để test:

```javascript
// Test API base URL
console.log('Testing API...');

// Test một endpoint
fetch('https://smartfarm.kimngn.cfd/api/farms', {
  headers: {
    'Authorization': `Bearer ${localStorage.getItem('token')}`
  }
})
  .then(r => {
    console.log('✅ Status:', r.status);
    return r.json();
  })
  .then(data => console.log('✅ Data:', data))
  .catch(err => console.error('❌ Error:', err));
```

---

## ✅ Kết Quả Mong Đợi

Sau khi clear cache và test lại:

- ✅ **Không còn lỗi** `api/api/...` trong console
- ✅ **API calls thành công** (status 200)
- ✅ **Dashboard load được dữ liệu**
- ✅ **Sensor data hiển thị đúng**

---

## 🐛 Nếu Vẫn Còn Lỗi

### Kiểm tra file JavaScript được build:

1. Mở Developer Tools → Network tab
2. Reload trang (F5)
3. Tìm file `main.*.js` hoặc `bundle.*.js`
4. Click vào file đó → Response
5. Search (Ctrl+F) cho: `smartfarm.kimngn.cfd`
6. Kiểm tra xem có `/api/api` hay chỉ `/api`

**Nếu vẫn thấy `/api/api`:**
- Code chưa được rebuild đúng
- Cần rebuild lại với `--no-cache`

### Kiểm tra trong container:

```bash
# Vào container
docker compose exec frontend sh

# Tìm file JS
find /usr/share/nginx/html -name "*.js" | head -5

# Xem một file để check
grep -o "smartfarm.kimngn.cfd[^\"]*" /usr/share/nginx/html/static/js/main.*.js | head -5

# Exit
exit
```

---

## 🔒 Cảnh Báo Bảo Mật

⚠️ **PHÁT HIỆN:** Logs cho thấy có request đến `/.git/config`:

```
GET /.git/config HTTP/1.1" 200
```

**Đây là security vulnerability!**

### Cách Fix:

1. **Kiểm tra `.git` folder có bị copy vào build không:**

```bash
# Trên VPS
docker compose exec frontend ls -la /usr/share/nginx/html/ | grep git
```

2. **Thêm vào `.dockerignore` hoặc `Dockerfile` để exclude `.git`:**

File: `J2EE_Frontend/.dockerignore`
```
.git
.gitignore
node_modules
.env
```

3. **Kiểm tra nginx config có block `.git` không:**

File: `J2EE_Frontend/nginx.conf` - thêm:
```nginx
location ~ /\. {
    deny all;
    return 404;
}
```

---

## 📋 Checklist

- [ ] Đã clear browser cache hoặc dùng Incognito mode
- [ ] Console không còn lỗi `api/api/...`
- [ ] API calls thành công (200 OK)
- [ ] Dashboard load được dữ liệu
- [ ] (Optional) Đã fix security issue với `.git` folder

---

**Nếu mọi thứ hoạt động tốt → 🎉 Thành công!**


