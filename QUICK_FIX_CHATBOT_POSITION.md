# 🔧 Quick Fix - Cố định Chatbot ở Góc Phải Màn Hình

## ✅ Đã sửa

- ✅ Xóa tính năng draggable (kéo thả)
- ✅ Cố định chatbot ở góc phải màn hình
- ✅ Vị trí: `right: 24px`, `bottom: 24px`

## 🚀 Deploy lên VPS

### Bước 1: Pull code mới

```bash
ssh root@109.205.180.72
cd /opt/SmartFarm

# Pull code mới
git pull origin main
```

### Bước 2: Rebuild frontend

```bash
# Rebuild frontend container
docker compose build frontend

# Restart frontend
docker compose restart frontend

# Hoặc recreate để chắc chắn
docker compose stop frontend
docker compose rm -f frontend
docker compose up -d frontend
```

### Bước 3: Kiểm tra

1. Mở browser: http://109.205.180.72
2. Click vào nút chatbot (góc phải dưới)
3. Chatbot sẽ xuất hiện ở góc phải màn hình và **KHÔNG thể kéo thả** nữa

## 📝 Thay đổi

**Trước:**
- Chatbot có thể kéo thả (draggable)
- Vị trí được lưu trong localStorage
- Có thể di chuyển đến bất kỳ đâu trên màn hình

**Sau:**
- Chatbot cố định ở góc phải màn hình
- Không thể kéo thả
- Vị trí: `right: 24px`, `bottom: 24px`

## 🔍 Kiểm tra logs

```bash
# Xem logs frontend
docker compose logs frontend --tail=20

# Kiểm tra container status
docker compose ps frontend
```

## ⚠️ Lưu ý

- Nếu frontend không rebuild, có thể cần clear cache browser (Ctrl+Shift+R)
- Trên mobile, chatbot vẫn fullscreen như cũ
