package com.example.demo.Services;

import com.example.demo.DTO.AlertResponseDTO;
import com.example.demo.DTO.SensorDataLastestDTO;
import com.example.demo.Entities.SensorDataEntity;
import com.example.demo.Repositories.SensorDataRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Service để tự động tạo alerts từ dữ liệu sensor mới nhất
 * Chạy định kỳ mỗi 5 phút để kiểm tra và tạo alerts
 */
@Slf4j
@Service
public class AlertSchedulerService {

    @Autowired
    private SensorDataRepository sensorDataRepository;

    @Autowired
    private AlertService alertService;

    /**
     * Tự động tạo alerts từ dữ liệu sensor mới nhất
     * Chạy mỗi 30 phút (1800000 milliseconds)
     * Sau khi tạo alerts, sẽ cập nhật field status dựa trên alerts
     * 
     * Chạy tự động mỗi 30 phút
     */
    @Scheduled(fixedRate = 1800000) // 30 phút = 1800000 milliseconds
    public void generateAlertsFromLatestSensorData() {
        try {
            log.info("🔄 Bắt đầu tạo alerts từ dữ liệu sensor mới nhất...");
            
            // Lấy dữ liệu mới nhất cho tất cả sensors
            List<SensorDataEntity> latestDataList = sensorDataRepository.findLatestDataForAllSensors();
            
            if (latestDataList == null || latestDataList.isEmpty()) {
                log.warn("⚠️ Không có dữ liệu sensor nào để tạo alerts");
                return;
            }
            
            log.info("📊 Tìm thấy {} sensors có dữ liệu mới nhất", latestDataList.size());
            
            // Convert sang SensorDataLastestDTO
            List<SensorDataLastestDTO> sensorDataLastestDTOs = new ArrayList<>();
            for (SensorDataEntity entity : latestDataList) {
                // Chỉ xử lý các sensor có field và crop season (để có threshold)
                if (entity.getSensor() != null && entity.getSensor().getField() != null) {
                    SensorDataLastestDTO dto = SensorDataLastestDTO.builder()
                            .sensorId(entity.getSensor().getId())
                            .type(entity.getSensor().getType())
                            .value(entity.getValue() != null ? entity.getValue().doubleValue() : null)
                            .timestamp(entity.getTime())
                            .build();
                    sensorDataLastestDTOs.add(dto);
                }
            }
            
            if (sensorDataLastestDTOs.isEmpty()) {
                log.warn("⚠️ Không có sensor nào có field và crop season để tạo alerts");
                return;
            }
            
            log.info("✅ Đang tạo alerts cho {} sensors...", sensorDataLastestDTOs.size());
            
            // Tạo alerts
            List<AlertResponseDTO> alerts = alertService.createAlertsForAllSensors(sensorDataLastestDTOs);
            
            log.info("✅ Đã tạo thành công {} alerts", alerts.size());
            
            // Log số lượng alerts theo status
            long criticalCount = alerts.stream()
                    .filter(a -> "Critical".equalsIgnoreCase(a.getStatus()))
                    .count();
            long warningCount = alerts.stream()
                    .filter(a -> "Warning".equalsIgnoreCase(a.getStatus()))
                    .count();
            long goodCount = alerts.stream()
                    .filter(a -> "Good".equalsIgnoreCase(a.getStatus()))
                    .count();
            
            log.info("📊 Thống kê alerts: Critical={}, Warning={}, Good={}", 
                    criticalCount, warningCount, goodCount);
            
            // Cập nhật field status dựa trên alerts vừa tạo
            log.info("🔄 Bắt đầu cập nhật field status từ alerts...");
            alertService.updateAllFieldStatuses();
            log.info("✅ Đã hoàn thành cập nhật field status");
            
        } catch (Exception e) {
            log.error("❌ Lỗi khi tạo alerts tự động: {}", e.getMessage(), e);
        }
    }

    /**
     * Tạo alerts ngay lập tức (có thể gọi thủ công từ API)
     */
    public List<AlertResponseDTO> generateAlertsNow() {
        try {
            log.info("🔄 Tạo alerts ngay lập tức...");
            
            List<SensorDataEntity> latestDataList = sensorDataRepository.findLatestDataForAllSensors();
            
            if (latestDataList == null || latestDataList.isEmpty()) {
                log.warn("⚠️ Không có dữ liệu sensor nào");
                return new ArrayList<>();
            }
            
            List<SensorDataLastestDTO> sensorDataLastestDTOs = new ArrayList<>();
            for (SensorDataEntity entity : latestDataList) {
                if (entity.getSensor() != null && entity.getSensor().getField() != null) {
                    SensorDataLastestDTO dto = SensorDataLastestDTO.builder()
                            .sensorId(entity.getSensor().getId())
                            .type(entity.getSensor().getType())
                            .value(entity.getValue() != null ? entity.getValue().doubleValue() : null)
                            .timestamp(entity.getTime())
                            .build();
                    sensorDataLastestDTOs.add(dto);
                }
            }
            
            List<AlertResponseDTO> alerts = alertService.createAlertsForAllSensors(sensorDataLastestDTOs);
            
            // Cập nhật field status sau khi tạo alerts
            alertService.updateAllFieldStatuses();
            
            return alerts;
            
        } catch (Exception e) {
            log.error("❌ Lỗi khi tạo alerts: {}", e.getMessage(), e);
            return new ArrayList<>();
        }
    }
}

