# 🔧 Fix Lỗi: Model chưa được load (Pest Detection Service)

## ⚠️ Lỗi

```
Error: API connection error: 500 INTERNAL SERVER ERROR
"error":"Model chưa được load"
```

**Nguyên nhân:** Model file không tồn tại trong container hoặc không được load thành công.

---

## 🔍 Kiểm Tra

### 1. Kiểm tra Pest Service đang chạy

```bash
# Trên VPS
docker compose ps pest-service
# hoặc
docker compose ps | grep pest
```

### 2. Kiểm tra logs của Pest Service

```bash
docker compose logs pest-service --tail=100
```

**Tìm các dòng:**
- `Model file không tồn tại` → Model file không có trong container
- `Model đã được load thành công` → Model đã load OK
- `⚠️ WARNING: Model chưa được load` → Model chưa load

### 3. Kiểm tra model file có trong container không

```bash
# Vào trong container
docker compose exec pest-service ls -lh /app/

# Hoặc check file cụ thể
docker compose exec pest-service ls -lh /app/best_vit_wheat_model_4classes.pth

# Kiểm tra file size (phải khoảng 343MB)
docker compose exec pest-service stat /app/best_vit_wheat_model_4classes.pth
```

**Kết quả mong đợi:**
- File phải tồn tại
- File size: ~343MB (khoảng 359,000,000 bytes)

---

## ✅ Giải Pháp

### Giải pháp 1: Model file không có trong container

**Vấn đề:** Model file không được copy vào Docker image.

**Fix:**

#### Bước 1: Kiểm tra model file có trong thư mục không

```bash
# Trên VPS
cd /opt/SmartFarm/PestAndDisease
ls -lh best_vit_wheat_model_4classes.pth
```

**Nếu không có file:**
- Model file quá lớn, có thể không được commit vào Git
- Cần copy model file vào thư mục

#### Bước 2: Copy model file (nếu cần)

```bash
# Nếu bạn có file model ở chỗ khác, copy vào:
cp /path/to/best_vit_wheat_model_4classes.pth /opt/SmartFarm/PestAndDisease/

# Hoặc download từ Git LFS (nếu dùng)
git lfs pull
```

#### Bước 3: Rebuild container

```bash
cd /opt/SmartFarm

# Rebuild pest service
docker compose build pest-service --no-cache

# Restart service
docker compose up -d --force-recreate pest-service

# Đợi khởi động (30-60 giây để load model)
sleep 60

# Kiểm tra logs
docker compose logs pest-service --tail=50
```

### Giải pháp 2: Model file bị corrupt hoặc quá nhỏ

**Vấn đề:** Model file có nhưng bị corrupt hoặc chỉ là placeholder.

**Fix:**

```bash
# Kiểm tra file size
docker compose exec pest-service stat /app/best_vit_wheat_model_4classes.pth

# File phải có size ~343MB
# Nếu nhỏ hơn 100MB → File bị corrupt hoặc không đúng
```

**Nếu file quá nhỏ:**
1. Xóa file cũ
2. Copy file model đúng vào thư mục
3. Rebuild container

### Giải pháp 3: Model load bị lỗi (architecture mismatch)

**Vấn đề:** Model file đúng nhưng không load được do architecture không khớp.

**Kiểm tra logs:**

```bash
docker compose logs pest-service | grep -i "error\|lỗi\|state_dict"
```

**Nếu thấy lỗi về state_dict:**
- Model architecture không khớp với checkpoint
- Cần kiểm tra code load model

---

## 📋 Checklist

### Trên VPS:

- [ ] Pest service đang chạy (`docker compose ps`)
- [ ] Model file tồn tại trong container (`ls -lh /app/best_vit_wheat_model_4classes.pth`)
- [ ] File size đúng (~343MB)
- [ ] Logs không có lỗi "Model file không tồn tại"
- [ ] Logs có dòng "Model đã được load thành công"

### Nếu model file không có:

- [ ] Model file có trong thư mục `PestAndDisease/` trên VPS
- [ ] Đã rebuild container với `--no-cache`
- [ ] Đã restart service
- [ ] Đã đợi đủ thời gian để load model (60 giây)

---

## 🐛 Troubleshooting

### Lỗi: "Model file không tồn tại"

**Kiểm tra:**

```bash
# 1. Check file có trong thư mục source không
cd /opt/SmartFarm/PestAndDisease
ls -lh best_vit_wheat_model_4classes.pth

# 2. Check file có trong container không
docker compose exec pest-service ls -lh /app/best_vit_wheat_model_4classes.pth

# 3. Check Dockerfile có copy file không
grep -A 2 "COPY.*pth" /opt/SmartFarm/PestAndDisease/Dockerfile
```

**Nếu file không có trong container:**
- Model file không được commit vào Git (quá lớn)
- Cần dùng Git LFS hoặc copy file thủ công

### Lỗi: "Model file quá nhỏ"

**Fix:**

```bash
# Xóa file cũ và copy file mới
cd /opt/SmartFarm/PestAndDisease
rm -f best_vit_wheat_model_4classes.pth
# Copy file model đúng vào đây (343MB)
# Sau đó rebuild
```

### Lỗi: Service không start

```bash
# Kiểm tra logs chi tiết
docker compose logs pest-service

# Kiểm tra có đủ memory không (PyTorch cần ~2GB RAM)
docker stats pest-service

# Nếu thiếu memory, cần tăng memory cho container hoặc VPS
```

---

## 💡 Lệnh Nhanh

```bash
# Kiểm tra tất cả
cd /opt/SmartFarm && \
echo "=== Service Status ===" && \
docker compose ps pest-service && \
echo "" && \
echo "=== Model File in Container ===" && \
docker compose exec pest-service ls -lh /app/best_vit_wheat_model_4classes.pth 2>/dev/null || echo "File not found" && \
echo "" && \
echo "=== Last 30 Logs ===" && \
docker compose logs pest-service --tail=30
```

---

## 📝 Lưu Ý

1. **Model file lớn (~343MB):**
   - Có thể không được commit vào Git nếu không dùng Git LFS
   - Cần copy file vào VPS thủ công nếu cần

2. **Load time:**
   - Model cần 30-60 giây để load khi service start
   - Health check có `start-period=40s` để đợi model load

3. **Memory:**
   - PyTorch + ViT model cần ~2-3GB RAM
   - Đảm bảo VPS có đủ memory

---

**Sau khi fix, test lại API:** `POST /api/pest-disease/detect`


