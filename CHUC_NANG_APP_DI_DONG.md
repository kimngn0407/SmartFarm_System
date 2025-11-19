# 📱 CÁC CHỨC NĂNG CHÍNH CHO APP DI ĐỘNG SMART FARM

> **Lưu ý:** ✅ = Rất hợp lý | ⚠️ = Hợp lý nhưng cần tối ưu | ❌ = Nên dùng trên Web/Desktop

## 🔐 1. XÁC THỰC NGƯỜI DÙNG ✅
- Đăng ký tài khoản mới
- Đăng nhập/Đăng xuất
- Quản lý profile cá nhân
- Phân quyền (Admin/User)
- **Lý do:** Cần thiết để truy cập app, dễ dùng trên mobile

## 🏠 2. DASHBOARD TỔNG QUAN ✅
- Hiển thị thống kê tổng hợp:
  - Tổng số cảm biến
  - Tổng số cảnh báo
  - Nhiệt độ trung bình
  - Độ ẩm không khí trung bình
  - Độ ẩm đất trung bình
  - Ánh sáng trung bình
- Biểu đồ theo dõi sensor theo thời gian thực (⚠️ cần tối ưu responsive)
- Trạng thái đồng ruộng (Good/Warning/Critical)
- **Lý do:** Xem nhanh tình trạng khi ở ngoài đồng ruộng, rất cần thiết trên mobile

## 🚜 3. QUẢN LÝ NÔNG TRẠI ⚠️
- **Xem danh sách nông trại** ✅ (rất cần khi ở ngoài đồng ruộng)
- **Tạo/Sửa/Xóa nông trại** ❌ (nên làm trên web/desktop vì cần nhập nhiều thông tin)
- **Quản lý thông tin nông trại** ❌ (nên làm trên web/desktop)
- **Lý do:** Mobile chỉ nên xem danh sách, quản lý chi tiết nên làm trên màn hình lớn

## 🌾 4. QUẢN LÝ ĐỒNG RUỘNG (FIELD) ⚠️
- **Xem danh sách đồng ruộng** ✅ (rất cần khi ở ngoài đồng ruộng)
- **Hiển thị bản đồ đồng ruộng** ✅ (GPS + Maps rất hữu ích trên mobile)
- **Xem thông tin chi tiết** ✅ (xem nhanh khi đang ở đồng ruộng)
- **Tạo/Sửa/Xóa đồng ruộng** ❌ (nên làm trên web/desktop)
- **Quản lý thông tin chi tiết** ❌ (nên làm trên web/desktop)
- **Lý do:** Mobile tuyệt vời cho xem danh sách + bản đồ (GPS), nhưng tạo mới cần màn hình lớn

## 🌱 5. QUẢN LÝ CÂY TRỒNG (CROP) ⚠️
- **Xem danh sách cây trồng** ✅ (cần thiết khi ở đồng ruộng)
- **Xem thông tin cây trồng** ✅ (tra cứu nhanh)
- **Theo dõi các giai đoạn phát triển** ✅ (xem trạng thái hiện tại)
- **Tạo/Sửa/Xóa cây trồng** ❌ (nên làm trên web/desktop)
- **Quản lý mùa vụ (Crop Season)** ❌ (cần nhập nhiều thông tin, nên làm trên web)
- **Lý do:** Mobile tốt cho xem/tra cứu, không tốt cho tạo/sửa nhiều dữ liệu

## 🤖 6. GỢI Ý CÂY TRỒNG (CROP RECOMMENDATION) ✅
- **Tự động lấy dữ liệu từ sensor** ✅ (tính năng đặc biệt của mobile: có thể ở ngay đồng ruộng)
- Nhập điều kiện môi trường thủ công:
  - Nhiệt độ (°C)
  - Độ ẩm không khí (%)
  - Độ ẩm đất (%)
- Nhận gợi ý cây trồng phù hợp từ AI (RandomForest Model)
- Xem kết quả dự đoán với confidence score
- **Lý do:** Rất hợp lý khi ở đồng ruộng, có thể lấy dữ liệu trực tiếp từ sensor hoặc nhập nhanh

