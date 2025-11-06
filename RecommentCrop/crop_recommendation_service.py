"""
Crop Recommendation Service
API service để gợi ý cây trồng dựa trên model RandomForest
"""

import pickle
import numpy as np
from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
import os

# Cấu hình logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configure CORS with environment variable support
origins_env = os.environ.get("FRONTEND_ORIGINS", "")
if origins_env:
    origins = [origin.strip() for origin in origins_env.split(",") if origin.strip()]
else:
    # Default origins for local development
    origins = [
        "http://localhost:3000",
        "http://localhost:8000",
        "http://localhost:8080",
        "http://localhost:9002"
    ]

CORS(app, origins=origins, supports_credentials=True, 
     allow_headers=["Content-Type", "Authorization"],
     methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"])

# Load model khi khởi động service
MODEL_PATH = 'RandomForest_RecomentTree.pkl'
model = None

# Mapping crop names (English to Vietnamese)
# Model trả về tên tiếng Anh, cần chuyển sang tiếng Việt
CROP_NAMES = {
    'apple': 'Táo',
    'banana': 'Chuối',
    'blackgram': 'Đậu đen',
    'chickpea': 'Đậu gà',
    'coconut': 'Dừa',
    'coffee': 'Cà phê',
    'cotton': 'Bông',
    'grapes': 'Nho',
    'jute': 'Đay',
    'kidneybeans': 'Đậu thận',
    'lentil': 'Đậu lăng',
    'maize': 'Ngô',
    'mango': 'Xoài',
    'mothbeans': 'Đậu ngài',
    'mungbean': 'Đậu xanh',
    'muskmelon': 'Dưa lưới',
    'orange': 'Cam',
    'papaya': 'Đu đủ',
    'pigeonpeas': 'Đậu chim',
    'pomegranate': 'Lựu',
    'rice': 'Lúa',
    'watermelon': 'Dưa hấu'
}

def load_model():
    """Load RandomForest model từ file pkl"""
    global model
    try:
        if not os.path.exists(MODEL_PATH):
            logger.error(f"Model file không tồn tại: {MODEL_PATH}")
            return False
        
        # Try using joblib first (better for sklearn models)
        try:
            import joblib
            model = joblib.load(MODEL_PATH)
            logger.info("✓ Model loaded using joblib")
        except:
            # Fallback to pickle with allow_pickle
            import warnings
            warnings.filterwarnings('ignore', category=UserWarning)
            
            with open(MODEL_PATH, 'rb') as f:
                model = pickle.load(f)
            logger.info("✓ Model loaded using pickle")
        
        logger.info("✓ Model đã được load thành công!")
        logger.info(f"Model type: {type(model)}")
        
        # Kiểm tra model có method predict không
        if hasattr(model, 'predict'):
            logger.info("✓ Model có method predict()")
        
        return True
    except Exception as e:
        logger.error(f"Lỗi khi load model: {str(e)}")
        logger.error("Gợi ý: Model có thể được train với sklearn version khác. Cần train lại model với sklearn hiện tại.")
        return False

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': model is not None
    }), 200

