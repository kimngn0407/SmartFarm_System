# 🔧 Fix GitHub 403 Error - Token Authentication

## 🔍 Vấn Đề

**Lỗi khi push:**
```
remote: Permission to kimngn0407/SmartFarm_System.git denied to kimngn0407.
fatal: unable to access 'https://github.com/kimngn0407/SmartFarm_System.git/': The requested URL returned error: 403
```

**Nguyên nhân có thể:**
- Token không đúng hoặc đã hết hạn
- Token không có quyền `repo`
- Token bị copy sai (có khoảng trắng, thiếu ký tự)

---

## ✅ Giải Pháp

### Cách 1: Tạo Token Mới Với Đúng Scope

**Bước 1: Tạo Token Mới**

1. **Vào GitHub:** https://github.com/settings/tokens
2. **Xóa token cũ** (nếu có)
3. **Click:** "Generate new token" → "Generate new token (classic)"
4. **Đặt tên:** "VPS SmartFarm Push"
5. **Chọn scope:**
   - ✅ **`repo`** (Full control of private repositories) - **QUAN TRỌNG!**
   - ✅ `workflow` (nếu cần)
6. **Click:** "Generate token"
7. **Copy token** (chỉ hiện 1 lần, lưu lại!)

**Lưu ý:** Token phải bắt đầu bằng `ghp_` (ví dụ: `ghp_xxxxxxxxxxxxxxxxxxxx`)

---

### Cách 2: Dùng Token Trong URL (Tránh Nhập Lại)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Thay <TOKEN> bằng token thực tế của bạn
git push https://<TOKEN>@github.com/kimngn0407/SmartFarm_System.git main

# Ví dụ:
# git push https://ghp_xxxxxxxxxxxxxxxxxxxx@github.com/kimngn0407/SmartFarm_System.git main
```

**Hoặc set remote URL với token:**
```bash
# Thay <TOKEN> bằng token thực tế
git remote set-url origin https://<TOKEN>@github.com/kimngn0407/SmartFarm_System.git

# Sau đó push bình thường
git push origin main
```

---

### Cách 3: Dùng SSH Key (Khuyên Dùng - Tốt Nhất)

**Bước 1: Tạo SSH Key**

```bash
# Tạo SSH key
ssh-keygen -t ed25519 -C "vps-smartfarm"
# Nhấn Enter để dùng default location
# Nhấn Enter để không đặt passphrase (hoặc đặt nếu muốn)

# Xem public key
cat ~/.ssh/id_ed25519.pub
# Copy toàn bộ output (bắt đầu bằng ssh-ed25519)
```

**Bước 2: Thêm SSH Key Vào GitHub**

1. **Vào GitHub:** https://github.com/settings/keys
2. **Click:** "New SSH key"
3. **Title:** "VPS SmartFarm"
4. **Key:** Paste public key đã copy
5. **Click:** "Add SSH key"

**Bước 3: Đổi Remote Sang SSH**

```bash
cd /opt/SmartFarm

# Đổi sang SSH
git remote set-url origin git@github.com:kimngn0407/SmartFarm_System.git

# Test connection
ssh -T git@github.com
# Phải thấy: "Hi kimngn0407! You've successfully authenticated..."

# Push
git push origin main
```

---

### Cách 4: Kiểm Tra Token Có Đúng Không

**Nếu dùng token, kiểm tra:**

```bash
# Test token với curl
curl -H "Authorization: token <TOKEN>" https://api.github.com/user

