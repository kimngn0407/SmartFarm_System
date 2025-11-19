# 🔧 XỬ LÝ VPS RESET LIÊN TỤC

Chào anh Tèo! VPS reset liên tục thường do các nguyên nhân sau. Hướng dẫn kiểm tra và xử lý:

---

## 🔍 NGUYÊN NHÂN THƯỜNG GẶP

1. **Hết RAM (OOM - Out of Memory)** - Phổ biến nhất
2. **CPU quá tải** - Process chiếm 100% CPU
3. **Disk đầy** - Không còn dung lượng
4. **Services crash và restart liên tục** - PM2/systemd loop
5. **Swap không đủ** - Cần thêm swap space
6. **VPS provider có vấn đề** - Hardware/network issue

---

## 🔍 BƯỚC 1: KIỂM TRA LOGS HỆ THỐNG

### 1.1. Kiểm tra system logs

```bash
# Xem logs hệ thống (sau khi reconnect)
journalctl -xe | tail -50

# Xem logs OOM (Out of Memory)
dmesg | grep -i "out of memory"
dmesg | grep -i "killed process"

# Xem logs systemd
journalctl -p err -b | tail -50
```

### 1.2. Kiểm tra lịch sử reboot

```bash
# Xem lịch sử reboot
last reboot

# Xem uptime
uptime

# Xem thời gian hệ thống
date
```

---

## 🔍 BƯỚC 2: KIỂM TRA TÀI NGUYÊN HỆ THỐNG

### 2.1. Kiểm tra RAM

```bash
# Xem RAM hiện tại
free -h

# Xem process sử dụng RAM nhiều nhất
ps aux --sort=-%mem | head -10

# Xem memory usage chi tiết
cat /proc/meminfo | grep -E "MemTotal|MemFree|MemAvailable|SwapTotal|SwapFree"
```

**Nếu RAM < 100MB free → Cần tối ưu hoặc nâng cấp**

### 2.2. Kiểm tra CPU

```bash
# Xem CPU usage
top
# Hoặc
htop  # Nếu đã cài

# Xem process sử dụng CPU nhiều nhất
ps aux --sort=-%cpu | head -10

# Xem load average
uptime
```

**Nếu load average > số cores → CPU quá tải**

### 2.3. Kiểm tra Disk

```bash
# Xem dung lượng disk
df -h

# Xem dung lượng chi tiết từng thư mục
du -sh /* 2>/dev/null | sort -h

# Xem dung lượng Docker
docker system df

# Xem logs lớn
du -sh /var/log/* 2>/dev/null | sort -h
```

**Nếu disk > 90% → Cần dọn dẹp**

### 2.4. Kiểm tra Swap

```bash
# Xem swap hiện tại
swapon --show
free -h

# Kiểm tra swap có đủ không
cat /proc/swaps
```

**Nếu không có swap hoặc swap quá nhỏ → Cần tạo swap**

---

## 🔧 BƯỚC 3: XỬ LÝ CÁC VẤN ĐỀ

### 3.1. TẠO/TĂNG SWAP SPACE (QUAN TRỌNG!)

Swap giúp VPS không bị OOM khi hết RAM:

```bash
# Kiểm tra swap hiện tại
free -h

# Tạo swap file 2GB (điều chỉnh theo nhu cầu)
sudo fallocate -l 2G /swapfile
# Hoặc nếu fallocate không có:
# sudo dd if=/dev/zero of=/swapfile bs=1024 count=2097152

# Set quyền
sudo chmod 600 /swapfile

# Tạo swap
sudo mkswap /swapfile

# Kích hoạt swap
sudo swapon /swapfile

# Kiểm tra lại
free -h

# Lưu vĩnh viễn (tự động mount khi reboot)
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Tối ưu swappiness (độ ưu tiên dùng swap)
# Giá trị 10-60 là hợp lý (mặc định 60)
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

**Lưu ý:** 
- Swap trên disk nên chậm hơn RAM
- Nên có swap = 1-2x RAM (ví dụ: 1GB RAM → 1-2GB swap)
- swappiness=10 nghĩa là chỉ dùng swap khi RAM > 90%

### 3.2. DỌN DẸP DISK

```bash
# Dọn Docker (quan trọng!)
docker system prune -a --volumes

# Xóa logs cũ
sudo journalctl --vacuum-time=7d  # Giữ logs 7 ngày
sudo find /var/log -type f -name "*.log" -mtime +30 -delete

# Xóa packages không dùng
sudo apt-get autoremove -y
sudo apt-get autoclean

# Xóa PM2 logs cũ
pm2 flush  # Xóa tất cả logs
# Hoặc xóa logs cũ hơn 7 ngày
find ~/.pm2/logs -name "*.log" -mtime +7 -delete

# Xóa npm cache
npm cache clean --force

