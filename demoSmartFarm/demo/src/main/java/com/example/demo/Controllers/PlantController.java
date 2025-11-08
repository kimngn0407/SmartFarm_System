package com.example.demo.Controllers;

import com.example.demo.DTO.PlantDTO;
import com.example.demo.DTO.PlantDetailDTO;
import com.example.demo.DTO.PlantFlatStageDTO;
import com.example.demo.Services.PlantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/plants")
@CrossOrigin(origins = {"https://hackathon-pione-dream.vercel.app", "https://hackathon-pione-dream-vzj5.vercel.app", "http://localhost:3000"})
public class PlantController {

    @Autowired
    private PlantService plantService;

    @PostMapping
    public PlantDTO createPlant(@RequestBody PlantDTO dto) {
        return plantService.createPlant(dto);
    }

    @GetMapping
    public List<PlantDTO> getAllPlants() {
        return plantService.getAllPlants();
    }

    @GetMapping("/{id}")
    public PlantDTO getPlantById(@PathVariable Long id) {
        return plantService.getPlantById(id);
    }

    @PutMapping("/{id}")
    public PlantDTO updatePlant(@PathVariable Long id, @RequestBody PlantDTO dto) {
        return plantService.updatePlant(id, dto);
    }

    @DeleteMapping("/{id}")
    public void deletePlant(@PathVariable Long id) {
        plantService.deletePlant(id);
    }

    @GetMapping("/details")
    public ResponseEntity<List<PlantDetailDTO>> getPlantDetails() {
        List<PlantDetailDTO> details = plantService.getAllPlantDetails();
        return ResponseEntity.ok(details);
    }
    @GetMapping("/{plantId}/flat-stages")
    public ResponseEntity<List<PlantFlatStageDTO>> getFlatStagesByPlantId(@PathVariable Long plantId) {
        List<PlantFlatStageDTO> dtos = plantService.getFlatStagesByPlantId(plantId);
        return ResponseEntity.ok(dtos);
    }


}