# Phải trả về thông tin user (JSON)
# Nếu 401/403 → Token sai hoặc hết hạn
```

---

## 🎯 Khuyên Dùng: SSH Key

**SSH key tốt hơn vì:**
- ✅ Không cần nhập token mỗi lần
- ✅ An toàn hơn
- ✅ Dễ quản lý
- ✅ Không bị hết hạn

**Personal Access Token:**
- ✅ Dễ setup hơn
- ⚠️ Có thể hết hạn
- ⚠️ Cần nhập lại nếu không lưu

---

## 📋 Checklist

- [ ] Đã tạo token mới với scope `repo`
- [ ] Đã copy token đúng (không có khoảng trắng)
- [ ] Đã test token với curl
- [ ] Đã thử push với token trong URL
- [ ] Hoặc đã setup SSH key và đổi remote

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ `git push origin main` thành công
- ✅ Không còn lỗi 403
- ✅ Commits đã được push lên GitHub

---

**Hãy tạo token mới với scope `repo` hoặc setup SSH key!** 🔧✨

# 🔧 Fix GitHub 403 Error - Token Authentication

## 🔍 Vấn Đề

**Lỗi khi push:**
```
remote: Permission to kimngn0407/SmartFarm_System.git denied to kimngn0407.
fatal: unable to access 'https://github.com/kimngn0407/SmartFarm_System.git/': The requested URL returned error: 403
```

**Nguyên nhân có thể:**
- Token không đúng hoặc đã hết hạn
- Token không có quyền `repo`
- Token bị copy sai (có khoảng trắng, thiếu ký tự)

---

## ✅ Giải Pháp

### Cách 1: Tạo Token Mới Với Đúng Scope

**Bước 1: Tạo Token Mới**

1. **Vào GitHub:** https://github.com/settings/tokens
2. **Xóa token cũ** (nếu có)
3. **Click:** "Generate new token" → "Generate new token (classic)"
4. **Đặt tên:** "VPS SmartFarm Push"
5. **Chọn scope:**
   - ✅ **`repo`** (Full control of private repositories) - **QUAN TRỌNG!**
   - ✅ `workflow` (nếu cần)
6. **Click:** "Generate token"
7. **Copy token** (chỉ hiện 1 lần, lưu lại!)

**Lưu ý:** Token phải bắt đầu bằng `ghp_` (ví dụ: `ghp_xxxxxxxxxxxxxxxxxxxx`)

---

### Cách 2: Dùng Token Trong URL (Tránh Nhập Lại)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Thay <TOKEN> bằng token thực tế của bạn
git push https://<TOKEN>@github.com/kimngn0407/SmartFarm_System.git main

# Ví dụ:
# git push https://ghp_xxxxxxxxxxxxxxxxxxxx@github.com/kimngn0407/SmartFarm_System.git main
```

**Hoặc set remote URL với token:**
```bash
# Thay <TOKEN> bằng token thực tế
git remote set-url origin https://<TOKEN>@github.com/kimngn0407/SmartFarm_System.git

# Sau đó push bình thường
git push origin main
```

---

### Cách 3: Dùng SSH Key (Khuyên Dùng - Tốt Nhất)

**Bước 1: Tạo SSH Key**

```bash
# Tạo SSH key
ssh-keygen -t ed25519 -C "vps-smartfarm"
# Nhấn Enter để dùng default location
# Nhấn Enter để không đặt passphrase (hoặc đặt nếu muốn)

# Xem public key
cat ~/.ssh/id_ed25519.pub
# Copy toàn bộ output (bắt đầu bằng ssh-ed25519)
```

**Bước 2: Thêm SSH Key Vào GitHub**

1. **Vào GitHub:** https://github.com/settings/keys
2. **Click:** "New SSH key"
3. **Title:** "VPS SmartFarm"
4. **Key:** Paste public key đã copy
5. **Click:** "Add SSH key"

**Bước 3: Đổi Remote Sang SSH**

```bash
cd /opt/SmartFarm

# Đổi sang SSH
git remote set-url origin git@github.com:kimngn0407/SmartFarm_System.git

# Test connection
ssh -T git@github.com
# Phải thấy: "Hi kimngn0407! You've successfully authenticated..."

# Push
git push origin main
```

---

### Cách 4: Kiểm Tra Token Có Đúng Không

**Nếu dùng token, kiểm tra:**

```bash
# Test token với curl
curl -H "Authorization: token <TOKEN>" https://api.github.com/user

# Phải trả về thông tin user (JSON)
# Nếu 401/403 → Token sai hoặc hết hạn
```

---

## 🎯 Khuyên Dùng: SSH Key

**SSH key tốt hơn vì:**
- ✅ Không cần nhập token mỗi lần
- ✅ An toàn hơn
- ✅ Dễ quản lý
- ✅ Không bị hết hạn

**Personal Access Token:**
- ✅ Dễ setup hơn
- ⚠️ Có thể hết hạn
- ⚠️ Cần nhập lại nếu không lưu

---

## 📋 Checklist

- [ ] Đã tạo token mới với scope `repo`
- [ ] Đã copy token đúng (không có khoảng trắng)
- [ ] Đã test token với curl
- [ ] Đã thử push với token trong URL
- [ ] Hoặc đã setup SSH key và đổi remote

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ `git push origin main` thành công
- ✅ Không còn lỗi 403
- ✅ Commits đã được push lên GitHub

---

**Hãy tạo token mới với scope `repo` hoặc setup SSH key!** 🔧✨