# Xóa pip cache
pip cache purge
```

### 3.3. TỐI ƯU SERVICES

#### Giới hạn memory cho PM2

Tạo file `ecosystem.config.js` trong thư mục gốc:

```bash
cd ~/SmartContract
nano ecosystem.config.js
```

Nội dung:

```javascript
module.exports = {
  apps: [
    {
      name: 'oracle-node',
      script: 'server.js',
      cwd: '/root/SmartContract/oracle-node',
      instances: 1,
      max_memory_restart: '200M',  // Restart nếu > 200MB
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'flask-api',
      script: 'app.py',
      interpreter: 'python3',
      cwd: '/root/SmartContract/flask-api',
      instances: 1,
      max_memory_restart: '300M',  // Restart nếu > 300MB
      env: {
        FLASK_ENV: 'production'
      }
    }
  ]
};
```

Sau đó restart:

```bash
pm2 delete all
pm2 start ecosystem.config.js
pm2 save
```

#### Giới hạn memory cho Docker PostgreSQL

```bash
# Stop container
docker stop smartfarm-postgres

# Xóa container cũ
docker rm smartfarm-postgres

# Tạo lại với giới hạn memory
docker run -d \
    --name smartfarm-postgres \
    --memory="512m" \
    --memory-swap="1g" \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=smartfarm \
    -p 5432:5432 \
    -v smartfarm-data:/var/lib/postgresql/data \
    postgres:15-alpine
```

### 3.4. TỐI ƯU POSTGRESQL

```bash
# Kết nối vào PostgreSQL
docker exec -it smartfarm-postgres psql -U postgres -d smartfarm

# Xóa dữ liệu cũ (giữ lại 30 ngày gần nhất)
DELETE FROM public.sensor_data 
WHERE "time" < NOW() - INTERVAL '30 days';

# Tạo index nếu chưa có
CREATE INDEX IF NOT EXISTS idx_sensor_data_time ON public.sensor_data("time");
CREATE INDEX IF NOT EXISTS idx_sensor_data_sensor_id ON public.sensor_data(sensor_id);

# Vacuum để giải phóng space
VACUUM ANALYZE public.sensor_data;

# Thoát
\q
```

### 3.5. GIỚI HẠN LOG ROTATION

Tạo file log rotation cho PM2:

```bash
sudo nano /etc/logrotate.d/pm2
```

Nội dung:

```
/root/.pm2/logs/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root root
}
```

---

## 🔍 BƯỚC 4: KIỂM TRA SERVICES

### 4.1. Kiểm tra PM2

```bash
# Xem status
pm2 status

# Xem memory usage
pm2 monit

# Xem logs
pm2 logs --lines 100

# Kiểm tra restart count
pm2 list
```

**Nếu restart count tăng liên tục → Service đang crash**

### 4.2. Kiểm tra Docker

```bash
# Xem containers
docker ps -a

# Xem logs PostgreSQL
docker logs smartfarm-postgres --tail 50

# Xem resource usage
docker stats
```

### 4.3. Kiểm tra systemd

```bash
# Xem services failed
systemctl --failed

# Xem services đang chạy
systemctl list-units --type=service --state=running
```

---

## 🚨 BƯỚC 5: MONITORING VÀ ALERT

### 5.1. Tạo script monitoring

Tạo file `check_resources.sh`:

```bash
cd ~/SmartContract
nano check_resources.sh
```

Nội dung:

```bash
#!/bin/bash
# Script kiểm tra tài nguyên hệ thống

echo "=== KIỂM TRA TÀI NGUYÊN HỆ THỐNG ==="
echo

# RAM
echo "RAM:"
free -h
echo

# Disk
echo "Disk:"
df -h | grep -E "Filesystem|/dev/"
echo

# CPU Load
echo "CPU Load:"
uptime
echo

# Top processes by memory
echo "Top 5 processes by memory:"
ps aux --sort=-%mem | head -6
echo

# Top processes by CPU
echo "Top 5 processes by CPU:"
ps aux --sort=-%cpu | head -6
echo

# PM2 status
echo "PM2 Status:"
pm2 list
echo

# Docker containers
echo "Docker containers:"
docker ps
echo

# Check if services are running
echo "Service checks:"
curl -s http://localhost:8000/api/latest > /dev/null && echo "✓ Flask API: OK" || echo "✗ Flask API: FAILED"
curl -s http://localhost:5001/oracle/health > /dev/null && echo "✓ Oracle Node: OK" || echo "✗ Oracle Node: FAILED"
```

Cấp quyền:

```bash
chmod +x check_resources.sh
```

Chạy định kỳ:

```bash
# Chạy thủ công
./check_resources.sh

# Hoặc thêm vào crontab (mỗi 5 phút)
crontab -e
# Thêm dòng:
*/5 * * * * /root/SmartContract/check_resources.sh >> /root/SmartContract/resource_log.txt 2>&1
```

### 5.2. Setup alert khi RAM thấp

Tạo script `check_memory.sh`:

```bash
#!/bin/bash
# Kiểm tra RAM và cảnh báo

