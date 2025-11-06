# 📚 GIẢI THÍCH CODE VÀ LUỒNG HOẠT ĐỘNG

## TỔNG QUAN HỆ THỐNG

Hệ thống Smart Farm có 3 AI Services chính:
1. **PestAndDisease** - Phát hiện sâu bệnh từ ảnh (Computer Vision)
2. **RecommentCrop** - Gợi ý cây trồng dựa trên điều kiện môi trường (Machine Learning)
3. **AI_SmartFarm_CHatbot** - Chatbot AI trợ lý nông nghiệp (LLM)

---

## 1️⃣ PESTANDDISEASE - PHÁT HIỆN SÂU BỆNH

### 📋 Mô tả
Service phát hiện 4 loại sâu bệnh trên cây trồng bằng Vision Transformer (ViT):
- **Aphid** (Rệp hại lúa mì)
- **Blast** (Bệnh đạo ôn - cháy lá/cổ bông)
- **Septoria** (Bệnh đốm lá do nấm)
- **Smut** (Bệnh than - đen hạt/bông)

### 🏗️ Kiến trúc

```
Frontend (React)
    ↓ Upload ảnh
Backend (Spring Boot) - Port 8080
    ↓ POST /api/pest-disease/detect
Pest AI Service (Python Flask) - Port 5001
    ↓ Process image với ViT model
Model: best_vit_wheat_model_4classes.pth
    ↓ Prediction
Response: { disease, disease_en, confidence, all_predictions }
```

### 💻 Code Structure

#### **pest_disease_service.py** (Main Service)

**1. Khởi tạo Flask App:**
```python
app = Flask(__name__)
CORS(app, origins=origins)  # Cho phép frontend gọi API
```

**2. Load Model (Vision Transformer):**
```python
def load_model():
    # Tạo ViT-B/16 architecture
    model = models.vit_b_16(weights=None)
    
    # Sửa classification head: 1000 classes → 4 classes
    model.heads = nn.Sequential(nn.Linear(768, 4))
    
    # Load weights từ file .pth
    checkpoint = torch.load(MODEL_PATH, map_location=device)
    model.load_state_dict(checkpoint['model_state_dict'])
    
    model.eval()  # Chuyển sang evaluation mode
```

**3. Xử lý ảnh:**
```python
def process_image(image_file):
    # Đọc ảnh và convert RGB
    image = Image.open(image_file).convert('RGB')
    
    # Transform ảnh về format model cần:
    # - Resize về 224x224
    # - Convert sang tensor
    # - Normalize với ImageNet stats
    image_tensor = transform(image).unsqueeze(0).to(device)
    return image_tensor
```

**4. API Endpoint `/api/detect` (POST):**
```python
@app.route('/api/detect', methods=['POST'])
def detect_disease():
    # 1. Nhận ảnh từ request (FormData hoặc Base64)
    if 'image' in request.files:
        file = request.files['image']
        image_tensor = process_image(file)
    
    # 2. Predict với model
    with torch.no_grad():
        outputs = model(image_tensor)
        probabilities = softmax(outputs, dim=1)
        confidence, predicted = max(probabilities, 1)
    
    # 3. Lấy tất cả predictions (xác suất của 4 classes)
    all_predictions = []
    for i, prob in enumerate(probabilities[0]):
        all_predictions.append({
            'class_id': i,
            'class_name_en': CLASS_NAMES[i],
            'class_name_vi': CLASS_NAMES_VI[i],
            'probability': float(prob)
        })
    
    # 4. Trả về response
    return {
        'success': True,
        'disease': CLASS_NAMES_VI[predicted_class],  # Tên tiếng Việt
        'disease_en': CLASS_NAMES[predicted_class],   # Tên tiếng Anh
        'confidence': float(confidence_value),
        'all_predictions': sorted_predictions
    }
```

### 🔄 Luồng hoạt động chi tiết

```
1. User upload ảnh trong Frontend
   ↓
2. Frontend gửi FormData với key "image"
   POST http://localhost:8080/api/pest-disease/detect
   ↓
3. Backend (PestDiseaseController) nhận file
   - Validate file không rỗng
   - Gọi PestDiseaseService.detectDisease(file)
   ↓
4. Backend forward request đến Pest AI Service
   POST http://localhost:5001/api/detect
   Body: MultipartFormData với key "image"
   ↓
5. Pest AI Service xử lý:
   a) Load model nếu chưa load
   b) Process image: Resize → Normalize → Tensor
   c) Model predict: ViT forward pass
   d) Tính probabilities: Softmax(outputs)
   e) Lấy class có xác suất cao nhất
   f) Trả về kết quả
   ↓
6. Backend nhận response và trả về Frontend
   ↓
7. Frontend hiển thị:
   - Tên bệnh (tiếng Việt)
   - Độ tin cậy (%)
   - Tất cả predictions với xác suất
   - Khuyến nghị xử lý
```

