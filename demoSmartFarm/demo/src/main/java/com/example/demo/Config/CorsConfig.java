package com.example.demo.Config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        
        // Allow credentials
        config.setAllowCredentials(true);
        
        // Get allowed origins from environment variable
        String envOrigins = System.getenv("FRONTEND_ORIGINS");
        List<String> allowedOrigins = new ArrayList<>();
        
        if (envOrigins != null && !envOrigins.trim().isEmpty()) {
            // Split by comma and add each origin
            String[] origins = envOrigins.split("\\s*,\\s*");
            for (String origin : origins) {
                if (!origin.trim().isEmpty()) {
                    allowedOrigins.add(origin.trim());
                }
            }
        }
        
        // Fallback to default origins if no env var is set
        if (allowedOrigins.isEmpty()) {
            allowedOrigins.addAll(Arrays.asList(
                "http://localhost:3000",
                "http://localhost:8000",
                "http://localhost:8080",
                "http://localhost:9002"
            ));
        }
        
        config.setAllowedOrigins(allowedOrigins);
        
        // Allow specific headers for better security
        config.setAllowedHeaders(Arrays.asList(
            "Content-Type",
            "Authorization",
            "X-Requested-With",
            "Accept",
            "Origin",
            "Access-Control-Request-Method",
            "Access-Control-Request-Headers"
        ));
        
        // Allow all HTTP methods
        config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        
        // Expose headers that might be needed
        config.setExposedHeaders(Arrays.asList("Authorization"));
        
        // Max age for preflight requests
        config.setMaxAge(3600L);
        
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
}
