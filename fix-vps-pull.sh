#!/bin/bash
# Script để fix lỗi pull trên VPS khi có local changes

echo "🔍 Kiểm tra local changes..."
git status

echo ""
echo "📦 Stashing local changes..."
git stash push -m "Local changes before pull $(date +%Y%m%d_%H%M%S)"

echo ""
echo "⬇️ Pulling latest code..."
git pull origin main

echo ""
echo "🔄 Applying stashed changes..."
git stash pop

echo ""
echo "✅ Hoàn tất! Kiểm tra conflicts nếu có:"
git status