### 🎯 API Endpoints

| Endpoint | Method | Mô tả |
|----------|--------|-------|
| `/health` | GET | Kiểm tra service và model đã load chưa |
| `/api/detect` | POST | Phát hiện sâu bệnh từ ảnh |
| `/api/classes` | GET | Lấy danh sách 4 loại bệnh |

### 🔧 Technologies

- **Framework:** Flask (Python)
- **Model:** Vision Transformer (ViT-B/16)
- **Library:** PyTorch, Torchvision
- **Image Processing:** PIL/Pillow
- **Port:** 5001

---

## 2️⃣ RECOMMENTCROP - GỢI Ý CÂY TRỒNG

### 📋 Mô tả
Service gợi ý cây trồng phù hợp dựa trên 3 thông số môi trường:
- **Temperature** (Nhiệt độ) - °C
- **Humidity** (Độ ẩm không khí) - %
- **Soil Moisture** (Độ ẩm đất) - %

Model hỗ trợ 22 loại cây trồng: Lúa, Ngô, Chuối, Táo, Cam, Dưa hấu, v.v.

### 🏗️ Kiến trúc

```
Frontend (React)
    ↓ Nhập: temperature, humidity, soil_moisture
Backend (Spring Boot) - Port 8080
    ↓ POST /api/crop/recommend
Crop AI Service (Python Flask) - Port 5000
    ↓ Predict với RandomForest model
Model: RandomForest_RecomentTree.pkl
    ↓ Prediction
Response: { recommended_crop, crop_name_en, confidence, input_data }
```

### 💻 Code Structure

#### **crop_recommendation_service.py** (Main Service)

**1. Load Model (RandomForest):**
```python
def load_model():
    # Load model từ file .pkl
    # Ưu tiên dùng joblib (tốt hơn cho sklearn models)
    try:
        import joblib
        model = joblib.load(MODEL_PATH)
    except:
        # Fallback về pickle
        model = pickle.load(open(MODEL_PATH, 'rb'))
    
    # Model type: RandomForestClassifier
    # Input: 3 features [temperature, humidity, soil_moisture]
    # Output: Tên cây trồng (tiếng Anh)
```

**2. Mapping tên cây:**
```python
CROP_NAMES = {
    'rice': 'Lúa',
    'maize': 'Ngô',
    'banana': 'Chuối',
    'watermelon': 'Dưa hấu',
    'apple': 'Táo',
    # ... 22 loại cây
}
```

**3. API Endpoint `/api/recommend-crop` (POST):**
```python
@app.route('/api/recommend-crop', methods=['POST'])
def recommend_crop():
    # 1. Validate input: 3 features bắt buộc
    required_fields = ['temperature', 'humidity', 'soil_moisture']
    
    # 2. Chuẩn bị input cho model
    input_features = np.array([[
        float(data['temperature']),
        float(data['humidity']),
        float(data['soil_moisture'])
    ]])
    
    # 3. Model predict
    prediction = model.predict(input_features)[0]  # Trả về tên tiếng Anh
    
    # 4. Tính confidence (nếu có predict_proba)
    if hasattr(model, 'predict_proba'):
        probabilities = model.predict_proba(input_features)[0]
        confidence = max(probabilities)
    
    # 5. Chuyển tên tiếng Anh → tiếng Việt
    crop_name_en = str(prediction).lower()
    crop_name_vi = CROP_NAMES.get(crop_name_en, prediction)
    
    # 6. Trả về response
    return {
        'success': True,
        'recommended_crop': crop_name_vi,      # "Dưa hấu"
        'crop_name_en': crop_name_en,          # "watermelon"
        'confidence': confidence,              # 0.8 (80%)
        'input_data': data
    }
```

### 🔄 Luồng hoạt động chi tiết

