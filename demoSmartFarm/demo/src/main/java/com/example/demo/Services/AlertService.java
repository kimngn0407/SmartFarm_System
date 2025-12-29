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
    private final FieldRepository fieldRepository;
    
    @Autowired(required = false)
    private EmailService emailService;
    
    private final CropSeasonRepository cropSeasonRepository;
    private final SimpMessagingTemplate messagingTemplate;
    
    public AlertService(SensorRepository sensorRepository,
                       AccountRepository accountRepository,
                       Warning_thresholdRepository thresholdRepository,
                       AlertRepository alertRepository,
                       FieldRepository fieldRepository,
                       CropSeasonRepository cropSeasonRepository,
                       SimpMessagingTemplate messagingTemplate) {
        this.sensorRepository = sensorRepository;
        this.accountRepository = accountRepository;
        this.thresholdRepository = thresholdRepository;
        this.alertRepository = alertRepository;
        this.fieldRepository = fieldRepository;
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
    // Sau khi resolve alert, sẽ tự động tính lại field status
    public void resolveAlert(Long alertId) {
        Optional<AlertEntity> alertOpt = alertRepository.findById(alertId);
        if (alertOpt.isPresent()) {
            AlertEntity alert = alertOpt.get();
            Long fieldId = alert.getField() != null ? alert.getField().getId() : null;
            
            // Đổi status alert thành GOOD (đã xử lý)
            alert.setStatus("GOOD");
            alertRepository.save(alert);
            
            // Tính lại field status sau khi resolve alert
            if (fieldId != null) {
                System.out.println("🔄 Alert " + alertId + " đã được resolve, tính lại field " + fieldId + " status...");
                calculateAndUpdateFieldStatus(fieldId);
            }
        }
    }

    // ✅ Mark alert as read
    // Sau khi mark as read, sẽ tự động tính lại field status
    public void markAlertAsRead(Long alertId) {
        Optional<AlertEntity> alertOpt = alertRepository.findById(alertId);
        if (alertOpt.isPresent()) {
            AlertEntity alert = alertOpt.get();
            Long fieldId = alert.getField() != null ? alert.getField().getId() : null;
            
            // You can add a 'read' field to AlertEntity if needed
            // For now, we'll just update the status
            if ("CRITICAL".equals(alert.getStatus())) {
                alert.setStatus("WARNING");
            }
            alertRepository.save(alert);
            
            // Tính lại field status sau khi mark as read
            if (fieldId != null) {
                System.out.println("🔄 Alert " + alertId + " đã được mark as read, tính lại field " + fieldId + " status...");
                calculateAndUpdateFieldStatus(fieldId);
            }
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
    }

    /**
     * Tính và cập nhật field status dựa trên alerts của field
     * Logic:
     * - Nếu có ≥1 alert CRITICAL → Field = CRITICAL
     * - Nếu có ≥1 alert WARNING (và không có CRITICAL) → Field = WARNING
     * - Nếu tất cả alerts đều GOOD → Field = GOOD
     * 
     * @param fieldId ID của field cần cập nhật status
     */
    public void calculateAndUpdateFieldStatus(Long fieldId) {
        try {
            Optional<FieldEntity> fieldOpt = fieldRepository.findById(fieldId);
            if (fieldOpt.isEmpty()) {
                System.err.println("Field not found: " + fieldId);
                return;
            }

            FieldEntity field = fieldOpt.get();
            
            // Lấy TẤT CẢ alerts của field để tính lại status chính xác
            // (Không filter theo thời gian để đảm bảo tính đúng sau khi resolve alert)
            List<AlertEntity> allAlerts = alertRepository.findByFieldId(fieldId);
            
            // Tính field status từ TẤT CẢ alerts của field
            String fieldStatus = calculateFieldStatusFromAlerts(allAlerts);
            
            // Cập nhật field status
            field.setStatus(fieldStatus);
            fieldRepository.save(field);
            
            System.out.println("✅ Đã cập nhật field " + fieldId + " status: " + fieldStatus);
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi cập nhật field status cho field " + fieldId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Tính field status từ danh sách alerts
     * Priority: CRITICAL > WARNING > GOOD
     * 
     * Logic:
     * - Nếu có ≥1 alert CRITICAL → Field = CRITICAL
     * - Nếu có ≥1 alert WARNING (và không có CRITICAL) → Field = WARNING
     * - Nếu tất cả alerts đều GOOD → Field = GOOD
     */
    private String calculateFieldStatusFromAlerts(List<AlertEntity> alerts) {
        if (alerts == null || alerts.isEmpty()) {
            return "GOOD"; // Mặc định là GOOD nếu không có alert
        }

        boolean hasCritical = false;
        boolean hasWarning = false;
        boolean hasGood = false;

        for (AlertEntity alert : alerts) {
            String status = alert.getStatus();
            if (status == null) continue;

            // So sánh case-insensitive
            String upperStatus = status.toUpperCase().trim();
            
            // Kiểm tra status (có thể là "Critical", "CRITICAL", "Warning", "WARNING", "Good", "GOOD")
            if (upperStatus.equals("CRITICAL") || upperStatus.contains("CRITICAL")) {
                hasCritical = true;
            } else if (upperStatus.equals("WARNING") || upperStatus.contains("WARNING")) {
                hasWarning = true;
            } else if (upperStatus.equals("GOOD") || upperStatus.contains("GOOD")) {
                hasGood = true;
            }
        }

        // Logic: CRITICAL > WARNING > GOOD
        // Nếu có CRITICAL → CRITICAL (ưu tiên cao nhất)
        if (hasCritical) {
            return "CRITICAL";
        } 
        // Nếu có WARNING (và không có CRITICAL) → WARNING
        else if (hasWarning) {
            return "WARNING";
        } 
        // Nếu tất cả đều GOOD → GOOD
        else if (hasGood) {
            return "GOOD";
        }

        // Mặc định
        return "GOOD";
    }

    /**
     * Cập nhật status cho tất cả fields dựa trên alerts của chúng
     * Được gọi sau khi tạo alerts mới
     */
    public void updateAllFieldStatuses() {
        try {
            // Lấy tất cả fields
            List<FieldEntity> allFields = fieldRepository.findAll();
            
            System.out.println("🔄 Bắt đầu cập nhật status cho " + allFields.size() + " fields...");
            
            for (FieldEntity field : allFields) {
                calculateAndUpdateFieldStatus(field.getId());
            }
            
            System.out.println("✅ Đã cập nhật status cho tất cả fields");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi cập nhật status cho tất cả fields: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
