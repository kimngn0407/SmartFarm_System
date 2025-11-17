# ✅ Post-Deployment Checklist

## 🎉 Deployment Status: SUCCESS!

Tất cả critical services đều healthy:
- ✅ Backend API (8080)
- ✅ Frontend (80)
- ✅ Database (5432)
- ✅ Crop ML Service (5000)
- ✅ Pest ML Service (5001)
- ✅ Chatbot (9002)

---

## ⚠️ Cần kiểm tra

### 1. Nginx đang Restarting

```bash
# Kiểm tra logs nginx
docker compose logs nginx

# Nếu có lỗi, có thể tạm thời tắt nginx (không bắt buộc)
docker compose stop nginx
```

**Lưu ý**: Nginx là optional, frontend vẫn chạy được trên port 80.

### 2. Kiểm tra IPv4 Address

IP hiển thị là IPv6. Cần lấy IPv4:

```bash
# Lấy IPv4
hostname -I | awk '{print $1}'

# Hoặc
curl -4 ifconfig.me
```

### 3. Kiểm tra Ports (thay netstat)

```bash
# Dùng ss thay vì netstat
ss -tuln | grep -E ':(80|8080|9002)'

# Hoặc dùng docker
docker compose ps
```

---

## 🌐 Truy cập từ Browser

### Lấy IP VPS:

```bash
# IPv4
curl -4 ifconfig.me

# Hoặc xem trong VPS panel
```

### Truy cập:

- **Frontend**: `http://YOUR_VPS_IP`
- **Backend API**: `http://YOUR_VPS_IP:8080`
- **Chatbot**: `http://YOUR_VPS_IP:9002`

---

## 🔍 Kiểm tra chi tiết

### 1. Test Backend API

```bash
# Health check
curl http://localhost:8080/actuator/health

# Test endpoint mới (Dashboard sensor data)
curl http://localhost:8080/api/sensor-data/dashboard
```

### 2. Test Frontend

```bash
curl http://localhost:80 | head -20
```

### 3. Kiểm tra Database

```bash
# Kết nối database
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# Kiểm tra bảng sensor_data
SELECT COUNT(*) FROM "Sensor_data";
SELECT * FROM "Sensor_data" ORDER BY "time" DESC LIMIT 5;

# Thoát
\q
```

---

## 📊 Monitoring

### Xem logs real-time:

```bash
# Tất cả services
docker compose logs -f

# Từng service
docker compose logs -f backend
docker compose logs -f frontend
```

### Xem resource usage:

```bash
docker stats
```

---

## 🚀 Next Steps

1. ✅ **Truy cập Frontend**: Mở browser và vào `http://YOUR_VPS_IP`
2. ✅ **Test Dashboard**: Kiểm tra xem dữ liệu IoT có hiển thị không
3. ✅ **Setup ESP32**: Theo hướng dẫn trong `SmartContract/device/ESP32_SETUP_GUIDE.md`
4. ✅ **Cấu hình Firewall**: Mở ports cần thiết

---

## 🔧 Troubleshooting

### Nếu không truy cập được từ browser:

1. **Kiểm tra Firewall**:
```bash
# Xem firewall rules
ufw status

# Mở ports nếu cần
ufw allow 80/tcp
ufw allow 8080/tcp
ufw allow 9002/tcp
```

2. **Kiểm tra VPS Provider Firewall**:
   - Vào VPS control panel
   - Mở ports: 80, 8080, 9002

3. **Test từ VPS**:
```bash
# Test local
curl http://localhost:80
curl http://localhost:8080/actuator/health

# Nếu local OK nhưng không truy cập được từ ngoài → Firewall issue
```

---

## ✅ Deployment Complete!

Hệ thống đã sẵn sàng. Bạn có thể:
- Truy cập frontend để quản lý nông trại
- Kết nối ESP32 để gửi dữ liệu IoT
- Sử dụng dashboard để xem dữ liệu cảm biến thật