THRESHOLD=100  # MB free RAM tối thiểu
FREE_RAM=$(free -m | awk 'NR==2{print $7}')

if [ $FREE_RAM -lt $THRESHOLD ]; then
    echo "WARNING: RAM thấp! Free: ${FREE_RAM}MB"
    # Có thể gửi email hoặc log
    echo "$(date): RAM thấp - ${FREE_RAM}MB free" >> /root/SmartContract/memory_alert.log
    
    # Restart services để giải phóng memory
    pm2 restart all
fi
```

Thêm vào crontab (mỗi phút):

```bash
crontab -e
# Thêm:
* * * * * /root/SmartContract/check_memory.sh
```

---

## 🔧 BƯỚC 6: TỐI ƯU HỆ THỐNG

### 6.1. Tắt services không cần thiết

```bash
# Xem services đang chạy
systemctl list-units --type=service --state=running

# Tắt services không cần (ví dụ: snapd, bluetooth, etc.)
sudo systemctl disable snapd
sudo systemctl stop snapd
```

### 6.2. Giảm số lượng PM2 instances

Nếu đang chạy nhiều instances, giảm xuống 1:

```bash
pm2 delete all
pm2 start ecosystem.config.js --instances 1
```

### 6.3. Tối ưu PostgreSQL

Chỉnh sửa PostgreSQL config để dùng ít memory hơn:

```bash
# Vào container
docker exec -it smartfarm-postgres bash

# Chỉnh sửa postgresql.conf
# Tìm và chỉnh:
# shared_buffers = 128MB (thay vì mặc định)
# work_mem = 4MB
# maintenance_work_mem = 64MB
```

---

## 📊 CHECKLIST KIỂM TRA

Sau khi xử lý, kiểm tra:

- [ ] Đã tạo swap space (ít nhất 1GB)
- [ ] RAM free > 100MB
- [ ] Disk usage < 80%
- [ ] PM2 services không restart liên tục
- [ ] Docker containers đang chạy ổn định
- [ ] Logs không quá lớn
- [ ] CPU load < số cores
- [ ] Services response OK

---

## 🚀 LỆNH NHANH ĐỂ CHẠY NGAY

```bash
# 1. Tạo swap 2GB
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 2. Dọn Docker
docker system prune -a -f

# 3. Dọn logs
sudo journalctl --vacuum-time=3d
pm2 flush

# 4. Kiểm tra resources
free -h && df -h && uptime

# 5. Restart services
pm2 restart all
```

---

## 🔍 NẾU VẪN BỊ RESET

### Kiểm tra với VPS provider

1. **Xem monitoring từ provider dashboard:**
   - CPU usage history
   - RAM usage history
   - Network traffic
   - Disk I/O

2. **Kiểm tra hardware:**
   - Có thể VPS bị lỗi hardware
   - Liên hệ support để kiểm tra

3. **Nâng cấp VPS:**
   - Nếu RAM < 1GB → Nâng lên 2GB
   - Nếu CPU quá tải → Nâng CPU cores

### Tạo script auto-recovery

Tạo file `auto_recovery.sh`:

```bash
#!/bin/bash
# Script tự động khôi phục khi VPS restart

# Đợi hệ thống sẵn sàng
sleep 30

# Khởi động Docker container
docker start smartfarm-postgres

# Đợi PostgreSQL sẵn sàng
sleep 10

# Khởi động PM2 services
cd ~/SmartContract
pm2 resurrect
# Hoặc
# pm2 start ecosystem.config.js

# Log
echo "$(date): Auto-recovery completed" >> /root/SmartContract/recovery.log
```

Thêm vào crontab @reboot:

```bash
crontab -e
# Thêm:
@reboot /root/SmartContract/auto_recovery.sh
```

---

## 📝 TÓM TẮT

**Nguyên nhân chính VPS reset:**
1. ❌ **Hết RAM** → Tạo swap, tối ưu services
2. ❌ **Disk đầy** → Dọn dẹp logs, Docker
3. ❌ **Services crash** → Kiểm tra logs, giới hạn memory
4. ❌ **CPU quá tải** → Giảm số instances, tối ưu code

**Giải pháp ngay lập tức:**
1. ✅ Tạo swap 2GB
2. ✅ Dọn Docker và logs
3. ✅ Giới hạn memory cho PM2
4. ✅ Setup monitoring

---

**Chúc anh Tèo xử lý thành công! 🚀**

Nếu vẫn bị reset, hãy:
1. Kiểm tra logs: `journalctl -xe`
2. Kiểm tra OOM: `dmesg | grep -i "out of memory"`
3. Liên hệ VPS provider để kiểm tra hardware





