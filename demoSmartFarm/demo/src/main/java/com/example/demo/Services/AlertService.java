package com.example.demo.Services;

import com.example.demo.DTO.AlertResponseDTO;
import com.example.demo.DTO.SensorDataLastestDTO;
import com.example.demo.Entities.*;
import com.example.demo.Repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class AlertService {

    private final SensorRepository sensorRepository;
    private final AccountRepository accountRepository;
    private final Warning_thresholdRepository thresholdRepository;
    private final AlertRepository alertRepository;
    
    @Autowired(required = false)
    private EmailService emailService;
    
    private final CropSeasonRepository cropSeasonRepository;
    private final SimpMessagingTemplate messagingTemplate;
    
    public AlertService(SensorRepository sensorRepository,
                       AccountRepository accountRepository,
                       Warning_thresholdRepository thresholdRepository,
                       AlertRepository alertRepository,
                       CropSeasonRepository cropSeasonRepository,
                       SimpMessagingTemplate messagingTemplate) {
        this.sensorRepository = sensorRepository;
        this.accountRepository = accountRepository;
        this.thresholdRepository = thresholdRepository;
        this.alertRepository = alertRepository;
        this.cropSeasonRepository = cropSeasonRepository;
        this.messagingTemplate = messagingTemplate;
    }

    // ✅ Get all alerts for statistics
    public List<AlertEntity> getAllAlerts() {
        return alertRepository.findAll();
    }

    // ✅ Get alerts by field
    public List<AlertResponseDTO> getAlertsByField(Long fieldId) {
        List<AlertEntity> alerts = alertRepository.findByFieldId(fieldId);
        List<AlertResponseDTO> responseDTOs = new ArrayList<>();

        for (AlertEntity alert : alerts) {
            responseDTOs.add(AlertResponseDTO.builder()
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
                    .build());
        }

        return responseDTOs;
    }

    // ✅ Resolve alert
    public void resolveAlert(Long alertId) {
        Optional<AlertEntity> alertOpt = alertRepository.findById(alertId);
        if (alertOpt.isPresent()) {
            AlertEntity alert = alertOpt.get();
            alert.setStatus("GOOD");
            alertRepository.save(alert);
        }
    }

    // ✅ Mark alert as read
    public void markAlertAsRead(Long alertId) {
        Optional<AlertEntity> alertOpt = alertRepository.findById(alertId);
        if (alertOpt.isPresent()) {
            AlertEntity alert = alertOpt.get();
            // You can add a 'read' field to AlertEntity if needed
            // For now, we'll just update the status
            if ("CRITICAL".equals(alert.getStatus())) {
                alert.setStatus("WARNING");
            }
            alertRepository.save(alert);
        }
    }

    // Nhận danh sách sensor từ bên ngoài
    public List<AlertResponseDTO> createAlertsForAllSensors(List<SensorDataLastestDTO> sensorDataList) {
        List<AlertResponseDTO> allAlerts = new ArrayList<>();

        for (SensorDataLastestDTO data : sensorDataList) {
            Optional<SensorEntity> sensorOpt = sensorRepository.findById(data.getSensorId());
            if (sensorOpt.isEmpty()) continue;

            SensorEntity sensor = sensorOpt.get();

            // Gắn dữ liệu cho xử lý
            List<AlertResponseDTO> alerts = createAlertsFromSensorData(sensor, data);
            allAlerts.addAll(alerts);
        }

        return allAlerts;
    }
    public List<AlertResponseDTO> createAlertsFromSensorData(SensorEntity sensor, SensorDataLastestDTO data) {
        List<AlertResponseDTO> alerts = new ArrayList<>();

        // ⚠️ TẠM TẮT - Không tạo cảnh báo tự động
        // Để bật lại, xóa hoặc comment dòng return bên dưới
        return alerts;

        /* ĐÃ TẮT - Uncomment để bật lại
        FieldEntity field = sensor.getField();
        if (field == null){ return alerts;}
        Optional<CropSeasonEntity> cropSeasonEntity = cropSeasonRepository.findFirstByFieldIdOrderByPlantingDateDesc(field.getId());
        if(cropSeasonEntity.isEmpty()){
            return alerts;
        }
        Optional<Warning_thresholdEntity> thresholdOpt;
        thresholdOpt = thresholdRepository.findByCropSeasonId(cropSeasonEntity.get().getId());
        if (thresholdOpt.isEmpty()) return alerts;

        Warning_thresholdEntity threshold = thresholdOpt.get();
        double value = data.getValue();
        double min, max;
        String messages = "Alert for sensor ";
        switch (sensor.getType()) {
            case "Temperature":
                if (threshold.getMinTemperature() == null || threshold.getMaxTemperature() == null) return alerts;
                min = threshold.getMinTemperature();
                max = threshold.getMaxTemperature();
                messages += "Temperature";
                break;
            case "Humidity":
                if (threshold.getMinHumidity() == null || threshold.getMaxHumidity() == null) return alerts;
                min = threshold.getMinHumidity();
                max = threshold.getMaxHumidity();
                messages += "Humidity";
                break;
            case "Soil Moisture":
                if (threshold.getMinSoilMoisture() == null || threshold.getMaxSoilMoisture() == null) return alerts;
                min = threshold.getMinSoilMoisture();
                max = threshold.getMaxSoilMoisture();
                messages += "Soil Moisture";
                break;
            default:
                return alerts;
        }

        String status;
        double warningMargin = (max - min) * 0.1;

        if (value < min - warningMargin || value > max + warningMargin) {
            status = "Critical";
        } else if (value < min || value > max) {
            status = "Warning";
        } else {
            status = "Good";
        }

        AlertEntity alert = new AlertEntity();
        alert.setSensor(sensor);
        alert.setField(field);
        alert.setType(sensor.getType());
        alert.setValue(value);
        alert.setThresholdMin(min);
        alert.setThresholdMax(max);
        alert.setTimestamp(LocalDateTime.now());
        alert.setStatus(status);
        alert.setMessage(messages+ status);

        alert.setGroupType("s");
        alert.setOwnerId(sensor.getId());

        alertRepository.save(alert);

        // If alert is critical, send email notification (non-blocking) to farm owner and field-related users
        try {
            String s = status == null ? "" : status.toString();
            if (s.equalsIgnoreCase("critical")) {
                // build a simple HTML body
                String subject = "[SmartFarm] Critical Alert: " + alert.getType();
        // HTML body is generated from Thymeleaf template below via model

                // collect recipients: farm owner + field-assigned accounts with roles FARMER/TECHNICIAN/FARM_OWNER
                java.util.Set<String> recipients = new java.util.HashSet<>();

                if (field.getFarm() != null && field.getFarm().getOwner() != null) {
                    String ownerEmail = field.getFarm().getOwner().getEmail();
                    if (ownerEmail != null && !ownerEmail.isEmpty()) recipients.add(ownerEmail);
                }

                // find accounts assigned to this field
                try {
                    java.util.List<com.example.demo.Entities.AccountEntity> accounts = accountRepository.findByFieldId(field.getId());
                    for (com.example.demo.Entities.AccountEntity acc : accounts) {
                        if (acc == null) continue;
                        if (acc.getEmail() == null) continue;
                        // check roles
                        if (acc.getRoles() != null) {
                            for (com.example.demo.DTO.Role r : acc.getRoles()) {
                                if (r == com.example.demo.DTO.Role.FARMER || r == com.example.demo.DTO.Role.TECHNICIAN || r == com.example.demo.DTO.Role.FARM_OWNER) {
                                    recipients.add(acc.getEmail());
                                    break;
                                }
                            }
                        }
                    }
                } catch (Exception exAccounts) {
                    // log and continue
                    System.err.println("Failed to lookup field accounts: " + exAccounts.getMessage());
                }

                // send a single email with multiple recipients (To list)
                java.util.List<String> toList = new java.util.ArrayList<>(recipients);
                java.util.Map<String, Object> model = new java.util.HashMap<>();
                model.put("templateName", "alert-email");
                model.put("fieldName", field.getFieldName());
                model.put("farmName", field.getFarm() != null ? field.getFarm().getFarmName() : "");
                model.put("sensorName", sensor.getSensorName());
                model.put("type", alert.getType());
                model.put("value", alert.getValue());
                model.put("thresholdMin", alert.getThresholdMin());
                model.put("thresholdMax", alert.getThresholdMax());
                model.put("timestamp", alert.getTimestamp());
                model.put("message", alert.getMessage());
                model.put("status", alert.getStatus());

                try {
                    if (emailService != null) {
                        emailService.sendAlertEmail(toList, null, null, subject, model);
                    } else {
                        System.out.println("Email service not configured, skipping alert email");
                    }
                } catch (Exception exSend) {
                    System.err.println("Failed to send alert email (batch): " + exSend.getMessage());
                }
            }
        } catch (Exception ex) {
            // log and continue
            System.err.println("Failed to process alert email sending: " + ex.getMessage());
        }

        AlertResponseDTO responseDto = AlertResponseDTO.builder()
                .id(alert.getId())
                .status(status)
                .message(alert.getMessage())
                .groupType(alert.getGroupType())
                .ownerId(alert.getOwnerId())
                .sensorId(sensor.getId())
                .fieldId(field.getId())
                .type(sensor.getType())
                .value(value)
                .thresholdMin(min)
                .thresholdMax(max)
                .timestamp(alert.getTimestamp())
                .fieldName(field.getFieldName())
                .sensorName(sensor.getSensorName())
                .build();

        alerts.add(responseDto);

        // Publish realtime notification to subscribers of this field
        try {
            String dest = "/topic/alerts/field-" + field.getId();
            messagingTemplate.convertAndSend(dest, responseDto);
        } catch (Exception exWs) {
            System.err.println("Failed to publish websocket alert: " + exWs.getMessage());
        }

        return alerts;
        */
    }
}
