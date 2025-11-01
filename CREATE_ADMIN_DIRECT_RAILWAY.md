# 🔐 Tạo Admin Trực Tiếp Trong Railway Database

## 📋 CÁCH 1: Dùng Railway Query Tab

### Bước 1: Mở Railway Dashboard
```
https://railway.app/
→ Project của bạn
→ PostgreSQL service
→ Tab "Query"
```

### Bước 2: Chạy Query Tạo Admin

**Copy và paste query này:**

```sql
-- 1. Tạo admin account
INSERT INTO account (email, password_hash, full_name, created_at)
VALUES (
    'admin@test.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO',  -- password: "admin123"
    'Admin User',
    NOW()
)
ON CONFLICT (email) DO NOTHING
RETURNING id;

-- 2. Lấy ID vừa tạo (hoặc xem trong table account)
-- Giả sử ID = 51 (adjust nếu khác)

-- 3. Thêm role ADMIN
INSERT INTO account_roles (account_id, role)
VALUES (51, 'ADMIN')
ON CONFLICT DO NOTHING;
```

### Bước 3: Check Kết Quả

**Tab "Data" → table `account`:**
- Phải có row: `admin@test.com`

**Tab "Data" → table `account_roles`:**
- Phải có row: `account_id = 51, role = ADMIN`

---

## 📋 CÁCH 2: Nếu Query Không Chạy

### Tạo thủ công qua UI:

**1. Tab "Data" → table `account` → "+ Row"**

Fill:
```
email: admin@test.com
password_hash: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO
full_name: Admin User
created_at: 2025-10-31 00:00:00
```

**2. Check ID vừa tạo (ví dụ: 51)**

**3. Tab "Data" → table `account_roles` → "+ Row"**

Fill:
```
account_id: 51
role: ADMIN
```

---

## 🚀 SAU KHI TẠO XONG

### Login Frontend:

```
URL: https://hackathon-pione-dream.vercel.app/
Email: admin@test.com
Password: admin123
```

---

## 🔑 PASSWORD HASH

**Password hash trên là cho: `admin123`**

**Nếu muốn password khác:**

1. Dùng tool này: https://bcrypt-generator.com/
2. Input: password bạn muốn
3. Rounds: 10
4. Copy hash
5. Paste vào `password_hash`

---

## ⚠️ LƯU Ý

- `account_id` trong `account_roles` phải trùng với `id` trong `account`
- `password_hash` PHẢI bắt đầu bằng `$2a$` hoặc `$2b$` (bcrypt format)
- `email` phải unique (không trùng với account khác)

---

## ✅ CHECK THÀNH CÔNG

**Sau khi tạo, kiểm tra:**

```sql
-- Check account
SELECT * FROM account WHERE email = 'admin@test.com';

-- Check roles
SELECT a.email, ar.role 
FROM account a
JOIN account_roles ar ON a.id = ar.account_id
WHERE a.email = 'admin@test.com';
```

**Phải thấy:**
```
email: admin@test.com
role: ADMIN
```

---

**GIỜ THỬ LOGIN!** 🚀


