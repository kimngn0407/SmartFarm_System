package com.example.demo.DTO;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.time.ZoneOffset;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Setter @Getter
public class SensorDataDTO {
    private Long id;
    private Long sensorId;
    private Float value;
    
    // Serialize LocalDateTime as ISO 8601 with UTC timezone (Z suffix)
    // Database stores UTC, so we treat LocalDateTime as UTC when serializing
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'", timezone = "UTC")
    private LocalDateTime time;
}
