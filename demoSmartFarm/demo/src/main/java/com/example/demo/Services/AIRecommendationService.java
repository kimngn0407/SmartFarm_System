package com.example.demo.Services;

import com.example.demo.DTO.AIPredictionRequest;
import com.example.demo.DTO.AIPredictionResponse;
import com.example.demo.DTO.AIHealthResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.RestClientException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AIRecommendationService {

    private static final Logger logger = LoggerFactory.getLogger(AIRecommendationService.class);

    @Autowired
    @Qualifier("aiRestTemplate")
    private RestTemplate restTemplate;

    @Value("${crop.recommendation.url:http://crop-service:5000}")
    private String aiApiUrl;

    @Value("${ai.api.enabled:true}")
    private boolean aiApiEnabled;

    /**
     * Check if AI API is healthy and model is loaded
     */
    public boolean isHealthy() {
        if (!aiApiEnabled) {
            logger.warn("AI API is disabled");
            return false;
        }

        try {
            String url = aiApiUrl + "/health";
            ResponseEntity<Map> response = restTemplate.getForEntity(
                url,
                Map.class
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                Map<String, Object> health = response.getBody();
                return health != null && Boolean.TRUE.equals(health.get("model_loaded"));
            }

            return false;

        } catch (RestClientException e) {
            logger.error("AI API health check failed: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Get crop recommendation prediction from sensor data
     */
    public AIPredictionResponse getPrediction(Double temperature, Double humidity, 
                                              Double soilMoisture, Double ph,
                                              Double rainfall, Integer nitrogen, 
                                              Integer phosphorus, Integer potassium) {
        if (!aiApiEnabled) {
            logger.warn("AI API is disabled, skipping prediction");
            return createErrorResponse("AI API is disabled");
        }

        try {
            // Use the actual endpoint from Python service
            String url = aiApiUrl + "/api/recommend-crop";

            // Create request - map to Python service format (only 3 fields)
            Map<String, Object> requestMap = new HashMap<>();
            requestMap.put("temperature", temperature);
            requestMap.put("humidity", humidity);
            requestMap.put("soil_moisture", soilMoisture);

            // Set headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestMap, headers);

            // Make API call
            logger.info("Calling AI API for prediction: {}", requestMap);

            ResponseEntity<Map> response = restTemplate.postForEntity(
                url,
                entity,
                Map.class
            );

            Map<String, Object> result = response.getBody();
            
            // Log raw response from Python service
            logger.info("🔍 Raw Python service response: {}", result);
            if (result != null) {
                logger.info("🔍 Response keys: {}", result.keySet());
                logger.info("🔍 recommended_crop value: {}", result.get("recommended_crop"));
                logger.info("🔍 crop_name_en value: {}", result.get("crop_name_en"));
                logger.info("🔍 confidence value: {}", result.get("confidence"));
            }

            // Map Python response to Java DTO
            AIPredictionResponse aiResponse = new AIPredictionResponse();
            if (result != null && Boolean.TRUE.equals(result.get("success"))) {
                aiResponse.setSuccess(true);
                
                // Extract crop information from Python service response
                // Python service returns: { success: true, recommended_crop: "Dưa hấu", crop_name_en: "watermelon", confidence: 0.8, input_data: {...} }
                if (result.containsKey("recommended_crop")) {
                    Object recommendedCropObj = result.get("recommended_crop");
                    String recommendedCrop = recommendedCropObj != null ? recommendedCropObj.toString() : null;
                    aiResponse.setRecommendedCrop(recommendedCrop);
                    logger.info("✅ Set recommendedCrop: {}", recommendedCrop);
                } else {
                    logger.warn("⚠️ Response không có key 'recommended_crop'");
                }
                
                if (result.containsKey("crop_name_en")) {
                    Object cropNameEnObj = result.get("crop_name_en");
                    String cropNameEn = cropNameEnObj != null ? cropNameEnObj.toString() : null;
                    aiResponse.setCropNameEn(cropNameEn);
                    logger.info("✅ Set cropNameEn: {}", cropNameEn);
                }
                
                if (result.containsKey("confidence")) {
                    Object conf = result.get("confidence");
                    if (conf instanceof Number) {
                        aiResponse.setConfidence(((Number) conf).doubleValue());
                        logger.info("✅ Set confidence: {}", conf);
                    }
                }
                
                // Store crop name as string in prediction field for compatibility
                List<List<Double>> predictionList = new ArrayList<>();
                List<Double> cropList = new ArrayList<>();
                cropList.add(1.0); // placeholder
                predictionList.add(cropList);
                aiResponse.setPrediction(predictionList);
                
                logger.info("✅ AI prediction successful - Final AIPredictionResponse: recommendedCrop={}, cropNameEn={}, confidence={}", 
                    aiResponse.getRecommendedCrop(), aiResponse.getCropNameEn(), aiResponse.getConfidence());
                return aiResponse;
            } else {
                String errorMsg = (String) result.getOrDefault("error", "Prediction failed");
                logger.error("AI prediction failed: {}", errorMsg);
                return createErrorResponse(errorMsg);
            }

        } catch (RestClientException e) {
            logger.error("Error calling AI API: {}", e.getMessage());
            return createErrorResponse("AI API connection error: " + e.getMessage());
        }
    }

    /**
     * Get recommendation from SensorData entity
     */
    public AIPredictionResponse getPredictionFromSensorData(
            Double temperature, Double humidity, Double soilMoisture) {
        // Use default values for missing data
        return getPrediction(
            temperature != null ? temperature : 25.0,
            humidity != null ? humidity : 70.0,
            soilMoisture != null ? soilMoisture : 50.0,
            6.5,  // Default pH
            100.0, // Default rainfall
            50,    // Default N
            30,    // Default P
            40     // Default K
        );
    }

    /**
     * Get crop recommendation score (0-100)
     */
    public Double getRecommendationScore(Double temperature, Double humidity, 
                                         Double soilMoisture, Double ph,
                                         Double rainfall, Integer nitrogen,
                                         Integer phosphorus, Integer potassium) {
        AIPredictionResponse response = getPrediction(
            temperature, humidity, soilMoisture, ph,
            rainfall, nitrogen, phosphorus, potassium
        );

        if (response != null && Boolean.TRUE.equals(response.getSuccess())) {
            // Extract score from prediction (adjust based on model output)
            if (response.getPrediction() != null && 
                !response.getPrediction().isEmpty() &&
                !response.getPrediction().get(0).isEmpty()) {
                
                Double score = response.getPrediction().get(0).get(0);
                return score * 100; // Convert to percentage
            }
        }

        return null;
    }

    private AIPredictionResponse createErrorResponse(String errorMessage) {
        AIPredictionResponse response = new AIPredictionResponse();
        response.setSuccess(false);
        response.setError(errorMessage);
        return response;
    }
}

