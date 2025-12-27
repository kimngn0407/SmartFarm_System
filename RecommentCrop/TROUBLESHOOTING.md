# 🔧 Troubleshooting Crop Recommendation Service

## Lỗi: "Model chưa được load"

### Nguyên nhân có thể:
1. **Version scikit-learn không tương thích** - Model được train với version khác
2. **Dependencies chưa được cài đặt đúng**
3. **File model bị corrupt hoặc không đọc được**

## Cách khắc phục:

### Bước 1: Kiểm tra file model

```bash
cd RecommentCrop
python debug_model.py
```

Script này sẽ:
- ✅ Kiểm tra file model có tồn tại không
- ✅ Kiểm tra kích thước file
- ✅ Thử load model bằng joblib và pickle
- ✅ Test predict với dữ liệu mẫu

### Bước 2: Cài đặt lại dependencies

```bash
cd RecommentCrop

# Tạo virtual environment mới (nếu chưa có)
python -m venv venv

# Activate (Windows)
venv\Scripts\activate

# Activate (Linux/Mac)
# source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Cài đặt dependencies với version mới
pip install -r requirements.txt
```

### Bước 3: Kiểm tra version scikit-learn

```bash
python -c "import sklearn; print(sklearn.__version__)"
```

Nên dùng version >= 1.0.0. Nếu version < 1.0, cập nhật:

```bash
pip install --upgrade scikit-learn joblib
```

### Bước 4: Chạy lại service

```bash
python crop_recommendation_service.py
```

Kiểm tra logs xem model có load được không:
- ✅ Nếu thấy "✓ Model đã được load thành công!" → OK
- ❌ Nếu thấy "⚠️ WARNING: Model chưa được load" → Xem lỗi chi tiết

### Bước 5: Test API

```bash
# Test health check
curl http://localhost:5000/health

# Test recommend (nếu model đã load)
curl -X POST http://localhost:5000/api/recommend-crop \
  -H "Content-Type: application/json" \
  -d '{"temperature": 25.0, "humidity": 80.0, "soil_moisture": 45.0}'
```

## Lỗi thường gặp:

### 1. "ModuleNotFoundError: No module named 'sklearn'"
```bash
pip install scikit-learn
```

### 2. "AttributeError: 'RandomForestClassifier' object has no attribute 'predict_proba'"
- Model có thể không phải là classifier
- Hoặc version sklearn không tương thích
- Giải pháp: Update scikit-learn

### 3. "ValueError: X has 3 features, but RandomForestClassifier is expecting X features"
- Model được train với số features khác
- Kiểm tra lại input data (cần 3 features: temperature, humidity, soil_moisture)

### 4. "Pickle protocol version X is not supported"
- Model được save với pickle protocol version cao hơn Python hiện tại
- Giải pháp: Upgrade Python hoặc re-save model với protocol thấp hơn

## Nếu vẫn không được:

1. **Kiểm tra logs chi tiết:**
   ```bash
   python crop_recommendation_service.py
   ```
   Xem toàn bộ error message và stack trace

2. **Thử load model thủ công:**
   ```python
   import joblib
   model = joblib.load('RandomForest_RecomentTree.pkl')
   print(type(model))
   print(dir(model))
   ```

3. **Kiểm tra Python version:**
   ```bash
   python --version
   ```
   Nên dùng Python 3.9+

4. **Nếu model không load được, có thể cần:**
   - Train lại model với scikit-learn version hiện tại
   - Hoặc downgrade scikit-learn về version tương thích với model






# 🔧 Troubleshooting Crop Recommendation Service

## Lỗi: "Model chưa được load"

### Nguyên nhân có thể:
1. **Version scikit-learn không tương thích** - Model được train với version khác
2. **Dependencies chưa được cài đặt đúng**
3. **File model bị corrupt hoặc không đọc được**

## Cách khắc phục:

### Bước 1: Kiểm tra file model

```bash
cd RecommentCrop
python debug_model.py
```

Script này sẽ:
- ✅ Kiểm tra file model có tồn tại không
- ✅ Kiểm tra kích thước file
- ✅ Thử load model bằng joblib và pickle
- ✅ Test predict với dữ liệu mẫu

### Bước 2: Cài đặt lại dependencies

```bash
cd RecommentCrop

# Tạo virtual environment mới (nếu chưa có)
python -m venv venv

# Activate (Windows)
venv\Scripts\activate

# Activate (Linux/Mac)
# source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Cài đặt dependencies với version mới
pip install -r requirements.txt
```

### Bước 3: Kiểm tra version scikit-learn

```bash
python -c "import sklearn; print(sklearn.__version__)"
```

Nên dùng version >= 1.0.0. Nếu version < 1.0, cập nhật:

```bash
pip install --upgrade scikit-learn joblib
```

### Bước 4: Chạy lại service

```bash
python crop_recommendation_service.py
```

Kiểm tra logs xem model có load được không:
- ✅ Nếu thấy "✓ Model đã được load thành công!" → OK
- ❌ Nếu thấy "⚠️ WARNING: Model chưa được load" → Xem lỗi chi tiết

### Bước 5: Test API

```bash
# Test health check
curl http://localhost:5000/health

# Test recommend (nếu model đã load)
curl -X POST http://localhost:5000/api/recommend-crop \
  -H "Content-Type: application/json" \
  -d '{"temperature": 25.0, "humidity": 80.0, "soil_moisture": 45.0}'
```

## Lỗi thường gặp:

### 1. "ModuleNotFoundError: No module named 'sklearn'"
```bash
pip install scikit-learn
```

### 2. "AttributeError: 'RandomForestClassifier' object has no attribute 'predict_proba'"
- Model có thể không phải là classifier
- Hoặc version sklearn không tương thích
- Giải pháp: Update scikit-learn

### 3. "ValueError: X has 3 features, but RandomForestClassifier is expecting X features"
- Model được train với số features khác
- Kiểm tra lại input data (cần 3 features: temperature, humidity, soil_moisture)

### 4. "Pickle protocol version X is not supported"
- Model được save với pickle protocol version cao hơn Python hiện tại
- Giải pháp: Upgrade Python hoặc re-save model với protocol thấp hơn

## Nếu vẫn không được:

1. **Kiểm tra logs chi tiết:**
   ```bash
   python crop_recommendation_service.py
   ```
   Xem toàn bộ error message và stack trace

2. **Thử load model thủ công:**
   ```python
   import joblib
   model = joblib.load('RandomForest_RecomentTree.pkl')
   print(type(model))
   print(dir(model))
   ```

3. **Kiểm tra Python version:**
   ```bash
   python --version
   ```
   Nên dùng Python 3.9+

4. **Nếu model không load được, có thể cần:**
   - Train lại model với scikit-learn version hiện tại
   - Hoặc downgrade scikit-learn về version tương thích với model






