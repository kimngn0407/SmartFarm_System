# Crop Recommendation Service

Service gợi ý cây trồng sử dụng RandomForest model cho hệ thống Smart Farm.

## 📋 Yêu cầu

- Python 3.8+
- Virtual environment (đã có sẵn trong `.venv`)

## 🚀 Cài đặt

### 1. Kích hoạt virtual environment

```bash
# Windows
.venv\Scripts\activate

# Linux/Mac
source .venv/bin/activate
```

### 2. Cài đặt dependencies

```bash
pip install -r requirements.txt
```

## 🎯 Sử dụng

### Cách 1: Chạy API Service (Khuyến nghị)

#### Khởi động service:

```bash
# Sử dụng batch file (Windows)
start_service.bat

# Hoặc chạy trực tiếp
python crop_recommendation_service.py
```

Service sẽ chạy tại: `http://localhost:5000`

#### Test API:

```bash
# Trong terminal khác (sau khi service đã chạy)
python test_api.py
```

### Cách 2: Test model trực tiếp

```bash
python test_model.py
```

## 📡 API Endpoints

### 1. Health Check
```http
GET /health
```

**Response:**
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

### 2. Gợi ý cây trồng (Single)
```http
POST /api/recommend-crop
Content-Type: application/json

{
  "N": 90,
  "P": 42,
  "K": 43,
  "temperature": 20.87,
  "humidity": 82.0,
  "ph": 6.5,
  "rainfall": 202.93
}
```

**Response:**
```json
{
  "success": true,
  "recommended_crop": "Lúa",
  "crop_code": 0,
  "confidence": 0.95,
  "input_data": {...}
}
```

### 3. Gợi ý cây trồng (Batch)
```http
POST /api/recommend-crop/batch
Content-Type: application/json

{
  "samples": [
    {
      "N": 90, "P": 42, "K": 43,
      "temperature": 20.87, "humidity": 82.0,
      "ph": 6.5, "rainfall": 202.93
    },
    {...}
  ]
}
```

### 4. Danh sách cây trồng
```http
GET /api/crops
```

## 🔗 Tích hợp vào Backend Java

### Tạo Service gọi API trong Java Spring Boot:

```java
// src/main/java/com/example/smartfarm/service/CropRecommendationService.java
package com.example.smartfarm.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.Map;

@Service
public class CropRecommendationService {
    
    private final RestTemplate restTemplate;
    private final String API_BASE_URL = "http://localhost:5000/api";
    
    public CropRecommendationService() {
        this.restTemplate = new RestTemplate();
    }
    
    public Map<String, Object> recommendCrop(
        double n, double p, double k,
        double temperature, double humidity,
        double ph, double rainfall
    ) {
        try {
            String url = API_BASE_URL + "/recommend-crop";
            
            Map<String, Object> request = new HashMap<>();
            request.put("N", n);
            request.put("P", p);
            request.put("K", k);
            request.put("temperature", temperature);
            request.put("humidity", humidity);
            request.put("ph", ph);
            request.put("rainfall", rainfall);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);
            
            ResponseEntity<Map> response = restTemplate.exchange(
                url, 
                HttpMethod.POST, 
                entity, 
                Map.class
            );
            
            return response.getBody();
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("error", e.getMessage());
            return error;
        }
    }
}
```

### Tạo Controller:

```java
// src/main/java/com/example/smartfarm/controller/CropRecommendationController.java
package com.example.smartfarm.controller;

import com.example.smartfarm.service.CropRecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/crop-recommendation")
@CrossOrigin(origins = "*")
public class CropRecommendationController {
    
    @Autowired
    private CropRecommendationService cropRecommendationService;
    
    @PostMapping("/recommend")
    public ResponseEntity<Map<String, Object>> recommend(@RequestBody Map<String, Double> data) {
        Map<String, Object> result = cropRecommendationService.recommendCrop(
            data.get("N"),
            data.get("P"),
            data.get("K"),
            data.get("temperature"),
            data.get("humidity"),
            data.get("ph"),
            data.get("rainfall")
        );
        
        return ResponseEntity.ok(result);
    }
}
```

## 🎨 Tích hợp vào Frontend React

### Tạo Service:

```javascript
// src/services/cropRecommendationService.js
const API_BASE_URL = 'http://localhost:8080/api/crop-recommendation';

export const cropRecommendationService = {
  async recommendCrop(data) {
    try {
      const response = await fetch(`${API_BASE_URL}/recommend`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
      });
      return await response.json();
    } catch (error) {
      console.error('Error recommending crop:', error);
      throw error;
    }
  }
};
```

### Sử dụng trong Component:

```javascript
import { cropRecommendationService } from '../services/cropRecommendationService';

const handleRecommend = async () => {
  const soilData = {
    N: 90,
    P: 42,
    K: 43,
    temperature: 20.87,
    humidity: 82.0,
    ph: 6.5,
    rainfall: 202.93
  };
  
  const result = await cropRecommendationService.recommendCrop(soilData);
  console.log('Recommended crop:', result.recommended_crop);
};
```

## 📊 Các tham số Input

| Tham số | Mô tả | Đơn vị | Ví dụ |
|---------|-------|--------|-------|
| N | Nitrogen (Đạm) | ppm | 90 |
| P | Phosphorus (Lân) | ppm | 42 |
| K | Potassium (Kali) | ppm | 43 |
| temperature | Nhiệt độ | °C | 20.87 |
| humidity | Độ ẩm | % | 82.0 |
| ph | Độ pH đất | - | 6.5 |
| rainfall | Lượng mưa | mm | 202.93 |

## 🌱 Danh sách Cây trồng

| Code | Tên cây trồng |
|------|---------------|
| 0 | Lúa |
| 1 | Ngô |
| 2 | Đậu |
| 3 | Khoai tây |
| 4 | Cà chua |
| 5 | Dưa hấu |
| 6 | Đậu đỗ |
| 7 | Cà phê |
| 8 | Bông |
| 9 | Mía |
| 10 | Khoai lang |
| 11 | Lạc |
| 12 | Dứa |
| 13 | Chuối |
| 14 | Cam |
| 15 | Chanh |
| 16 | Táo |
| 17 | Xoài |
| 18 | Nho |
| 19 | Ớt |
| 20 | Gừng |
| 21 | Tỏi |

## 🔧 Troubleshooting

### Model không load được
- Kiểm tra file `RandomForest_RecomentTree.pkl` có tồn tại không
- Kiểm tra scikit-learn version

### API không kết nối được
- Kiểm tra service có đang chạy không
- Kiểm tra port 5000 có bị conflict không
- Kiểm tra CORS settings

### Lỗi prediction
- Kiểm tra input data có đúng format không
- Kiểm tra các giá trị có phải số không
- Kiểm tra thứ tự các tham số

## 📝 Notes

- Service chạy ở port 5000 (Python Flask)
- Backend Java chạy ở port 8080
- Frontend React chạy ở port 3000
- Đảm bảo CORS được cấu hình đúng





