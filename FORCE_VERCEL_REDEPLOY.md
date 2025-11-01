# 🔄 Force Vercel Redeploy

## Cách 1: Qua Vercel Dashboard (Khuyến nghị)

### Bước 1: Mở Vercel
```
https://vercel.com/kimngn0407s-projects
```

### Bước 2: Chọn Project
- Click vào project "hackathon-pione-dream" (hoặc tên Frontend project)

### Bước 3: Vào Deployments Tab
- Click tab "Deployments"
- Xem deployment mới nhất

### Bước 4: Redeploy
- Click vào deployment mới nhất (có commit e0c381d)
- Click nút "..." (3 dots)
- Click "Redeploy"
- Chọn "Use existing Build Cache" UNCHECK
- Click "Redeploy"

### Bước 5: Đợi
- Đợi status: Building → Ready
- Khoảng 1-2 phút

---

## Cách 2: Push Empty Commit (Nếu Cách 1 Không Được)

### Bước 1: Tạo empty commit
```bash
cd E:\DoAnJ2EE\J2EE_Frontend
git commit --allow-empty -m "Force redeploy"
git push
```

### Bước 2: Đợi Vercel auto-deploy
- Vercel sẽ tự động detect push mới
- Sẽ trigger deployment mới
- Đợi 1-2 phút

---

## Cách 3: Clear Vercel Cache

### Trong Vercel Dashboard:
```
1. Project Settings
2. Git
3. Scroll down
4. Click "Clear Build Cache"
5. Redeploy
```

---

## ✅ Kiểm Tra Deployment Thành Công

### Check trong Vercel:
- Status: ✅ Ready (màu xanh)
- Build time: < 2 phút
- No errors in Build Logs

### Check Frontend:
```
1. Mở Incognito: https://hackathon-pione-dream.vercel.app/
2. F12 → Network tab
3. Clear, reload
4. Check file Dashboard.js → Preview
5. Tìm dòng 114 → Phải thấy:
   const farms = Array.isArray(farmsResponse.data) ? farmsResponse.data : [];
```

---

## 🚨 Nếu Vẫn Lỗi

### Check Production URL:
```
1. Vercel Dashboard → Domains
2. Có thể có nhiều URLs:
   - hackathon-pione-dream.vercel.app
   - hackathon-pione-dream-git-main.vercel.app
   - hackathon-pione-dream-[hash].vercel.app
3. Thử MỘT trong các URLs deployment mới nhất
```

### Hoặc check Source Maps:
```
F12 → Sources → webpack:// → src/pages/dashboard/Dashboard.js
→ Xem code có đúng như đã sửa không
```


