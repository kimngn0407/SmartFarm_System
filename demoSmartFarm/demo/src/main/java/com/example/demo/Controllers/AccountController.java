package com.example.demo.Controllers;

import com.example.demo.DTO.AccountDTO;
import com.example.demo.DTO.Role;
import com.example.demo.Entities.AccountEntity;
import com.example.demo.Services.AccountService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/accounts")
public class AccountController {

    private final AccountService accountService;

    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }

    // Đăng ký tài khoản
    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody AccountDTO accountDTO) {
        // Tất cả người dùng đăng ký mới đều là ADMIN để trải nghiệm đầy đủ chức năng
        // Bỏ qua role được gửi từ frontend, luôn gán ADMIN
        String roleString = Role.ADMIN.name();

        String response = accountService.register(
                accountDTO.getFullName(),
                accountDTO.getEmail(),
                accountDTO.getPassword(),
                roleString
        );

        if (response.contains("không hợp lệ") || response.contains("đã tồn tại")) {
            return ResponseEntity.badRequest().body(response);
        }

        return ResponseEntity.ok(response);
    }

    // Đăng nhập
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AccountDTO accountDTO) {
        Object response = accountService.login(accountDTO.getEmail(), accountDTO.getPassword());

        if (response instanceof String && response.equals("Email hoặc mật khẩu không đúng!")) {
            return ResponseEntity.status(401).body(response);
        }

        return ResponseEntity.ok(response);
    }

    // Lấy thông tin hồ sơ người dùng
    @GetMapping("/profile")
    @PreAuthorize("hasAnyRole('ADMIN', 'FARM_OWNER', 'TECHNICIAN', 'FARMER')")
    public ResponseEntity<?> getProfile(@RequestParam String email) {
        try {
            AccountDTO dto = accountService.getProfileByEmail(email);
            return ResponseEntity.ok(dto);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Cập nhật hồ sơ cá nhân
    @PutMapping("/updateprofile")
    @PreAuthorize("hasAnyRole('ADMIN', 'FARM_OWNER', 'TECHNICIAN', 'FARMER')")
    public ResponseEntity<?> updateProfile(@RequestParam String email, @RequestBody AccountDTO updateDTO) {
        String result = accountService.updateProfile(email, updateDTO);
        if (result.equals("Không tìm thấy tài khoản!")) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(result);
    }

    // Lấy danh sách tất cả tài khoản (chỉ ADMIN)
    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public List<AccountDTO> getAllAccounts() {
        return accountService.getAllAccounts().stream().map(account -> {
            AccountDTO dto = new AccountDTO();
            dto.setId(account.getId());
            dto.setFullName(account.getFullName());
            dto.setEmail(account.getEmail());
            dto.setRoles(account.getRoles());

            if (account.getFarm() != null) {
                dto.setFarmId(account.getFarm().getId());
                dto.setFarmName(account.getFarm().getFarmName());
            }

            if (account.getField() != null) {
                dto.setFieldId(account.getField().getId());
                dto.setFieldName(account.getField().getFieldName());
            }

            return dto;
        }).collect(Collectors.toList());
    }

    // Cập nhật vai trò (chỉ ADMIN)
    @PutMapping("/{id}/role")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> updateRole(@PathVariable Long id, @RequestBody AccountDTO dto) {
        String result = accountService.updateRole(id,
                String.join(",", dto.getRoles().stream().map(Role::name).toList()));
        if (result.contains("không hợp lệ") || result.contains("Không tìm thấy")) {
            return ResponseEntity.badRequest().body(result);
        }
        return ResponseEntity.ok(result);
    }

    // Cập nhật vai trò + phân công farm/field (chỉ ADMIN)
    @PutMapping("/{id}/assign")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> updateRoleAndAssignment(
            @PathVariable Long id,
            @RequestBody AccountDTO dto) {
        try {
            String response = accountService.updateRoleAndAssignment(
                    id,
                    String.join(",", dto.getRoles().stream().map(Role::name).toList()),
                    dto.getFarmId(),
                    dto.getFieldId()
            );

            if (response.contains("không hợp lệ") || response.contains("Không tìm thấy")) {
                return ResponseEntity.badRequest().body(response);
            }

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Lỗi hệ thống: " + e.getMessage());
        }
    }
}
