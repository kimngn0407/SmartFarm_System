# 🔧 Fix Git Merge Conflict

## ❌ Lỗi:
```
error: Your local changes to the following files would be overwritten by merge:
        SmartContract/setup_auto_iot.sh
Please commit your changes or stash them before you merge.
```

## ✅ Giải pháp (Chọn 1 trong 3 cách):

### Cách 1: Commit local changes (Khuyến nghị nếu muốn giữ thay đổi)

```bash
cd ~/projects/SmartFarm/SmartContract

# Xem thay đổi
git status
git diff setup_auto_iot.sh

# Nếu muốn giữ thay đổi, commit
git add setup_auto_iot.sh
git commit -m "Local changes to setup_auto_iot.sh"

# Sau đó pull
git pull origin main

# Nếu có conflict, giải quyết và commit lại
```

### Cách 2: Stash local changes (Tạm thời lưu, có thể lấy lại sau)

```bash
cd ~/projects/SmartFarm/SmartContract

# Stash thay đổi
git stash

# Pull code mới
git pull origin main

# Nếu muốn lấy lại thay đổi cũ (tùy chọn)
git stash pop
```

### Cách 3: Discard local changes (Xóa thay đổi local, dùng code từ remote)

```bash
cd ~/projects/SmartFarm/SmartContract

# Xem thay đổi trước khi xóa
git diff setup_auto_iot.sh

# Xóa thay đổi local (dùng code từ remote)
git checkout -- setup_auto_iot.sh

# Hoặc reset toàn bộ (cẩn thận!)
# git reset --hard origin/main

# Sau đó pull
git pull origin main
```

---

## 🎯 Khuyến nghị cho trường hợp này:

Vì bạn đang trên VPS và muốn lấy code mới nhất (đã có fix cho `.cjs`), nên dùng **Cách 3**:

```bash
cd ~/projects/SmartFarm/SmartContract

# Xóa thay đổi local
git checkout -- setup_auto_iot.sh

# Pull code mới
git pull origin main
```

Sau đó chạy lại setup script:
```bash
chmod +x setup_auto_iot.sh
./setup_auto_iot.sh
```

---

## 📝 Lưu ý:

- **Cách 1**: Dùng nếu bạn đã chỉnh sửa file và muốn giữ lại
- **Cách 2**: Dùng nếu muốn tạm thời lưu thay đổi, có thể merge sau
- **Cách 3**: Dùng nếu muốn dùng code mới nhất từ remote, bỏ qua thay đổi local