## 🐛 7. PHÁT HIỆN SÂU BỆNH (PEST & DISEASE DETECTION) ✅✅✅
- **Chụp ảnh trực tiếp từ camera điện thoại** ✅ (tính năng đặc biệt của mobile!)
- Upload ảnh từ thư viện
- Phân tích tự động bằng AI (Vision Transformer)
- Nhận diện 4 loại sâu bệnh:
  - Aphid (Rệp)
  - Blast (Bệnh đạo ôn)
  - Septoria (Bệnh đốm lá)
  - Smut (Bệnh than)
- Hiển thị confidence score và khuyến nghị xử lý
- Lịch sử phát hiện sâu bệnh
- **Lý do:** ĐÂY LÀ TÍNH NĂNG QUAN TRỌNG NHẤT TRÊN MOBILE! Chụp ảnh ngay tại đồng ruộng → AI phân tích ngay lập tức

## 📡 8. QUẢN LÝ CẢM BIẾN (SENSOR MANAGEMENT) ⚠️
- **Xem danh sách cảm biến** ✅ (cần thiết khi ở đồng ruộng)
- **Theo dõi 4 loại cảm biến** ✅ (xem giá trị real-time)
  - **Nhiệt độ** (Temperature)
  - **Độ ẩm không khí** (Humidity)
  - **Độ ẩm đất** (Soil Moisture)
  - **Ánh sáng** (Light)
- **Hiển thị vị trí cảm biến trên bản đồ** ✅ (GPS + Maps rất hữu ích)
- **Xem dữ liệu sensor theo thời gian thực** ✅ (xem nhanh khi đang ở đồng ruộng)
- **Biểu đồ dữ liệu sensor** ⚠️ (cần tối ưu responsive cho màn hình nhỏ)
- **Quản lý trạng thái cảm biến** ❌ (nên làm trên web/desktop)
- **Lý do:** Mobile tuyệt vời cho xem/giám sát, không tốt cho quản lý chi tiết

## 📊 9. DỮ LIỆU CẢM BIẾN THEO THỜI GIAN THỰC ✅✅
- **Lấy dữ liệu sensor từ IoT** ✅ (tự động sync real-time)
- **Hiển thị dữ liệu real-time** ✅ (xem nhanh khi ở đồng ruộng)
- **Biểu đồ xu hướng 6 giờ/12 giờ/24 giờ** ⚠️ (cần tối ưu cho màn hình nhỏ)
- **Lưu trữ lịch sử dữ liệu** ✅ (xem lại khi cần)
- **Lọc dữ liệu theo khoảng thời gian** ⚠️ (UI cần đơn giản)
- **Lý do:** Rất cần thiết trên mobile vì người dùng thường xem khi đang ở ngoài đồng ruộng

## ⚠️ 10. QUẢN LÝ CẢNH BÁO (ALERTS) ✅✅✅
- **Xem danh sách cảnh báo** ✅ (rất cần thiết)
- **Phân loại cảnh báo** ✅ (xem nhanh trạng thái):
  - **Good**: Giá trị trong ngưỡng an toàn
  - **Warning**: Giá trị vượt ngưỡng
  - **Critical**: Giá trị vượt ngưỡng nguy hiểm
- **Cảnh báo theo loại sensor** ✅:
  - Nhiệt độ
  - Độ ẩm không khí
  - Độ ẩm đất
- **Push notification cho cảnh báo quan trọng** ✅✅✅ (tính năng đặc biệt của mobile!)
- Email notification (tùy chọn)
- **Xem cảnh báo theo đồng ruộng** ✅
- **Lý do:** ĐÂY LÀ TÍNH NĂNG QUAN TRỌNG NHẤT! Push notification trên mobile giúp người dùng biết ngay khi có vấn đề

## 💧 11. QUẢN LÝ TƯỚI TIÊU (IRRIGATION) ✅
- **Điều khiển hệ thống tưới tiêu** ✅ (điều khiển từ xa khi ở đồng ruộng)
- **Xem trạng thái tưới tiêu** ✅ (kiểm tra nhanh)
- **Lịch sử hoạt động tưới tiêu** ✅ (xem lại khi cần)
- **Cài đặt tự động tưới** ❌ (nên làm trên web/desktop vì cần cấu hình phức tạp)
- **Lý do:** Mobile rất tốt cho điều khiển nhanh và xem trạng thái, nhưng cài đặt chi tiết nên làm trên web

