package com.example.demo.Controllers;

import com.example.demo.DTO.FarmDTO;
import com.example.demo.DTO.FieldDTO;
import com.example.demo.Services.FarmService;
import com.example.demo.Services.FieldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/farms")
@CrossOrigin(origins = {"https://hackathon-pione-dream.vercel.app", "https://hackathon-pione-dream-vzj5.vercel.app", "http://localhost:3000"})
public class FarmController {

    @Autowired
    private FarmService farmService;

    @Autowired
    private FieldService fieldService;

    @PostMapping
    public FarmDTO createFarm(@RequestBody FarmDTO farmDTO) {
        return farmService.createFarm(farmDTO);
    }

    @GetMapping
    public List<FarmDTO> getAllFarms() {
        return farmService.getAllFarms();
    }

    @GetMapping("/{id}")
    public FarmDTO getFarmById(@PathVariable Long id) {
        return farmService.getFarmById(id);
    }

    @PutMapping("/{id}")
    public FarmDTO updateFarm(@PathVariable Long id, @RequestBody FarmDTO farmDTO) {
        return farmService.updateFarm(id, farmDTO);
    }

    @DeleteMapping("/{id}")
    public void deleteFarm(@PathVariable Long id) {
        farmService.deleteFarm(id);
    }

    // Get all fields by farm ID
    @GetMapping("/{farmId}/fields")
    public List<FieldDTO> getFieldsByFarm(@PathVariable Long farmId) {
        return fieldService.getFieldsByFarmId(farmId);
    }
}

