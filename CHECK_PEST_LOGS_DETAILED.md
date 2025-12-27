# 🔍 Kiểm Tra Chi Tiết Pest Service Logs

## 📋 Các Lệnh Kiểm Tra

### 1. Xem logs khi service khởi động (quan trọng nhất!)

```bash
# Xem logs từ đầu (khi service start)
docker compose logs pest-service | grep -A 50 "Loading\|model\|Model\|ERROR\|WARNING\|success"
```

Hoặc xem toàn bộ logs từ đầu:
```bash
docker compose logs pest-service 2>&1 | head -200
```

### 2. Kiểm tra model file

```bash
# Kiểm tra file có trong container không
docker compose exec pest-service ls -lh /app/best_vit_wheat_model_4classes.pth

# Kiểm tra file có trong source code không
ls -lh /opt/SmartFarm/PestAndDisease/best_vit_wheat_model_4classes.pth
```

### 3. Xem error logs chi tiết

```bash
# Xem tất cả error và warning
docker compose logs pest-service 2>&1 | grep -i "error\|warning\|lỗi\|exception" -A 5

# Xem logs khi có request đến /api/detect
docker compose logs pest-service 2>&1 | grep -A 10 "POST /api/detect"
```

### 4. Test trực tiếp trong container

```bash
# Vào container
docker compose exec pest-service python -c "
import os
print('Current dir:', os.getcwd())
print('Files:', os.listdir('.'))
if os.path.exists('best_vit_wheat_model_4classes.pth'):
    size = os.path.getsize('best_vit_wheat_model_4classes.pth')
    print(f'Model file exists: {size} bytes')
else:
    print('Model file NOT FOUND!')
"
```

---

## 🔍 Những Gì Cần Tìm

### ✅ Nếu model đã load thành công, sẽ thấy:

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

### ❌ Nếu model chưa load, sẽ thấy một trong các lỗi:

**Lỗi 1: File không tồn tại**
```
ERROR: Model file không tồn tại: best_vit_wheat_model_4classes.pth
ERROR: Current working directory: /app
ERROR: Files in current directory: [...]
```

**Lỗi 2: File quá nhỏ**
```
ERROR: Model file quá nhỏ (xxx bytes), có thể bị corrupt
```

**Lỗi 3: Load checkpoint lỗi**
```
ERROR: Lỗi khi load checkpoint: ...
```

**Lỗi 4: State dict không khớp**
```
ERROR: Lỗi khi load state_dict: ...
ERROR: Có thể model architecture không khớp với checkpoint
```

**Hoặc chỉ thấy warning:**
```
⚠️  WARNING: Model chưa được load. API /api/detect sẽ trả về lỗi.
⚠️  Service vẫn chạy để health check hoạt động.
```

---

## 💡 Lệnh Tất-Cả-Trong-Một

```bash
echo "=== Checking Pest Service Model ===" && \
echo "" && \
echo "1. Model file in container:" && \
docker compose exec pest-service ls -lh /app/best_vit_wheat_model_4classes.pth 2>&1 && \
echo "" && \
echo "2. Model file in source:" && \
ls -lh /opt/SmartFarm/PestAndDisease/best_vit_wheat_model_4classes.pth 2>&1 && \
echo "" && \
echo "3. Model load logs:" && \
docker compose logs pest-service 2>&1 | grep -i "model\|loading\|success\|error\|warning" | head -30 && \
echo "" && \
echo "4. Recent error logs:" && \
docker compose logs pest-service 2>&1 | grep -i "error\|exception" | tail -10
```

---

Chạy các lệnh trên và gửi kết quả cho tôi!


