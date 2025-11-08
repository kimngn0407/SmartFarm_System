# 🔄 Hướng Dẫn Rebuild Backend trên VPS

## 📋 Thay đổi mới nhất
- **Tự động gán quyền ADMIN** cho tất cả người dùng đăng ký mới

## 🚀 Các bước thực hiện trên VPS

### Cách 1: Sử dụng script tự động (Khuyến nghị)

```bash
cd ~/projects/SmartFarm

# Tải script về (nếu chưa có)
# Hoặc tạo file rebuild-backend-vps.sh với nội dung từ file trong repo

# Cấp quyền thực thi
chmod +x rebuild-backend-vps.sh

# Chạy script
./rebuild-backend-vps.sh
```

### Cách 2: Thực hiện thủ công

```bash
cd ~/projects/SmartFarm

# 1. Pull code mới nhất
git pull origin main

# 2. Dừng backend
docker compose stop backend

# 3. Rebuild backend với code mới
docker compose build --no-cache backend

# 4. Start lại backend
docker compose up -d backend

# 5. Kiểm tra logs
docker compose logs -f backend | tail -50

# 6. Kiểm tra health
curl http://localhost:8080/actuator/health
```

## ✅ Kiểm tra sau khi rebuild

```bash
# Kiểm tra container đang chạy
docker compose ps

# Kiểm tra logs backend
docker compose logs backend | tail -30

# Test đăng ký tài khoản mới
# Tài khoản mới sẽ tự động có quyền ADMIN
```

## 🔍 Troubleshooting

### Nếu git pull bị conflict:
```bash
git stash
git pull origin main
git stash pop
```

### Nếu rebuild bị lỗi:
```bash
# Xem logs chi tiết
docker compose build --no-cache backend 2>&1 | tee build.log

# Hoặc xem logs container
docker compose logs backend | tail -100
```

### Nếu backend không start:
```bash
# Kiểm tra lỗi
docker compose ps -a
docker compose logs backend | tail -50

# Restart service
docker compose restart backend
```

## 📝 Lưu ý

- Backend sẽ tự động restart sau khi rebuild
- Đợi khoảng 15-30 giây để backend khởi động hoàn toàn
- Kiểm tra logs để đảm bảo không có lỗi

---

**Chúc bạn rebuild thành công! 🎉**

