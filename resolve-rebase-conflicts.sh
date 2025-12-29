#!/bin/bash

# Script để resolve rebase conflicts trên VPS

echo "🔧 Resolving rebase conflicts..."

# 1. Xóa các file bị conflict (modify/delete) - giữ HEAD (xóa file)
echo "🗑️  Removing files that were deleted in HEAD..."
git rm CREATE_TEST_DATA_VIA_API.html 2>/dev/null
git rm EXPORT_LOCAL_DATABASE.bat 2>/dev/null
git rm FIND_POSTGRESQL_FIXED.ps1 2>/dev/null
git rm GUIDE_CREATE_DATA_VIA_FRONTEND.md 2>/dev/null
git rm IMPORT_SAMPLE_DATA_TO_RAILWAY.bat 2>/dev/null
git rm RecommentCrop/INSTALL_WORKING_VERSION.bat 2>/dev/null
git rm RecommentCrop/README.md 2>/dev/null
git rm RecommentCrop/START_HERE.txt 2>/dev/null
git rm RecommentCrop/start_service.bat 2>/dev/null
git rm SEARCH_POSTGRESQL_ALL_DRIVES.ps1 2>/dev/null
git rm TEST_WITH_TOKEN.bat 2>/dev/null
git rm sample_data.sql 2>/dev/null
git rm start_all_services.bat 2>/dev/null

# 2. Xử lý CorsConfig.java conflict - giữ version HEAD (hiện tại)
echo "✅ Keeping current CorsConfig.java (already has localhost:8000)"
git checkout --ours demoSmartFarm/demo/src/main/java/com/example/demo/Config/CorsConfig.java
git add demoSmartFarm/demo/src/main/java/com/example/demo/Config/CorsConfig.java

# 3. Add tất cả resolved files
git add -A

echo "✅ Conflicts resolved! Continuing rebase..."
git rebase --continue

