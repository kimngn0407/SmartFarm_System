# Cập nhật Email Password trên VPS - Nhanh

## Cách 1: Sử dụng script tự động (Khuyến nghị)

```bash
cd ~/projects/SmartFarm
chmod +x UPDATE_EMAIL_ON_VPS.sh
./UPDATE_EMAIL_ON_VPS.sh
```

Script sẽ hỏi bạn:
- Gmail App Password
- Gmail address
- Tự động cập nhật docker-compose.yml và restart backend

---

## Cách 2: Cập nhật thủ công

### Bước 1: Mở docker-compose.yml
```bash
cd ~/projects/SmartFarm
nano docker-compose.yml
```

### Bước 2: Tìm section `backend` → `environment`

Tìm dòng:
```yaml
      FRONTEND_ORIGINS: ${FRONTEND_ORIGINS:-http://173.249.48.25,http://173.249.48.25:80,http://localhost:3000,http://localhost:80}
```

### Bước 3: Thêm hoặc cập nhật email config

**Nếu chưa có email config**, thêm ngay sau dòng FRONTEND_ORIGINS:
```yaml
      # Email Configuration
      MAIL_HOST: smtp.gmail.com
      MAIL_PORT: 587
      MAIL_USERNAME: lovengan0407@gmail.com
      MAIL_PASSWORD: bjjdyvqwrrmqdicg
      MAIL_FROM: your-email@gmail.com
```

**Nếu đã có email config**, chỉ cần sửa dòng `MAIL_PASSWORD`:
```yaml
      MAIL_PASSWORD: bjjdyvqwrrmqdicg
```

### Bước 4: Lưu file
- **Nano**: `Ctrl + O` → Enter → `Ctrl + X`
- **Vi**: `:wq` → Enter

### Bước 5: Restart backend
```bash
docker-compose stop backend
docker-compose up -d --build backend
```

### Bước 6: Kiểm tra
```bash
# Kiểm tra environment variables
docker exec smartfarm-backend env | grep MAIL

# Xem logs
docker-compose logs -f backend | grep -i mail
```

---

## Cách 3: Sử dụng sed (Nhanh nhất)

```bash
cd ~/projects/SmartFarm

# Backup
cp docker-compose.yml docker-compose.yml.backup

# Cập nhật password (thay YOUR_EMAIL và PASSWORD)
sed -i 's/MAIL_PASSWORD:.*/MAIL_PASSWORD: bjjdyvqwrrmqdicg/' docker-compose.yml
sed -i 's/MAIL_USERNAME:.*/MAIL_USERNAME: your-email@gmail.com/' docker-compose.yml

# Restart
docker-compose stop backend
docker-compose up -d --build backend
```

---

## Lưu ý

⚠️ **Bảo mật**:
- Password trong docker-compose.yml sẽ visible trong `docker inspect`
- Nên sử dụng Docker secrets hoặc environment file cho production
- Không commit password vào Git

✅ **Sau khi cập nhật**:
- Backend sẽ tự động load config mới
- Email service sẽ hoạt động ngay
- Test bằng cách tạo Critical alert

