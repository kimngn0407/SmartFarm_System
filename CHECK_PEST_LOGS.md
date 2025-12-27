# 🔍 Kiểm Tra Pest Service Logs

Service đang chạy và healthy, nhưng model có thể chưa được load. Cần kiểm tra logs.

## 📋 Lệnh Kiểm Tra

### 1. Kiểm tra logs khởi động (khi service start)

```bash
docker compose logs pest-service | head -100
```

Tìm các dòng quan trọng:
- `🔄 Loading Vision Transformer model...`
- `✓ Model đã được load thành công!` ✅
- `⚠️ WARNING: Model chưa được load` ❌
- `Model file không tồn tại` ❌
- `Lỗi khi load model` ❌

### 2. Kiểm tra logs hiện tại

```bash
docker compose logs pest-service --tail=50
```

### 3. Kiểm tra model file trong container

```bash
# Kiểm tra file có tồn tại không
docker compose exec pest-service ls -lh /app/best_vit_wheat_model_4classes.pth

# Kiểm tra file size (phải ~343MB)
docker compose exec pest-service stat /app/best_vit_wheat_model_4classes.pth

# Kiểm tra working directory
docker compose exec pest-service pwd

# List files trong /app
docker compose exec pest-service ls -lh /app/
```

### 4. Test API trực tiếp

```bash
# Health check
curl http://localhost:5001/health

# Test detect endpoint (sẽ fail nếu model chưa load)
curl -X POST http://localhost:5001/api/detect \
  -F "image=@/path/to/test-image.jpg"
```

---

## 🔧 Fix Nếu Model Chưa Load

### Nếu file không tồn tại trong container:

```bash
# 1. Kiểm tra file có trong source code không
cd /opt/SmartFarm/PestAndDisease
ls -lh best_vit_wheat_model_4classes.pth

# 2. Nếu không có, cần copy vào
# (File này quá lớn để commit vào Git thông thường)
# Cần copy từ nơi khác hoặc download

# 3. Rebuild container
cd /opt/SmartFarm
docker compose build pest-service --no-cache
docker compose up -d --force-recreate pest-service

# 4. Đợi 60 giây để model load
sleep 60

# 5. Kiểm tra logs
docker compose logs pest-service --tail=50 | grep -i "model\|error\|success"
```

### Nếu file có nhưng load bị lỗi:

Xem logs chi tiết để tìm lỗi cụ thể:
```bash
docker compose logs pest-service | grep -i "error\|lỗi\|exception\|traceback" -A 10
```

---

## ✅ Kết Quả Mong Đợi

**Logs khi model load thành công:**
```
==================================================
🔄 Loading Vision Transformer model...
📂 Model Path: best_vit_wheat_model_4classes.pth
Model file size: 359000000 bytes
🏗️  Creating ViT-B/16 architecture...
📥 Loading checkpoint...
✓ Checkpoint loaded successfully
✓ Loaded from checkpoint dict
==================================================
✓ Model đã được load thành công!
✓ Architecture: Vision Transformer Base (ViT-B/16)
✓ Device: cpu
✓ Classes: 4
==================================================
```

**File trong container:**
```
-rw-r--r-- 1 appuser appuser 343M Dec 27 02:00 /app/best_vit_wheat_model_4classes.pth
```

---

Chạy các lệnh trên và cho tôi biết kết quả!