# 🔧 Fix GitHub 403 Error - Token Authentication

## 🔍 Vấn Đề

**Lỗi khi push:**
```
remote: Permission to kimngn0407/SmartFarm_System.git denied to kimngn0407.
fatal: unable to access 'https://github.com/kimngn0407/SmartFarm_System.git/': The requested URL returned error: 403
```

**Nguyên nhân có thể:**
- Token không đúng hoặc đã hết hạn
- Token không có quyền `repo`
- Token bị copy sai (có khoảng trắng, thiếu ký tự)

---

## ✅ Giải Pháp

### Cách 1: Tạo Token Mới Với Đúng Scope

**Bước 1: Tạo Token Mới**

1. **Vào GitHub:** https://github.com/settings/tokens
2. **Xóa token cũ** (nếu có)
3. **Click:** "Generate new token" → "Generate new token (classic)"
4. **Đặt tên:** "VPS SmartFarm Push"
5. **Chọn scope:**
   - ✅ **`repo`** (Full control of private repositories) - **QUAN TRỌNG!**
   - ✅ `workflow` (nếu cần)
6. **Click:** "Generate token"
7. **Copy token** (chỉ hiện 1 lần, lưu lại!)

**Lưu ý:** Token phải bắt đầu bằng `ghp_` (ví dụ: `ghp_xxxxxxxxxxxxxxxxxxxx`)

---

### Cách 2: Dùng Token Trong URL (Tránh Nhập Lại)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Thay <TOKEN> bằng token thực tế của bạn
git push https://<TOKEN>@github.com/kimngn0407/SmartFarm_System.git main

# Ví dụ:
# git push https://ghp_xxxxxxxxxxxxxxxxxxxx@github.com/kimngn0407/SmartFarm_System.git main
```

**Hoặc set remote URL với token:**
```bash
# Thay <TOKEN> bằng token thực tế
git remote set-url origin https://<TOKEN>@github.com/kimngn0407/SmartFarm_System.git

# Sau đó push bình thường
git push origin main
```

---

### Cách 3: Dùng SSH Key (Khuyên Dùng - Tốt Nhất)

**Bước 1: Tạo SSH Key**

```bash
# Tạo SSH key
ssh-keygen -t ed25519 -C "vps-smartfarm"
# Nhấn Enter để dùng default location
# Nhấn Enter để không đặt passphrase (hoặc đặt nếu muốn)

# Xem public key
cat ~/.ssh/id_ed25519.pub
# Copy toàn bộ output (bắt đầu bằng ssh-ed25519)
```

**Bước 2: Thêm SSH Key Vào GitHub**

1. **Vào GitHub:** https://github.com/settings/keys
2. **Click:** "New SSH key"
3. **Title:** "VPS SmartFarm"
4. **Key:** Paste public key đã copy
5. **Click:** "Add SSH key"

**Bước 3: Đổi Remote Sang SSH**

```bash
cd /opt/SmartFarm

# Đổi sang SSH
git remote set-url origin git@github.com:kimngn0407/SmartFarm_System.git

# Test connection
ssh -T git@github.com
# Phải thấy: "Hi kimngn0407! You've successfully authenticated..."

# Push
git push origin main
```

---

### Cách 4: Kiểm Tra Token Có Đúng Không

**Nếu dùng token, kiểm tra:**

```bash
# Test token với curl
curl -H "Authorization: token <TOKEN>" https://api.github.com/user

# Phải trả về thông tin user (JSON)
# Nếu 401/403 → Token sai hoặc hết hạn
```

---

## 🎯 Khuyên Dùng: SSH Key

**SSH key tốt hơn vì:**
- ✅ Không cần nhập token mỗi lần
- ✅ An toàn hơn
- ✅ Dễ quản lý
- ✅ Không bị hết hạn

**Personal Access Token:**
- ✅ Dễ setup hơn
- ⚠️ Có thể hết hạn
- ⚠️ Cần nhập lại nếu không lưu

---

## 📋 Checklist

- [ ] Đã tạo token mới với scope `repo`
- [ ] Đã copy token đúng (không có khoảng trắng)
- [ ] Đã test token với curl
- [ ] Đã thử push với token trong URL
- [ ] Hoặc đã setup SSH key và đổi remote

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ `git push origin main` thành công
- ✅ Không còn lỗi 403
- ✅ Commits đã được push lên GitHub

---

**Hãy tạo token mới với scope `repo` hoặc setup SSH key!** 🔧✨

