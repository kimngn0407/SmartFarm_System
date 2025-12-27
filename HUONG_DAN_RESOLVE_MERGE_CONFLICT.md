# 🔧 Hướng Dẫn Giải Quyết Merge Conflict Trên VPS

## 🔍 Vấn Đề

**Sau khi `git pull origin main`, có merge conflict:**
```
Unmerged paths:
  both modified:   AI_SmartFarm_CHatbot/next.config.ts
  both modified:   nginx/nginx.conf
```

---

## ✅ Giải Pháp Nhanh

### Cách 1: Dùng Script Tự Động (Khuyên Dùng)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull script mới
git pull origin main

# Chạy script resolve conflict
chmod +x resolve-merge-conflict-vps.sh
./resolve-merge-conflict-vps.sh
```

**Script sẽ:**
- Tự động giữ version từ remote (origin/main) cho các file conflict
- Tự động add và commit

---

### Cách 2: Giải Quyết Thủ Công

**Bước 1: Giữ Version Từ Remote (Origin/Main)**

```bash
cd /opt/SmartFarm

# Giữ version từ remote cho next.config.ts
git checkout --theirs AI_SmartFarm_CHatbot/next.config.ts
git add AI_SmartFarm_CHatbot/next.config.ts

# Giữ version từ remote cho nginx.conf
git checkout --theirs nginx/nginx.conf
git add nginx/nginx.conf
```

**Bước 2: Commit**

```bash
git commit -m "Resolve merge conflict - keep remote version"
```

**Bước 3: Kiểm Tra**

```bash
git status
# Phải thấy: "nothing to commit, working tree clean"
```

---

### Cách 3: Giữ Version Local (Nếu Cần)

**Nếu muốn giữ version local thay vì remote:**

```bash
cd /opt/SmartFarm

# Giữ version local cho next.config.ts
git checkout --ours AI_SmartFarm_CHatbot/next.config.ts
git add AI_SmartFarm_CHatbot/next.config.ts

# Giữ version local cho nginx.conf
git checkout --ours nginx/nginx.conf
git add nginx/nginx.conf

# Commit
git commit -m "Resolve merge conflict - keep local version"
```

---

## 📋 Giải Thích

**`--theirs`:** Giữ version từ remote (origin/main) - **Khuyên dùng**
- Đây là code mới nhất từ GitHub
- Đã được test và merge

**`--ours`:** Giữ version local (trên VPS)
- Chỉ dùng nếu bạn đã sửa trực tiếp trên VPS
- Thường không khuyên dùng

---

## 🎯 Sau Khi Resolve

**Sau khi resolve conflict và commit:**

```bash
# Kiểm tra status
git status

# Phải thấy:
# "nothing to commit, working tree clean"
# "Your branch is up to date with 'origin/main'"
```

**Nếu cần rebuild services:**

```bash
# Rebuild frontend (nếu có thay đổi)
docker compose build frontend
docker compose up -d frontend

# Rebuild chatbot (nếu có thay đổi)
docker compose build chatbot
docker compose up -d chatbot

# Reload Nginx (nếu có thay đổi nginx.conf)
docker compose restart nginx
```

---

## ✅ Checklist

- [ ] Đã chạy script hoặc resolve conflict thủ công
- [ ] Đã commit conflict resolution
- [ ] Đã kiểm tra `git status` không còn conflict
- [ ] Đã rebuild services nếu cần
- [ ] Đã reload Nginx nếu có thay đổi nginx.conf

---

**Hãy chạy script hoặc resolve conflict thủ công!** 🔧✨

# 🔧 Hướng Dẫn Giải Quyết Merge Conflict Trên VPS

## 🔍 Vấn Đề

**Sau khi `git pull origin main`, có merge conflict:**
```
Unmerged paths:
  both modified:   AI_SmartFarm_CHatbot/next.config.ts
  both modified:   nginx/nginx.conf
```

---

## ✅ Giải Pháp Nhanh

### Cách 1: Dùng Script Tự Động (Khuyên Dùng)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull script mới
git pull origin main

# Chạy script resolve conflict
chmod +x resolve-merge-conflict-vps.sh
./resolve-merge-conflict-vps.sh
```

**Script sẽ:**
- Tự động giữ version từ remote (origin/main) cho các file conflict
- Tự động add và commit

---

### Cách 2: Giải Quyết Thủ Công

**Bước 1: Giữ Version Từ Remote (Origin/Main)**

```bash
cd /opt/SmartFarm

# Giữ version từ remote cho next.config.ts
git checkout --theirs AI_SmartFarm_CHatbot/next.config.ts
git add AI_SmartFarm_CHatbot/next.config.ts

# Giữ version từ remote cho nginx.conf
git checkout --theirs nginx/nginx.conf
git add nginx/nginx.conf
```

**Bước 2: Commit**

```bash
git commit -m "Resolve merge conflict - keep remote version"
```

**Bước 3: Kiểm Tra**

```bash
git status
# Phải thấy: "nothing to commit, working tree clean"
```

---

### Cách 3: Giữ Version Local (Nếu Cần)

**Nếu muốn giữ version local thay vì remote:**