```
1. User nhập thông số môi trường trong Frontend
   - Temperature: 25°C
   - Humidity: 80%
   - Soil Moisture: 45%
   ↓
2. Frontend gửi JSON request
   POST http://localhost:8080/api/crop/recommend
   Body: { temperature: 25, humidity: 80, soil_moisture: 45 }
   ↓
3. Backend (CropRecommendationController) nhận request
   - Map request → AIPredictionRequest
   - Gọi AIRecommendationService.getPrediction()
   ↓
4. Backend forward request đến Crop AI Service
   POST http://localhost:5000/api/recommend-crop
   Body: { temperature: 25, humidity: 80, soil_moisture: 45 }
   ↓
5. Crop AI Service xử lý:
   a) Validate 3 fields bắt buộc
   b) Convert → numpy array shape (1, 3)
   c) Model predict: RandomForest.predict()
   d) Model trả về tên cây tiếng Anh: "watermelon"
   e) Tính confidence: predict_proba → max probability
   f) Map tên: "watermelon" → "Dưa hấu"
   g) Trả về response
   ↓
6. Backend nhận response và map:
   - recommended_crop: "Dưa hấu"
   - crop_name_en: "watermelon"
   - confidence: 0.8
   - input_data: { temperature, humidity, soil_moisture }
   ↓
7. Frontend hiển thị:
   - Tên cây: "Dưa hấu" (watermelon)
   - Độ tin cậy: 80.0%
   - Progress bar
```

### 🎯 API Endpoints

| Endpoint | Method | Mô tả |
|----------|--------|-------|
| `/health` | GET | Kiểm tra service và model đã load chưa |
| `/api/recommend-crop` | POST | Gợi ý cây trồng (single) |
| `/api/recommend-crop/batch` | POST | Gợi ý cây trồng (nhiều mẫu) |
| `/api/crops` | GET | Lấy danh sách 22 loại cây trồng |

### 🔧 Technologies

- **Framework:** Flask (Python)
- **Model:** RandomForest Classifier (Scikit-learn)
- **Library:** NumPy, Scikit-learn, Joblib
- **Port:** 5000

---

## 3️⃣ AI_SMARTFARM_CHATBOT - CHATBOT AI

### 📋 Mô tả
Chatbot AI trợ lý nông nghiệp sử dụng Google Gemini AI để trả lời câu hỏi về:
- Kỹ thuật trồng trọt
- Chăm sóc cây trồng
- Quản lý sâu bệnh
- Kiến thức nông nghiệp

### 🏗️ Kiến trúc

```
User (Browser)
    ↓ Câu hỏi: "Cách trồng lúa như thế nào?"
Next.js Frontend (React) - Port 9002
    ↓ Gọi AI Flow
Genkit AI Engine (Google Gemini)
    ↓ Generate response
Response: "Để trồng lúa, bạn cần..."
Frontend hiển thị markdown
```

### 💻 Code Structure

#### **page.tsx** (Main Chat Interface)

**1. State Management:**
```typescript
const [messages, setMessages] = useState<Message[]>([{
    id: crypto.randomUUID(),
    role: 'assistant',
    content: "Xin chào! Tôi là Smart Farm Bot..."
}]);

const [isPending, startTransition] = useTransition();  // Loading state
```

**2. Xử lý câu hỏi:**
```typescript
const handleQuery = (query: string) => {
    // 1. Thêm tin nhắn user vào list
    setMessages(prev => [...prev, {
        id: crypto.randomUUID(),
        role: "user",
        content: query
    }]);
    
    // 2. Gọi AI (async)
    startTransition(async () => {
        // Lấy 6 tin nhắn gần nhất làm context
        const recentMessages = messages.slice(-6);
        const conversationHistory = recentMessages
            .map(msg => `${msg.role === 'user' ? 'Người dùng' : 'Smart Farm Bot'}: ${msg.content}`)
            .join('\n');
        
        // Gọi AI engine
        const result = await generateInsightsFromExcel({
            excelDataUri: '',  // Không dùng file upload
            query,             // Câu hỏi hiện tại
            conversationHistory,  // Ngữ cảnh cuộc trò chuyện
        });
        
        // Thêm câu trả lời vào list
        setMessages(prev => [...prev, {
            id: crypto.randomUUID(),
            role: "assistant",
            content: result.answer
        }]);
    });
};
```

#### **generate-insights-from-excel.ts** (AI Engine)

**1. Define Schema (Validation):**
```typescript
const GenerateInsightsFromExcelInputSchema = z.object({
    excelDataUri: z.string().optional(),  // File Excel (base64) - không bắt buộc
    query: z.string(),                      // Câu hỏi - bắt buộc
    conversationHistory: z.string().optional(),  // Ngữ cảnh - không bắt buộc
});

const GenerateInsightsFromExcelOutputSchema = z.object({
    answer: z.string(),  // Câu trả lời từ AI
});
```

