# 🔧 Fix Admin Login & Menu "Quản lý tài khoản"

## ❌ Vấn Đề

1. **Tài khoản `admin.nguyen@smartfarm.com` không đăng nhập được**
   - Password trong database đã được hash (BCrypt)
   - Hash hiện tại có thể không khớp với password `admin123`

2. **Menu "Quản lý tài khoản" không hiển thị**
   - Menu chỉ hiển thị khi RoleGuard nhận diện role ADMIN từ JWT token
   - Có thể do JWT token không chứa role ADMIN đúng cách

## 🔍 Kiểm Tra

### 1. Kiểm Tra Role Trong Database

**Trên VPS:**
```bash
docker exec -it $(docker compose ps -q postgres) psql -U postgres -d smartfarm -c "
SELECT a.id, a.email, a.full_name, ar.role 
FROM account a 
LEFT JOIN account_roles ar ON a.id = ar.account_id 
WHERE a.email = 'admin.nguyen@smartfarm.com';
"
```

**Kết quả mong đợi:**
```
 id | email                        | full_name   | role
----+------------------------------+-------------+------
 49 | admin.nguyen@smartfarm.com   | Admin Nguyen| ADMIN
```

### 2. Kiểm Tra JWT Token Sau Khi Login

Sau khi đăng nhập thành công, mở Console và decode JWT token:
```javascript
// Lấy token từ localStorage
const token = localStorage.getItem('token');

// Decode payload (phần thứ 2 của JWT)
const payload = JSON.parse(atob(token.split('.')[1]));
console.log('JWT Payload:', payload);
console.log('Roles:', payload.roles);
```

**Kết quả mong đợi:**
```javascript
{
  sub: "admin.nguyen@smartfarm.com",
  roles: ["ADMIN"],  // ← Phải có ADMIN trong array
  iat: ...,
  exp: ...
}
```

## 🔨 Giải Pháp

### Option 1: Reset Password (Khuyến Nghị)

**Trên VPS:**
```bash
cd ~/projects/SmartFarm
chmod +x reset-admin-password.sh
./reset-admin-password.sh
```

Hoặc reset thủ công:
```bash
# Kết nối vào database
docker exec -it $(docker compose ps -q postgres) psql -U postgres -d smartfarm

# Update password (dùng BCrypt hash của "admin123")
UPDATE account 
SET password = '$2a$10$XWiyRvBz/hLjXss0J9Nva.OQBMV8IclmnMX3sVY5ZS6VOPOTFz.nO' 
WHERE email = 'admin.nguyen@smartfarm.com';

# Kiểm tra role
SELECT a.id, a.email, ar.role 
FROM account a 
LEFT JOIN account_roles ar ON a.id = ar.account_id 
WHERE a.email = 'admin.nguyen@smartfarm.com';
```

### Option 2: Đăng Ký Tài Khoản Mới

Vì tất cả user mới đăng ký đều là ADMIN:
1. Vào trang đăng ký
2. Đăng ký với email/password mới
3. Tài khoản mới sẽ tự động có role ADMIN

### Option 3: Tạo Tài Khoản Qua API

**Trên VPS:**
```bash
curl -X POST http://173.249.48.25:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Admin User",
    "email": "newadmin@smartfarm.com",
    "password": "admin123"
  }'
```

## 🔍 Kiểm Tra Menu "Quản lý tài khoản"

Sau khi đăng nhập thành công:

1. **Kiểm tra Console:**
   ```javascript
   // Xem JWT token có role ADMIN không
   const token = localStorage.getItem('token');
   const payload = JSON.parse(atob(token.split('.')[1]));
   console.log('Roles in token:', payload.roles);
   ```

2. **Kiểm tra RoleGuard:**
   - Mở Console, tìm log: `🔍 JWT token decoded:`
   - Xem `roles` array có chứa `"ADMIN"` không

3. **Kiểm tra Menu:**
   - Menu "Quản lý tài khoản" chỉ hiển thị khi:
     - JWT token có `roles: ["ADMIN"]`
     - RoleGuard decode thành công
     - `allowedRoles={['ADMIN']}` match với role trong token

## 📝 Lưu Ý

- **Password trong database đã được hash** (BCrypt), không phải plain text
- **Menu "Quản lý tài khoản" chỉ hiển thị cho ADMIN** (theo code)
- **JWT token phải chứa role ADMIN** để menu hiển thị
- **Nếu vẫn không hiển thị**, kiểm tra:
  - JWT token có role ADMIN không
  - RoleGuard có decode đúng không
  - Console có lỗi gì không

---

**Chúc bạn fix thành công! 🎉**

