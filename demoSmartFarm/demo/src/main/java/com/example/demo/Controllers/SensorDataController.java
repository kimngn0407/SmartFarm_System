package com.example.demo.Controllers;

import com.example.demo.DTO.SensorDataDTO;
import com.example.demo.DTO.DashboardSensorDataDTO;
import com.example.demo.Services.SensorDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/sensor-data")
public class SensorDataController {

    @Autowired
    private SensorDataService sensorDataService;

    @PostMapping
    public SensorDataDTO saveSensorData(@RequestBody SensorDataDTO dto) {
        return sensorDataService.saveSensorData(dto);
    }

    @GetMapping
    public List<SensorDataDTO> getSensorData(
            @RequestParam(required = false) Long sensorId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to
    ) {
        if (sensorId != null && from != null && to != null) {
            return sensorDataService.getSensorData(sensorId, from, to);
        }
        // Nếu không có params, trả về empty list hoặc lỗi
        return List.of();
    }

    @GetMapping("/latest/{sensorId}")
    public ResponseEntity<List<SensorDataDTO>> getLatestSensorData(@PathVariable Long sensorId) {
        List<SensorDataDTO> latestData = sensorDataService.getLatestDataBySensorId(sensorId);
        return ResponseEntity.ok(latestData);
    }

    /**
     * Endpoint mới cho Dashboard - Lấy dữ liệu theo type và fieldId
     */
    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> getDashboardSensorData(
            @RequestParam(required = false) Long fieldId,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to
    ) {
        Map<String, Object> response = new HashMap<>();
        
        // Nếu không có from/to, mặc định lấy 12 giờ gần nhất
        if (from == null || to == null) {
            to = LocalDateTime.now();
            from = to.minusHours(12);
        }
        
        if (fieldId != null && type != null) {
            // Lấy theo fieldId và type
            List<DashboardSensorDataDTO> data = sensorDataService.getSensorDataByFieldAndType(
                    fieldId, type, from, to);
            response.put("data", data);
            response.put("average", sensorDataService.getAverageValueByType(type, from, to));
        } else if (type != null) {
            // Lấy theo type (tất cả fields)
            List<DashboardSensorDataDTO> data = sensorDataService.getSensorDataByType(type, from, to);
            response.put("data", data);
            response.put("average", sensorDataService.getAverageValueByType(type, from, to));
        } else {
            // Lấy tất cả types cho dashboard
            List<DashboardSensorDataDTO> tempData = sensorDataService.getSensorDataByType("Temperature", from, to);
            List<DashboardSensorDataDTO> humData = sensorDataService.getSensorDataByType("Humidity", from, to);
            List<DashboardSensorDataDTO> soilData = sensorDataService.getSensorDataByType("Soil Moisture", from, to);
            List<DashboardSensorDataDTO> lightData = sensorDataService.getSensorDataByType("Light", from, to);
            
            response.put("temperature", tempData);
            response.put("humidity", humData);
            response.put("soilMoisture", soilData);
            response.put("light", lightData);
            
            response.put("avgTemperature", sensorDataService.getAverageValueByType("Temperature", from, to));
            response.put("avgHumidity", sensorDataService.getAverageValueByType("Humidity", from, to));
            response.put("avgSoilMoisture", sensorDataService.getAverageValueByType("Soil Moisture", from, to));
            response.put("avgLight", sensorDataService.getAverageValueByType("Light", from, to));
        }
        
        return ResponseEntity.ok(response);
    }

    /**
     * Endpoint để lấy dữ liệu mới nhất theo type (cho real-time updates)
     */
    @GetMapping("/latest/type/{type}")
    public ResponseEntity<List<DashboardSensorDataDTO>> getLatestDataByType(
            @PathVariable String type,
            @RequestParam(defaultValue = "12") int limit
    ) {
        List<DashboardSensorDataDTO> latestData = sensorDataService.getLatestDataByType(type, limit);
        return ResponseEntity.ok(latestData);
    }

}
