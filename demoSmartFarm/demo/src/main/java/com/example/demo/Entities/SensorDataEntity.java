package com.example.demo.Entities;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "sensor_data")
@Data
public class SensorDataEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "sensor_id")
    private SensorEntity sensor;

    private Float value;

    private LocalDateTime time;
}

