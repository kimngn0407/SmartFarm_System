package com.example.demo.Controllers;

import com.example.demo.DTO.SensorDTO;
import com.example.demo.Services.SensorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sensors")
@CrossOrigin(origins = {"http://173.249.48.25", "http://173.249.48.25:80", "http://localhost:3000"})
public class SensorController {

    @Autowired
    private SensorService sensorService;

    @PostMapping
    public SensorDTO createSensor(@RequestBody SensorDTO dto) {
        return sensorService.createSensor(dto);
    }

    @GetMapping
    public List<SensorDTO> getSensors(@RequestParam(required = false) Long fieldId) {
        if (fieldId != null) {
            return sensorService.getSensorsByFieldId(fieldId);
        } else {
            // Return ALL sensors if no fieldId provided
            return sensorService.getAllSensors();
        }
    }

    @GetMapping("/{id}")
    public SensorDTO getSensorById(@PathVariable Long id) {
        return sensorService.getSensorById(id);
    }

    @PutMapping("/{id}")
    public SensorDTO updateSensor(@PathVariable Long id, @RequestBody SensorDTO dto) {
        return sensorService.updateSensor(id, dto);
    }

    @DeleteMapping("/{id}")
    public void deleteSensor(@PathVariable Long id) {
        sensorService.deleteSensor(id);
    }

    @GetMapping("/farm/{farmId}/count")
    public ResponseEntity<Long> countSensorsByFarmId(@PathVariable Long farmId) {
        long count = sensorService.countSensorsByFarmId(farmId);
        return ResponseEntity.ok(count);
    }

    @GetMapping("/count")
    public ResponseEntity<Long> countAllSensors() {
        long count = sensorService.countAllSensors();
        return ResponseEntity.ok(count);
    }



}
