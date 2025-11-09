# 📚 GIẢI THÍCH HỆ THỐNG SMART FARM - CÁCH ĐƠN GIẢN

> **Tài liệu này giải thích hệ thống theo cách dễ hiểu nhất, không cần kiến thức lập trình**

---

## 🎯 HỆ THỐNG LÀ GÌ?

**Smart Farm** là một hệ thống quản lý nông trại thông minh, giúp nông dân:
- 📊 Xem dữ liệu từ cảm biến (nhiệt độ, độ ẩm, đất)
- 🤖 Hỏi AI về kỹ thuật trồng trọt
- 🌱 Nhận gợi ý cây trồng phù hợp
- 🐛 Phát hiện sâu bệnh qua ảnh
- 💰 Quản lý thu hoạch và doanh thu

---

## 🏗️ KIẾN TRÚC TỔNG QUAN (Hình ảnh đơn giản)

```
┌─────────────────────────────────────────────────┐
│           NGƯỜI DÙNG (Nông dân)                 │
│         (Dùng trình duyệt web)                  │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │   GIAO DIỆN WEB      │  ← Người dùng thấy gì?
        │   (Frontend React)    │     - Trang đăng nhập
        │   Port: 80           │     - Dashboard
        └──────────┬───────────┘     - Form nhập liệu
                   │
        ┌──────────┴───────────┐
        │                      │
        ▼                      ▼
┌──────────────┐      ┌──────────────┐
│   BACKEND    │      │   CHATBOT    │
│   (Java)     │      │  (Next.js)   │
│   Port: 8080 │      │  Port: 9002  │
└──────┬───────┘      └──────┬───────┘
       │                     │
       │                     │
       ├──────────┬──────────┘
       │          │
       ▼          ▼
┌──────────────┐  ┌──────────────┐
│  CROP ML     │  │  PEST ML     │
│  (Python)    │  │  (Python)    │
│  Port: 5000  │  │  Port: 5001  │
└──────────────┘  └──────────────┘
       │
       ▼
┌──────────────┐
│  DATABASE    │
│ (PostgreSQL) │
│  Port: 5432  │
└──────────────┘
```

---

## 📦 CÁC THÀNH PHẦN CHÍNH (9 phần)

### 1. 🌐 **Frontend (Giao diện web)** - `J2EE_Frontend/`
**Nhiệm vụ:** Hiển thị giao diện cho người dùng

**Ví dụ đơn giản:**
- Giống như **màn hình TV**, người dùng nhìn thấy và tương tác
- Khi bạn click nút "Gợi ý cây trồng", nó gửi yêu cầu đến Backend

**File quan trọng:**
- `App.js` - File chính, quản lý tất cả các trang
- `pages/crop/CropRecommendation.js` - Trang gợi ý cây trồng
- `services/cropRecommendationService.js` - Gửi request đến Backend

**Luồng hoạt động:**
```
User nhập dữ liệu → Click "Gợi ý" 
→ Frontend gửi request đến Backend (http://localhost:8080/api/crop/recommend)
→ Nhận kết quả → Hiển thị lên màn hình
```

---

### 2. ☕ **Backend (Server xử lý)** - `demoSmartFarm/demo/`
**Nhiệm vụ:** Xử lý logic, kết nối Database, gọi ML services

**Ví dụ đơn giản:**
- Giống như **bộ não** của hệ thống
- Nhận yêu cầu từ Frontend → Xử lý → Trả kết quả

**Cấu trúc:**
```
Controllers/     → Nhận request từ Frontend
Services/        → Xử lý logic nghiệp vụ
Repositories/    → Truy vấn Database
Entities/        → Định nghĩa cấu trúc dữ liệu
```

**Ví dụ luồng Login:**
```
1. User nhập email/password → Frontend gửi đến /api/auth/login
2. AuthController nhận request
3. AccountService kiểm tra email/password trong Database
4. Nếu đúng → Tạo JWT token → Trả về Frontend
5. Frontend lưu token → User đăng nhập thành công
```

**Ví dụ luồng Crop Recommendation:**
```
1. Frontend gửi: {temperature: 25, humidity: 80, soil_moisture: 45}
2. CropRecommendationController nhận request
3. AIRecommendationService gọi Python ML service (http://crop-service:5000)
4. Python trả về: {recommended_crop: "Dưa hấu", confidence: 0.85}
5. Backend chuyển đổi → Trả về Frontend
6. Frontend hiển thị: "Cây trồng được gợi ý: Dưa hấu"
```

---

### 3. 🤖 **AI Chatbot** - `AI_SmartFarm_CHatbot/`
**Nhiệm vụ:** Trả lời câu hỏi về nông nghiệp bằng AI

**Ví dụ đơn giản:**
- Giống như **trợ lý ảo** có thể trả lời câu hỏi
- Sử dụng Google Gemini AI để hiểu và trả lời

