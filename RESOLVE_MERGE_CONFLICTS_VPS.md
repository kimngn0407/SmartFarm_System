# 🔧 Resolve Tất Cả Merge Conflicts Trên VPS

## 🔍 Vấn Đề

**Có nhiều files bị conflict:**
- Arduino_SmartFarm_IoT.ino
- HUONG_DAN_DIEN_DNS.md
- IOT_SEND_DATA_GUIDE.md
- README.md
- RecommentCrop/Dockerfile
- RecommentCrop/requirements.txt
- check-esp32-tools.ps1
- AIRecommendationService.java
- PestDiseaseService.java
- application.properties
- nginx/nginx.conf
- setup-ssl-standalone.sh

---

## ✅ Giải Pháp: Dùng Script Tự Động

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull script mới
git pull origin main --no-rebase --no-edit

# Chạy script resolve conflicts
chmod +x resolve-all-conflicts-vps.sh
./resolve-all-conflicts-vps.sh
```

**Script sẽ:**
- Tự động giữ version từ remote (origin/main) cho tất cả files
- Tự động add và commit

---

## 🔧 Giải Pháp Thủ Công (Nếu Script Không Chạy)

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Giữ version từ remote cho tất cả files
git checkout --theirs Arduino_SmartFarm_IoT.ino
git checkout --theirs HUONG_DAN_DIEN_DNS.md
git checkout --theirs IOT_SEND_DATA_GUIDE.md
git checkout --theirs RecommentCrop/Dockerfile
git checkout --theirs RecommentCrop/requirements.txt
git checkout --theirs check-esp32-tools.ps1
git checkout --theirs demoSmartFarm/demo/src/main/java/com/example/demo/Services/AIRecommendationService.java
git checkout --theirs demoSmartFarm/demo/src/main/java/com/example/demo/Services/PestDiseaseService.java
git checkout --theirs demoSmartFarm/demo/src/main/resources/application.properties
git checkout --theirs nginx/nginx.conf
git checkout --theirs setup-ssl-standalone.sh

# Xử lý README.md (modify/delete conflict)
git rm README.md

# Add tất cả
git add .

# Commit
git commit -m "Resolve merge conflicts - keep remote version"
```

---

## 📋 Checklist

- [ ] Đã pull code mới
- [ ] Đã chạy script hoặc resolve thủ công
- [ ] Đã commit conflicts resolution
- [ ] Đã kiểm tra `git status` không còn conflicts
- [ ] Đã reload Nginx nếu có thay đổi nginx.conf

---

## 🎯 Kết Quả Mong Đợi

**Sau khi resolve:**
- ✅ `git status`: "nothing to commit, working tree clean"
- ✅ Tất cả conflicts đã được resolve
- ✅ Code đã được sync với remote

---

**Hãy chạy script hoặc resolve thủ công!** 🔧✨
