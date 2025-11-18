package com.example.demo.Repositories;

import com.example.demo.Entities.SensorDataEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.awt.print.Pageable;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface SensorDataRepository extends JpaRepository<SensorDataEntity, Long> {
    List<SensorDataEntity> findBySensorIdAndTimeBetween(Long sensorId, LocalDateTime from, LocalDateTime to);

    List<SensorDataEntity> findTop5BySensorIdOrderByTimeDesc(Long sensorId);



}