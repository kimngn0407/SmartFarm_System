# ⚡ Hướng Dẫn Nhanh Bật Lại Cảnh Báo - Cho Ngày Thi

> **⏱️ Thời gian:** 5-10 phút

---

## 🚀 CÁCH NHANH NHẤT

### Trên VPS:

```bash
# 1. SSH vào VPS
ssh root@your-vps-ip
cd ~/projects/SmartFarm

# 2. Pull code mới (nếu đã commit code bật lại)
git pull origin main

# HOẶC chạy script tự động:
chmod +x enable_alerts_for_demo.sh
./enable_alerts_for_demo.sh

# 3. Rebuild backend
docker-compose up -d --build backend

# 4. Kiểm tra
docker-compose logs -f backend
```

---

## ✅ CHECKLIST NHANH

Sau khi chạy script hoặc sửa thủ công, kiểm tra:

- [ ] Backend đã rebuild: `docker-compose ps backend`
- [ ] Logs không có lỗi: `docker-compose logs backend | tail -50`
- [ ] Thấy dòng "🔄 Bắt đầu tạo alerts" trong logs (sau 5 phút)
- [ ] Test API: `curl -X POST http://your-vps-ip:8080/api/alerts/generate/now`

---

## 📋 CÁC FILE CẦN SỬA (Nếu làm thủ công)

1. **AlertSchedulerService.java** - Uncomment `@Scheduled`
2. **AlertService.java** - Xóa early return, uncomment code
3. **AlertController.java** - Uncomment API endpoints
4. **EmailService.java** - Uncomment `@Service`, xóa early return
5. **application-prod.properties** - Uncomment email config
6. **docker-compose.yml** - Uncomment và set MAIL_*

---

## 📖 XEM HƯỚNG DẪN CHI TIẾT

Xem file: **`HUONG_DAN_BAT_LAI_CANH_BAO.md`** để biết chi tiết từng bước.

---

## 🔄 SAU KHI THI

```bash
# Tắt lại
chmod +x disable_alerts_after_demo.sh
./disable_alerts_after_demo.sh

# Hoặc pull code đã tắt
git pull origin main
docker-compose up -d --build backend
```

---

**Chúc bạn thi tốt! 🎉**

