# 🔍 Kiểm Tra DNS Trên Windows

## ✅ Các Lệnh Kiểm Tra DNS

### Cách 1: Sử Dụng nslookup (Có Sẵn)

```powershell
# Kiểm tra A record (IPv4)
nslookup smartfarm.codex.io.vn

# Hoặc chỉ lấy IP
nslookup -type=A smartfarm.codex.io.vn
```

**Kết quả mong đợi:**
```
Name:    smartfarm.codex.io.vn
Address:  109.205.180.72
```

---

### Cách 2: Sử Dụng Resolve-DnsName (PowerShell)

```powershell
# Kiểm tra A record
Resolve-DnsName -Name smartfarm.codex.io.vn -Type A

# Hoặc chỉ lấy IP
(Resolve-DnsName -Name smartfarm.codex.io.vn -Type A).IPAddress
```

**Kết quả mong đợi:**
```
Name           Type   TTL   Section    IPAddress
----           ----   ---   -------    ---------
smartfarm.codex.io.vn A      3600   Answer     109.205.180.72
```

---

### Cách 3: Kiểm Tra Bằng Online Tool

**Không cần cài đặt gì:**
- https://dnschecker.org/#A/smartfarm.codex.io.vn
- https://www.whatsmydns.net/#A/smartfarm.codex.io.vn
- https://mxtoolbox.com/DNSLookup.aspx

**Nhập:** `smartfarm.codex.io.vn`  
**Chọn:** `A Record`  
**Kết quả mong đợi:** `109.205.180.72`

---

## 🔧 Script Kiểm Tra DNS Nhanh

**Tạo file `check-dns.ps1`:**
```powershell
# check-dns.ps1
$domain = "smartfarm.codex.io.vn"
$expectedIP = "109.205.180.72"

Write-Host "🔍 Checking DNS for $domain" -ForegroundColor Cyan
Write-Host ""

try {
    $result = Resolve-DnsName -Name $domain -Type A -ErrorAction Stop
    
    if ($result) {
        $ip = $result.IPAddress
        Write-Host "✅ DNS A record found: $ip" -ForegroundColor Green
        
        if ($ip -eq $expectedIP) {
            Write-Host "✅ DNS points to correct IP: $expectedIP" -ForegroundColor Green
        } else {
            Write-Host "⚠️  WARNING: DNS points to $ip, expected $expectedIP" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "❌ ERROR: No A record found for $domain" -ForegroundColor Red
    Write-Host "   Please add A record: smartfarm → $expectedIP" -ForegroundColor Yellow
}
```

**Chạy:**
```powershell
.\check-dns.ps1
```

---

## 🐛 Troubleshooting

### Vẫn Thấy IPv6 Thay Vì IPv4

**Kiểm tra:**
```powershell
# Kiểm tra A record (IPv4)
Resolve-DnsName -Name smartfarm.codex.io.vn -Type A

# Kiểm tra AAAA record (IPv6)
Resolve-DnsName -Name smartfarm.codex.io.vn -Type AAAA
```

**Nếu chỉ có AAAA (IPv6):**
- Cần thêm A record trong DNS provider
- Xem hướng dẫn trong `FIX_DNS_ISSUE.md`

---

### Xóa DNS Cache

**Nếu DNS đã sửa nhưng vẫn thấy IP cũ:**
```powershell
# Xóa DNS cache
ipconfig /flushdns

# Kiểm tra lại
nslookup smartfarm.codex.io.vn
```

---

### Kiểm Tra Từ DNS Server Khác

**Dùng Google DNS:**
```powershell
nslookup smartfarm.codex.io.vn 8.8.8.8
```

**Dùng Cloudflare DNS:**
```powershell
nslookup smartfarm.codex.io.vn 1.1.1.1
```

---

## 📋 Checklist

- [ ] A record tồn tại: `smartfarm.codex.io.vn` → `109.205.180.72`
- [ ] DNS đã propagate (kiểm tra bằng nslookup)
- [ ] Ping domain thành công: `ping smartfarm.codex.io.vn`
- [ ] HTTP request thành công: `curl http://smartfarm.codex.io.vn`

---

**Hãy dùng `nslookup` hoặc `Resolve-DnsName` trên Windows!** 🔍✨
