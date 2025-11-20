package com.example.demo.Repositories;

import com.example.demo.Entities.SensorDataEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface SensorDataRepository extends JpaRepository<SensorDataEntity, Long> {
    // Query trực tiếp theo sensor_id trong bảng sensor_data (native query để tránh join với Sensor table)
    @Query(value = "SELECT * FROM sensor_data WHERE sensor_id = :sensorId AND time BETWEEN :from AND :to ORDER BY time ASC", nativeQuery = true)
    List<SensorDataEntity> findBySensorIdAndTimeBetween(@Param("sensorId") Long sensorId, @Param("from") LocalDateTime from, @Param("to") LocalDateTime to);

    @Query(value = "SELECT * FROM sensor_data WHERE sensor_id = :sensorId ORDER BY time DESC LIMIT 5", nativeQuery = true)
    List<SensorDataEntity> findTop5BySensorIdOrderByTimeDesc(@Param("sensorId") Long sensorId);

    // Get latest data for each sensor (one record per sensor)
    @Query(value = "SELECT sd.* FROM sensor_data sd " +
            "INNER JOIN (SELECT sensor_id, MAX(time) as max_time FROM sensor_data GROUP BY sensor_id) latest " +
            "ON sd.sensor_id = latest.sensor_id AND sd.time = latest.max_time", nativeQuery = true)
    List<SensorDataEntity> findLatestDataForAllSensors();

}