# 💡 Giải Thích 2 Đèn Trên Relay Module

## 🔍 Relay Module Thường Có 2 LED

### LED 1: LED Nguồn (Power LED)
- **Luôn sáng** khi relay module có điện
- **Màu:** Thường là **đỏ** hoặc **xanh**
- **Ý nghĩa:** Báo relay module đang được cấp nguồn
- **Không phản ánh** trạng thái relay (BẬT/TẮT)

### LED 2: LED Trạng Thái (Status LED)
- **Sáng khi relay BẬT** (kết nối)
- **Tắt khi relay TẮT** (ngắt kết nối)
- **Màu:** Thường là **xanh** hoặc **vàng**
- **Ý nghĩa:** Báo trạng thái thực tế của relay

---

## 🎯 Cách Nhận Biết

### Nếu Cả 2 LED Đều Sáng:
- **LED 1 (Power):** Luôn sáng → Bình thường ✅
- **LED 2 (Status):** Sáng → **Relay đang BẬT** ✅

### Nếu Chỉ 1 LED Sáng:
- **LED 1 (Power):** Sáng → Bình thường ✅
- **LED 2 (Status):** Tắt → **Relay đang TẮT** ❌

---

## 🔧 Kiểm Tra Thực Tế

### Bước 1: Xem Khi Relay TẮT
1. **Đảm bảo độ ẩm đất trong khoảng [30%, 70%]**
2. **Nhìn vào relay module:**
   - **LED 1 (Power):** Vẫn sáng (bình thường)
   - **LED 2 (Status):** Phải TẮT

### Bước 2: Xem Khi Relay BẬT
1. **Làm đất khô** (độ ẩm < 30%) hoặc **ướt quá** (> 70%)
2. **Nhìn vào relay module:**
   - **LED 1 (Power):** Vẫn sáng (bình thường)
   - **LED 2 (Status):** Sẽ SÁNG (relay BẬT)

---

## 💡 Cách Phân Biệt 2 LED

### Thường Thấy:
- **LED đỏ/xanh (Power):** Luôn sáng khi có nguồn
- **LED xanh/vàng (Status):** Chỉ sáng khi relay BẬT

### Hoặc:
- **LED lớn hơn (Power):** Luôn sáng
- **LED nhỏ hơn (Status):** Sáng/Tắt theo relay

---

## 🔍 Kiểm Tra Bằng Serial Monitor

### Khi Relay BẬT:
```
💧 Máy bơm BẬT
```
→ **LED 2 (Status) phải SÁNG**

### Khi Relay TẮT:
```
💧 Máy bơm TẮT
✅ Đã tưới xong
```
→ **LED 2 (Status) phải TẮT**

---

## 🎯 Tóm Tắt

**2 LED trên relay:**
1. **LED Power (Nguồn):** Luôn sáng khi có điện → Bình thường
2. **LED Status (Trạng thái):** Sáng = Relay BẬT, Tắt = Relay TẮT

**Cách nhận biết relay BẬT:**
- **LED Status SÁNG** = Relay đang BẬT ✅
- **LED Status TẮT** = Relay đang TẮT ❌

---

## 🔧 Nếu Cả 2 LED Luôn Sáng

**Có thể do:**
1. **Relay luôn BẬT** → Kiểm tra code và logic
2. **LED Status bị lỗi** → Không phản ánh đúng trạng thái
3. **Cảm biến đất luôn báo khô/ướt** → Relay luôn BẬT

**Cách kiểm tra:**
- Xem Serial Monitor có thông báo `💧 Máy bơm BẬT` liên tục không?
- Kiểm tra giá trị `"soil"` trong Serial Monitor
- Thử làm đất ẩm (trong khoảng 30-70%) xem relay có TẮT không

---

**Hãy xem LED nào thay đổi (sáng/tắt) khi relay BẬT/TẮT - Đó là LED Status!** 💡✨


