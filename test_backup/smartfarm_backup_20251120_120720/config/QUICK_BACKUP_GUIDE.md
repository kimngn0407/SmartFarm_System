# ⚡ Hướng Dẫn Nhanh Backup VPS - Trước Khi Gia Hạn

> **⏱️ Thời gian:** 10-15 phút

---

## 🚀 CÁCH NHANH NHẤT

### Trên VPS:

```bash
# 1. SSH vào VPS
ssh root@your-vps-ip
cd ~/projects/SmartFarm

# 2. Chạy script backup
chmod +x backup_system.sh
./backup_system.sh

# 3. Tải backup về local (từ máy local)
scp root@your-vps-ip:~/projects/SmartFarm/backups/smartfarm_backup_*.tar.gz ./
```

---

## 📋 CHECKLIST

- [ ] Đã chạy script backup
- [ ] Đã tải file backup về local
- [ ] Đã lưu backup ở cloud (Google Drive/Dropbox)
- [ ] Đã ghi lại IP VPS và thông tin đăng nhập
- [ ] Đã sẵn sàng gia hạn VPS

---

## 🔄 SAU KHI GIA HẠN

```bash
# 1. Setup Docker trên VPS mới
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# 2. Upload backup lên VPS
scp smartfarm_backup_*.tar.gz root@your-vps-ip:~/

# 3. Restore hệ thống
ssh root@your-vps-ip
mkdir -p ~/projects/SmartFarm
cd ~/projects/SmartFarm
tar -xzf ~/smartfarm_backup_*.tar.gz -C ./backups/
chmod +x restore_system.sh
./restore_system.sh smartfarm_backup_YYYYMMDD_HHMMSS
```

---

## 📖 XEM HƯỚNG DẪN CHI TIẾT

Xem file: **`HUONG_DAN_BACKUP_VA_GIA_HAN_VPS.md`**

---

**Lưu ý:** Luôn backup trước khi gia hạn! 💾