**2. Define Prompt (AI Instructions):**
```typescript
const prompt = ai.definePrompt({
    name: 'generateInsightsFromExcelPrompt',
    input: {schema: GenerateInsightsFromExcelInternalInputSchema},
    output: {schema: GenerateInsightsFromExcelOutputSchema},
    
    prompt: `Bạn là Smart Farm Bot — trợ lý AI cho nông nghiệp thông minh tại Việt Nam.
    
    Nguyên tắc trả lời:
    - Trả lời trực tiếp bằng tiếng Việt, ngắn gọn và hữu dụng
    - KHÔNG in các tiêu đề như "Trả lời:", "Nguồn dữ liệu:", etc.
    - Nếu có dữ liệu Excel phù hợp, ưu tiên dùng "CÂU TRẢ LỜI"
    - Nếu không có dữ liệu, bắt đầu bằng "(không tìm thấy trong dữ liệu)"
    
    Dữ liệu: {{{excelDataJson}}}
    Ngữ cảnh: {{{conversationHistory}}}
    Câu hỏi: {{{query}}}
    `,
});
```

**3. Main Flow Function:**
```typescript
export async function generateInsightsFromExcel(input) {
    // BƯỚC 1: Đọc file Excel
    let buffer: Buffer;
    
    if (input.excelDataUri) {
        // Nếu có file upload, decode từ base64
        const base64Data = input.excelDataUri.split(',')[1];
        buffer = Buffer.from(base64Data, 'base64');
    } else {
        // Nếu không có, dùng file mặc định
        const filePath = path.join(process.cwd(), 'src', 'data', 'sample-data.xlsx');
        buffer = fs.readFileSync(filePath);
    }
    
    // BƯỚC 2: Parse Excel → JSON
    const workbook = xlsx.read(buffer, { type: 'buffer' });
    const worksheet = workbook.Sheets[workbook.SheetNames[0]];
    const excelDataJson = xlsx.utils.sheet_to_json(worksheet);
    
    // BƯỚC 3: Gọi AI với prompt
    const {output} = await prompt({
        excelDataJson: JSON.stringify(excelDataJson),
        query: input.query,
        conversationHistory: input.conversationHistory || '',
    });
    
    // BƯỚC 4: Trả về answer
    return output;
}
```

### 🔄 Luồng hoạt động chi tiết

```
1. User nhập câu hỏi trong Chatbox
   "Cách trồng lúa như thế nào?"
   ↓
2. Frontend (page.tsx) xử lý:
   - Thêm tin nhắn user vào messages array
   - Set isPending = true (hiển thị loading)
   ↓
3. Gọi AI Flow (generateInsightsFromExcel):
   - Lấy 6 tin nhắn gần nhất làm conversation history
   - Tạo prompt với context
   ↓
4. Gọi Google Gemini AI:
   POST https://generativelanguage.googleapis.com/...
   Body: {
       prompt: "Bạn là Smart Farm Bot...",
       model: "gemini-1.5-flash",
       temperature: 0.7
   }
   ↓
5. AI Flow xử lý:
   a) Đọc file Excel (mặc định hoặc upload)
   b) Parse Excel → JSON format
   c) Tạo prompt với:
      - Dữ liệu Excel (JSON)
      - Conversation history
      - Câu hỏi hiện tại
   d) Gọi Google Gemini AI qua Genkit
   e) AI generate response dựa trên prompt
   ↓
6. Gemini AI generate response:
   "Để trồng lúa, bạn cần:
   1. Chuẩn bị đất...
   2. Gieo hạt...
   3. Chăm sóc..."
   ↓
7. Frontend nhận response:
   - Thêm tin nhắn assistant vào messages array
   - Set isPending = false
   - Render markdown với react-markdown
   ↓
8. Hiển thị câu trả lời:
   - Format markdown (đầu đề, danh sách, code)
   - Syntax highlighting
   - Auto scroll xuống tin nhắn mới
```

### 🎯 Features

- **Conversation History:** Giữ 6 tin nhắn gần nhất làm context
- **Markdown Support:** Hiển thị code, lists, headings
- **Syntax Highlighting:** Highlight code blocks
- **Auto Scroll:** Tự động cuộn xuống tin nhắn mới
- **Widget Mode:** Có thể embed vào website khác

### 🔧 Technologies

