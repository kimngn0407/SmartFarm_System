# 🔧 GIẢI THÍCH HỆ THỐNG SMART FARM - CHI TIẾT KỸ THUẬT

> **Tài liệu này giải thích chi tiết code, architecture, và luồng xử lý cho developers**

---

## 📋 MỤC LỤC

1. [Kiến trúc tổng quan](#kiến-trúc-tổng-quan)
2. [Frontend (React)](#frontend-react)
3. [Backend (Spring Boot)](#backend-spring-boot)
4. [AI Chatbot (Next.js)](#ai-chatbot-nextjs)
5. [ML Services (Python)](#ml-services-python)
6. [Database Schema](#database-schema)
7. [Authentication & Authorization](#authentication--authorization)
8. [API Endpoints](#api-endpoints)
9. [Docker & Deployment](#docker--deployment)

---

## 🏗️ KIẾN TRÚC TỔNG QUAN

### **Microservices Architecture**

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  React Frontend (Port 80)                            │   │
│  │  - Material-UI Components                            │   │
│  │  - React Router (SPA)                                │   │
│  │  - Axios for API calls                               │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ HTTP/REST API
                            │ JWT Authentication
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    API GATEWAY LAYER                        │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Spring Boot Backend (Port 8080)                     │   │
│  │  - REST Controllers                                   │   │
│  │  - Service Layer (Business Logic)                     │   │
│  │  - Repository Pattern (Data Access)                  │   │
│  │  - JWT Security                                       │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  PostgreSQL  │  │  Crop ML     │  │  Pest ML      │
│  (Port 5432) │  │  (Port 5000)  │  │  (Port 5001)  │
│              │  │              │  │              │
│  - JPA/Hibernate│  │  - Flask API │  │  - Flask API │
│  - ACID       │  │  - RandomForest│  │  - ViT Model │
└──────────────┘  └──────────────┘  └──────────────┘
        │
        ▼
┌──────────────┐
│  AI Chatbot  │
│  (Port 9002) │
│              │
│  - Next.js   │
│  - Genkit    │
│  - Gemini AI │
└──────────────┘
```

---

## 🌐 FRONTEND (REACT)

### **Cấu trúc thư mục**

```
J2EE_Frontend/src/
├── App.js                    # Root component, routing
├── index.js                  # Entry point
├── components/               # Reusable components
│   ├── Layout.js            # Main layout với sidebar
│   ├── MenuBar.js           # Navigation menu
│   ├── SmartFarmChatbot.js  # Chatbot widget
│   └── Auth/
│       └── RoleGuard.jsx    # Route protection by role
├── pages/                    # Page components
│   ├── auth/
│   │   ├── Login.js         # Login page
│   │   └── Register.js      # Register page
│   ├── dashboard/
│   │   └── Dashboard.js     # Main dashboard
│   ├── crop/
│   │   ├── CropRecommendation.js  # Crop recommendation UI
│   │   └── PestDetection.js       # Pest detection UI
│   └── ...
├── services/                 # API service layer
│   ├── authService.js       # Authentication API
│   ├── cropRecommendationService.js  # Crop ML API
│   ├── farmService.js       # Farm management API
│   └── ...
└── config/
    └── api.config.js        # API base URL configuration
```

### **Luồng xử lý chính**

#### **1. App.js - Routing & Authentication**

```javascript
// App.js
const App = () => {
  const isAuthenticated = Boolean(localStorage.getItem('token'));
  
  return (
    <Router>
      <Routes>
        {/* Public routes */}
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        
        {/* Protected routes */}
        <Route element={isAuthenticated ? <Layout /> : <Navigate to="/login" />}>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/crop" element={<CropManager />} />
          {/* ... */}
        </Route>
      </Routes>
    </Router>
  );
};
```

**Giải thích:**
- `isAuthenticated` kiểm tra token trong `localStorage`
- Nếu chưa đăng nhập → Redirect về `/login`
- Nếu đã đăng nhập → Render `Layout` với các routes con

#### **2. Login Flow**

```javascript
// pages/auth/Login.js
const handleSubmit = async (e) => {
  e.preventDefault();
  
  try {
    // Gọi API login
    const response = await authService.login(email, password);
    
    // Lưu token và user info
    localStorage.setItem('token', response.data.token);
    localStorage.setItem('userEmail', response.data.personalInfo.email);
    localStorage.setItem('userRole', response.data.personalInfo.roles[0]);
    
    // Navigate to dashboard
    navigate('/dashboard');
  } catch (error) {
    setError('Đăng nhập thất bại');
  }
};
```

**Luồng:**
1. User nhập email/password
2. Frontend gọi `authService.login()` → POST `/api/auth/login`
3. Backend trả về JWT token
4. Frontend lưu token vào `localStorage`
5. Navigate đến Dashboard

#### **3. Crop Recommendation Flow**

```javascript
// pages/crop/CropRecommendation.js
const handleSubmit = async (e) => {
  e.preventDefault();
  
  // 1. Chuẩn bị dữ liệu
  const requestData = {
    temperature: parseFloat(formData.temperature),
    humidity: parseFloat(formData.humidity),
    soil_moisture: parseFloat(formData.soil_moisture)
  };
  
  // 2. Gọi service
  const response = await cropRecommendationService.recommendCrop(requestData);
  
  // 3. Hiển thị kết quả
  if (response.success) {
    setResult({
      recommended_crop: response.recommended_crop,
      confidence: response.confidence
    });
  }
};
```

```javascript
// services/cropRecommendationService.js
export const recommendCrop = async (data) => {
  const response = await fetch(`${API_BASE_URL}/api/crop/recommend`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    },
    body: JSON.stringify(data)
  });
  
  return await response.json();
};
```

**Luồng:**
1. User nhập dữ liệu → Click "Gợi ý"
2. `CropRecommendation.js` gọi `cropRecommendationService.recommendCrop()`
3. Service gửi POST `/api/crop/recommend` đến Backend
4. Backend gọi Python ML service
5. Nhận kết quả → Hiển thị lên UI

---

## ☕ BACKEND (SPRING BOOT)

### **Cấu trúc thư mục (Clean Architecture)**

```
demoSmartFarm/demo/src/main/java/com/example/demo/
├── Controllers/          # REST API endpoints
│   ├── AuthController.java
│   ├── CropRecommendationController.java
│   ├── FarmController.java
│   └── ...
├── Services/             # Business logic layer
│   ├── AccountService.java
│   ├── AIRecommendationService.java
│   ├── FarmService.java
│   └── ...
├── Repositories/         # Data access layer
│   ├── AccountRepository.java
│   ├── FarmRepository.java
│   └── ...
├── Entities/             # JPA entities (Database tables)
│   ├── AccountEntity.java
│   ├── FarmEntity.java
│   └── ...
├── DTO/                  # Data Transfer Objects
│   ├── AccountDTO.java
│   ├── AIPredictionResponse.java
│   └── ...
└── Security/             # Security configuration
    ├── SecurityConfig.java
    ├── JwtUtils.java
    └── JwtAuthenticationFilter.java
```

### **Luồng xử lý chính**

#### **1. Authentication Flow**

```java
// Controllers/AuthController.java
@PostMapping("/login")
public ResponseEntity<?> login(@RequestBody AccountDTO accountDTO) {
    // 1. Validate input
    if (accountDTO.getEmail() == null || accountDTO.getPassword() == null) {
        return ResponseEntity.badRequest().body("Email and password required");
    }
    
    // 2. Call service
    Object response = accountService.login(
        accountDTO.getEmail(), 
        accountDTO.getPassword()
    );
    
    // 3. Return response
    return ResponseEntity.ok(response);
}
```

```java
// Services/AccountService.java
public Object login(String email, String password) {
    // 1. Find user in database
    AccountEntity account = accountRepository.findByEmail(email)
        .orElseThrow(() -> new RuntimeException("User not found"));
    
    // 2. Verify password (BCrypt)
    if (!passwordEncoder.matches(password, account.getPassword())) {
        return "Email hoặc mật khẩu không đúng!";
    }
    
    // 3. Generate JWT token
    String token = jwtUtils.generateToken(account.getEmail(), account.getRoles());
    
    // 4. Build response
    Map<String, Object> response = new HashMap<>();
    response.put("token", token);
    response.put("personalInfo", convertToDTO(account));
    
    return response;
}
```

**Luồng:**
1. `AuthController` nhận POST `/api/auth/login`
2. Validate input
3. Gọi `AccountService.login()`
4. Service tìm user trong Database
5. Verify password bằng BCrypt
6. Tạo JWT token
7. Trả về token + user info

#### **2. Crop Recommendation Flow**

```java
// Controllers/CropRecommendationController.java
@PostMapping("/recommend")
public ResponseEntity<?> recommendCrop(@RequestBody Map<String, Object> request) {
    // 1. Extract input data
    Double temperature = ((Number) request.get("temperature")).doubleValue();
    Double humidity = ((Number) request.get("humidity")).doubleValue();
    Double soilMoisture = ((Number) request.get("soil_moisture")).doubleValue();
    
    // 2. Call AI service
    AIPredictionResponse prediction = aiService.getPrediction(
        temperature, humidity, soilMoisture, null, null, null, null, null
    );
    
    // 3. Map to frontend format
    Map<String, Object> response = new HashMap<>();
    response.put("success", prediction.getSuccess());
    response.put("recommended_crop", prediction.getRecommendedCrop());
    response.put("confidence", prediction.getConfidence());
    
    return ResponseEntity.ok(response);
}
```

```java
// Services/AIRecommendationService.java
public AIPredictionResponse getPrediction(Double temperature, Double humidity, 
                                          Double soilMoisture, ...) {
    // 1. Build request to Python ML service
    String url = aiApiUrl + "/api/recommend-crop";  // http://crop-service:5000/api/recommend-crop
    
    Map<String, Object> requestMap = new HashMap<>();
    requestMap.put("temperature", temperature);
    requestMap.put("humidity", humidity);
    requestMap.put("soil_moisture", soilMoisture);
    
    // 2. Call Python service
    ResponseEntity<Map> response = restTemplate.postForEntity(
        url,
        new HttpEntity<>(requestMap, headers),
        Map.class
    );
    
    // 3. Parse response
    Map<String, Object> result = response.getBody();
    AIPredictionResponse aiResponse = new AIPredictionResponse();
    aiResponse.setRecommendedCrop((String) result.get("recommended_crop"));
    aiResponse.setConfidence(((Number) result.get("confidence")).doubleValue());
    
    return aiResponse;
}
```

**Luồng:**
1. `CropRecommendationController` nhận POST `/api/crop/recommend`
2. Extract input data (temperature, humidity, soil_moisture)
3. Gọi `AIRecommendationService.getPrediction()`
4. Service gửi HTTP POST đến Python ML service (`http://crop-service:5000`)
5. Python ML xử lý → Trả về JSON
6. Service parse response → Map sang `AIPredictionResponse`
7. Controller map sang format Frontend → Trả về

#### **3. JWT Authentication Filter**

```java
// Security/JwtAuthenticationFilter.java
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                    HttpServletResponse response, 
                                    FilterChain filterChain) {
        // 1. Extract token from header
        String token = extractTokenFromRequest(request);
        
        if (token != null && jwtUtils.validateToken(token)) {
            // 2. Extract user info from token
            String email = jwtUtils.getEmailFromToken(token);
            List<String> roles = jwtUtils.getRolesFromToken(token);
            
            // 3. Set authentication in SecurityContext
            UsernamePasswordAuthenticationToken authentication = 
                new UsernamePasswordAuthenticationToken(email, null, 
                    roles.stream().map(SimpleGrantedAuthority::new).collect(Collectors.toList()));
            
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }
        
        filterChain.doFilter(request, response);
    }
}
```

**Giải thích:**
- Filter chạy trước mỗi request
- Extract JWT token từ header `Authorization: Bearer <token>`
- Validate token → Extract user info
- Set authentication vào SecurityContext
- Controller có thể dùng `@PreAuthorize("hasRole('ADMIN')")` để check role

---

## 🤖 AI CHATBOT (NEXT.JS)

### **Cấu trúc thư mục**

```
AI_SmartFarm_CHatbot/src/
├── app/
│   ├── page.tsx              # Main chatbot page
│   └── embed/
│       └── page.tsx          # Embeddable widget page
├── ai/
│   ├── genkit.ts             # Genkit AI configuration
│   └── flows/
│       └── generate-insights-from-excel.ts  # Main AI flow
├── components/
│   ├── chatbot-widget.tsx    # Reusable chatbot widget
│   └── chat-message.tsx      # Message component
└── data/
    └── sample-data.xlsx      # Q&A data
```

### **Luồng xử lý**

#### **1. Genkit Configuration**

```typescript
// ai/genkit.ts
import {genkit} from 'genkit';
import {googleAI} from '@genkit-ai/googleai';

export const ai = genkit({
  plugins: [googleAI()],  // Google Gemini AI plugin
  model: 'googleai/gemini-2.5-flash',
});
```

**Giải thích:**
- Genkit là framework để build AI applications
- `googleAI()` plugin kết nối với Google Gemini AI
- Model `gemini-2.5-flash` là model nhanh, phù hợp cho chatbot

#### **2. AI Flow**

```typescript
// ai/flows/generate-insights-from-excel.ts
const generateInsightsFromExcelFlow = ai.defineFlow(
  {
    name: 'generateInsightsFromExcelFlow',
    inputSchema: GenerateInsightsFromExcelInputSchema,
    outputSchema: GenerateInsightsFromExcelOutputSchema,
  },
  async input => {
    try {
      // 1. Read Excel file
      const filePath = path.join(process.cwd(), 'src', 'data', 'sample-data.xlsx');
      const buffer = fs.readFileSync(filePath);
      
      // 2. Parse Excel to JSON
      const workbook = xlsx.read(buffer, { type: 'buffer' });
      const worksheet = workbook.Sheets[workbook.SheetNames[0]];
      const excelDataJson = xlsx.utils.sheet_to_json(worksheet);
      
      // 3. Call AI with prompt
      const {output} = await prompt({
        excelDataJson: JSON.stringify(excelDataJson),
        query: input.query,
        conversationHistory: input.conversationHistory || '',
      });
      
      // 4. Return answer
      return output!;
    } catch (error) {
      // Error handling...
    }
  }
);
```

**Luồng:**
1. User gửi câu hỏi → `generateInsightsFromExcel()` được gọi
2. Flow đọc file Excel (`sample-data.xlsx`)
3. Parse Excel → JSON
4. Gọi AI prompt với: câu hỏi + dữ liệu Excel + lịch sử chat
5. Google Gemini AI phân tích → Trả về câu trả lời
6. Return answer cho Frontend

#### **3. Frontend Integration**

```typescript
// app/page.tsx
const handleQuery = (query: string) => {
  // 1. Add user message to chat
  setMessages(prev => [...prev, { id: generateUUID(), role: "user", content: query }]);
  
  // 2. Call AI flow
  startTransition(async () => {
    try {
      const result = await generateInsightsFromExcel({
        excelDataUri: '',
        query,
        conversationHistory: buildHistory(messages),
      });
      
      // 3. Add AI response to chat
      setMessages(prev => [...prev, {
        id: generateUUID(),
        role: "assistant",
        content: result.answer,
      }]);
    } catch (error) {
      // Error handling...
    }
  });
};
```

---

## 🐍 ML SERVICES (PYTHON)

### **1. Crop Recommendation Service**

```python
# RecommentCrop/crop_recommendation_service.py
from flask import Flask, request, jsonify
import pickle
import numpy as np

app = Flask(__name__)

# Load model khi khởi động
model = None
def load_model():
    global model
    with open('RandomForest_RecomentTree.pkl', 'rb') as f:
        model = pickle.load(f)

# Mapping crop names (English → Vietnamese)
CROP_NAMES = {
    'watermelon': 'Dưa hấu',
    'rice': 'Lúa',
    'maize': 'Ngô',
    # ...
}

@app.route('/api/recommend-crop', methods=['POST'])
def recommend_crop():
    # 1. Get input data
    data = request.json
    temperature = data.get('temperature')
    humidity = data.get('humidity')
    soil_moisture = data.get('soil_moisture')
    
    # 2. Prepare features array
    features = np.array([[temperature, humidity, soil_moisture]])
    
    # 3. Predict using RandomForest model
    prediction = model.predict(features)[0]  # e.g., 'watermelon'
    probabilities = model.predict_proba(features)[0]
    confidence = max(probabilities)
    
    # 4. Map to Vietnamese
    crop_name_vi = CROP_NAMES.get(prediction, prediction)
    
    # 5. Return response
    return jsonify({
        'success': True,
        'recommended_crop': crop_name_vi,
        'crop_name_en': prediction,
        'confidence': float(confidence)
    })
```

**Luồng:**
1. Service khởi động → Load model từ file `.pkl`
2. Nhận POST `/api/recommend-crop` với `{temperature, humidity, soil_moisture}`
3. Chuẩn bị features array
4. Model dự đoán → Trả về tên cây trồng (tiếng Anh)
5. Map sang tiếng Việt
6. Trả về JSON response

### **2. Pest Detection Service**

```python
# PestAndDisease/pest_disease_service.py
import torch
from transformers import ViTForImageClassification, ViTImageProcessor

# Load ViT model
model = ViTForImageClassification.from_pretrained('model_path')
processor = ViTImageProcessor.from_pretrained('model_path')

@app.route('/api/detect', methods=['POST'])
def detect_pest():
    # 1. Get image from request
    image_file = request.files['image']
    image = Image.open(image_file)
    
    # 2. Preprocess image
    inputs = processor(image, return_tensors="pt")
    
    # 3. Predict
    with torch.no_grad():
        outputs = model(**inputs)
        logits = outputs.logits
        probabilities = torch.nn.functional.softmax(logits, dim=-1)
        predicted_class = torch.argmax(probabilities, dim=-1).item()
        confidence = probabilities[0][predicted_class].item()
    
    # 4. Map class to disease name
    disease_names = ['Aphid', 'Blast', 'Septoria', 'Smut']
    disease = disease_names[predicted_class]
    
    # 5. Return response
    return jsonify({
        'disease': disease,
        'confidence': float(confidence),
        'treatment': get_treatment(disease)
    })
```

---

## 💾 DATABASE SCHEMA

### **Các bảng chính**

```sql
-- Account (Người dùng)
CREATE TABLE account (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- BCrypt hashed
    full_name VARCHAR(255),
    created_at TIMESTAMP
);

-- Farm (Nông trại)
CREATE TABLE "Farm" (
    id BIGSERIAL PRIMARY KEY,
    farm_name VARCHAR(255),
    owner_id BIGINT REFERENCES account(id),
    area DECIMAL,
    region VARCHAR(255)
);

-- Field (Đồng ruộng)
CREATE TABLE "Field" (
    id BIGSERIAL PRIMARY KEY,
    farm_id BIGINT REFERENCES "Farm"(id),
    field_name VARCHAR(255),
    status VARCHAR(50),  -- GOOD, WARNING, CRITICAL
    area DECIMAL
);

-- Sensor (Cảm biến)
CREATE TABLE "Sensor" (
    id BIGSERIAL PRIMARY KEY,
    field_id BIGINT REFERENCES "Field"(id),
    sensor_name VARCHAR(255),
    type VARCHAR(50),  -- TEMPERATURE, HUMIDITY, SOIL_MOISTURE
    status VARCHAR(50)  -- ACTIVE, INACTIVE
);

-- Sensor_Data (Dữ liệu cảm biến)
CREATE TABLE "Sensor_Data" (
    id BIGSERIAL PRIMARY KEY,
    sensor_id BIGINT REFERENCES "Sensor"(id),
    temperature DECIMAL,
    humidity DECIMAL,
    soil_moisture DECIMAL,
    timestamp TIMESTAMP
);

-- Plant (Cây trồng)
CREATE TABLE "Plant" (
    id BIGSERIAL PRIMARY KEY,
    plant_name VARCHAR(255),
    description TEXT
);

-- Harvest (Thu hoạch)
CREATE TABLE "Harvest" (
    id BIGSERIAL PRIMARY KEY,
    field_id BIGINT REFERENCES "Field"(id),
    plant_id BIGINT REFERENCES "Plant"(id),
    quantity DECIMAL,
    revenue DECIMAL,
    harvest_date DATE
);
```

### **JPA Entity Example**

```java
// Entities/FarmEntity.java
@Entity
@Table(name = "Farm")
public class FarmEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "farm_name")
    private String farmName;
    
    @ManyToOne
    @JoinColumn(name = "owner_id")
    private AccountEntity owner;
    
    @OneToMany(mappedBy = "farm")
    private List<FieldEntity> fields;
    
    // Getters & Setters...
}
```

---

## 🔐 AUTHENTICATION & AUTHORIZATION

### **JWT Token Structure**

```json
{
  "sub": "admin@example.com",
  "roles": ["ADMIN"],
  "iat": 1762585563,
  "exp": 1762671963
}
```

**Giải thích:**
- `sub`: Subject (email của user)
- `roles`: Danh sách roles
- `iat`: Issued at (thời gian tạo)
- `exp`: Expiration (thời gian hết hạn)

### **Security Configuration**

```java
// Security/SecurityConfig.java
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) {
    return http
        .csrf(csrf -> csrf.disable())
        .cors(cors -> cors.configurationSource(corsConfigurationSource()))
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/api/auth/**").permitAll()
            .requestMatchers("/api/accounts/**").hasRole("ADMIN")
            .anyRequest().authenticated()
        )
        .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
        .build();
}
```

---

## 📡 API ENDPOINTS

### **Authentication**
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/register` - Đăng ký

### **Crop Recommendation**
- `POST /api/crop/recommend` - Gợi ý cây trồng
- `GET /api/crop/health` - Kiểm tra ML service

### **Farm Management**
- `GET /api/farms` - Lấy danh sách nông trại
- `POST /api/farms` - Tạo nông trại mới
- `PUT /api/farms/{id}` - Cập nhật nông trại
- `DELETE /api/farms/{id}` - Xóa nông trại

### **Sensor Data**
- `GET /api/sensors` - Lấy danh sách cảm biến
- `GET /api/sensors/{id}/data` - Lấy dữ liệu cảm biến

---

## 🐳 DOCKER & DEPLOYMENT

### **Docker Compose Structure**

```yaml
services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: SmartFarm1
    volumes:
      - postgres_data:/var/lib/postgresql/data
  
  backend:
    build: ./demoSmartFarm/demo
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/SmartFarm1
      CROP_RECOMMENDATION_URL: http://crop-service:5000
    depends_on:
      - postgres
      - crop-service
  
  crop-service:
    build: ./RecommentCrop
    ports:
      - "5000:5000"
  
  frontend:
    build: ./J2EE_Frontend
    ports:
      - "80:80"
    depends_on:
      - backend
  
  chatbot:
    build: ./AI_SmartFarm_CHatbot
    environment:
      GOOGLE_GENAI_API_KEY: ${GOOGLE_GENAI_API_KEY}
    ports:
      - "9002:9002"
```

### **Network Communication**

- Tất cả services trong cùng Docker network: `smartfarm-network`
- Services giao tiếp qua service name: `http://crop-service:5000`
- Frontend gọi Backend qua: `http://173.249.48.25:8080` (VPS IP)

---

## 📝 TÓM TẮT

**Kiến trúc:**
- **Frontend**: React SPA với Material-UI
- **Backend**: Spring Boot REST API với JWT auth
- **Chatbot**: Next.js với Google Gemini AI
- **ML Services**: Python Flask với scikit-learn/PyTorch
- **Database**: PostgreSQL với JPA/Hibernate

**Luồng xử lý:**
```
User Request → Frontend → Backend → Database/ML Services → Response
```

**Security:**
- JWT token cho authentication
- Role-based authorization
- CORS configuration

---

**🎉 Bạn đã hiểu chi tiết về hệ thống! Có thể trả lời mọi câu hỏi kỹ thuật!**