**Luồng hoạt động:**
```
1. User gõ: "Cách trồng lúa?"
2. Frontend gửi đến Chatbot (http://localhost:9002)
3. Chatbot đọc file Excel chứa câu hỏi-đáp
4. Gửi câu hỏi + dữ liệu Excel cho Google Gemini AI
5. AI phân tích và trả lời: "Trồng lúa cần đất phù sa, nước đầy đủ..."
6. Chatbot trả về Frontend → Hiển thị cho user
```

**File quan trọng:**
- `src/ai/flows/generate-insights-from-excel.ts` - Logic xử lý AI
- `src/app/page.tsx` - Giao diện chatbot
- `src/data/sample-data.xlsx` - File dữ liệu câu hỏi-đáp

---

### 4. 🌱 **Crop Recommendation ML** - `RecommentCrop/`
**Nhiệm vụ:** Gợi ý cây trồng dựa trên điều kiện môi trường

**Ví dụ đơn giản:**
- Giống như **bác sĩ** khám và đưa ra lời khuyên
- Nhận: Nhiệt độ, độ ẩm, độ ẩm đất
- Trả về: Tên cây trồng phù hợp + độ tin cậy

**Cách hoạt động:**
```
1. Model RandomForest đã được train sẵn (file .pkl)
2. Khi khởi động service → Load model vào memory
3. Nhận request: {temperature: 25, humidity: 80, soil_moisture: 45}
4. Model dự đoán → Trả về: "watermelon" (Dưa hấu)
5. Service chuyển sang tiếng Việt → Trả về Backend
```

**File quan trọng:**
- `crop_recommendation_service.py` - API service
- `RandomForest_RecomentTree.pkl` - Model đã train

---

### 5. 🐛 **Pest Detection ML** - `PestAndDisease/`
**Nhiệm vụ:** Nhận diện sâu bệnh qua ảnh

**Ví dụ đơn giản:**
- Giống như **bác sĩ nhìn ảnh X-quang** và chẩn đoán
- Nhận: Ảnh lá cây
- Trả về: Loại sâu bệnh + độ tin cậy + cách xử lý

**Cách hoạt động:**
```
1. Model Vision Transformer (ViT) đã được train sẵn
2. User upload ảnh lá cây
3. Model phân tích ảnh → Nhận diện: "Aphid" (Rệp)
4. Trả về: {disease: "Aphid", confidence: 0.92, treatment: "..."}
```

---

### 6. 💾 **Database (PostgreSQL)**
**Nhiệm vụ:** Lưu trữ tất cả dữ liệu

**Ví dụ đơn giản:**
- Giống như **tủ hồ sơ** lưu trữ thông tin
- Lưu: User, Farm, Field, Sensor data, Harvest...

**Các bảng chính:**
- `account` - Thông tin người dùng
- `Farm` - Nông trại
- `Field` - Đồng ruộng
- `Sensor` - Cảm biến
- `Sensor_Data` - Dữ liệu từ cảm biến
- `Plant` - Cây trồng
- `Harvest` - Thu hoạch

---

## 🔄 LUỒNG HOẠT ĐỘNG TỔNG QUAN

### **Luồng 1: Đăng nhập**
```
1. User mở trình duyệt → http://localhost:80
2. Frontend hiển thị trang Login
3. User nhập email/password → Click "Đăng nhập"
4. Frontend gửi POST /api/auth/login đến Backend
5. Backend kiểm tra Database → Tạo JWT token
6. Backend trả về token → Frontend lưu vào localStorage
7. Frontend chuyển đến Dashboard
```

### **Luồng 2: Gợi ý cây trồng**
```
1. User vào trang "Gợi ý cây trồng"
2. Nhập: Nhiệt độ = 25°C, Độ ẩm = 80%, Độ ẩm đất = 45%
3. Click "Gợi ý cây trồng"
4. Frontend gửi POST /api/crop/recommend đến Backend
5. Backend gọi Python ML service (http://crop-service:5000/api/recommend-crop)
6. Python ML xử lý → Trả về: "watermelon" (Dưa hấu)
7. Backend chuyển đổi → Trả về Frontend
8. Frontend hiển thị: "Cây trồng được gợi ý: Dưa hấu"
```

### **Luồng 3: Hỏi Chatbot**
```
1. User mở Chatbot widget
2. Gõ: "Cách trồng lúa?"
3. Frontend gửi đến Chatbot (http://localhost:9002)
4. Chatbot đọc file Excel (sample-data.xlsx)
5. Gửi câu hỏi + dữ liệu Excel cho Google Gemini AI
6. AI phân tích và trả lời
7. Chatbot trả về Frontend → Hiển thị câu trả lời
```

