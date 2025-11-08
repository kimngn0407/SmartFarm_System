package com.example.demo.Controllers;

import com.example.demo.DTO.FieldDTO;
import com.example.demo.Services.FieldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/fields")
@CrossOrigin(origins = {"https://hackathon-pione-dream.vercel.app", "https://hackathon-pione-dream-vzj5.vercel.app", "http://localhost:3000"})
public class FieldController {

    @Autowired
    private FieldService fieldService;

    @PostMapping
    public FieldDTO createField(@RequestBody FieldDTO dto) {
        return fieldService.createField(dto);
    }

    @GetMapping
    public List<FieldDTO> getAllFields() {
        return fieldService.getAllFields();
    }

    @GetMapping("/{farmId}/field")
    public List<FieldDTO> getFieldsByFarmId(@PathVariable Long farmId) {
        return fieldService.getFieldsByFarmId(farmId);
    }

    @GetMapping("/{id}")
    public FieldDTO getFieldById(@PathVariable Long id) {
        return fieldService.getFieldById(id);
    }

    @PutMapping("/{id}")
    public FieldDTO updateField(@PathVariable Long id, @RequestBody FieldDTO dto) {
        return fieldService.updateField(id, dto);
    }

    @DeleteMapping("/{id}")
    public void deleteField(@PathVariable Long id) {
        fieldService.deleteField(id);
    }
}