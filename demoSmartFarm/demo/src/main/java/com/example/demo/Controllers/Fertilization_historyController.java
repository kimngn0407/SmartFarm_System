package com.example.demo.Controllers;

import com.example.demo.DTO.Fertilization_historyDTO;
import com.example.demo.Services.Fertilization_historyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/fertilization")
@CrossOrigin(origins = {"https://hackathon-pione-dream.vercel.app", "http://localhost:3000"})
public class Fertilization_historyController {

    @Autowired
    private Fertilization_historyService fertilizationHistoryService;

    @GetMapping
    public ResponseEntity<?> getByField(@RequestParam(required = false) Long fieldId) {
        try {
            // Validate fieldId
            if (fieldId == null || fieldId <= 0) {
                return ResponseEntity.badRequest().body("fieldId là bắt buộc và phải lớn hơn 0");
            }
            
            List<Fertilization_historyDTO> history = fertilizationHistoryService.getByFieldId(fieldId);
            
            // Trả về empty list nếu không có dữ liệu (không phải lỗi)
            return ResponseEntity.ok(history);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi khi lấy lịch sử bón phân: " + e.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Fertilization_historyDTO dto) {
        try {
            Fertilization_historyDTO created = fertilizationHistoryService.create(dto);
            return ResponseEntity.status(HttpStatus.CREATED).body(created);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi khi tạo lịch sử bón phân: " + e.getMessage());
        }
    }
}
