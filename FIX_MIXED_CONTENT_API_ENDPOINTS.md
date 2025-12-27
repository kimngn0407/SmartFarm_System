# 🔧 Fix Lỗi Mixed Content & API Endpoints

## 🔍 Vấn Đề

**Lỗi:**
- Login thành công ✅
- Các API khác đều lỗi ❌
- Mixed Content error hoặc 404 Not Found

**Nguyên nhân:**
1. **API endpoints có `/api` bị duplicate:**
   - `API_BASE_URL` = `https://smartfarm.kimngn.cfd/api`
   - Endpoints lại thêm `/api` nữa → `https://smartfarm.kimngn.cfd/api/api/auth/login` ❌

2. **Frontend chưa được rebuild** với code mới

---

## ✅ Giải Pháp

### Bước 1: Pull Code Mới Trên VPS

```bash
cd /opt/SmartFarm
git pull origin main
```

---

### Bước 2: Rebuild Frontend (QUAN TRỌNG!)

```bash
# Rebuild frontend image với code mới
docker compose build frontend

# Recreate frontend container
docker compose up -d --force-recreate frontend

# Đợi frontend khởi động (15-20 giây)
sleep 20
```

---

### Bước 3: Kiểm Tra Logs

```bash
# Xem logs frontend
docker compose logs frontend --tail=30

# Kiểm tra frontend đang chạy
docker compose ps frontend
```

---

### Bước 4: Test API

**Trong browser console (F12):**
```javascript
// Test API base URL
console.log('API Base URL:', process.env.REACT_APP_API_URL);

// Test một endpoint
fetch('https://smartfarm.kimngn.cfd/api/health')
  .then(r => r.json())
  .then(console.log)
  .catch(console.error);
```

**Hoặc test từ VPS:**
```bash
# Test health endpoint
curl -I https://smartfarm.kimngn.cfd/api/health

# Test với authentication (nếu cần)
curl -X GET https://smartfarm.kimngn.cfd/api/sensors/data \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 🎯 Thay Đổi Đã Thực Hiện

### 1. Sửa `api.config.js`

**Trước:**
```javascript
API_BASE_URL = "https://smartfarm.kimngn.cfd/api"
LOGIN: `${API_BASE_URL}/api/auth/login`  // ❌ /api/api/auth/login
```

**Sau:**
```javascript
API_BASE_URL = "https://smartfarm.kimngn.cfd/api"
LOGIN: `${API_BASE_URL}/auth/login`  // ✅ /api/auth/login
```

### 2. Sửa `Dockerfile`

**Trước:**
```dockerfile
ARG REACT_APP_API_URL=http://109.205.180.72:8080  // ❌ HTTP + IP
```

**Sau:**
```dockerfile
ARG REACT_APP_API_URL=https://smartfarm.kimngn.cfd/api  // ✅ HTTPS + Domain
```

---

## 📋 Checklist

- [ ] Đã pull code mới từ git
- [ ] Đã rebuild frontend image (`docker compose build frontend`)
- [ ] Đã recreate frontend container (`docker compose up -d --force-recreate frontend`)
- [ ] Đã đợi frontend khởi động (15-20 giây)
- [ ] Đã test API từ browser console
- [ ] Đã refresh browser (Ctrl+F5 để clear cache)
- [ ] Đã kiểm tra không còn lỗi Mixed Content

---

## 🚨 Nếu Vẫn Lỗi

### Kiểm Tra 1: Frontend Đã Build Với Code Mới Chưa?

```bash
# Xem build date trong frontend container
docker compose exec frontend ls -la /usr/share/nginx/html/static/js/

# Hoặc xem environment variables
docker compose exec frontend printenv | grep REACT_APP_API_URL
# Phải thấy: REACT_APP_API_URL=https://smartfarm.kimngn.cfd/api
```

### Kiểm Tra 2: Browser Cache

**Hard refresh:**
- **Chrome/Edge:** `Ctrl + Shift + R` hoặc `Ctrl + F5`
- **Firefox:** `Ctrl + Shift + R`
- **Safari:** `Cmd + Shift + R`

**Hoặc clear cache:**
- `F12` → `Application` → `Clear storage` → `Clear site data`

### Kiểm Tra 3: Network Tab

**Mở DevTools (F12) → Network tab:**
- Xem các API requests
- Kiểm tra URL có đúng không: `https://smartfarm.kimngn.cfd/api/...`
- Kiểm tra không có `/api/api/...` (duplicate)

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ Tất cả API calls dùng HTTPS
- ✅ URL đúng format: `https://smartfarm.kimngn.cfd/api/...`
- ✅ Không có duplicate `/api/api/...`
- ✅ Không còn Mixed Content error
- ✅ Login, Dashboard, Sensors, tất cả đều hoạt động

---

**Hãy rebuild frontend và test lại!** 🔧✨