- **Framework:** Next.js 15 (React + TypeScript)
- **AI Model:** Google Gemini 1.5 Flash
- **AI Library:** Genkit AI (@genkit-ai/next)
- **Data Source:** Excel file (sample-data.xlsx) chứa Q&A về nông nghiệp
- **Excel Parser:** xlsx library
- **UI:** Tailwind CSS, Radix UI components
- **Markdown:** react-markdown, rehype-highlight (syntax highlighting)
- **Features:** Conversation history, Auto scroll, Markdown rendering
- **Port:** 9002

---

## 🔗 TÍCH HỢP VỚI BACKEND (SPRING BOOT)

### Pest Disease Integration

**Backend Controller:**
```java
@RestController
@RequestMapping("/api/pest-disease")
public class PestDiseaseController {
    
    @PostMapping("/detect")
    public ResponseEntity<Map<String, Object>> detectDisease(
            @RequestParam("image") MultipartFile file) {
        
        // Forward request đến Pest AI Service
        Map<String, Object> result = pestDiseaseService.detectDisease(file);
        
        // result = {
        //   "success": true,
        //   "disease": "Bệnh đạo ôn",
        //   "disease_en": "Blast",
        //   "confidence": 0.95,
        //   "all_predictions": [...]
        // }
        
        return ResponseEntity.ok(result);
    }
}
```

**Backend Service:**
```java
@Service
public class PestDiseaseService {
    @Value("${pest.disease.service.url:http://localhost:5001}")
    private String pestDiseaseApiUrl;
    
    public Map<String, Object> detectDisease(MultipartFile imageFile) {
        // POST http://localhost:5001/api/detect
        // Body: MultipartFormData với key "image"
        
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("image", new ByteArrayResource(imageFile.getBytes()));
        
        ResponseEntity<Map> response = restTemplate.postForEntity(
            pestDiseaseApiUrl + "/api/detect",
            new HttpEntity<>(body, headers),
            Map.class
        );
        
        return response.getBody();
    }
}
```

### Crop Recommendation Integration

**Backend Controller:**
```java
@RestController
@RequestMapping("/api/crop")
public class CropRecommendationController {
    
    @PostMapping("/recommend")
    public ResponseEntity<Map<String, Object>> getRecommendation(
            @RequestBody Map<String, Object> request) {
        
        // Map request → AI service format
        AIPredictionRequest aiRequest = new AIPredictionRequest();
        aiRequest.setTemperature(getDoubleValue(request.get("temperature")));
        aiRequest.setHumidity(getDoubleValue(request.get("humidity")));
        aiRequest.setSoilMoisture(getDoubleValue(request.get("soil_moisture")));
        
        // Gọi AI service
        AIPredictionResponse prediction = aiService.getPrediction(
            aiRequest.getTemperature(),
            aiRequest.getHumidity(),
            aiRequest.getSoilMoisture()
        );
        
        // Map response → Frontend format
        Map<String, Object> response = new HashMap<>();
        response.put("recommended_crop", prediction.getRecommendedCrop());
        response.put("crop_name_en", prediction.getCropNameEn());
        response.put("confidence", prediction.getConfidence());
        
        return ResponseEntity.ok(response);
    }
}
```

**Backend Service:**
```java
@Service
public class AIRecommendationService {
    @Value("${crop.recommendation.service.url:http://localhost:5000}")
    private String aiApiUrl;
    
    public AIPredictionResponse getPrediction(
            Double temperature, Double humidity, Double soilMoisture) {
        
        // POST http://localhost:5000/api/recommend-crop
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("temperature", temperature);
        requestMap.put("humidity", humidity);
        requestMap.put("soil_moisture", soilMoisture);
        
        ResponseEntity<Map> response = restTemplate.postForEntity(
            aiApiUrl + "/api/recommend-crop",
            new HttpEntity<>(requestMap, headers),
            Map.class
        );
        
        Map<String, Object> result = response.getBody();
        
        // Map Python response → Java DTO
        AIPredictionResponse aiResponse = new AIPredictionResponse();
        aiResponse.setRecommendedCrop((String) result.get("recommended_crop"));
        aiResponse.setCropNameEn((String) result.get("crop_name_en"));
        aiResponse.setConfidence(((Number) result.get("confidence")).doubleValue());
        
        return aiResponse;
    }
}
```

---

## 📊 SO SÁNH 3 SERVICES

