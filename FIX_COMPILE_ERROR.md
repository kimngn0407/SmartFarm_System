# 🔧 Fix Compile Error trên VPS

## Vấn đề: Code trên VPS vẫn còn `getName()` thay vì `getFieldName()`

## ✅ Giải pháp

### Cách 1: Commit và Push code từ local (Khuyên dùng)

Trên máy local (Windows):

```bash
cd E:\SmartFarm

# Kiểm tra thay đổi
git status

# Commit code fix
git add demoSmartFarm/demo/src/main/java/com/example/demo/Services/SensorDataService.java
git add demoSmartFarm/demo/src/main/java/com/example/demo/Security/SecurityConfig.java
git commit -m "Fix: Use getFieldName() and allow dashboard API without auth"

# Push lên GitHub
git push
```

Sau đó trên VPS:

```bash
cd ~/projects/SmartFarm
git pull
docker compose build --no-cache backend
docker compose restart backend
```

### Cách 2: Sửa trực tiếp trên VPS

Trên VPS:

```bash
cd ~/projects/SmartFarm

# Sửa file trực tiếp
nano demoSmartFarm/demo/src/main/java/com/example/demo/Services/SensorDataService.java
```

Tìm và thay thế 3 chỗ:
- Dòng 78: `getName()` → `getFieldName()`
- Dòng 99: `getName()` → `getFieldName()`
- Dòng 127: `getName()` → `getFieldName()`

Sau đó:

```bash
# Rebuild
docker compose build --no-cache backend
docker compose restart backend
```

### Cách 3: Dùng sed để sửa tự động

Trên VPS:

```bash
cd ~/projects/SmartFarm

# Sửa tự động
sed -i 's/\.getField()\.getName()/\.getField()\.getFieldName()/g' demoSmartFarm/demo/src/main/java/com/example/demo/Services/SensorDataService.java

# Kiểm tra đã sửa đúng chưa
grep -n "getFieldName\|getName" demoSmartFarm/demo/src/main/java/com/example/demo/Services/SensorDataService.java

# Rebuild
docker compose build --no-cache backend
docker compose restart backend
```

---

## ✅ Sau khi sửa

Kiểm tra compile thành công:

```bash
docker compose logs backend | grep -i "started\|BUILD SUCCESS"
```

Test API:

```bash
curl http://localhost:8080/api/sensor-data/dashboard
```

