# 🔧 Fix Script Permissions

## Lỗi: Permission denied

```bash
./check-deployment.sh: Permission denied
```

## ✅ Giải pháp

Chạy lệnh này trên VPS:

```bash
cd ~/projects/SmartFarm
chmod +x check-deployment.sh deploy.sh
./check-deployment.sh
```

## Hoặc chạy trực tiếp với bash:

```bash
bash check-deployment.sh
```

