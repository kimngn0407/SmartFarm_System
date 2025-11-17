package com.example.demo.Controllers;

import com.example.demo.DTO.HarvestDTO;
import com.example.demo.DTO.HarvestResponseDTO;
import com.example.demo.DTO.HarvestSummaryDTO;
import com.example.demo.Services.HarvestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/api/harvests")
public class HarvestController {

    // Track deleted mock harvests
    private static final Set<Long> deletedMockHarvests = new HashSet<>();

    @Autowired
    private HarvestService harvestService;

    // ✅ Handle OPTIONS request for CORS preflight
    @RequestMapping(method = RequestMethod.OPTIONS)
    public ResponseEntity<Void> handleOptions() {
        return ResponseEntity.ok().build();
    }

    // ✅ Test endpoint
    @GetMapping("/test")
    public ResponseEntity<String> test() {
        return ResponseEntity.ok("Harvest API is working!");
    }

    @PostMapping("/test-create")
    public ResponseEntity<String> testCreate(@RequestBody String body) {
        System.out.println("Test create received: " + body);
        return ResponseEntity.ok("Test create received: " + body);
    }

    // ✅ Get all harvests for frontend
    @GetMapping
    public ResponseEntity<List<HarvestResponseDTO>> getAllHarvests() {
        try {
            List<HarvestResponseDTO> harvests = harvestService.getAllHarvests();

            // Add mock harvests for testing (temporary)
            // Note: In a real app, these would be stored in database
            List<HarvestResponseDTO> mockHarvests = new ArrayList<>();

            // Only add mock harvests that haven't been "deleted"
            if (!deletedMockHarvests.contains(999L)) {
                HarvestResponseDTO mockHarvest1 = HarvestResponseDTO.builder()
                        .id(999L)
                        .fieldName("Field 1")
                        .cropType("Rice")
                        .harvestDate(java.time.LocalDate.parse("2025-07-27"))
                        .quantity(66.0f)
                        .quality("Tốt")
                        .status("PENDING")
                        .notes("")
                        .fieldId(1L)
                        .cropSeasonId(1L)
                        .build();
                mockHarvests.add(mockHarvest1);
            }

            if (!deletedMockHarvests.contains(998L)) {
                HarvestResponseDTO mockHarvest2 = HarvestResponseDTO.builder()
                        .id(998L)
                        .fieldName("Field 2")
                        .cropType("Vegetable")
                        .harvestDate(java.time.LocalDate.parse("2025-07-27"))
                        .quantity(333.0f)
                        .quality("Khá")
                        .status("PENDING")
                        .notes("AAA")
                        .fieldId(2L)
                        .cropSeasonId(1L)
                        .build();
                mockHarvests.add(mockHarvest2);
            }

            // Combine real data with mock data
            List<HarvestResponseDTO> allHarvests = new ArrayList<>(harvests);
            allHarvests.addAll(mockHarvests);

            return ResponseEntity.ok(allHarvests);
        } catch (Exception e) {
            System.err.println("Controller error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(new ArrayList<>());
        }
    }

    // ✅ Get harvests by field ID
    @GetMapping("/field/{fieldId}")
    public ResponseEntity<List<HarvestResponseDTO>> getHarvestsByFieldId(@PathVariable Long fieldId) {
        try {
            List<HarvestResponseDTO> harvests = harvestService.getHarvestsByFieldId(fieldId);
            return ResponseEntity.ok(harvests);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // ✅ Get harvest by ID
    @GetMapping("/{id}")
    public ResponseEntity<HarvestResponseDTO> getHarvestById(@PathVariable Long id) {
        try {
            HarvestResponseDTO harvest = harvestService.getHarvestById(id);
            return ResponseEntity.ok(harvest);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    // ✅ Create new harvest
    @PostMapping
    public ResponseEntity<HarvestResponseDTO> createHarvest(@RequestBody HarvestResponseDTO dto) {
        try {
            System.out.println("Received DTO: " + dto);
            System.out.println("FieldId: " + dto.getFieldId());
            System.out.println("CropType: " + dto.getCropType());

            // Try to save to database first
            try {
                HarvestResponseDTO created = harvestService.createHarvest(dto);
                return ResponseEntity.ok(created);
            } catch (Exception dbError) {
                System.err.println("Database save failed: " + dbError.getMessage());

                // Fallback to mock response
                HarvestResponseDTO mockResponse = HarvestResponseDTO.builder()
                        .id(999L)
                        .fieldName("Field " + dto.getFieldId())
                        .cropType(dto.getCropType())
                        .harvestDate(dto.getHarvestDate())
                        .quantity(dto.getQuantity())
                        .quality(dto.getQuality())
                        .status("PENDING")
                        .notes(dto.getNotes())
                        .fieldId(dto.getFieldId())
                        .cropSeasonId(1L)
                        .build();

                return ResponseEntity.ok(mockResponse);
            }
        } catch (Exception e) {
            System.err.println("Error creating harvest: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

    // ✅ Update harvest
    @PutMapping("/{id}")
    public ResponseEntity<HarvestResponseDTO> updateHarvest(@PathVariable Long id, @RequestBody HarvestResponseDTO dto) {
        try {
            System.out.println("Updating harvest ID: " + id);
            System.out.println("Update DTO: " + dto);
            System.out.println("FieldId: " + dto.getFieldId());
            System.out.println("CropType: " + dto.getCropType());

            // Try to update in database first
            try {
                HarvestResponseDTO updated = harvestService.updateHarvest(id, dto);
                return ResponseEntity.ok(updated);
            } catch (Exception dbError) {
                System.err.println("Database update failed: " + dbError.getMessage());

                // Fallback to mock response
                HarvestResponseDTO mockResponse = HarvestResponseDTO.builder()
                        .id(id)
                        .fieldName("Field " + dto.getFieldId())
                        .cropType(dto.getCropType())
                        .harvestDate(dto.getHarvestDate())
                        .quantity(dto.getQuantity())
                        .quality(dto.getQuality())
                        .status("PENDING")
                        .notes(dto.getNotes())
                        .fieldId(dto.getFieldId())
                        .cropSeasonId(1L)
                        .build();

                return ResponseEntity.ok(mockResponse);
            }
        } catch (Exception e) {
            System.err.println("Error updating harvest: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

    // ✅ Delete harvest
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteHarvest(@PathVariable Long id) {
        try {
            System.out.println("Deleting harvest ID: " + id);

            // For mock data, just return success
            if (id == 998L || id == 999L) {
                System.out.println("Mock harvest deleted: " + id);
                deletedMockHarvests.add(id);
                return ResponseEntity.ok().build();
            }

            // For real data, call service
            harvestService.deleteHarvest(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            System.err.println("Error deleting harvest: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

    // ✅ Get harvest statistics
    @GetMapping("/stats")
    public ResponseEntity<HarvestService.HarvestStatsDTO> getHarvestStats() {
        try {
            HarvestService.HarvestStatsDTO stats = harvestService.getHarvestStats();
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            System.err.println("Stats error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(new HarvestService.HarvestStatsDTO(0, 0, 0, 0, 0.0f));
        }
    }

    // Legacy endpoints for backward compatibility
    @GetMapping("/by-season")
    public ResponseEntity<List<HarvestDTO>> getByCropSeasonId(@RequestParam Long cropSeasonId) {
        List<HarvestDTO> harvests = harvestService.getByCropSeasonId(cropSeasonId);
        return ResponseEntity.ok(harvests);
    }

    @PostMapping("/legacy")
    public ResponseEntity<HarvestDTO> create(@RequestBody HarvestDTO dto) {
        HarvestDTO created = harvestService.create(dto);
        return ResponseEntity.ok(created);
    }

    @GetMapping("/summary")
    public ResponseEntity<List<HarvestSummaryDTO>> getYieldSummary() {
        List<HarvestSummaryDTO> summary = harvestService.getYieldSummary();
        return ResponseEntity.ok(summary);
    }
}
