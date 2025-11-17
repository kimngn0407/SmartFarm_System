package com.example.demo.DTO;

import lombok.*;

import java.time.LocalDateTime;

/**
 * DTO cho dashboard - chứa dữ liệu sensor theo type
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Setter @Getter
public class DashboardSensorDataDTO {
    private LocalDateTime time;
    private Double value;
    private String type;  // Temperature, Humidity, Soil Moisture, Light
    private Long fieldId;
    private String fieldName;
}

