package com.example.demo.Controllers;

import com.example.demo.DTO.AIPredictionRequest;
import com.example.demo.DTO.AIPredictionResponse;
import com.example.demo.Services.AIRecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/crop")
@CrossOrigin(origins = "*")
public class CropRecommendationController {

    @Autowired
    private AIRecommendationService aiService;

    /**
     * Get crop recommendation - Frontend endpoint
     * Maps to /api/ai/recommend internally
     */
    @PostMapping("/recommend")
    public ResponseEntity<Map<String, Object>> getRecommendation(
            @RequestBody Map<String, Object> request) {
        
        try {
            // Map frontend request to AIPredictionRequest format
            AIPredictionRequest aiRequest = new AIPredictionRequest();
            aiRequest.setTemperature(getDoubleValue(request.get("temperature")));
            aiRequest.setHumidity(getDoubleValue(request.get("humidity")));
            aiRequest.setSoilMoisture(getDoubleValue(request.get("soil_moisture"), 
                                                     getDoubleValue(request.get("soilMoisture"))));
            aiRequest.setPh(getDoubleValue(request.get("ph"), 6.5));
            aiRequest.setRainfall(getDoubleValue(request.get("rainfall"), 100.0));
            aiRequest.setNitrogen(getIntegerValue(request.get("N"), request.get("nitrogen"), 50));
            aiRequest.setPhosphorus(getIntegerValue(request.get("P"), request.get("phosphorus"), 30));
            aiRequest.setPotassium(getIntegerValue(request.get("K"), request.get("potassium"), 40));
            
            AIPredictionResponse prediction = aiService.getPrediction(
                aiRequest.getTemperature(),
                aiRequest.getHumidity(),
                aiRequest.getSoilMoisture(),
                aiRequest.getPh(),
                aiRequest.getRainfall(),
                aiRequest.getNitrogen(),
                aiRequest.getPhosphorus(),
                aiRequest.getPotassium()
            );

            // Map response to frontend expected format
            Map<String, Object> response = new HashMap<>();
            Boolean success = prediction.getSuccess() != null && prediction.getSuccess();
            response.put("success", success);
            if (success) {
                // Extract crop information from AI service response
                // Đảm bảo luôn có recommended_crop
                String recommendedCrop = prediction.getRecommendedCrop();
                if (recommendedCrop != null && !recommendedCrop.trim().isEmpty()) {
                    response.put("recommended_crop", recommendedCrop);
                } else {
                    // Fallback: thử lấy từ cropNameEn hoặc set default
                    String cropNameEn = prediction.getCropNameEn();
                    if (cropNameEn != null && !cropNameEn.trim().isEmpty()) {
                        response.put("recommended_crop", cropNameEn);
                    } else {
                        response.put("recommended_crop", "Cây trồng được gợi ý");
                    }
                }
                
                if (prediction.getCropNameEn() != null && !prediction.getCropNameEn().trim().isEmpty()) {
                    response.put("crop_name_en", prediction.getCropNameEn());
                }
                
                if (prediction.getConfidence() != null) {
                    response.put("confidence", prediction.getConfidence());
                }
                
                // Include input data if available
                Map<String, Object> inputData = new HashMap<>();
                if (request.containsKey("temperature")) {
                    inputData.put("temperature", request.get("temperature"));
                }
                if (request.containsKey("humidity")) {
                    inputData.put("humidity", request.get("humidity"));
                }
                if (request.containsKey("soil_moisture")) {
                    inputData.put("soil_moisture", request.get("soil_moisture"));
                }
                // Luôn có input_data, ngay cả khi empty
                response.put("input_data", inputData);
            } else {
                response.put("error", prediction.getError() != null ? prediction.getError() : "Không thể nhận được gợi ý từ server");
            }

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("error", "Failed to process recommendation: " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }
    
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> checkHealth() {
        try {
            boolean healthy = aiService.isHealthy();
            Map<String, Object> response = new HashMap<>();
            response.put("healthy", healthy);
            response.put("status", healthy ? "healthy" : "unhealthy");
            response.put("message", healthy ? "AI service is ready" : "AI service is not available");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("healthy", false);
            errorResponse.put("status", "error");
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }
    
    private Double getDoubleValue(Object value) {
        return getDoubleValue(value, null);
    }
    
    private Double getDoubleValue(Object value, Double defaultValue) {
        if (value == null) return defaultValue;
        if (value instanceof Number) return ((Number) value).doubleValue();
        try {
            return Double.parseDouble(value.toString());
        } catch (Exception e) {
            return defaultValue;
        }
    }
    
    private Integer getIntegerValue(Object... values) {
        for (Object value : values) {
            if (value != null) {
                if (value instanceof Number) return ((Number) value).intValue();
                try {
                    return Integer.parseInt(value.toString());
                } catch (Exception e) {
                    continue;
                }
            }
        }
        return 50; // default
    }
}

