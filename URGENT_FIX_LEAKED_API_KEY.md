# 🚨 URGENT: API Key Đã Bị Leak Trên Git!

## Vấn đề nghiêm trọng

GitHub đã phát hiện API key bị leak trong commit `d0b8629b` tại file `QUICK_FIX_NEW_API_KEY.md`.

**API key đã bị public và cần được revoke ngay lập tức!**

## Các bước khẩn cấp

### Bước 1: Revoke API key cũ ngay lập tức

1. **Truy cập Google AI Studio:**
   - URL: https://aistudio.google.com/
   - Đăng nhập với Google account

2. **Revoke API key bị leak:**
   - Vào **API Keys**
   - Tìm API key: `AIzaSyA9cEW7vY0GKdUd1K4J0Fsj7QLoW47WMaU`
   - Click **Delete** hoặc **Revoke**
   - Xác nhận xóa

### Bước 2: Tạo API key MỚI

1. **Tạo API key mới:**
   - Vào **Get API Key** → **Create API Key**
   - Chọn project hoặc tạo project mới
   - Copy API key mới

2. **Lưu ý:**
   - ⚠️ **KHÔNG commit API key mới lên Git**
   - ⚠️ **Chỉ set trong file .env trên VPS**
   - ⚠️ **Không share API key công khai**

### Bước 3: Cập nhật API key mới trên VPS

```bash
cd /opt/SmartFarm

# 1. Mở file .env
nano .env

# 2. Tìm và thay API key cũ bằng API key MỚI
# GOOGLE_GENAI_API_KEY=YOUR_NEW_API_KEY_HERE

# 3. Lưu: Ctrl+O, Enter, Ctrl+X
```

### Bước 4: Restart chatbot

```bash
# Restart để load API key mới
docker compose restart chatbot

# Kiểm tra logs
docker compose logs chatbot --tail=20

# Phải thấy:
# ✅ API key found: ... (API key mới)
# ✅ Genkit đã được khởi tạo thành công
```

### Bước 5: Xóa API key khỏi Git history (nếu cần)

**CẢNH BÁO:** Chỉ làm nếu bạn hiểu rõ về Git và có backup!

```bash
# Option 1: Sử dụng git-filter-repo (khuyến nghị)
# Cần cài đặt: pip install git-filter-repo

# Option 2: Sử dụng BFG Repo-Cleaner
# Download từ: https://rtyley.github.io/bfg-repo-cleaner/

# Option 3: Tạo commit mới xóa API key (không xóa khỏi history)
# Đã được thực hiện - file đã được sửa
```

## Lưu ý quan trọng

1. **API key cũ đã bị leak và phải được revoke**
2. **API key mới KHÔNG được commit lên Git**
3. **Chỉ set API key trong file .env trên VPS**
4. **File .env đã có trong .gitignore - không commit**

## Checklist

- [ ] Revoke API key cũ trên Google AI Studio
- [ ] Tạo API key mới
- [ ] Cập nhật API key mới trong .env trên VPS
- [ ] Restart chatbot
- [ ] Test chatbot hoạt động
- [ ] Đảm bảo không commit API key lên Git

## Phòng ngừa trong tương lai

1. **Luôn kiểm tra .gitignore có .env**
2. **Không bao giờ commit API key trong code hoặc documentation**
3. **Sử dụng environment variables hoặc secret management**
4. **Review code trước khi commit**
