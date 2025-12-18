package com.example.demo.Services;

import com.example.demo.DTO.AccountDTO;
import com.example.demo.DTO.CompleteProfileDTO;
import com.example.demo.DTO.PersonalInfoDTO;
import com.example.demo.DTO.Role;
import com.example.demo.Entities.AccountEntity;
import com.example.demo.Entities.FarmEntity;
import com.example.demo.Entities.FieldEntity;
import com.example.demo.Repositories.AccountRepository;
import com.example.demo.Repositories.FarmRepository;
import com.example.demo.Repositories.FieldRepository;
import com.example.demo.Security.CustomUserDetailsService;
import com.example.demo.Security.JwtUtils;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class AccountService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    private final AccountRepository accountRepository;
    private final FarmRepository farmRepository;
    private final FieldRepository fieldRepository;

    public AccountService(AccountRepository accountRepository,
                          FarmRepository farmRepository,
                          FieldRepository fieldRepository) {
        this.accountRepository = accountRepository;
        this.farmRepository = farmRepository;
        this.fieldRepository = fieldRepository;
    }

    public Optional<AccountEntity> getByEmail(String email) {
        return accountRepository.findByEmail(email);
    }

    @Transactional
    public String changePassword(String email, String oldPassword, String newPassword) {
        Optional<AccountEntity> accountOpt = accountRepository.findByEmail(email);
        if (accountOpt.isEmpty()) {
            return "Không tìm thấy tài khoản!";
        }
        AccountEntity account = accountOpt.get();
        
        if (!passwordEncoder.matches(oldPassword, account.getPassword())) {
            return "Mật khẩu cũ không đúng!";
        }
        
        account.setPassword(passwordEncoder.encode(newPassword));
        accountRepository.save(account);
        return "Đổi mật khẩu thành công!";
    }

    @Transactional
    public String register(String fullName, String email, String password, String roleInput) {
        if (accountRepository.findByEmail(email).isPresent()) {
            return "Email đã tồn tại!";
        }

        String[] roleArray = roleInput.split(",");
        Set<Role> roles = new HashSet<>();

        for (String r : roleArray) {
            try {
                roles.add(Role.valueOf(r.trim().toUpperCase()));
            } catch (IllegalArgumentException e) {
                return "Vai trò không hợp lệ! Chọn một trong: ADMIN, FARMER, TECHNICIAN, FARM_OWNER.";
            }
        }

        AccountEntity accountEntity = new AccountEntity();
        accountEntity.setFullName(fullName);
        accountEntity.setEmail(email);
        accountEntity.setPassword(passwordEncoder.encode(password));
        accountEntity.setRoles(roles);
        accountEntity.setDateCreated(java.time.LocalDateTime.now());

        accountRepository.save(accountEntity);
        return "Đăng ký thành công!";
    }

    public Object login(String email, String password) {
        Optional<AccountEntity> accountOpt = accountRepository.findByEmail(email);

        if (accountOpt.isEmpty() || !passwordEncoder.matches(password, accountOpt.get().getPassword())) {
            return "Email hoặc mật khẩu không đúng!";
        }

        // Generate JWT token
        UserDetails userDetails = userDetailsService.loadUserByUsername(email);
        String token = jwtUtils.generateToken(userDetails);

        // Build complete profile response
        AccountEntity account = accountOpt.get();
        CompleteProfileDTO profile = new CompleteProfileDTO(token);
        
        // Add personal info
        PersonalInfoDTO personalInfo = new PersonalInfoDTO();
        personalInfo.setId(account.getId());
        personalInfo.setFullName(account.getFullName());
        personalInfo.setEmail(account.getEmail());
        personalInfo.setRoles(account.getRoles());
        
        // Add farm/field info if assigned
        if (account.getFarm() != null) {
            personalInfo.setFarmId(account.getFarm().getId());
            personalInfo.setFarmName(account.getFarm().getFarmName());
        }
        if (account.getField() != null) {
            personalInfo.setFieldId(account.getField().getId());
            personalInfo.setFieldName(account.getField().getFieldName());
        }
        
        profile.setPersonalInfo(personalInfo);
        
        return profile;
    }

    @Transactional
    public String updateProfile(String email, AccountDTO dto) {
        Optional<AccountEntity> accountOpt = accountRepository.findByEmail(email);
        if (accountOpt.isEmpty()) {
            return "Không tìm thấy tài khoản!";
        }

        AccountEntity account = accountOpt.get();
        if (dto.getFullName() != null) account.setFullName(dto.getFullName());
        if (dto.getPhone() != null) account.setPhone(dto.getPhone());
        if (dto.getAddress() != null) account.setAddress(dto.getAddress());
        if (dto.getPassword() != null) account.setPassword(passwordEncoder.encode(dto.getPassword()));
        if (dto.getRoles() != null) account.setRoles(dto.getRoles());

        accountRepository.save(account);
        return "Cập nhật thông tin thành công!";
    }

    private AccountDTO convertToDTO(AccountEntity account) {
        AccountDTO dto = new AccountDTO();
        dto.setId(account.getId());
        dto.setFullName(account.getFullName());
        dto.setEmail(account.getEmail());
        dto.setPhone(account.getPhone());
        dto.setAddress(account.getAddress());
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
    }

    public AccountDTO getProfileByEmail(String email) {
        AccountEntity account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return convertToDTO(account);
    }

    public List<AccountEntity> getAllAccounts() {
        return accountRepository.findAll();
    }

    @Transactional
    public String updateRole(Long id, String roleInput) {
        Optional<AccountEntity> accountOpt = accountRepository.findById(id);
        if (accountOpt.isEmpty()) {
            return "Không tìm thấy tài khoản!";
        }

        String[] roleArray = roleInput.split(",");
        Set<Role> roles = new HashSet<>();

        for (String r : roleArray) {
            try {
                roles.add(Role.valueOf(r.trim().toUpperCase()));
            } catch (IllegalArgumentException e) {
                return "Vai trò không hợp lệ! Chọn một trong: ADMIN, FARMER, TECHNICIAN, FARM_OWNER.";
            }
        }

        AccountEntity account = accountOpt.get();
        account.setRoles(roles);
        accountRepository.save(account);
        return "Cập nhật vai trò thành công!";
    }

    @Transactional
    public String updateRoleAndAssignment(Long id, String roleInput, Long farmId, Long fieldId) {
        Optional<AccountEntity> accountOpt = accountRepository.findById(id);
        if (accountOpt.isEmpty()) {
            return "Không tìm thấy tài khoản!";
        }

        String[] roleArray = roleInput.split(",");
        Set<Role> roles = new HashSet<>();

        for (String r : roleArray) {
            try {
                roles.add(Role.valueOf(r.trim().toUpperCase()));
            } catch (IllegalArgumentException e) {
                return "Vai trò không hợp lệ! Chọn một trong: ADMIN, FARMER, TECHNICIAN, FARM_OWNER.";
            }
        }

        AccountEntity account = accountOpt.get();
        account.setRoles(roles);

        if (farmId != null) {
            FarmEntity farm = farmRepository.findById(farmId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy Farm với ID: " + farmId));
            account.setFarm(farm);
        }

        if (fieldId != null) {
            FieldEntity field = fieldRepository.findById(fieldId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy Field với ID: " + fieldId));
            account.setField(field);
        }

        accountRepository.save(account);
        return "Phân quyền và gán farm/field thành công!";
    }
}
