package com.example.demo.Services;

import com.example.demo.DTO.FarmDTO;
import com.example.demo.Entities.AccountEntity;
import com.example.demo.Entities.FarmEntity;
import com.example.demo.Repositories.AccountRepository;
import com.example.demo.Repositories.FarmRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FarmService {

    @Autowired
    private FarmRepository farmRepository;

    @Autowired
    private AccountRepository accountRepository;

    public FarmDTO createFarm(FarmDTO farmDTO) {
        Optional<AccountEntity> ownerOpt = accountRepository.findById(farmDTO.getOwnerId());
        if (ownerOpt.isEmpty()) {
            throw new RuntimeException("Owner not found");
        }

        FarmEntity farm = new FarmEntity();
        farm.setFarmName(farmDTO.getFarmName());
        farm.setOwner(ownerOpt.get());
        farm.setArea(farmDTO.getArea());
        farm.setRegion(farmDTO.getRegion());
        farm.setLat(farmDTO.getLat());
        farm.setLng(farmDTO.getLng());
        FarmEntity saved = farmRepository.save(farm);
        return convertToDTO(saved);
    }

    public List<FarmDTO> getAllFarms() {
        return farmRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public FarmDTO getFarmById(Long id) {
        FarmEntity farm = farmRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Farm not found"));
        return convertToDTO(farm);
    }

    public FarmDTO updateFarm(Long id, FarmDTO farmDTO) {
        FarmEntity farm = farmRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Farm not found"));

        farm.setFarmName(farmDTO.getFarmName());
        farm.setArea(farmDTO.getArea());
        farm.setRegion(farmDTO.getRegion());
        farm.setLat(farmDTO.getLat());
        farm.setLng(farmDTO.getLng());

        if (!farm.getOwner().getId().equals(farmDTO.getOwnerId())) {
            AccountEntity newOwner = accountRepository.findById(farmDTO.getOwnerId())
                    .orElseThrow(() -> new RuntimeException("New owner not found"));
            farm.setOwner(newOwner);
        }

        FarmEntity updated = farmRepository.save(farm);
        return convertToDTO(updated);
    }

    public void deleteFarm(Long id) {
        farmRepository.deleteById(id);
    }

    private FarmDTO convertToDTO(FarmEntity farm) {
        return new FarmDTO(
                farm.getId(),
                farm.getFarmName(),
                farm.getOwner() != null ? farm.getOwner().getId() : null,
                farm.getLat(),
                farm.getLng(),
                farm.getArea(),
                farm.getRegion()
        );
    }
}
