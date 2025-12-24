#!/bin/bash

# Script kiểm tra bảo mật API key trước khi commit
# Chạy: ./check-api-key-security.sh

echo "🔒 Kiểm tra Bảo mật API Key"
echo "============================"
echo ""

ERRORS=0
WARNINGS=0

# Màu sắc
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Kiểm tra .env có được track trong Git không
echo "1️⃣ Kiểm tra .env files trong Git..."
if git ls-files | grep -E "\.env$" > /dev/null 2>&1; then
    echo -e "${RED}❌ CẢNH BÁO: File .env đang được track trong Git!${NC}"
    echo "   Files:"
    git ls-files | grep -E "\.env$"
    echo "   → Cần thêm vào .gitignore và xóa khỏi Git:"
    echo "     git rm --cached .env"
    echo "     echo '.env' >> .gitignore"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ .env không được track trong Git${NC}"
fi
echo ""

# 2. Kiểm tra API key thật trong source code
echo "2️⃣ Kiểm tra API key thật trong source code..."
API_KEY_PATTERN="AIzaSy[A-Za-z0-9_-]{35}"
FOUND_IN_CODE=$(grep -r "$API_KEY_PATTERN" --include="*.ts" --include="*.js" --include="*.tsx" --include="*.jsx" --include="*.java" --include="*.py" 2>/dev/null | grep -v "your-api-key" | grep -v "YOUR_API_KEY" | wc -l)

if [ "$FOUND_IN_CODE" -gt 0 ]; then
    echo -e "${RED}❌ Tìm thấy API key thật trong source code!${NC}"
    grep -r "$API_KEY_PATTERN" --include="*.ts" --include="*.js" --include="*.tsx" --include="*.jsx" --include="*.java" --include="*.py" 2>/dev/null | grep -v "your-api-key" | grep -v "YOUR_API_KEY"
    echo "   → Cần xóa API key khỏi các file này"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ Không tìm thấy API key thật trong source code${NC}"
fi
echo ""

# 3. Kiểm tra API key trong documentation
echo "3️⃣ Kiểm tra API key trong documentation..."
FOUND_IN_DOCS=$(grep -r "$API_KEY_PATTERN" --include="*.md" --include="*.txt" 2>/dev/null | grep -v "your-api-key" | grep -v "YOUR_API_KEY" | grep -v "YOUR_NEW_API_KEY" | wc -l)

if [ "$FOUND_IN_DOCS" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Tìm thấy API key trong documentation!${NC}"
    grep -r "$API_KEY_PATTERN" --include="*.md" --include="*.txt" 2>/dev/null | grep -v "your-api-key" | grep -v "YOUR_API_KEY" | grep -v "YOUR_NEW_API_KEY" | head -5
    echo "   → Nên thay bằng placeholder: YOUR_API_KEY_HERE"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}✅ Không tìm thấy API key thật trong documentation${NC}"
fi
echo ""

# 4. Kiểm tra .gitignore có .env
echo "4️⃣ Kiểm tra .gitignore..."
if grep -q "^\.env$" .gitignore 2>/dev/null; then
    echo -e "${GREEN}✅ .env đã có trong .gitignore${NC}"
else
    echo -e "${YELLOW}⚠️  .env chưa có trong .gitignore${NC}"
    echo "   → Thêm: echo '.env' >> .gitignore"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# 5. Kiểm tra .env có trong staging area
echo "5️⃣ Kiểm tra .env trong staging area..."
if git diff --cached --name-only | grep -E "\.env$" > /dev/null 2>&1; then
    echo -e "${RED}❌ CẢNH BÁO: .env đang trong staging area!${NC}"
    echo "   → Chạy: git reset HEAD .env"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ .env không trong staging area${NC}"
fi
echo ""

# 6. Kiểm tra API key trong Git history (chỉ 5 commit gần nhất)
echo "6️⃣ Kiểm tra API key trong Git history (5 commits gần nhất)..."
FOUND_IN_HISTORY=$(git log -5 --all --full-history --source -- "*" 2>/dev/null | grep "$API_KEY_PATTERN" | wc -l)

if [ "$FOUND_IN_HISTORY" -gt 0 ]; then
    echo -e "${RED}❌ CẢNH BÁO: Tìm thấy API key trong Git history!${NC}"
    echo "   → API key đã bị commit vào Git"
    echo "   → Cần xóa khỏi Git history (xem SECURE_API_KEY_GUIDE.md)"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ Không tìm thấy API key trong Git history (5 commits gần nhất)${NC}"
fi
echo ""

# Tổng kết
echo "============================"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ Tất cả kiểm tra đều PASS!${NC}"
    echo "   Bạn có thể commit an toàn."
    exit 0
elif [ $ERRORS -gt 0 ]; then
    echo -e "${RED}❌ Tìm thấy $ERRORS lỗi bảo mật!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Và $WARNINGS cảnh báo${NC}"
    fi
    echo "   → KHÔNG nên commit cho đến khi fix các lỗi này"
    exit 1
else
    echo -e "${YELLOW}⚠️  Tìm thấy $WARNINGS cảnh báo${NC}"
    echo "   → Nên fix trước khi commit"
    exit 0
fi