### **Luồng 4: Phát hiện sâu bệnh**
```
1. User vào trang "Phát hiện sâu bệnh"
2. Upload ảnh lá cây
3. Frontend gửi ảnh đến Backend
4. Backend gọi Python ML service (http://pest-service:5001/api/detect)
5. Python ML phân tích ảnh → Nhận diện: "Aphid"
6. Trả về: {disease: "Aphid", confidence: 0.92, treatment: "..."}
7. Frontend hiển thị kết quả + cách xử lý
```

---

## 🔐 BẢO MẬT VÀ XÁC THỰC

### **JWT Token (JSON Web Token)**
- Khi đăng nhập thành công, Backend tạo một **token** (giống như thẻ ID)
- Token chứa: Email, Role (ADMIN/FARMER...)
- Mỗi request từ Frontend phải gửi kèm token
- Backend kiểm tra token → Cho phép hoặc từ chối

**Ví dụ:**
```
Login thành công → Token: "eyJhbGciOiJIUzI1NiJ9..."
Frontend lưu token vào localStorage
Mỗi request gửi kèm: Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

---

## 📁 CẤU TRÚC THƯ MỤC (Đơn giản)

```
SmartFarm/
├── J2EE_Frontend/          ← Giao diện web (React)
│   ├── src/
│   │   ├── App.js          ← File chính, quản lý routing
│   │   ├── pages/          ← Các trang (Dashboard, Farm, Crop...)
│   │   └── services/       ← Gửi request đến Backend
│
├── demoSmartFarm/demo/      ← Backend (Java Spring Boot)
│   └── src/main/java/
│       ├── Controllers/    ← Nhận request từ Frontend
│       ├── Services/      ← Xử lý logic
│       ├── Repositories/  ← Truy vấn Database
│       └── Entities/      ← Định nghĩa bảng Database
│
├── AI_SmartFarm_CHatbot/   ← Chatbot AI (Next.js)
│   └── src/
│       ├── app/page.tsx    ← Giao diện chatbot
│       └── ai/flows/       ← Logic xử lý AI
│
├── RecommentCrop/          ← ML gợi ý cây trồng (Python)
│   ├── crop_recommendation_service.py  ← API service
│   └── RandomForest_RecomentTree.pkl   ← Model đã train
│
└── PestAndDisease/         ← ML phát hiện sâu bệnh (Python)
    └── pest_disease_service.py  ← API service
```

---

## 🚀 CÁCH CHẠY HỆ THỐNG

### **Cách 1: Dùng Docker (Khuyên dùng)**
```bash
docker compose up -d
```
→ Tự động chạy tất cả services

### **Cách 2: Chạy từng service**
```bash
# 1. Database
docker compose up -d postgres

# 2. Backend
cd demoSmartFarm/demo
mvn spring-boot:run

# 3. Frontend
cd J2EE_Frontend
npm start

# 4. Chatbot
cd AI_SmartFarm_CHatbot
npm run dev

# 5. Crop ML
cd RecommentCrop
python crop_recommendation_service.py

# 6. Pest ML
cd PestAndDisease
python pest_disease_service.py
```

---

## ❓ CÂU HỎI THƯỜNG GẶP

### **Q: Frontend và Backend khác nhau như thế nào?**
**A:** 
- **Frontend** = Giao diện người dùng thấy (như màn hình TV)
- **Backend** = Xử lý logic phía sau (như bộ não)

### **Q: Tại sao cần nhiều services?**
**A:** 
- Mỗi service làm một việc riêng (chia nhỏ để dễ quản lý)
- Frontend = Giao diện
- Backend = Logic chính
- Chatbot = AI riêng
- Crop ML = Machine Learning riêng
- Pest ML = Machine Learning riêng

### **Q: Database lưu gì?**
**A:** 
- Tất cả dữ liệu: User, Farm, Field, Sensor data, Harvest...
- Giống như file Excel nhưng có cấu trúc và có thể truy vấn nhanh

### **Q: JWT Token là gì?**
**A:** 
- Giống như **thẻ ID** chứng minh bạn đã đăng nhập
- Mỗi request phải gửi kèm token
- Backend kiểm tra token → Cho phép hoặc từ chối

---

## 📝 TÓM TẮT

**Hệ thống Smart Farm gồm:**
1. **Frontend** - Giao diện web (React)
2. **Backend** - Xử lý logic (Java Spring Boot)
3. **Chatbot** - AI tư vấn (Next.js + Google Gemini)
4. **Crop ML** - Gợi ý cây trồng (Python + RandomForest)
5. **Pest ML** - Phát hiện sâu bệnh (Python + ViT)
6. **Database** - Lưu trữ dữ liệu (PostgreSQL)

**Luồng hoạt động:**
```
User → Frontend → Backend → Database/ML Services → Trả về User
```

---

**🎉 Bạn đã hiểu cơ bản về hệ thống! Đọc tiếp file `GIAI_THICH_HE_THONG_CHI_TIET.md` để biết chi tiết kỹ thuật!**

