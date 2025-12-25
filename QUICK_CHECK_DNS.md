# 🔍 Kiểm Tra DNS Nhanh - Windows

## ✅ Lệnh Đúng

```powershell
# Phải có domain đầy đủ
nslookup smartfarm.codex.io.vn
```

**KHÔNG phải:**
```powershell
nslookup smartfarm  # ❌ Sai - thiếu domain
```

---

## 📋 Các Lệnh Kiểm Tra

### 1. Kiểm Tra A Record (IPv4)

```powershell
nslookup smartfarm.codex.io.vn
```

**Kết quả mong đợi:**
```
Name:    smartfarm.codex.io.vn
Address:  109.205.180.72
```

---

### 2. Kiểm Tra Bằng PowerShell

```powershell
Resolve-DnsName -Name smartfarm.codex.io.vn -Type A
```

**Kết quả mong đợi:**
```
Name           Type   TTL   Section    IPAddress
----           ----   ---   -------    ---------
smartfarm.codex.io.vn A      3600   Answer     109.205.180.72
```

---

### 3. Kiểm Tra Online (Không Cần Cài Gì)

**Mở trình duyệt:**
- https://dnschecker.org/#A/smartfarm.codex.io.vn
- https://www.whatsmydns.net/#A/smartfarm.codex.io.vn

**Nhập:** `smartfarm.codex.io.vn`  
**Chọn:** `A Record`  
**Kết quả mong đợi:** `109.205.180.72`

---

## ⚠️ Nếu Vẫn Thấy IPv6

**Kiểm tra:**
```powershell
# Kiểm tra A record (IPv4)
Resolve-DnsName -Name smartfarm.codex.io.vn -Type A

# Kiểm tra AAAA record (IPv6)
Resolve-DnsName -Name smartfarm.codex.io.vn -Type AAAA
```

**Nếu chỉ có AAAA (IPv6):**
- Cần thêm A record trong DNS provider
- Xem hướng dẫn: `FIX_DNS_ISSUE.md`

---

## 🔧 Xóa DNS Cache

**Nếu DNS đã sửa nhưng vẫn thấy IP cũ:**
```powershell
ipconfig /flushdns
nslookup smartfarm.codex.io.vn
```

---

**Hãy chạy: `nslookup smartfarm.codex.io.vn` (có domain đầy đủ)!** 🔍✨
