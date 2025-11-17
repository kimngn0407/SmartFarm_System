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

    // Query để lấy dữ liệu sensor theo fieldId, type và khoảng thời gian
    @Query("SELECT sd FROM SensorDataEntity sd " +
           "JOIN sd.sensor s " +
           "WHERE s.field.id = :fieldId " +
           "AND s.type = :type " +
           "AND sd.time BETWEEN :from AND :to " +
           "ORDER BY sd.time ASC")
    List<SensorDataEntity> findByFieldIdAndTypeAndTimeBetween(
        @Param("fieldId") Long fieldId,
        @Param("type") String type,
        @Param("from") LocalDateTime from,
        @Param("to") LocalDateTime to
    );

    // Query để lấy dữ liệu sensor theo type (tất cả fields) trong khoảng thời gian
    @Query("SELECT sd FROM SensorDataEntity sd " +
           "JOIN sd.sensor s " +
           "WHERE s.type = :type " +
           "AND sd.time BETWEEN :from AND :to " +
           "ORDER BY sd.time ASC")
    List<SensorDataEntity> findByTypeAndTimeBetween(
        @Param("type") String type,
        @Param("from") LocalDateTime from,
        @Param("to") LocalDateTime to
    );

    // Query để lấy giá trị trung bình theo type trong khoảng thời gian
    @Query("SELECT AVG(sd.value) FROM SensorDataEntity sd " +
           "JOIN sd.sensor s " +
           "WHERE s.type = :type " +
           "AND sd.time BETWEEN :from AND :to")
    Double getAverageValueByTypeAndTimeBetween(
        @Param("type") String type,
        @Param("from") LocalDateTime from,
        @Param("to") LocalDateTime to
    );

    // Query để lấy dữ liệu mới nhất theo type
    @Query("SELECT sd FROM SensorDataEntity sd " +
           "JOIN sd.sensor s " +
           "WHERE s.type = :type " +
           "ORDER BY sd.time DESC")
    List<SensorDataEntity> findLatestByType(@Param("type") String type, org.springframework.data.domain.Pageable pageable);

}