## 🌾 12. QUẢN LÝ THU HOẠCH (HARVEST) ✅
- **Ghi nhận thu hoạch** ✅ (ghi ngay tại đồng ruộng bằng điện thoại)
- **Nhập thông tin thu hoạch** ✅ (nhập nhanh trên mobile):
  - Ngày thu hoạch
  - Sản lượng
  - Cây trồng (chọn từ danh sách)
  - Đồng ruộng (chọn từ danh sách)
- **Xem lịch sử thu hoạch** ✅
- **Lý do:** Rất hợp lý! Người dùng có thể ghi nhận ngay khi thu hoạch, không cần về nhà mới ghi

## 💰 13. QUẢN LÝ DOANH THU (REVENUE) ⚠️
- **Xem thống kê doanh thu** ✅ (xem nhanh trên mobile)
- **Thống kê theo thời gian** ✅ (ngày/tuần/tháng/năm)
- **Thống kê theo cây trồng/đồng ruộng/nông trại** ✅
- **Biểu đồ doanh thu** ⚠️ (cần tối ưu responsive)
- **Báo cáo tài chính chi tiết** ❌ (nên xem trên web/desktop vì cần in/xuất file)
- **Tính toán doanh thu** ✅ (tự động từ dữ liệu thu hoạch)
- **Lý do:** Mobile tốt cho xem nhanh thống kê, nhưng báo cáo chi tiết nên làm trên web

## 💬 14. AI CHATBOT TƯ VẤN ✅
- **Chat với AI về nông nghiệp** ✅ (rất tiện khi ở đồng ruộng)
- **Tư vấn kỹ thuật canh tác** ✅ (hỏi ngay khi cần)
- **Hỏi đáp về sâu bệnh** ✅ (hỏi sau khi phát hiện sâu bệnh)
- **Gợi ý chăm sóc cây trồng** ✅ (tư vấn real-time)
- **Phân tích dữ liệu Excel** ❌ (không thực tế trên mobile)
- **Lý do:** Chatbot rất hợp lý trên mobile, người dùng có thể hỏi ngay khi ở đồng ruộng

## 👥 15. QUẢN LÝ TÀI KHOẢN (ADMIN) ❌
- **Xem danh sách người dùng** ⚠️ (có thể xem nhưng không tiện)
- **Quản lý quyền người dùng** ❌ (nên làm trên web/desktop)
- **Cập nhật thông tin người dùng** ❌ (nên làm trên web/desktop)
- **Lý do:** Tính năng admin phức tạp, cần màn hình lớn, nên ưu tiên web/desktop

## ⚙️ 16. CÀI ĐẶT HỆ THỐNG ⚠️
- **Cấu hình thông báo** ✅ (bật/tắt push notification)
- **Cài đặt ngưỡng cảnh báo** ❌ (nên làm trên web/desktop vì cần nhập nhiều giá trị)
- **Quản lý cài đặt chung** ❌ (nên làm trên web/desktop)
- **Lý do:** Mobile chỉ nên có cài đặt cơ bản (notification), cài đặt phức tạp nên làm trên web

## 📱 17. TÍNH NĂNG DI ĐỘNG ĐẶC BIỆT ✅✅✅
- **Push Notifications** ✅✅✅ - Thông báo cảnh báo sensor (tính năng quan trọng nhất!)
- **Camera Integration** ✅✅✅ - Chụp ảnh để phát hiện sâu bệnh (tính năng đặc biệt!)
- **GPS Integration** ✅✅ - Xác định vị trí đồng ruộng, hiển thị bản đồ
- **Offline Mode** ✅ - Xem dữ liệu đã cache khi mất mạng
- **Biểu đồ tương tác** ⚠️ - Zoom, pan trên biểu đồ sensor (cần tối ưu)
- **Dark Mode** ✅ - Giao diện tối cho ban đêm/ngoài đồng ruộng

---

## 📊 TÓM TẮT ĐÁNH GIÁ

### ✅ RẤT HỢP LÝ TRÊN MOBILE (Ưu tiên cao)
1. **Phát hiện sâu bệnh bằng Camera** - Tính năng đặc biệt của mobile
2. **Cảnh báo + Push Notification** - Thông báo real-time khi có vấn đề
3. **Xem dữ liệu sensor real-time** - Giám sát khi ở đồng ruộng
4. **Ghi nhận thu hoạch** - Ghi ngay tại đồng ruộng
5. **AI Chatbot** - Tư vấn real-time
6. **Dashboard tổng quan** - Xem nhanh tình trạng

