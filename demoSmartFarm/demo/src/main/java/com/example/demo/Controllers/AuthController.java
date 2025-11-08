package com.example.demo.Controllers;

import com.example.demo.DTO.AccountDTO;
import com.example.demo.Services.AccountService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = {"https://hackathon-pione-dream.vercel.app", "http://localhost:3000"})
public class AuthController {

    private final AccountService accountService;

    public AuthController(AccountService accountService) {
        this.accountService = accountService;
    }

    /**
     * Login endpoint
     * POST /api/auth/login
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AccountDTO accountDTO) {
        try {
            // Validate input
            if (accountDTO.getEmail() == null || accountDTO.getEmail().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("Email is required"));
            }
            
            if (accountDTO.getPassword() == null || accountDTO.getPassword().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("Password is required"));
            }

            // Call service
            Object response = accountService.login(accountDTO.getEmail(), accountDTO.getPassword());

            // Check if login failed
            if (response instanceof String) {
                String message = (String) response;
                if (message.contains("không đúng") || message.contains("không tìm thấy")) {
                    return ResponseEntity.status(401).body(createErrorResponse(message));
                }
            }

            // Login successful
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("Internal server error: " + e.getMessage()));
        }
    }

    /**
     * Register endpoint
     * POST /api/auth/register
     */
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody AccountDTO accountDTO) {
        try {
            // Validate input
            if (accountDTO.getEmail() == null || accountDTO.getEmail().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("Email is required"));
            }
            
            if (accountDTO.getPassword() == null || accountDTO.getPassword().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("Password is required"));
            }
            
            if (accountDTO.getFullName() == null || accountDTO.getFullName().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("Full name is required"));
            }

            // Tất cả người dùng đăng ký mới đều là ADMIN để trải nghiệm đầy đủ chức năng
            // Bỏ qua role được gửi từ frontend, luôn gán ADMIN
            String roleString = "ADMIN";

            // Call service
            String response = accountService.register(
                accountDTO.getFullName(),
                accountDTO.getEmail(),
                accountDTO.getPassword(),
                roleString
            );

            // Check if registration failed
            if (response.contains("không hợp lệ") || response.contains("đã tồn tại")) {
                return ResponseEntity.badRequest().body(createErrorResponse(response));
            }

            // Registration successful
            Map<String, Object> successResponse = new HashMap<>();
            successResponse.put("success", true);
            successResponse.put("message", response);
            return ResponseEntity.ok(successResponse);

        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("Internal server error: " + e.getMessage()));
        }
    }

    /**
     * Health check endpoint
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("service", "auth");
        response.put("status", "healthy");
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.ok(response);
    }

    /**
     * Helper method to create error response
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", message);
        error.put("timestamp", System.currentTimeMillis());
        return error;
    }
}

