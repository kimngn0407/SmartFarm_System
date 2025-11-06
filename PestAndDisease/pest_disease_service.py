"""
Pest and Disease Detection Service
API service để phát hiện sâu bệnh trên cây trồng sử dụng Vision Transformer
"""

import os
import io
import torch
import torch.nn as nn
from PIL import Image
from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
import base64
from torchvision import models

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

# Model configuration
MODEL_PATH = 'best_vit_wheat_model_4classes.pth'
model = None
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

# Class names for wheat pests and diseases (4 classes)
# NOTE: Class 2 và 3 đã được đảo ngược để khớp với model
CLASS_NAMES = {
    0: 'Aphid',             # Rệp (hại lúa mì)
    1: 'Blast',             # Bệnh đạo ôn (bệnh cháy lá / cháy cổ bông)
    2: 'Septoria',          # Bệnh đốm lá do nấm Septoria (ĐÃ ĐẢO)
    3: 'Smut'               # Bệnh than (đen hạt / đen bông) (ĐÃ ĐẢO)
}

# Vietnamese translation
CLASS_NAMES_VI = {
    0: 'Rệp (hại lúa mì)',
    1: 'Bệnh đạo ôn (cháy lá/cổ bông)',
    2: 'Bệnh đốm lá Septoria',          # ĐÃ ĐẢO
    3: 'Bệnh than (đen hạt/bông)'       # ĐÃ ĐẢO
}

# Image preprocessing
from torchvision import transforms

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

def load_model():
    """Load Vision Transformer model"""
    global model
    try:
        if not os.path.exists(MODEL_PATH):
            logger.error(f"Model file không tồn tại: {MODEL_PATH}")
            return False
        
        logger.info("=" * 50)
        logger.info("🔄 Loading Vision Transformer model...")
        logger.info(f"📂 Model Path: {MODEL_PATH}")
        
        # Create model architecture (torchvision ViT-B/16)
        # This is Vision Transformer Base with 16x16 patches
        model = models.vit_b_16(weights=None)
        
        # Modify the head for 4 classes (default is 1000 classes)
        model.heads = nn.Sequential(
            nn.Linear(768, 4)  # 768 is the hidden dimension for ViT-B
        )
        
        # Load weights
        logger.info("📥 Loading checkpoint...")
        checkpoint = torch.load(MODEL_PATH, map_location=device)
        
        # Handle different checkpoint formats
        if isinstance(checkpoint, dict):
            if 'model_state_dict' in checkpoint:
                model.load_state_dict(checkpoint['model_state_dict'])
                logger.info("✓ Loaded from 'model_state_dict'")
            elif 'state_dict' in checkpoint:
                model.load_state_dict(checkpoint['state_dict'])
                logger.info("✓ Loaded from 'state_dict'")
            else:
                model.load_state_dict(checkpoint)
                logger.info("✓ Loaded from checkpoint dict")
        else:
            model.load_state_dict(checkpoint)
            logger.info("✓ Loaded checkpoint directly")
        
        model = model.to(device)
        model.eval()
        
        logger.info("=" * 50)
        logger.info("✓ Model đã được load thành công!")
        logger.info(f"✓ Architecture: Vision Transformer Base (ViT-B/16)")
        logger.info(f"✓ Device: {device}")
        logger.info(f"✓ Classes: {len(CLASS_NAMES)}")
        logger.info("=" * 50)
        
        return True
    except Exception as e:
        logger.error(f"Lỗi khi load model: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def process_image(image_file):
    """Process uploaded image"""
    try:
        # Read image
        image = Image.open(image_file).convert('RGB')
        
        # Apply transformations
        image_tensor = transform(image).unsqueeze(0).to(device)
        
        return image_tensor
    except Exception as e:
        logger.error(f"Error processing image: {str(e)}")
        raise

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': model is not None,
        'device': str(device),
        'classes': len(CLASS_NAMES)
    }), 200

@app.route('/api/detect', methods=['POST'])
def detect_disease():
    """
    API endpoint để phát hiện sâu bệnh
    
    Request:
    - Form-data with image file
    OR
    - JSON with base64 encoded image
    
    Response:
    {
        "success": true,
        "disease": "Bệnh gỉ sắt lá",
        "disease_en": "Leaf Rust",
        "class_id": 1,
        "confidence": 0.95,
        "all_predictions": [...]
    }
    """
    try:
        if model is None:
            return jsonify({
                'success': False,
                'error': 'Model chưa được load'
            }), 500
        
        # Get image from request
        image_tensor = None
        
        # Check if image is sent as file
        if 'image' in request.files:
            file = request.files['image']
            if file.filename == '':
                return jsonify({
                    'success': False,
                    'error': 'Không có file được chọn'
                }), 400
            
            image_tensor = process_image(file)
        
        # Check if image is sent as base64
        elif request.json and 'image' in request.json:
            image_data = request.json['image']
            # Remove header if present
            if ',' in image_data:
                image_data = image_data.split(',')[1]
            
            # Decode base64
            image_bytes = base64.b64decode(image_data)
            image_file = io.BytesIO(image_bytes)
            image_tensor = process_image(image_file)
        
        else:
            return jsonify({
                'success': False,
                'error': 'Không tìm thấy ảnh trong request'
            }), 400
        
        # Predict
        with torch.no_grad():
            outputs = model(image_tensor)
            probabilities = torch.nn.functional.softmax(outputs, dim=1)
            confidence, predicted = torch.max(probabilities, 1)
            
            predicted_class = predicted.item()
            confidence_value = confidence.item()
        
        # Get all class probabilities
        all_predictions = []
        probs = probabilities[0].cpu().numpy()
        for i, prob in enumerate(probs):
            all_predictions.append({
                'class_id': i,
                'class_name_en': CLASS_NAMES[i],
                'class_name_vi': CLASS_NAMES_VI[i],
                'probability': float(prob)
            })
        
        # Sort by probability
        all_predictions.sort(key=lambda x: x['probability'], reverse=True)
        
        logger.info(f"Prediction: {CLASS_NAMES_VI[predicted_class]} (confidence: {confidence_value:.2%})")
        
        return jsonify({
            'success': True,
            'disease': CLASS_NAMES_VI[predicted_class],
            'disease_en': CLASS_NAMES[predicted_class],
            'class_id': predicted_class,
            'confidence': float(confidence_value),
            'all_predictions': all_predictions
        }), 200
        
    except Exception as e:
        logger.error(f"Lỗi khi phát hiện bệnh: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'error': f'Lỗi server: {str(e)}'
        }), 500

@app.route('/api/classes', methods=['GET'])
def get_classes():
    """Lấy danh sách các loại bệnh"""
    classes = []
    for class_id, name_en in CLASS_NAMES.items():
        classes.append({
            'class_id': class_id,
            'name_en': name_en,
            'name_vi': CLASS_NAMES_VI[class_id]
        })
    
    return jsonify({
        'success': True,
        'total': len(classes),
        'classes': classes
    }), 200

if __name__ == '__main__':
    # Load model khi khởi động
    if load_model():
        logger.info("Đang khởi động Pest and Disease Detection Service...")
        logger.info("API sẽ chạy tại: http://localhost:5001")
        logger.info("\nEndpoints available:")
        logger.info("  - GET  /health           - Health check")
        logger.info("  - POST /api/detect       - Phát hiện sâu bệnh")
        logger.info("  - GET  /api/classes      - Danh sách bệnh")
        
        port = int(os.environ.get('PORT', 5001))
        app.run(host='0.0.0.0', port=port, debug=False)
    else:
        logger.error("Không thể khởi động service do lỗi load model")

