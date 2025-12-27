# Virtual Environment cho Crop Recommendation Service

## ✅ Virtual Environment đã được tạo

Virtual environment đã được tạo tại: `E:\SmartFarm\RecommentCrop\venv`

## 🚀 Cách sử dụng

### Activate virtual environment

**Windows PowerShell:**
```powershell
cd E:\SmartFarm\RecommentCrop
.\venv\Scripts\Activate.ps1
```

**Windows CMD:**
```cmd
cd E:\SmartFarm\RecommentCrop
venv\Scripts\activate.bat
```

### Chạy service

```bash
python crop_recommendation_service.py
```

Service sẽ chạy tại: http://localhost:5000

### Test service

```powershell
# Health check
Invoke-WebRequest -Uri http://localhost:5000/health -UseBasicParsing

# Test recommend
$body = @{
    temperature = 25.0
    humidity = 80.0
    soil_moisture = 45.0
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:5000/api/recommend-crop `
    -Method POST `
    -ContentType "application/json" `
    -Body $body `
    -UseBasicParsing
```

## 📦 Dependencies đã cài đặt

- flask==3.0.0
- flask-cors==4.0.0
- numpy==1.24.3
- scikit-learn==1.1.3
- joblib==1.2.0

## ✅ Model Status

Model đã được load thành công:
- File: `RandomForest_RecomentTree.pkl`
- Size: 2.3 MB
- Status: ✅ Loaded và hoạt động

## 🔧 Troubleshooting

Nếu gặp lỗi, xem file `TROUBLESHOOTING.md` để biết cách khắc phục.





# Virtual Environment cho Crop Recommendation Service

## ✅ Virtual Environment đã được tạo

Virtual environment đã được tạo tại: `E:\SmartFarm\RecommentCrop\venv`

## 🚀 Cách sử dụng

### Activate virtual environment

**Windows PowerShell:**
```powershell
cd E:\SmartFarm\RecommentCrop
.\venv\Scripts\Activate.ps1
```

**Windows CMD:**
```cmd
cd E:\SmartFarm\RecommentCrop
venv\Scripts\activate.bat
```

### Chạy service

```bash
python crop_recommendation_service.py
```

Service sẽ chạy tại: http://localhost:5000

### Test service

```powershell
# Health check
Invoke-WebRequest -Uri http://localhost:5000/health -UseBasicParsing

# Test recommend
$body = @{
    temperature = 25.0
    humidity = 80.0
    soil_moisture = 45.0
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:5000/api/recommend-crop `
    -Method POST `
    -ContentType "application/json" `
    -Body $body `
    -UseBasicParsing
```

## 📦 Dependencies đã cài đặt

- flask==3.0.0
- flask-cors==4.0.0
- numpy==1.24.3
- scikit-learn==1.1.3
- joblib==1.2.0

## ✅ Model Status

Model đã được load thành công:
- File: `RandomForest_RecomentTree.pkl`
- Size: 2.3 MB
- Status: ✅ Loaded và hoạt động

## 🔧 Troubleshooting

Nếu gặp lỗi, xem file `TROUBLESHOOTING.md` để biết cách khắc phục.





