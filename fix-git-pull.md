# Xử lý lỗi Divergent Branches khi Git Pull

## Tình huống: Code trên VPS và Git đã phân nhánh

Có 2 cách xử lý:

## Cách 1: Merge (Giữ cả 2 thay đổi) - Khuyến nghị

```bash
# Trên VPS
cd ~/projects/SmartFarm

# Pull với merge
git pull origin main --no-rebase

# Nếu có conflict, giải quyết conflict rồi:
git add .
git commit -m "Merge remote changes"
```

## Cách 2: Reset về Remote (Bỏ thay đổi local) - Nếu không cần giữ thay đổi trên VPS

**⚠️ CẢNH BÁO: Cách này sẽ xóa mọi thay đổi local trên VPS!**

```bash
# Trên VPS
cd ~/projects/SmartFarm

# Backup thay đổi local (nếu cần)
git stash

# Fetch code mới nhất
git fetch origin

# Reset về code trên Git (bỏ thay đổi local)
git reset --hard origin/main

# Hoặc nếu muốn giữ lại thay đổi local trong stash:
# git stash pop  # (sau khi reset)
```

## Cách 3: Rebase (Đặt thay đổi local lên trên)

```bash
# Trên VPS
cd ~/projects/SmartFarm

# Pull với rebase
git pull origin main --rebase

# Nếu có conflict, giải quyết conflict rồi:
git add .
git rebase --continue
```

## Cách 4: Cấu hình mặc định (để không bị hỏi nữa)

```bash
# Trên VPS
cd ~/projects/SmartFarm

# Cấu hình merge làm mặc định
git config pull.rebase false

# Sau đó pull bình thường
git pull origin main
```

## Khuyến nghị cho trường hợp này

Vì bạn đã push code mới từ local lên Git, và muốn lấy code mới nhất về VPS, nên dùng **Cách 2 (Reset)**:

```bash
cd ~/projects/SmartFarm
git fetch origin
git reset --hard origin/main
```

Sau đó rebuild frontend:
```bash
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

