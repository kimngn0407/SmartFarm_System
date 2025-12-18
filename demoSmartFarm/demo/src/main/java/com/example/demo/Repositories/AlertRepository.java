package com.example.demo.Repositories;

import com.example.demo.Entities.AlertEntity;
import com.example.demo.Entities.FieldEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface AlertRepository extends JpaRepository<AlertEntity, Long> {
    List<AlertEntity> findByFieldId(Long fieldId);     // ✅ đúng
    
    // Lấy alerts mới nhất của field trong khoảng thời gian
    @Query("SELECT a FROM AlertEntity a WHERE a.field.id = :fieldId AND a.timestamp >= :since ORDER BY a.timestamp DESC")
    List<AlertEntity> findRecentAlertsByFieldId(@Param("fieldId") Long fieldId, @Param("since") LocalDateTime since);

}