```bash
cd /opt/SmartFarm

# Giữ version local cho next.config.ts
git checkout --ours AI_SmartFarm_CHatbot/next.config.ts
git add AI_SmartFarm_CHatbot/next.config.ts

# Giữ version local cho nginx.conf
git checkout --ours nginx/nginx.conf
git add nginx/nginx.conf

# Commit
git commit -m "Resolve merge conflict - keep local version"
```

---

## 📋 Giải Thích

**`--theirs`:** Giữ version từ remote (origin/main) - **Khuyên dùng**
- Đây là code mới nhất từ GitHub
- Đã được test và merge

**`--ours`:** Giữ version local (trên VPS)
- Chỉ dùng nếu bạn đã sửa trực tiếp trên VPS
- Thường không khuyên dùng

---

## 🎯 Sau Khi Resolve

**Sau khi resolve conflict và commit:**

```bash
# Kiểm tra status
git status

# Phải thấy:
# "nothing to commit, working tree clean"
# "Your branch is up to date with 'origin/main'"
```

**Nếu cần rebuild services:**

```bash
# Rebuild frontend (nếu có thay đổi)
docker compose build frontend
docker compose up -d frontend

# Rebuild chatbot (nếu có thay đổi)
docker compose build chatbot
docker compose up -d chatbot

# Reload Nginx (nếu có thay đổi nginx.conf)
docker compose restart nginx
```

---

## ✅ Checklist

- [ ] Đã chạy script hoặc resolve conflict thủ công
- [ ] Đã commit conflict resolution
- [ ] Đã kiểm tra `git status` không còn conflict
- [ ] Đã rebuild services nếu cần
- [ ] Đã reload Nginx nếu có thay đổi nginx.conf

---

**Hãy chạy script hoặc resolve conflict thủ công!** 🔧✨

# 🔧 Hướng Dẫn Giải Quyết Merge Conflict Trên VPS

## 🔍 Vấn Đề

**Sau khi `git pull origin main`, có merge conflict:**
```
Unmerged paths:
  both modified:   AI_SmartFarm_CHatbot/next.config.ts
  both modified:   nginx/nginx.conf
```

---

## ✅ Giải Pháp Nhanh

### Cách 1: Dùng Script Tự Động (Khuyên Dùng)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull script mới
git pull origin main

# Chạy script resolve conflict
chmod +x resolve-merge-conflict-vps.sh
./resolve-merge-conflict-vps.sh
```

**Script sẽ:**
- Tự động giữ version từ remote (origin/main) cho các file conflict
- Tự động add và commit

---

### Cách 2: Giải Quyết Thủ Công

**Bước 1: Giữ Version Từ Remote (Origin/Main)**

```bash
cd /opt/SmartFarm

# Giữ version từ remote cho next.config.ts
git checkout --theirs AI_SmartFarm_CHatbot/next.config.ts
git add AI_SmartFarm_CHatbot/next.config.ts

# Giữ version từ remote cho nginx.conf
git checkout --theirs nginx/nginx.conf
git add nginx/nginx.conf
```

**Bước 2: Commit**

```bash
git commit -m "Resolve merge conflict - keep remote version"
```

**Bước 3: Kiểm Tra**

```bash
git status
# Phải thấy: "nothing to commit, working tree clean"
```

---

### Cách 3: Giữ Version Local (Nếu Cần)

**Nếu muốn giữ version local thay vì remote:**

```bash
cd /opt/SmartFarm

# Giữ version local cho next.config.ts
git checkout --ours AI_SmartFarm_CHatbot/next.config.ts
git add AI_SmartFarm_CHatbot/next.config.ts

# Giữ version local cho nginx.conf
git checkout --ours nginx/nginx.conf
git add nginx/nginx.conf

# Commit
git commit -m "Resolve merge conflict - keep local version"
```

---

## 📋 Giải Thích

**`--theirs`:** Giữ version từ remote (origin/main) - **Khuyên dùng**
- Đây là code mới nhất từ GitHub
- Đã được test và merge

**`--ours`:** Giữ version local (trên VPS)
- Chỉ dùng nếu bạn đã sửa trực tiếp trên VPS
- Thường không khuyên dùng

---

## 🎯 Sau Khi Resolve

**Sau khi resolve conflict và commit:**

```bash
# Kiểm tra status
git status

# Phải thấy:
# "nothing to commit, working tree clean"
# "Your branch is up to date with 'origin/main'"
```

**Nếu cần rebuild services:**

```bash
# Rebuild frontend (nếu có thay đổi)
docker compose build frontend
docker compose up -d frontend

# Rebuild chatbot (nếu có thay đổi)
docker compose build chatbot
docker compose up -d chatbot

# Reload Nginx (nếu có thay đổi nginx.conf)
docker compose restart nginx
```

---

## ✅ Checklist

- [ ] Đã chạy script hoặc resolve conflict thủ công
- [ ] Đã commit conflict resolution
- [ ] Đã kiểm tra `git status` không còn conflict
- [ ] Đã rebuild services nếu cần
- [ ] Đã reload Nginx nếu có thay đổi nginx.conf

---

**Hãy chạy script hoặc resolve conflict thủ công!** 🔧✨

