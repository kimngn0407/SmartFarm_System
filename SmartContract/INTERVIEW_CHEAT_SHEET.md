# 📋 Cheat Sheet - Trình Bày Sản Phẩm (1 Trang)

## 🎯 TỔNG QUAN (30s)
**SmartFarm IoT** - Hệ thống giám sát nông nghiệp:
- Thu thập: Nhiệt độ, độ ẩm, độ ẩm đất, ánh sáng
- Lưu trữ: PostgreSQL real-time
- Blockchain: Đảm bảo tính toàn vẹn dữ liệu
- Hỗ trợ: Arduino UNO + ESP32

---

## 🏗️ KIẾN TRÚC (1 phút)

### 2 Luồng Xử Lý:

**Luồng 1 - Arduino UNO:**
```
Arduino → Serial/USB → forwarder.py (Python) → Flask API → PostgreSQL + Blockchain
```

**Luồng 2 - ESP32:**
```
ESP32 → HTTP POST → Flask API → PostgreSQL + Blockchain
```

**Lý do**: Arduino không có WiFi → cần Serial Gateway. ESP32 có WiFi → gửi trực tiếp.

---

## 🔄 XỬ LÝ BACKEND (1 phút)

**Flask API xử lý 4 bước:**

1. **Authentication**: Kiểm tra API Key (`x-api-key` header)
2. **Validation**: Parse JSON, normalize timestamp, validate giá trị
3. **Database**: Lưu vào 4 sensors riêng biệt (ID 7,8,9,10)
4. **Blockchain**: Tính Keccak256 hash → Oracle Node → Smart Contract

---

## ⭐ ĐIỂM NỔI BẬT (1 phút)

1. **Hybrid Architecture**: Tối ưu cho 2 loại thiết bị
2. **Blockchain Integration**: Đảm bảo tính toàn vẹn dữ liệu
3. **Error Handling**: Retry mechanism, JSON error handling
4. **Flexible Timestamp**: Hỗ trợ Unix timestamp và seconds from boot

---

## 💡 CÂU HỎI THƯỜNG GẶP

**Q: Tại sao 2 phương pháp?**
A: Arduino không có WiFi → Serial Gateway. ESP32 có WiFi → HTTP trực tiếp.

**Q: Tại sao Blockchain?**
A: Đảm bảo tính toàn vẹn dữ liệu, có thể verify sau này.

**Q: Xử lý lỗi?**
A: Retry (3 lần), validate dữ liệu, transaction database, xử lý lỗi DHT11.

**Q: Scale được bao nhiêu?**
A: Hiện tại 50-100 devices. Muốn scale → microservices + message queue.

**Q: Bảo mật?**
A: API Key hiện tại. Production → JWT + Rate limiting + HTTPS.

---

## 🗣️ SCRIPT NGẮN GỌN (2 phút)

> "Em xin giới thiệu **SmartFarm IoT** - hệ thống giám sát nông nghiệp.
> 
> **Kiến trúc Hybrid** với 2 luồng:
> - Arduino UNO → Serial → Python Gateway → Flask API
> - ESP32 → HTTP POST trực tiếp → Flask API
> 
> **Backend**: Flask API nhận dữ liệu, lưu PostgreSQL, tính hash và gửi lên blockchain.
> 
> **Điểm nổi bật**: Blockchain integration, error handling thông minh, hỗ trợ 2 loại thiết bị.
> 
> **Tech Stack**: Python (Flask), Node.js (Oracle), PostgreSQL, Solidity."

---

## 📊 VẼ SƠ ĐỒ (Nếu có bảng)

```
[Arduino] → [forwarder.py] ─┐
                              ├→ [Flask API] → [PostgreSQL]
[ESP32] → HTTP ──────────────┘              → [Oracle] → [Blockchain]
```

---

## ✅ KEY POINTS

1. Hybrid Architecture (2 luồng)
2. Blockchain Integration (điểm nổi bật)
3. Error Handling (retry, validation)
4. Flexible Design (2 loại thiết bị)

---

**Nhớ: Tự tin, nói rõ ràng, sẵn sàng trả lời câu hỏi!** 🚀


