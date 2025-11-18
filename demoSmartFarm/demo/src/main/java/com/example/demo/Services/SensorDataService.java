package com.example.demo.Services;

import com.example.demo.DTO.SensorDataDTO;
import com.example.demo.Entities.SensorDataEntity;
import com.example.demo.Entities.SensorEntity;
import com.example.demo.Repositories.SensorDataRepository;
import com.example.demo.Repositories.SensorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;

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



}
