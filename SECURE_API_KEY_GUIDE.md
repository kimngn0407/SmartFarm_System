# 🔒 Hướng dẫn Bảo mật API Key - Tránh Leak

## ⚠️ Nguyên nhân API Key bị Leak

1. **Commit file `.env` vào Git** - API key bị public trên GitHub
2. **Chia sẻ API key trong code/documentation** - API key xuất hiện trong file `.md`, `.txt`
3. **Log API key ra console** - API key xuất hiện trong logs
4. **Hardcode API key trong source code** - API key được viết trực tiếp trong code

## ✅ Best Practices - Bảo vệ API Key

### 1. **KHÔNG BAO GIỜ commit file `.env`**

```bash
# Kiểm tra .gitignore đã có .env chưa
cat .gitignore | grep "^\.env$"

# Nếu chưa có, thêm vào:
echo ".env" >> .gitignore
echo ".env.local" >> .gitignore
echo ".env.production" >> .gitignore
```

### 2. **Sử dụng `.env.example` thay vì `.env`**

```bash
# Tạo file template (KHÔNG có API key thật)
cp .env .env.example

# Xóa API key thật khỏi .env.example
sed -i 's/GOOGLE_GENAI_API_KEY=.*/GOOGLE_GENAI_API_KEY=your-api-key-here/' .env.example

# Commit .env.example (an toàn)
git add .env.example
git commit -m "Add .env.example template"
```

### 3. **Xóa API key cũ khỏi Git History (nếu đã commit nhầm)**

```bash
# ⚠️ CẢNH BÁO: Chỉ chạy nếu API key đã bị commit vào Git
# Script này sẽ xóa API key khỏi toàn bộ Git history

# 1. Tìm API key cũ trong Git history
git log --all --full-history --source -- "*" | grep "AIzaSy" | head -5

# 2. Sử dụng git-filter-repo để xóa (cần cài: pip install git-filter-repo)
# git filter-repo --replace-text <(echo "AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw==>REDACTED")

# 3. Force push (⚠️ CẨN THẬN - sẽ rewrite history)
# git push origin --force --all
```

### 4. **Xóa API key khỏi các file documentation**

```bash
# Tìm tất cả file .md chứa API key
grep -r "AIzaSy" *.md --include="*.md" | grep -v "your-api-key"

# Xóa API key cũ và thay bằng placeholder
find . -name "*.md" -type f -exec sed -i 's/AIzaSy[A-Za-z0-9_-]\{35\}/YOUR_API_KEY_HERE/g' {} \;
```

### 5. **Không log API key ra console**

```typescript
// ❌ SAI - Log full API key
console.log('API key:', process.env.GOOGLE_GENAI_API_KEY);

// ✅ ĐÚNG - Chỉ log một phần
console.log('API key found:', apiKey.substring(0, 10) + '...' + apiKey.substring(apiKey.length - 4));
```

### 6. **Sử dụng Environment Variables trong Docker**

```yaml
# docker-compose.yml
services:
  chatbot:
    environment:
      # ✅ ĐÚNG - Đọc từ .env file (không hardcode)
      GOOGLE_GENAI_API_KEY: ${GOOGLE_GENAI_API_KEY:-your-api-key}
      
      # ❌ SAI - Hardcode API key
      # GOOGLE_GENAI_API_KEY: AIzaSyCHb8mRHJow08wv-uLJ40DkAXI_eIqennw
```

## 🛡️ Checklist Trước Khi Commit

Trước khi `git commit` và `git push`, kiểm tra:

```bash
# 1. Kiểm tra .env không được track
git status | grep ".env"

# 2. Kiểm tra không có API key thật trong code
grep -r "AIzaSy" --include="*.ts" --include="*.js" --include="*.tsx" --include="*.jsx" | grep -v "your-api-key"

# 3. Kiểm tra không có API key trong documentation
grep -r "AIzaSy" --include="*.md" | grep -v "your-api-key" | grep -v "YOUR_API_KEY"

# 4. Kiểm tra .gitignore có .env
grep "^\.env$" .gitignore
```

## 🔧 Script Tự Động Kiểm Tra

Chạy script `check-api-key-security.sh` trước mỗi commit:

```bash
chmod +x check-api-key-security.sh
./check-api-key-security.sh
```

## 📝 Quy trình Khi Tạo API Key Mới

1. **Tạo API key mới** từ https://aistudio.google.com/
2. **Chỉ thêm vào file `.env` trên VPS** (KHÔNG commit)
3. **Recreate container** để load API key mới:
   ```bash
   docker compose stop chatbot
   docker compose rm -f chatbot
   docker compose up -d chatbot
   ```
4. **KHÔNG** thêm API key vào:
   - ❌ Source code (.ts, .js, .tsx, .jsx)
   - ❌ Documentation (.md, .txt)
   - ❌ Git commit message
   - ❌ Docker compose file (hardcode)
   - ❌ Logs

## 🚨 Nếu API Key Đã Bị Leak

1. **Ngay lập tức revoke API key cũ** trên https://aistudio.google.com/
2. **Tạo API key mới**
3. **Xóa API key cũ khỏi tất cả file** (code, docs, .env)
4. **Xóa API key khỏi Git history** (nếu đã commit)
5. **Cập nhật API key mới** vào `.env` trên VPS

## 📚 Tài liệu Tham khảo

- [GitHub: Removing sensitive data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [OWASP: API Security](https://owasp.org/www-project-api-security/)
- [Google AI: API Key Security](https://ai.google.dev/gemini-api/docs/api-key)