### ⚠️ HỢP LÝ NHƯNG CẦN TỐI ƯU
- Biểu đồ sensor (cần responsive)
- Thống kê doanh thu (xem nhanh, không chi tiết)
- Bản đồ đồng ruộng (GPS integration)
- Xem danh sách Farm/Field/Crop

### ❌ KHÔNG HỢP LÝ TRÊN MOBILE (Nên làm trên Web/Desktop)
- Tạo/Sửa/Xóa dữ liệu (cần nhập nhiều thông tin)
- Quản lý chi tiết (cấu hình phức tạp)
- Báo cáo chi tiết (cần in/xuất file)
- Admin management (quản lý tài khoản)

---

## 🔗 API ENDPOINTS CẦN TÍCH HỢP

### Authentication
- `POST /api/auth/register` - Đăng ký
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/logout` - Đăng xuất

### Farms & Fields
- `GET /api/farms` - Danh sách nông trại
- `GET /api/fields` - Danh sách đồng ruộng
- `POST /api/farms/{id}/fields` - Tạo đồng ruộng

### Sensors
- `GET /api/sensors` - Danh sách cảm biến
- `GET /api/sensor-data?sensorId={id}&from={time}&to={time}` - Dữ liệu sensor

### AI Services
- `POST /api/crop/recommend` - Gợi ý cây trồng
- `POST /api/pest-disease/detect` - Phát hiện sâu bệnh

### Alerts
- `GET /api/alerts` - Danh sách cảnh báo
- `GET /api/alerts/field/{fieldId}` - Cảnh báo theo đồng ruộng

### Harvest & Revenue
- `GET /api/harvest` - Danh sách thu hoạch
- `GET /api/harvest-revenue` - Thống kê doanh thu

---

## 📊 KIẾN TRÚC HỆ THỐNG

```
Mobile App (React Native / Flutter)
    ↓
Spring Boot Backend API (Port 8080)
    ↓
├── PostgreSQL Database
├── Python ML Services:
│   ├── Crop Recommendation (Port 5000)
│   └── Pest Detection (Port 5001)
└── IoT Sensors (Arduino/ESP32) → Flask API → Database
```

---

## 🎯 ƯU TIÊN PHÁT TRIỂN CHO MOBILE

### Phase 1 (MVP) - Các tính năng QUAN TRỌNG NHẤT
1. ✅ **Authentication** - Bắt buộc
2. ✅ **Dashboard cơ bản** - Xem nhanh tình trạng
3. ✅✅ **Cảnh báo + Push Notification** - Tính năng đặc biệt của mobile
4. ✅✅ **Phát hiện sâu bệnh (Camera)** - Tính năng đặc biệt của mobile
5. ✅ **Xem dữ liệu sensor real-time** - Cần thiết khi ở đồng ruộng

### Phase 2 - Tính năng HỖ TRỢ
6. ✅ **Crop Recommendation** - Hữu ích khi ở đồng ruộng
7. ✅ **Ghi nhận thu hoạch** - Ghi ngay tại đồng ruộng
8. ✅ **AI Chatbot** - Tư vấn real-time
9. ✅ **Điều khiển tưới tiêu** - Điều khiển từ xa
10. ✅ **Xem danh sách Farm/Field/Crop** - Tra cứu nhanh
11. ✅ **Bản đồ đồng ruộng** - GPS + Maps

### Phase 3 - Tính năng NÂNG CAO
12. ⚠️ **Biểu đồ chi tiết** - Tối ưu responsive
13. ⚠️ **Thống kê doanh thu** - Xem nhanh
14. ✅ **Offline Mode** - Xem dữ liệu khi mất mạng
15. ⚠️ **Cài đặt thông báo** - Cấu hình notification

### ❌ KHÔNG NÊN LÀM TRÊN MOBILE (Ưu tiên Web/Desktop)
- Tạo/Sửa/Xóa Farm/Field/Crop (quản lý chi tiết)
- Quản lý cảm biến (cài đặt, sửa thông tin)
- Quản lý tài khoản admin
- Cài đặt ngưỡng cảnh báo chi tiết
- Báo cáo tài chính chi tiết
- Quản lý mùa vụ (cần nhập nhiều thông tin)