| Feature | PestAndDisease | RecommentCrop | AI_SmartFarm_CHatbot |
|---------|----------------|---------------|---------------------|
| **Input** | Ảnh (Image file) | 3 số: temp, humidity, soil | Câu hỏi (Text) |
| **Model** | Vision Transformer (ViT-B/16) | RandomForest Classifier | Google Gemini 1.5 Flash |
| **Output** | Tên bệnh + confidence | Tên cây trồng + confidence | Câu trả lời (Markdown) |
| **Port** | 5001 | 5000 | 9002 |
| **Framework** | Flask (Python) | Flask (Python) | Next.js (TypeScript) |
| **Library** | PyTorch, Torchvision | Scikit-learn, NumPy | Genkit AI |
| **Model File** | .pth (327MB) | .pkl (2.2MB) | API Key |
| **Type** | Computer Vision | Machine Learning | Large Language Model |

---

## 🔄 FLOW TỔNG THỂ

```
┌─────────────────────────────────────────────────────────────┐
│                     FRONTEND (React)                         │
│  - Upload ảnh → Pest Detection                              │
│  - Nhập thông số → Crop Recommendation                      │
│  - Chat → AI Chatbot                                         │
└───────────────┬─────────────────────────────────────────────┘
                │
                ↓ HTTP Requests
┌─────────────────────────────────────────────────────────────┐
│              BACKEND (Spring Boot) - Port 8080              │
│  - /api/pest-disease/detect                                 │
│  - /api/crop/recommend                                      │
│  - CORS, Authentication, Validation                         │
└───┬───────────────────────────┬────────────────────────────┘
    │                           │
    ↓                           ↓
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│ Pest AI Service  │    │ Crop AI Service  │    │ Chatbot (Next.js)│
│   Port 5001      │    │   Port 5000      │    │   Port 9002      │
│                  │    │                  │    │                  │
│ ViT Model       │    │ RandomForest     │    │ Gemini AI        │
│ - Load .pth     │    │ - Load .pkl      │    │ - API Call       │
│ - Process image │    │ - Predict crop   │    │ - Generate text  │
│ - Predict       │    │ - Return name    │    │ - Return answer  │
└──────────────────┘    └──────────────────┘    └──────────────────┘
```

---

## 🎯 CÁCH TRẢ LỜI KHI ĐƯỢC HỎI

### Khi hỏi về Pest Detection:
> "Service này sử dụng Vision Transformer (ViT-B/16) để phân tích ảnh cây trồng và phát hiện 4 loại sâu bệnh: Rệp, Bệnh đạo ôn, Bệnh đốm lá Septoria, và Bệnh than. Model được train trên PyTorch và load từ file `.pth`. Khi user upload ảnh, service sẽ resize về 224x224, normalize, và chạy qua model để predict. Kết quả trả về tên bệnh, độ tin cậy, và xác suất của tất cả 4 classes."

### Khi hỏi về Crop Recommendation:
> "Service này sử dụng RandomForest Classifier từ Scikit-learn để gợi ý cây trồng dựa trên 3 thông số môi trường: nhiệt độ, độ ẩm không khí, và độ ẩm đất. Model nhận input là numpy array shape (1, 3), predict ra tên cây trồng bằng tiếng Anh, sau đó map sang tiếng Việt. Service hỗ trợ 22 loại cây trồng như Lúa, Ngô, Dưa hấu, v.v. Nếu model có `predict_proba`, service sẽ tính confidence dựa trên xác suất cao nhất."

### Khi hỏi về Chatbot:
> "Chatbot sử dụng Google Gemini 1.5 Flash qua Genkit AI framework. Mỗi câu hỏi được gửi kèm với conversation history (6 tin nhắn gần nhất) để AI hiểu ngữ cảnh. Prompt được thiết kế đặc biệt cho domain nông nghiệp Việt Nam. Response được render dạng Markdown với syntax highlighting cho code blocks. Chatbot có thể hoạt động standalone hoặc embed dạng widget vào website khác."

### Khi hỏi về integration:
> "Backend Spring Boot đóng vai trò API Gateway, nhận request từ Frontend, validate, và forward đến các AI services tương ứng. Backend xử lý CORS, authentication, error handling, và format response cho Frontend. Mỗi AI service chạy độc lập trên port riêng (5000, 5001, 9002) và có thể scale riêng biệt. Backend config URL của các services trong `application.properties`."

---

## ❓ CÂU HỎI THƯỜNG GẶP VÀ CÁCH TRẢ LỜI

### 1. "Pest Detection hoạt động như thế nào?"

