# 🔧 Fix Lỗi Compile SensorDataController.java

## 🔍 Vấn Đề

**Lỗi compile trên VPS:**
```
[ERROR] /app/src/main/java/com/example/demo/Controllers/SensorDataController.java:[54,12] class, interface, enum, or record expected
[ERROR] /app/src/main/java/com/example/demo/Controllers/SensorDataController.java:[54,82] class, interface, enum, or record expected
[ERROR] /app/src/main/java/com/example/demo/Controllers/SensorDataController.java:[56,9] class, interface, enum, or record expected
[ERROR] /app/src/main/java/com/example/demo/Controllers/SensorDataController.java:[57,5] class, interface, enum, or record expected
```

**Nguyên nhân:**
- File trên VPS vẫn còn duplicate code hoặc code cũ
- Git pull có thể không cập nhật đúng file

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra File Trên VPS

```bash
cd /opt/SmartFarm

# Xem nội dung file trên VPS
cat demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java

# Đếm số dòng
wc -l demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java

# Phải có 50 dòng (không phải 60)
```

---

### Bước 2: Force Pull Code Mới

```bash
# Discard local changes và pull lại
cd /opt/SmartFarm

# Backup file hiện tại (nếu cần)
cp demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java SensorDataController.java.backup

# Reset file về version từ git
git checkout HEAD -- demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java

# Pull lại
git pull origin main

# Kiểm tra file đã đúng chưa
cat demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java | tail -10
```

---

### Bước 3: Kiểm Tra File Phải Có

**File phải kết thúc như sau:**
```java
    @GetMapping("/latest/{sensorId}")
    public ResponseEntity<List<SensorDataDTO>> getLatestSensorData(@PathVariable Long sensorId) {
        List<SensorDataDTO> latestData = sensorDataService.getLatestDataBySensorId(sensorId);
        return ResponseEntity.ok(latestData);
    }

}
```

**KHÔNG được có:**
- Duplicate method `getLatestSensorData`
- Dấu `}` thừa
- Code sau dòng 50

---

### Bước 4: Rebuild Backend

```bash
# Rebuild backend
docker compose build backend

# Nếu vẫn lỗi, xóa cache và rebuild
docker compose build --no-cache backend

# Recreate container
docker compose up -d --force-recreate backend

# Đợi backend khởi động
sleep 45

# Kiểm tra logs
docker compose logs backend --tail=50
```

---

## 🚨 Nếu Vẫn Lỗi

### Option 1: Xóa File và Pull Lại

```bash
cd /opt/SmartFarm

# Xóa file
rm demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java

# Pull lại từ git
git checkout HEAD -- demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java

# Kiểm tra
cat demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java
```

### Option 2: Copy File Đúng Từ Local

**Nếu bạn có quyền truy cập local, copy file đúng:**

```bash
# Trên local (Windows), tạo file tạm
# Copy nội dung file SensorDataController.java đúng vào file mới

# Trên VPS, tạo file mới:
nano demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java

# Paste nội dung đúng (50 dòng)
# Save và exit (Ctrl+X, Y, Enter)
```

---

## 📋 File Đúng (50 dòng)

```java
package com.example.demo.Controllers;

import com.example.demo.DTO.SensorDataDTO;
import com.example.demo.Services.SensorDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/sensor-data")
public class SensorDataController {

    @Autowired
    private SensorDataService sensorDataService;

    @PostMapping
    public SensorDataDTO saveSensorData(@RequestBody SensorDataDTO dto) {
        return sensorDataService.saveSensorData(dto);
    }

    /**
     * Public endpoint cho IoT devices - không cần authentication
     * Sử dụng endpoint này để gửi dữ liệu từ Arduino/ESP32
     */
    @PostMapping("/iot")
    public SensorDataDTO saveSensorDataFromIoT(@RequestBody SensorDataDTO dto) {
        return sensorDataService.saveSensorData(dto);
    }

    @GetMapping
    public List<SensorDataDTO> getSensorData(
            @RequestParam Long sensorId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to
    ) {
        return sensorDataService.getSensorData(sensorId, from, to);
    }

    @GetMapping("/latest/{sensorId}")
    public ResponseEntity<List<SensorDataDTO>> getLatestSensorData(@PathVariable Long sensorId) {
        List<SensorDataDTO> latestData = sensorDataService.getLatestDataBySensorId(sensorId);
        return ResponseEntity.ok(latestData);
    }

}
```

---

## ✅ Checklist

- [ ] Đã kiểm tra file trên VPS có đúng 50 dòng
- [ ] Đã reset file về version từ git (`git checkout HEAD --`)
- [ ] Đã pull code mới (`git pull origin main`)
- [ ] Đã kiểm tra file không có duplicate code
- [ ] Đã rebuild backend (`docker compose build backend`)
- [ ] Đã recreate backend container
- [ ] Đã kiểm tra logs không còn compile errors

---

**Hãy reset file và rebuild lại!** 🔧✨

