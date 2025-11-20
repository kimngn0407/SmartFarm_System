package com.example.demo.Controllers;

import com.example.demo.DTO.AlertResponseDTO;
import com.example.demo.DTO.SensorDataLastestDTO;
import com.example.demo.Entities.AlertEntity;
import com.example.demo.Entities.FieldEntity;
import com.example.demo.Repositories.AlertRepository;
import com.example.demo.Repositories.FieldRepository;
import com.example.demo.Services.AlertService;
import com.example.demo.Services.AlertSchedulerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/alerts")
@RequiredArgsConstructor
public class AlertController {

    private final AlertService alertService;
    private final AlertRepository alertRepository;
    private final AlertSchedulerService alertSchedulerService;


    @GetMapping
    public ResponseEntity<List<AlertResponseDTO>> getAllAlerts() {
        try {
            List<AlertEntity> alerts = alertService.getAllAlerts();
            List<AlertResponseDTO> responseDTOs = alerts.stream()
                    .map(alert -> AlertResponseDTO.builder()
                            .id(alert.getId())
                            .status(alert.getStatus())
                            .message(alert.getMessage())
                            .groupType(alert.getGroupType())
                            .ownerId(alert.getOwnerId())
                            .sensorId(alert.getSensor() != null ? alert.getSensor().getId() : null)
                            .fieldId(alert.getField() != null ? alert.getField().getId() : null)
                            .type(alert.getType())
                            .value(alert.getValue())
                            .thresholdMin(alert.getThresholdMin())
                            .thresholdMax(alert.getThresholdMax())
                            .timestamp(alert.getTimestamp())
                            .fieldName(alert.getField() != null ? alert.getField().getFieldName() : null)
                            .sensorName(alert.getSensor() != null ? alert.getSensor().getSensorName() : null)
                            .build())
                    .collect(Collectors.toList());
            return ResponseEntity.ok(responseDTOs);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // ✅ Get alerts by field
    @GetMapping("/field/{fieldId}")
    public ResponseEntity<List<AlertResponseDTO>> getAlertsByField(@PathVariable Long fieldId) {
        try {
            List<AlertResponseDTO> alerts = alertService.getAlertsByField(fieldId);
            return ResponseEntity.ok(alerts);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // ✅ Resolve alert
    @PutMapping("/resolve/{alertId}")
    public ResponseEntity<String> resolveAlert(@PathVariable Long alertId) {
        try {
            alertService.resolveAlert(alertId);
            return ResponseEntity.ok("Alert resolved successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to resolve alert: " + e.getMessage());
        }
    }

    // ✅ Mark alert as read
    @PutMapping("/{alertId}/read")
    public ResponseEntity<String> markAlertAsRead(@PathVariable Long alertId) {
        try {
            alertService.markAlertAsRead(alertId);
            return ResponseEntity.ok("Alert marked as read");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to mark alert as read: " + e.getMessage());
        }
    }

//    @GetMapping("/check")
//    public ResponseEntity<List<AlertResponseDTO>> getAlerts(@RequestParam Long sensorId) {
//        List<AlertResponseDTO> alerts = alertService.createAlertsFromSensor(sensorId);
//        return ResponseEntity.ok(alerts);
//    }

    // ✅ Tạo alert từ dữ liệu mới nhất (được nạp sẵn qua cronjob hoặc nơi khác)
    @PostMapping("/generate")
    public ResponseEntity<String> generateAlertsFromLatestData(@RequestBody(required = false) List<SensorDataLastestDTO> sensorDataLastestDTOS) {
        try {
            List<AlertResponseDTO> result;
            if (sensorDataLastestDTOS != null && !sensorDataLastestDTOS.isEmpty()) {
                // Nếu có dữ liệu từ request body, dùng dữ liệu đó
                result = alertService.createAlertsForAllSensors(sensorDataLastestDTOS);
            } else {
                // Nếu không có dữ liệu, tự động lấy dữ liệu mới nhất từ database
                // (Cần inject AlertSchedulerService vào controller)
                result = alertService.createAlertsForAllSensors(new java.util.ArrayList<>());
            }
            return ResponseEntity.ok("Generated " + result.size() + " alerts");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error when generating data: " + e.getMessage());
        }
    }

    // ✅ Tạo alerts ngay lập tức từ dữ liệu mới nhất trong database
    @PostMapping("/generate/now")
    public ResponseEntity<?> generateAlertsNow() {
        try {
            List<AlertResponseDTO> alerts = alertSchedulerService.generateAlertsNow();
            return ResponseEntity.ok("Generated " + alerts.size() + " alerts successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
}
