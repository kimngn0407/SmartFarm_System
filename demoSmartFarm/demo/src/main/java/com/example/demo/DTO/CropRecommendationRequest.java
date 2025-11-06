package com.example.demo.DTO;

/**
 * DTO for Crop Recommendation Request
 */
public class CropRecommendationRequest {
    private Double temperature;
    private Double humidity;
    private Double soil_moisture;  // Note: underscore for JSON compatibility
    private Double soilMoisture;   // Alternative camelCase

    public CropRecommendationRequest() {
    }

    public CropRecommendationRequest(Double temperature, Double humidity, Double soil_moisture) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.soil_moisture = soil_moisture;
        this.soilMoisture = soil_moisture;
    }

    public Double getTemperature() {
        return temperature;
    }

    public void setTemperature(Double temperature) {
        this.temperature = temperature;
    }

    public Double getHumidity() {
        return humidity;
    }

    public void setHumidity(Double humidity) {
        this.humidity = humidity;
    }

    public Double getSoil_moisture() {
        return soil_moisture != null ? soil_moisture : soilMoisture;
    }

    public void setSoil_moisture(Double soil_moisture) {
        this.soil_moisture = soil_moisture;
        this.soilMoisture = soil_moisture;
    }

    public Double getSoilMoisture() {
        return soilMoisture != null ? soilMoisture : soil_moisture;
    }

    public void setSoilMoisture(Double soilMoisture) {
        this.soilMoisture = soilMoisture;
        this.soil_moisture = soilMoisture;
    }

    @Override
    public String toString() {
        return "CropRecommendationRequest{" +
                "temperature=" + temperature +
                ", humidity=" + humidity +
                ", soil_moisture=" + getSoil_moisture() +
                '}';
    }
}

