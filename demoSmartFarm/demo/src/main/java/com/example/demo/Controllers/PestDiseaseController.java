package com.example.demo.Controllers;

import com.example.demo.Services.PestDiseaseService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/pest-disease")
@CrossOrigin(origins = {"http://173.249.48.25", "http://173.249.48.25:80", "http://localhost:3000"})
public class PestDiseaseController {

    private static final Logger logger = LoggerFactory.getLogger(PestDiseaseController.class);

    @Autowired
    private PestDiseaseService pestDiseaseService;

    /**
     * Health check endpoint
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        boolean healthy = pestDiseaseService.isHealthy();
        
        response.put("service", "pest-disease");
        response.put("status", healthy ? "healthy" : "unhealthy");
        response.put("ai_api_connected", healthy);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Get supported disease classes
     */
    @GetMapping("/classes")
    public ResponseEntity<Map<String, Object>> getClasses() {
        try {
            Map<String, Object> classes = pestDiseaseService.getClasses();
            return ResponseEntity.ok(classes);
        } catch (Exception e) {
            logger.error("Error getting classes: {}", e.getMessage());
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to get classes: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Detect pest/disease from uploaded image
     */
    @PostMapping("/detect")
    public ResponseEntity<Map<String, Object>> detectDisease(
            @RequestParam(value = "image", required = false) MultipartFile imageFile,
            @RequestParam(value = "file", required = false) MultipartFile fileParam) {
        
        // Support both "image" and "file" parameters for compatibility
        MultipartFile file = imageFile != null ? imageFile : fileParam;
        
        logger.info("Received disease detection request for file: {}", 
                    file != null ? file.getOriginalFilename() : "null");

        if (file == null || file.isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("error", "No image file provided");
            return ResponseEntity.badRequest().body(error);
        }

        try {
            Map<String, Object> result = pestDiseaseService.detectDisease(file);
            
            if (result == null) {
                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("error", "Pest AI service không phản hồi");
                return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(error);
            }
            
            if (result.containsKey("error") || (result.containsKey("success") && !Boolean.TRUE.equals(result.get("success")))) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
            }
            
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            logger.error("Error detecting disease: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("error", "Detection failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Get detection history (placeholder for future implementation)
     */
    @GetMapping("/history")
    public ResponseEntity<Map<String, Object>> getDetectionHistory() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "History feature coming soon");
        response.put("detections", new Object[0]);
        return ResponseEntity.ok(response);
    }
}