**Trả lời:**
> "Service sử dụng Vision Transformer (ViT-B/16) - một deep learning model cho computer vision. Khi user upload ảnh cây trồng, service sẽ:
> 1. Load model từ file `best_vit_wheat_model_4classes.pth` (327MB)
> 2. Preprocess ảnh: Resize về 224x224, normalize với ImageNet stats
> 3. Chuyển ảnh thành tensor và đưa qua model
> 4. Model output là logits của 4 classes → áp dụng softmax để có probabilities
> 5. Lấy class có xác suất cao nhất làm prediction
> 6. Trả về tên bệnh (tiếng Việt và tiếng Anh), confidence, và xác suất của tất cả 4 classes."

### 2. "Tại sao lại dùng Vision Transformer thay vì CNN?"

**Trả lời:**
> "Vision Transformer là architecture mới hơn, hiệu quả hơn cho image classification. ViT chia ảnh thành patches và sử dụng attention mechanism giống như Transformer trong NLP, giúp model hiểu context tốt hơn. Model được train trên dataset về sâu bệnh lúa mì với 4 classes, nên rất chuyên biệt cho domain này."

### 3. "Crop Recommendation sử dụng thuật toán gì?"

**Trả lời:**
> "Service sử dụng RandomForest Classifier từ Scikit-learn - một ensemble learning method. RandomForest tạo nhiều decision trees và vote để quyết định class cuối cùng. Model được train trên dataset với 3 features: Temperature, Humidity, Soil Moisture, và predict ra 1 trong 22 loại cây trồng. Model hỗ trợ `predict_proba()` để tính confidence score."

### 4. "Tại sao model chỉ nhận 3 features thay vì nhiều hơn?"

**Trả lời:**
> "Model được thiết kế để sử dụng dữ liệu từ IoT sensors - các sensor phổ biến nhất là Temperature, Humidity, và Soil Moisture. Điều này giúp system dễ dàng tích hợp với hardware sensors và không yêu cầu quá nhiều loại sensor phức tạp."

### 5. "Chatbot sử dụng AI gì? Có RAG không?"

**Trả lời:**
> "Chatbot sử dụng Google Gemini 1.5 Flash qua Genkit AI framework. Có RAG (Retrieval-Augmented Generation): chatbot đọc file Excel chứa Q&A về nông nghiệp, parse thành JSON, và inject vào prompt để AI có context. Ngoài ra, chatbot giữ conversation history (6 tin nhắn gần nhất) để hiểu ngữ cảnh cuộc trò chuyện."

### 6. "File Excel trong Chatbot có vai trò gì?"

**Trả lời:**
> "File Excel (`sample-data.xlsx`) chứa database câu hỏi và câu trả lời về nông nghiệp. Khi user hỏi, chatbot sẽ tìm trong Excel xem có câu hỏi tương tự không. Nếu có, AI sẽ trả lời dựa trên 'CÂU TRẢ LỜI' trong Excel. Nếu không, AI sẽ dùng kiến thức tổng quát của Gemini để trả lời. Đây là cách implement RAG đơn giản nhưng hiệu quả."

### 7. "Tại sao phải có Backend Spring Boot? Tại sao không gọi trực tiếp từ Frontend?"

**Trả lời:**
> "Backend đóng vai trò API Gateway và xử lý:
> - **CORS**: Cho phép Frontend gọi API
> - **Authentication**: Xác thực user (JWT tokens)
> - **Validation**: Kiểm tra dữ liệu đầu vào
> - **Error Handling**: Xử lý lỗi và format response
> - **API Mapping**: Map request format của Frontend → format của AI services
> - **Caching**: Có thể cache kết quả để tối ưu performance
> - **Security**: Ẩn AI service URLs, chỉ expose qua Backend"

### 8. "Làm thế nào để scale các AI services?"

**Trả lời:**
> "Mỗi AI service chạy độc lập trên port riêng (5000, 5001, 9002), có thể scale riêng biệt:
> - **Crop AI (5000)**: Lightweight (RandomForest), có thể chạy nhiều instances
> - **Pest AI (5001)**: Heavy (ViT model 327MB), cần GPU để scale tốt
> - **Chatbot (9002)**: Phụ thuộc vào Google Gemini API rate limits
> 
> Có thể deploy các services lên Docker containers và scale horizontally. Backend có thể load balance giữa các instances."

### 9. "Model files được quản lý như thế nào?"

**Trả lời:**
> "Model files được lưu trực tiếp trong source code:
> - **Pest AI**: `best_vit_wheat_model_4classes.pth` (327MB) - quá lớn để commit vào Git, cần download riêng
> - **Crop AI**: `RandomForest_RecomentTree.pkl` (2.2MB) - có thể commit vào Git
> 
> Trong production, nên lưu models trên cloud storage (S3, GCS) và download khi service khởi động."

