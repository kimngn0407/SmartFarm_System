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


    @GetMapping("/latest/{sensorId}")
    public ResponseEntity<List<SensorDataDTO>> getLatestSensorData(@PathVariable Long sensorId) {
        List<SensorDataDTO> latestData = sensorDataService.getLatestDataBySensorId(sensorId);
        return ResponseEntity.ok(latestData);
    }

}
