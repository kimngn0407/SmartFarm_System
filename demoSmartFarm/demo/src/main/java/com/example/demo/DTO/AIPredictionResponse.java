package com.example.demo.DTO;

import lombok.Data;
import java.util.List;

@Data
public class AIPredictionResponse {
    private Boolean success;
    private List<List<Double>> prediction;
    private List<Double> inputFeatures;
    private String timestamp;
    private String error;
    
    // Crop recommendation fields (from Python AI service)
    private String recommendedCrop;  // Vietnamese name (e.g., "Dưa hấu")
    private String cropNameEn;      // English name (e.g., "watermelon")
    private Double confidence;       // Confidence score (0.0 - 1.0)
}

