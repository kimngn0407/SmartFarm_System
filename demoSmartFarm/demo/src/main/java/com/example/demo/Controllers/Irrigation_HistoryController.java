package com.example.demo.Controllers;

import com.example.demo.DTO.Irrigation_HistoryDTO;
import com.example.demo.Services.Irrigation_HistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/irrigation")
public class Irrigation_HistoryController {

    @Autowired
    private Irrigation_HistoryService irrigationHistoryService;

    @GetMapping
    public ResponseEntity<?> getByField(@RequestParam(required = false) Long fieldId) {
        try {
            // Validate fieldId
            if (fieldId == null || fieldId <= 0) {
                return ResponseEntity.badRequest().body("fieldId là bắt buộc và phải lớn hơn 0");
            }
            
            List<Irrigation_HistoryDTO> history = irrigationHistoryService.getByFieldId(fieldId);
            
            // Trả về empty list nếu không có dữ liệu (không phải lỗi)
            return ResponseEntity.ok(history);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi khi lấy lịch sử tưới tiêu: " + e.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Irrigation_HistoryDTO dto) {
        try {
            Irrigation_HistoryDTO created = irrigationHistoryService.create(dto);
            return ResponseEntity.status(HttpStatus.CREATED).body(created);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi khi tạo lịch sử tưới tiêu: " + e.getMessage());
        }
    }
}
