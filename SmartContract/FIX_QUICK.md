# 🔧 Fix Nhanh: Arduino Forwarder và Oracle Node

## ❌ Vấn đề 1: PM2 không load ecosystem.config.js

**Lỗi:**
```
Error [ERR_REQUIRE_ESM]: require() of ES Module ... not supported
```

**Nguyên nhân:** `package.json` có `"type": "module"` nên `.js` files là ES modules, không thể dùng `require()`

**Giải pháp:** Đã đổi tên thành `ecosystem.config.cjs`

### Cách fix trên VPS:

```bash
cd ~/projects/SmartFarm/SmartContract/device
git pull origin main

# Start với file .cjs mới
pm2 start ecosystem.config.cjs

# Hoặc dùng file .json (không bị ảnh hưởng)
pm2 start ecosystem.config.json

# Save
pm2 save
```

---

## ❌ Vấn đề 2: Oracle Node Health Check Failed

**Kiểm tra:**

```bash
# 1. Kiểm tra Oracle Node đang chạy
pm2 status oracle-node

# 2. Xem logs
pm2 logs oracle-node --lines 50

# 3. Test health endpoint
curl http://localhost:5001/oracle/health

# 4. Kiểm tra port
netstat -tuln | grep 5001
# hoặc
ss -tuln | grep 5001
```

### Các nguyên nhân có thể:

1. **Oracle Node chưa start:**
   ```bash
   cd ~/projects/SmartFarm/SmartContract/oracle-node
   pm2 start server.js --name oracle-node
   pm2 save
   ```

2. **Thiếu .env file:**
   ```bash
   cd ~/projects/SmartFarm/SmartContract/oracle-node
   cp env.sample .env
   nano .env
   # Điền: PRIVATE_KEY, CONTRACT_ADDRESS, RPC_URL, PORT
   ```

3. **Port bị conflict:**
   ```bash
   # Kiểm tra process đang dùng port 5001
   sudo lsof -i :5001
   # Hoặc
   sudo fuser 5001/tcp
   ```

4. **Firewall block:**
   ```bash
   sudo ufw status
   sudo ufw allow 5001
   ```

---

## ✅ Setup Hoàn chỉnh (Sau khi fix)

```bash
cd ~/projects/SmartFarm/SmartContract

# 1. Pull code mới
git pull origin main

# 2. Start Arduino Forwarder với .cjs
cd device
pm2 start ecosystem.config.cjs
pm2 save

# 3. Kiểm tra Oracle Node
cd ../oracle-node
pm2 status oracle-node
# Nếu chưa chạy:
pm2 start server.js --name oracle-node
pm2 save

# 4. Kiểm tra tất cả
pm2 status
```

**Kết quả mong đợi:**
```
┌────┬────────────────────┬──────────┬──────┬───────────┐
│ id │ name               │ status  │ ↺    │ memory    │
├────┼────────────────────┼──────────┼──────┼───────────┤
│ 0  │ flask-api          │ online  │ X    │ XXmb      │
│ 1  │ oracle-node        │ online  │ X    │ XXmb      │
│ 2  │ arduino-forwarder   │ online  │ X    │ XXmb      │
└────┴────────────────────┴──────────┴──────┴───────────┘
```

---

## 🧪 Test Flow Hoàn chỉnh

```bash
# 1. Test Flask API
curl http://localhost:8000/api/sensors/latest

# 2. Test Oracle Node
curl http://localhost:5001/oracle/health
# Kết quả: {"ok":true,"status":"running",...}

# 3. Xem logs Arduino Forwarder
pm2 logs arduino-forwarder --lines 20

# 4. Cắm USB Arduino và xem logs
pm2 logs arduino-forwarder -f
```

---

## 📝 Lưu ý

1. **Dùng `.cjs` hoặc `.json`** cho PM2 config (không dùng `.js` khi package.json có `"type": "module"`)

2. **Oracle Node cần `.env`** với:
   - `PRIVATE_KEY`: Private key của wallet
   - `CONTRACT_ADDRESS`: Địa chỉ smart contract đã deploy
   - `RPC_URL`: https://rpc.zeroscan.org
   - `CHAIN_ID`: 5080
   - `PORT`: 5001

3. **API_KEY phải khớp** giữa:
   - `device/ecosystem.config.cjs` (hoặc .json)
   - `flask-api/.env`

