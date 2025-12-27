#!/bin/bash

# Fix Model Files - Git LFS Issue
# Script này sẽ cài Git LFS và pull model files

set -e

echo "🔧 Fixing Model Files - Git LFS"
echo "================================"
echo ""

cd /opt/SmartFarm

# Check if Git LFS is installed
if ! command -v git-lfs &> /dev/null; then
    echo "📦 Installing Git LFS..."
    apt-get update
    apt-get install -y git-lfs
    git lfs install
    echo "✅ Git LFS installed"
else
    echo "✅ Git LFS already installed"
    git lfs install
fi

echo ""

# Check current file sizes
echo "📊 Current file sizes:"
CROP_SIZE=$(stat -c%s "RecommentCrop/RandomForest_RecomentTree.pkl" 2>/dev/null || echo "0")
PEST_SIZE=$(stat -c%s "PestAndDisease/best_vit_wheat_model_4classes.pth" 2>/dev/null || echo "0")

echo "   Crop model: $CROP_SIZE bytes"
echo "   Pest model: $PEST_SIZE bytes"
echo ""

# Pull LFS files
if [ "$CROP_SIZE" -lt 1000000 ] || [ "$PEST_SIZE" -lt 100000000 ]; then
    echo "📥 Pulling Git LFS files..."
    git lfs pull
    echo "✅ LFS files pulled"
    echo ""
    
    # Check new file sizes
    echo "📊 New file sizes:"
    CROP_SIZE=$(stat -c%s "RecommentCrop/RandomForest_RecomentTree.pkl" 2>/dev/null || echo "0")
    PEST_SIZE=$(stat -c%s "PestAndDisease/best_vit_wheat_model_4classes.pth" 2>/dev/null || echo "0")
    
    echo "   Crop model: $CROP_SIZE bytes"
    echo "   Pest model: $PEST_SIZE bytes"
    echo ""
    
    if [ "$CROP_SIZE" -lt 1000000 ] || [ "$PEST_SIZE" -lt 100000000 ]; then
        echo "⚠️  WARNING: Files still too small!"
        echo "   You may need to upload files manually or check Git LFS configuration."
        exit 1
    fi
else
    echo "✅ Model files already have correct size"
fi

# Copy to containers
echo "📥 Copying model files into containers..."
docker cp RecommentCrop/RandomForest_RecomentTree.pkl smartfarm-crop-service:/app/RandomForest_RecomentTree.pkl
docker cp PestAndDisease/best_vit_wheat_model_4classes.pth smartfarm-pest-service:/app/best_vit_wheat_model_4classes.pth

echo "✅ Files copied"
echo ""

# Fix permissions
echo "🔐 Fixing file permissions..."
docker compose exec -u root crop-service chown appuser:appuser /app/RandomForest_RecomentTree.pkl
docker compose exec -u root pest-service chown appuser:appuser /app/best_vit_wheat_model_4classes.pth

echo "✅ Permissions fixed"
echo ""

# Restart services
echo "🔄 Restarting services..."
docker compose restart crop-service pest-service

echo ""
echo "⏳ Waiting for services to restart..."
sleep 15

# Check health
echo ""
echo "🏥 Checking health..."
curl -s http://localhost:5000/health | jq . 2>/dev/null || curl -s http://localhost:5000/health
echo ""
curl -s http://localhost:5001/health | jq . 2>/dev/null || curl -s http://localhost:5001/health
echo ""

echo "✅ Done! Check logs to verify models loaded:"
echo "   docker compose logs crop-service | grep -i model"
echo "   docker compose logs pest-service | grep -i model"





#!/bin/bash

# Fix Model Files - Git LFS Issue
# Script này sẽ cài Git LFS và pull model files

set -e

echo "🔧 Fixing Model Files - Git LFS"
echo "================================"
echo ""

cd /opt/SmartFarm

# Check if Git LFS is installed
if ! command -v git-lfs &> /dev/null; then
    echo "📦 Installing Git LFS..."
    apt-get update
    apt-get install -y git-lfs
    git lfs install
    echo "✅ Git LFS installed"
else
    echo "✅ Git LFS already installed"
    git lfs install
fi

echo ""

# Check current file sizes
echo "📊 Current file sizes:"
CROP_SIZE=$(stat -c%s "RecommentCrop/RandomForest_RecomentTree.pkl" 2>/dev/null || echo "0")
PEST_SIZE=$(stat -c%s "PestAndDisease/best_vit_wheat_model_4classes.pth" 2>/dev/null || echo "0")

echo "   Crop model: $CROP_SIZE bytes"
echo "   Pest model: $PEST_SIZE bytes"
echo ""

# Pull LFS files
if [ "$CROP_SIZE" -lt 1000000 ] || [ "$PEST_SIZE" -lt 100000000 ]; then
    echo "📥 Pulling Git LFS files..."
    git lfs pull
    echo "✅ LFS files pulled"
    echo ""
    
    # Check new file sizes
    echo "📊 New file sizes:"
    CROP_SIZE=$(stat -c%s "RecommentCrop/RandomForest_RecomentTree.pkl" 2>/dev/null || echo "0")
    PEST_SIZE=$(stat -c%s "PestAndDisease/best_vit_wheat_model_4classes.pth" 2>/dev/null || echo "0")
    
    echo "   Crop model: $CROP_SIZE bytes"
    echo "   Pest model: $PEST_SIZE bytes"
    echo ""
    
    if [ "$CROP_SIZE" -lt 1000000 ] || [ "$PEST_SIZE" -lt 100000000 ]; then
        echo "⚠️  WARNING: Files still too small!"
        echo "   You may need to upload files manually or check Git LFS configuration."
        exit 1
    fi
else
    echo "✅ Model files already have correct size"
fi

# Copy to containers
echo "📥 Copying model files into containers..."
docker cp RecommentCrop/RandomForest_RecomentTree.pkl smartfarm-crop-service:/app/RandomForest_RecomentTree.pkl
docker cp PestAndDisease/best_vit_wheat_model_4classes.pth smartfarm-pest-service:/app/best_vit_wheat_model_4classes.pth

echo "✅ Files copied"
echo ""

# Fix permissions
echo "🔐 Fixing file permissions..."
docker compose exec -u root crop-service chown appuser:appuser /app/RandomForest_RecomentTree.pkl
docker compose exec -u root pest-service chown appuser:appuser /app/best_vit_wheat_model_4classes.pth

echo "✅ Permissions fixed"
echo ""

# Restart services
echo "🔄 Restarting services..."
docker compose restart crop-service pest-service

echo ""
echo "⏳ Waiting for services to restart..."
sleep 15

# Check health
echo ""
echo "🏥 Checking health..."
curl -s http://localhost:5000/health | jq . 2>/dev/null || curl -s http://localhost:5000/health
echo ""
curl -s http://localhost:5001/health | jq . 2>/dev/null || curl -s http://localhost:5001/health
echo ""

echo "✅ Done! Check logs to verify models loaded:"
echo "   docker compose logs crop-service | grep -i model"
echo "   docker compose logs pest-service | grep -i model"