### 10. "Làm thế nào để test các AI services?"

**Trả lời:**
> "Có thể test qua:
> 1. **Health Check**: `GET /health` để kiểm tra service và model đã load chưa
> 2. **API Endpoints**: Test trực tiếp với curl hoặc Postman
> 3. **Frontend**: Test qua giao diện người dùng
> 4. **Unit Tests**: Có thể viết Python tests cho từng service
> 
> Scripts có sẵn:
> - `CHAY_2_AI.bat`: Chạy cả 2 AI services
> - `CHAY_CROP_AI.bat`: Chạy riêng Crop AI
> - `CHAY_PEST_AI.bat`: Chạy riêng Pest AI"

### 11. "Error handling được xử lý như thế nào?"

**Trả lời:**
> "Mỗi layer có error handling riêng:
> - **Frontend**: Try-catch và hiển thị error message cho user
> - **Backend**: Validate input, catch exceptions, trả về error response với format chuẩn
> - **AI Services**: Validate input, catch model errors, trả về error JSON với message rõ ràng
> 
> Format error response chuẩn:
> ```json
> {
>   "success": false,
>   "error": "Error message mô tả lỗi"
> }
> ```"

### 12. "CORS được cấu hình như thế nào?"

**Trả lời:**
> "CORS được config ở 2 tầng:
> 1. **AI Services (Python Flask)**: CORS cho phép localhost (3000, 8080, 9002) và có thể config qua env var `FRONTEND_ORIGINS`
> 2. **Backend (Spring Boot)**: CORS config trong `CorsConfig.java` và `@CrossOrigin` annotations
> 
> Cho phép:
> - Localhost origins cho development
> - Production domains (Vercel, Railway) cho production"

### 13. "Có thể deploy lên cloud không?"

**Trả lời:**
> "Có, các services có thể deploy:
> - **Pest AI**: Hugging Face Spaces (đã có Dockerfile)
> - **Crop AI**: Render, Railway (có Procfile, render.yaml)
> - **Chatbot**: Vercel (Next.js) - đã deploy
> - **Backend**: Railway (Spring Boot) - đã deploy
> 
> Mỗi service có Dockerfile hoặc config files riêng cho deployment."

### 14. "Model accuracy là bao nhiêu?"

**Trả lời:**
> "Model accuracy phụ thuộc vào dataset training:
> - **Pest AI**: Model được train trên dataset về sâu bệnh lúa mì, accuracy tùy thuộc vào model gốc
> - **Crop AI**: RandomForest thường có accuracy cao (80-95%) cho classification tasks
> 
> Accuracy thực tế phụ thuộc vào:
> - Chất lượng dataset training
> - Độ phù hợp của input với training data
> - Model architecture và hyperparameters"

### 15. "Có thể thêm loại cây trồng hoặc bệnh mới không?"

**Trả lời:**
> "Có, nhưng cần retrain model:
> - **Crop AI**: Cần thêm class mới vào dataset và retrain RandomForest
> - **Pest AI**: Cần thêm class mới vào dataset và retrain ViT model
> 
> Sau khi retrain, cần:
> - Update `CROP_NAMES` mapping trong code
> - Update `CLASS_NAMES` và `CLASS_NAMES_VI` trong code
> - Deploy model mới
> 
> **Chatbot**: Không cần retrain, chỉ cần thêm Q&A vào file Excel."

---

## 📝 TÓM TẮT KEY POINTS

### Pest Detection Service
- ✅ Model: Vision Transformer (ViT-B/16)
- ✅ Input: Image file (FormData hoặc Base64)
- ✅ Output: Disease name + confidence + all predictions
- ✅ Preprocessing: Resize 224x224, Normalize ImageNet
- ✅ Framework: Flask (Python), PyTorch

### Crop Recommendation Service
- ✅ Model: RandomForest Classifier
- ✅ Input: 3 numbers (temperature, humidity, soil_moisture)
- ✅ Output: Crop name (VI + EN) + confidence
- ✅ Features: Temperature, Humidity, Soil Moisture
- ✅ Framework: Flask (Python), Scikit-learn

### AI Chatbot Service
- ✅ Model: Google Gemini 1.5 Flash
- ✅ Input: Text query + conversation history
- ✅ Output: Markdown text answer
- ✅ RAG: Excel file with Q&A database
- ✅ Framework: Next.js (TypeScript), Genkit AI

---

**Tài liệu này giải thích chi tiết code và luồng hoạt động của 3 AI Services trong hệ thống Smart Farm.**

