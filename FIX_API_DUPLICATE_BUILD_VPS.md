# 🔧 Fix Lỗi API Duplicate - Build Trên VPS

## 📋 Vấn Đề Đã Sửa

**Lỗi:** API endpoints bị duplicate `/api` → `api/api/farms` → 404

**Nguyên nhân:**
- `API_BASE_URL` có `/api`: `https://smartfarm.kimngn.cfd/api`
- Service files thêm `/api` nữa: `${API_BASE_URL}/api/farms`
- Kết quả: `https://smartfarm.kimngn.cfd/api/api/farms` ❌

**Đã sửa:**
- ✅ Bỏ `/api` khỏi `API_BASE_URL` trong production
- ✅ Thêm `/api` vào `API_ENDPOINTS` để nhất quán
- ✅ Sửa `Dockerfile` và `docker-compose.yml`

---

## 🚀 Các Bước Build Trên VPS

### Bước 1: SSH Vào VPS

```bash
ssh root@your-vps-ip
# hoặc
ssh root@109.205.180.72
```

### Bước 2: Vào Thư Mục Project

```bash
cd /opt/SmartFarm
# hoặc thư mục chứa project của bạn
```

### Bước 3: Pull Code Mới Nhất

```bash
# Pull code mới từ Git
git pull origin main

# Hoặc nếu branch khác
git pull origin master
```

### Bước 4: Rebuild Frontend Container

**Option 1: Rebuild chỉ frontend (Khuyến nghị - Nhanh hơn)**

```bash
# Rebuild frontend image với code mới
docker compose build frontend

# Recreate và restart frontend container
docker compose up -d --force-recreate frontend

# Đợi build hoàn tất (20-30 giây)
sleep 30
```

**Option 2: Rebuild tất cả services**

```bash
# Rebuild tất cả
docker compose down
docker compose up -d --build

# Hoặc nếu muốn giữ các services khác đang chạy
docker compose build
docker compose up -d
```

### Bước 5: Kiểm Tra Logs

```bash
# Xem logs frontend để đảm bảo build thành công
docker compose logs frontend --tail=50

# Kiểm tra frontend đang chạy
docker compose ps frontend
```

**Kết quả mong đợi:**
- ✅ Container status: `Up` (healthy)
- ✅ Không có lỗi trong logs
- ✅ Build thành công

### Bước 6: Kiểm Tra Trên Browser

1. **Mở trình duyệt:**
   - `https://smartfarm.kimngn.cfd` (hoặc domain của bạn)
   - Hoặc `http://your-vps-ip`

2. **Mở Developer Tools (F12) → Console:**
   - Không còn lỗi `api/api/...` 404
   - API calls thành công

3. **Kiểm tra API:**
   ```javascript
   // Trong browser console
   fetch('https://smartfarm.kimngn.cfd/api/farms')
     .then(r => r.json())
     .then(console.log)
     .catch(console.error);
   ```

---

## 🔍 Troubleshooting

### Lỗi: Container không start

```bash
# Kiểm tra logs chi tiết
docker compose logs frontend

# Kiểm tra xem có lỗi build không
docker compose build frontend --no-cache
```

### Lỗi: Vẫn thấy `api/api/...`

**Nguyên nhân:** Browser cache hoặc code chưa được rebuild

**Giải pháp:**
```bash
# 1. Hard refresh browser (Ctrl + Shift + R hoặc Cmd + Shift + R)

# 2. Hoặc clear cache và rebuild lại
docker compose build frontend --no-cache
docker compose up -d --force-recreate frontend

# 3. Kiểm tra lại file build
docker compose exec frontend ls -la /usr/share/nginx/html
```

### Lỗi: Git pull có conflict

```bash
# Xem các file conflict
git status

# Nếu có conflict, có thể stash thay đổi local
git stash
git pull origin main
git stash pop

# Hoặc reset hard (CẨN THẬN - sẽ mất thay đổi local)
git fetch origin
git reset --hard origin/main
```

### Lỗi: Không có quyền

```bash
# Đảm bảo bạn đang ở đúng thư mục và có quyền
cd /opt/SmartFarm
sudo chown -R $USER:$USER .
```

---

## ✅ Checklist

Trước khi build:
- [ ] Đã commit và push code lên Git
- [ ] SSH vào VPS thành công
- [ ] Đã pull code mới nhất

Sau khi build:
- [ ] Frontend container đang chạy (`docker compose ps`)
- [ ] Không có lỗi trong logs
- [ ] Browser không còn lỗi 404 `api/api/...`
- [ ] API calls thành công

---

## 📝 Lệnh Nhanh (Copy-Paste)

```bash
# Pull code và rebuild frontend
cd /opt/SmartFarm && \
git pull origin main && \
docker compose build frontend && \
docker compose up -d --force-recreate frontend && \
sleep 30 && \
docker compose logs frontend --tail=30
```

---

## 🎯 Kết Quả Mong Đợi

Sau khi build xong:
- ✅ API URLs đúng: `https://smartfarm.kimngn.cfd/api/farms` (không còn `/api/api/...`)
- ✅ Không còn lỗi 404 trong browser console
- ✅ Dashboard load dữ liệu thành công
- ✅ Tất cả API endpoints hoạt động bình thường

---

**Cập nhật:** 2025-01-20  
**Lỗi đã sửa:** API duplicate `/api/api/...` → `/api/...`


