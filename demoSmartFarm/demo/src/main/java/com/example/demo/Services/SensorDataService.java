package com.example.demo.Services;

import com.example.demo.DTO.SensorDataDTO;
import com.example.demo.Entities.SensorDataEntity;
import com.example.demo.Entities.SensorEntity;
import com.example.demo.Repositories.SensorDataRepository;
import com.example.demo.Repositories.SensorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SensorDataService {

    @Autowired
    private SensorDataRepository sensorDataRepository;

    @Autowired
    private SensorRepository sensorRepository;

    public SensorDataDTO saveSensorData(SensorDataDTO dto) {
        SensorEntity sensor = sensorRepository.findById(dto.getSensorId())
                .orElseThrow(() -> new RuntimeException("Sensor not found"));

        SensorDataEntity entity = new SensorDataEntity();
        entity.setSensor(sensor);
        entity.setValue(dto.getValue());
        entity.setTime(dto.getTime());

        return convertToDTO(sensorDataRepository.save(entity));
    }

    public List<SensorDataDTO> getSensorData(Long sensorId, LocalDateTime from, LocalDateTime to) {
        return sensorDataRepository.findBySensorIdAndTimeBetween(sensorId, from, to).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }


    private SensorDataDTO convertToDTO(SensorDataEntity entity) {
        return new SensorDataDTO(
                entity.getId(),
                entity.getSensor().getId(),
                entity.getValue(),
                entity.getTime()
        );
    }

    public List<SensorDataDTO> getLatestDataBySensorId(Long sensorId) {
        List<SensorDataEntity> sensorDataList = sensorDataRepository.findTop5BySensorIdOrderByTimeDesc(sensorId);
        return sensorDataList.stream()
                .map(data -> new SensorDataDTO(
                        data.getId(),
                        data.getSensor().getId(),
                        data.getValue(),
                        data.getTime()))
                .collect(Collectors.toList());
    }

    /**
     * Lấy dữ liệu sensor theo fieldId và type trong khoảng thời gian
     */
    public List<com.example.demo.DTO.DashboardSensorDataDTO> getSensorDataByFieldAndType(
            Long fieldId, String type, LocalDateTime from, LocalDateTime to) {
        List<SensorDataEntity> dataList = sensorDataRepository.findByFieldIdAndTypeAndTimeBetween(
                fieldId, type, from, to);
        return dataList.stream()
                .map(data -> {
                    com.example.demo.DTO.DashboardSensorDataDTO dto = new com.example.demo.DTO.DashboardSensorDataDTO();
                    dto.setTime(data.getTime());
                    dto.setValue(data.getValue().doubleValue());
                    dto.setType(data.getSensor().getType());
                    dto.setFieldId(data.getSensor().getFieldId());
                    if (data.getSensor().getField() != null) {
                        dto.setFieldName(data.getSensor().getField().getName());
                    }
                    return dto;
                })
                .collect(Collectors.toList());
    }

    /**
     * Lấy dữ liệu sensor theo type (tất cả fields) trong khoảng thời gian
     */
    public List<com.example.demo.DTO.DashboardSensorDataDTO> getSensorDataByType(
            String type, LocalDateTime from, LocalDateTime to) {
        List<SensorDataEntity> dataList = sensorDataRepository.findByTypeAndTimeBetween(type, from, to);
        return dataList.stream()
                .map(data -> {
                    com.example.demo.DTO.DashboardSensorDataDTO dto = new com.example.demo.DTO.DashboardSensorDataDTO();
                    dto.setTime(data.getTime());
                    dto.setValue(data.getValue().doubleValue());
                    dto.setType(data.getSensor().getType());
                    dto.setFieldId(data.getSensor().getFieldId());
                    if (data.getSensor().getField() != null) {
                        dto.setFieldName(data.getSensor().getField().getName());
                    }
                    return dto;
                })
                .collect(Collectors.toList());
    }

    /**
     * Lấy giá trị trung bình theo type trong khoảng thời gian
     */
    public Double getAverageValueByType(String type, LocalDateTime from, LocalDateTime to) {
        Double avg = sensorDataRepository.getAverageValueByTypeAndTimeBetween(type, from, to);
        return avg != null ? avg : 0.0;
    }

    /**
     * Lấy dữ liệu mới nhất theo type (cho dashboard)
     */
    public List<com.example.demo.DTO.DashboardSensorDataDTO> getLatestDataByType(String type, int limit) {
        List<SensorDataEntity> dataList = sensorDataRepository.findLatestByType(type, limit);
        return dataList.stream()
                .map(data -> {
                    com.example.demo.DTO.DashboardSensorDataDTO dto = new com.example.demo.DTO.DashboardSensorDataDTO();
                    dto.setTime(data.getTime());
                    dto.setValue(data.getValue().doubleValue());
                    dto.setType(data.getSensor().getType());
                    dto.setFieldId(data.getSensor().getFieldId());
                    if (data.getSensor().getField() != null) {
                        dto.setFieldName(data.getSensor().getField().getName());
                    }
                    return dto;
                })
                .collect(Collectors.toList());
    }

}
