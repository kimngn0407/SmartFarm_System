#!/bin/bash
# Script để fix SensorDataController.java trên VPS

cd /opt/SmartFarm

FILE_PATH="demoSmartFarm/demo/src/main/java/com/example/demo/Controllers/SensorDataController.java"

echo "🔧 Fixing SensorDataController.java..."

# Backup file hiện tại
cp "$FILE_PATH" "$FILE_PATH.backup.$(date +%Y%m%d_%H%M%S)"

# Xóa file và tạo lại với nội dung đúng
cat > "$FILE_PATH" << 'EOF'
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
EOF

# Kiểm tra file đã đúng chưa
LINE_COUNT=$(wc -l < "$FILE_PATH")
echo "✅ File đã được sửa. Số dòng: $LINE_COUNT (phải là 50 hoặc 51)"

# Kiểm tra không có duplicate
DUPLICATE_COUNT=$(grep -c "getLatestSensorData" "$FILE_PATH")
if [ "$DUPLICATE_COUNT" -gt 1 ]; then
    echo "❌ Vẫn còn duplicate! Có $DUPLICATE_COUNT lần xuất hiện 'getLatestSensorData'"
    exit 1
else
    echo "✅ Không có duplicate method"
fi

# Xem 5 dòng cuối
echo ""
echo "📄 5 dòng cuối của file:"
tail -5 "$FILE_PATH"

echo ""
echo "✅ File đã được sửa thành công!"
echo "📝 Bước tiếp theo: Rebuild backend"
echo "   docker compose build backend"
echo "   docker compose up -d --force-recreate backend"
