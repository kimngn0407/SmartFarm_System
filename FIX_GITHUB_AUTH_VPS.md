# 🔧 Fix GitHub Authentication Trên VPS

## 🔍 Vấn Đề

**Lỗi khi push:**
```
remote: Invalid username or token. Password authentication is not supported for Git operations.
fatal: Authentication failed
```

**Nguyên nhân:**
- GitHub không còn hỗ trợ password authentication
- Cần dùng Personal Access Token (PAT) hoặc SSH key

---

## ✅ Giải Pháp: Dùng Personal Access Token

### Bước 1: Tạo Personal Access Token Trên GitHub

1. **Vào GitHub:** https://github.com/settings/tokens
2. **Click:** "Generate new token" → "Generate new token (classic)"
3. **Đặt tên:** "VPS SmartFarm" (hoặc tên khác)
4. **Chọn scope:**
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (nếu cần)
5. **Click:** "Generate token"
6. **Copy token** (chỉ hiện 1 lần, lưu lại!)

---

### Bước 2: Dùng Token Khi Push

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Push với token
git push origin main
# Username: kimngn0407
# Password: <paste token ở đây>
```

**Hoặc set token trong URL (tạm thời):**
```bash
# Thay <TOKEN> bằng token của bạn
git push https://<TOKEN>@github.com/kimngn0407/SmartFarm_System.git main
```

---

### Bước 3: Lưu Credentials (Tùy Chọn)

**Nếu muốn lưu token để không phải nhập lại:**

```bash
# Cài git credential helper
git config --global credential.helper store

# Push lần đầu (sẽ lưu token)
git push origin main
# Username: kimngn0407
# Password: <paste token>

# Lần sau sẽ tự động dùng token đã lưu
```

---

## 🔐 Giải Pháp Tốt Hơn: Dùng SSH Key

### Bước 1: Tạo SSH Key Trên VPS

**Trên VPS, chạy:**
```bash
# Tạo SSH key
ssh-keygen -t ed25519 -C "vps-smartfarm"
# Nhấn Enter để dùng default location
# Nhấn Enter để không đặt passphrase (hoặc đặt nếu muốn)

# Xem public key
cat ~/.ssh/id_ed25519.pub
# Copy toàn bộ output
```

---

### Bước 2: Thêm SSH Key Vào GitHub

1. **Vào GitHub:** https://github.com/settings/keys
2. **Click:** "New SSH key"
3. **Title:** "VPS SmartFarm"
4. **Key:** Paste public key đã copy
5. **Click:** "Add SSH key"

---

### Bước 3: Đổi Remote URL Sang SSH

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Xem remote hiện tại
git remote -v

# Đổi sang SSH
git remote set-url origin git@github.com:kimngn0407/SmartFarm_System.git

# Test connection
ssh -T git@github.com
# Phải thấy: "Hi kimngn0407! You've successfully authenticated..."

# Push
git push origin main
```

---

## 🎯 Khuyên Dùng: SSH Key (Tốt Hơn)

**SSH key tốt hơn vì:**
- ✅ Không cần nhập token mỗi lần
- ✅ An toàn hơn
- ✅ Dễ quản lý

**Personal Access Token:**
- ✅ Dễ setup hơn
- ⚠️ Cần nhập lại mỗi lần (trừ khi lưu)

---

## 📋 Checklist

- [ ] Đã tạo Personal Access Token hoặc SSH key
- [ ] Đã thêm token/key vào GitHub
- [ ] Đã test push thành công
- [ ] Đã lưu credentials nếu dùng token

---

## 🎯 Kết Quả Mong Đợi

**Sau khi setup:**
- ✅ `git push origin main` thành công
- ✅ Không còn lỗi authentication
- ✅ Commits đã được push lên GitHub

---

**Hãy tạo Personal Access Token hoặc SSH key!** 🔧✨

