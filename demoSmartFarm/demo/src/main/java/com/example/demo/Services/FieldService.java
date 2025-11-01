package com.example.demo.Services;

import com.example.demo.DTO.FieldDTO;
import com.example.demo.Entities.FarmEntity;
import com.example.demo.Entities.FieldEntity;
import com.example.demo.Repositories.FarmRepository;
import com.example.demo.Repositories.FieldRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FieldService {

    @Autowired
    private FieldRepository fieldRepository;

    @Autowired
    private FarmRepository farmRepository;

    public FieldDTO createField(FieldDTO dto) {
        FarmEntity farm = farmRepository.findById(dto.getFarmId())
                .orElseThrow(() -> new RuntimeException("Farm not found"));

        FieldEntity field = new FieldEntity();
        field.setFieldName(dto.getFieldName());
        field.setStatus(dto.getStatus());
        field.setArea(dto.getArea());
        field.setRegion(dto.getRegion());
        field.setDateCreated(dto.getDateCreated() != null ? dto.getDateCreated() : LocalDateTime.now());
        field.setFarm(farm);

        return convertToDTO(fieldRepository.save(field));
    }

    public List<FieldDTO> getAllFields() {
        return fieldRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<FieldDTO> getFieldsByFarmId(Long farmId) {
        return fieldRepository.findByFarmId(farmId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public FieldDTO getFieldById(Long id) {
        FieldEntity field = fieldRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Field not found"));
        return convertToDTO(field);
    }

    public FieldDTO updateField(Long id, FieldDTO dto) {
        FieldEntity field = fieldRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Field not found"));

        field.setFieldName(dto.getFieldName());
        field.setStatus(dto.getStatus());
        field.setArea(dto.getArea());
        field.setRegion(dto.getRegion());

        if (!field.getFarm().getId().equals(dto.getFarmId())) {
            FarmEntity newFarm = farmRepository.findById(dto.getFarmId())
                    .orElseThrow(() -> new RuntimeException("New farm not found"));
            field.setFarm(newFarm);
        }

        return convertToDTO(fieldRepository.save(field));
    }

    public void deleteField(Long id) {
        fieldRepository.deleteById(id);
    }

    private FieldDTO convertToDTO(FieldEntity field) {
        return new FieldDTO(
                field.getId(),
                field.getFarm().getId(),
                field.getFieldName(),
                field.getStatus(),
                field.getDateCreated(),
                field.getArea(),
                field.getRegion()
        );
    }
}
