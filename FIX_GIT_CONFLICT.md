# 🔧 Fix Git Conflict

## Vấn đề: Unmerged files khi git pull

## ✅ Giải pháp

### Bước 1: Xem các file bị conflict

```bash
# Trên VPS
cd ~/projects/SmartFarm
git status
```

### Bước 2: Giải quyết conflict

Có 2 cách:

#### Cách 1: Giữ code local (nếu đã sửa code trên VPS)

```bash
# Xem file nào bị conflict
git status

# Giữ code local (nếu code local đúng)
git checkout --ours <file_name>
git add <file_name>

# Hoặc giữ code remote (nếu code remote đúng)
git checkout --theirs <file_name>
git add <file_name>
```

#### Cách 2: Stash changes và pull lại (Khuyên dùng)

```bash
# Lưu thay đổi local
git stash

# Pull code mới
git pull

# Nếu cần, restore thay đổi
git stash pop
```

#### Cách 3: Reset và pull lại (Mất thay đổi local)

```bash
# CẨN THẬN: Mất tất cả thay đổi local!
git reset --hard HEAD
git pull
```

---

## 🚀 Sau khi fix conflict

```bash
# Commit nếu cần
git add .
git commit -m "Resolve merge conflicts"

# Hoặc pull lại
git pull

# Rebuild và restart
docker compose build --no-cache backend
docker compose restart backend
```