@app.route('/api/recommend-crop', methods=['POST'])
def recommend_crop():
    """
    API endpoint để gợi ý cây trồng
    
    Request body:
    {
        "temperature": 25.5,    # Nhiệt độ (°C)
        "humidity": 80.0,       # Độ ẩm không khí (%)
        "soil_moisture": 45.0   # Độ ẩm đất (%)
    }
    
    Response:
    {
        "success": true,
        "recommended_crop": "Lúa",
        "crop_name_en": "rice",
        "confidence": 0.95,
        "input_data": {...}
    }
    """
    try:
        if model is None:
            return jsonify({
                'success': False,
                'error': 'Model chưa được load'
            }), 500
        
        data = request.get_json()
        
        # Validate input data - 3 FEATURES: Temperature, Humidity, Soil_Moisture
        required_fields = ['temperature', 'humidity', 'soil_moisture']
        for field in required_fields:
            if field not in data:
                return jsonify({
                    'success': False,
                    'error': f'Thiếu trường bắt buộc: {field}'
                }), 400
        
        # Chuẩn bị dữ liệu input cho model
        # Model nhận 3 features: Temperature, Humidity, Soil_Moisture
        input_features = np.array([[
            float(data['temperature']),
            float(data['humidity']),
            float(data['soil_moisture'])
        ]])
        
        # Dự đoán - Model trả về tên cây trồng bằng tiếng Anh
        prediction = model.predict(input_features)[0]
        
        # Nếu model hỗ trợ predict_proba, lấy confidence
        confidence = None
        if hasattr(model, 'predict_proba'):
            probabilities = model.predict_proba(input_features)[0]
            confidence = float(max(probabilities))
        
        # Chuyển đổi tên tiếng Anh sang tiếng Việt
        crop_name_en = str(prediction).lower()
        crop_name_vi = CROP_NAMES.get(crop_name_en, prediction)
        
        logger.info(f"Dự đoán: {crop_name_vi} ({crop_name_en}), Confidence: {confidence}")
        
        return jsonify({
            'success': True,
            'recommended_crop': crop_name_vi,
            'crop_name_en': crop_name_en,
            'confidence': confidence,
            'input_data': data
        }), 200
        
    except ValueError as e:
        return jsonify({
            'success': False,
            'error': f'Dữ liệu đầu vào không hợp lệ: {str(e)}'
        }), 400
    except Exception as e:
        logger.error(f"Lỗi khi dự đoán: {str(e)}")
        return jsonify({
            'success': False,
            'error': f'Lỗi server: {str(e)}'
        }), 500

@app.route('/api/recommend-crop/batch', methods=['POST'])
def recommend_crop_batch():
    """
    API endpoint để gợi ý cây trồng cho nhiều mẫu
    
    Request body:
    {
        "samples": [
            {"temperature": 25.5, "humidity": 80.0, "soil_moisture": 45.0},
            {"temperature": 28.0, "humidity": 75.0, "soil_moisture": 50.0},
            {...}
        ]
    }
    """
    try:
        if model is None:
            return jsonify({
                'success': False,
                'error': 'Model chưa được load'
            }), 500
        
        data = request.get_json()
        samples = data.get('samples', [])
        
        if not samples:
            return jsonify({
                'success': False,
                'error': 'Không có dữ liệu samples'
            }), 400
        
        results = []
        for idx, sample in enumerate(samples):
            try:
                # Model nhận 3 features: Temperature, Humidity, Soil_Moisture
                input_features = np.array([[
                    float(sample['temperature']),
                    float(sample['humidity']),
                    float(sample['soil_moisture'])
                ]])
                
                prediction = model.predict(input_features)[0]
                
                confidence = None
                if hasattr(model, 'predict_proba'):
                    probabilities = model.predict_proba(input_features)[0]
                    confidence = float(max(probabilities))
                
                # Chuyển đổi tên tiếng Anh sang tiếng Việt
                crop_name_en = str(prediction).lower()
                crop_name_vi = CROP_NAMES.get(crop_name_en, prediction)
                
                results.append({
                    'index': idx,
                    'recommended_crop': crop_name_vi,
                    'crop_name_en': crop_name_en,
                    'confidence': confidence,
                    'success': True
                })
            except Exception as e:
                results.append({
                    'index': idx,
                    'success': False,
                    'error': str(e)
                })
        
        return jsonify({
            'success': True,
            'results': results
        }), 200
        
    except Exception as e:
        logger.error(f"Lỗi khi dự đoán batch: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/crops', methods=['GET'])
def get_crop_list():
    """Lấy danh sách tất cả các loại cây trồng"""
    crops = [{'name_en': name_en, 'name_vi': name_vi} for name_en, name_vi in CROP_NAMES.items()]
    return jsonify({
        'success': True,
        'total': len(crops),
        'crops': crops
    }), 200

if __name__ == '__main__':
    # Load model khi khởi động
    if load_model():
        logger.info("Đang khởi động Crop Recommendation Service...")
        logger.info("API sẽ chạy tại: http://localhost:5000")
        logger.info("\nEndpoints available:")
        logger.info("  - GET  /health                    - Health check")
        logger.info("  - POST /api/recommend-crop        - Gợi ý cây trồng (single)")
        logger.info("  - POST /api/recommend-crop/batch  - Gợi ý cây trồng (batch)")
        logger.info("  - GET  /api/crops                 - Danh sách cây trồng")
        
        app.run(host='0.0.0.0', port=5000, debug=True)
    else:
        logger.error("Không thể khởi động service do lỗi load model")


