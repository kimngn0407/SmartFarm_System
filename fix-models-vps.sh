#!/bin/bash

# Fix Model Files trong Docker Containers
# Chạy script này trên VPS để copy model files vào containers

set -e

echo "🔧 Fixing Model Files in Docker Containers"
echo "========================================="
echo ""

cd /opt/SmartFarm

# Check if model files exist
if [ ! -f "RecommentCrop/RandomForest_RecomentTree.pkl" ]; then
    echo "❌ Crop model file not found!"
    exit 1
fi

if [ ! -f "PestAndDisease/best_vit_wheat_model_4classes.pth" ]; then
    echo "❌ Pest model file not found!"
    exit 1
fi

echo "✅ Model files found in repository"
echo ""

# Check current file sizes in containers
echo "📊 Current file sizes in containers:"
CROP_SIZE=$(docker compose exec -T crop-service ls -l RandomForest_RecomentTree.pkl 2>/dev/null | awk '{print $5}' || echo "0")
PEST_SIZE=$(docker compose exec -T pest-service ls -l best_vit_wheat_model_4classes.pth 2>/dev/null | awk '{print $5}' || echo "0")

echo "   Crop model in container: $CROP_SIZE bytes"
echo "   Pest model in container: $PEST_SIZE bytes"
echo ""

# Copy files
echo "📥 Copying model files into containers..."
docker cp RecommentCrop/RandomForest_RecomentTree.pkl smartfarm-crop-service:/app/RandomForest_RecomentTree.pkl
docker cp PestAndDisease/best_vit_wheat_model_4classes.pth smartfarm-pest-service:/app/best_vit_wheat_model_4classes.pth

echo "✅ Files copied"
echo ""

# Fix permissions (containers run as non-root user appuser with UID 1000)
echo "🔐 Fixing file permissions..."
docker compose exec -T crop-service chown appuser:appuser /app/RandomForest_RecomentTree.pkl 2>/dev/null || \
    docker compose exec -u root crop-service chown appuser:appuser /app/RandomForest_RecomentTree.pkl
docker compose exec -T pest-service chown appuser:appuser /app/best_vit_wheat_model_4classes.pth 2>/dev/null || \
    docker compose exec -u root pest-service chown appuser:appuser /app/best_vit_wheat_model_4classes.pth

echo "✅ Permissions fixed"
echo ""

# Verify file sizes
echo "📊 New file sizes in containers:"
docker compose exec -T crop-service ls -lh RandomForest_RecomentTree.pkl
docker compose exec -T pest-service ls -lh best_vit_wheat_model_4classes.pth
echo ""

# Restart services
echo "🔄 Restarting services..."
docker compose restart crop-service pest-service

echo ""
echo "⏳ Waiting for services to restart..."
sleep 10

# Check health
echo ""
echo "🏥 Checking health..."
curl -s http://localhost:5000/health | jq . || curl -s http://localhost:5000/health
echo ""
curl -s http://localhost:5001/health | jq . || curl -s http://localhost:5001/health
echo ""

echo "✅ Done! Check logs to verify models loaded:"
echo "   docker compose logs crop-service | grep -i model"
echo "   docker compose logs pest-service | grep -i model"





#!/bin/bash

# Fix Model Files trong Docker Containers
# Chạy script này trên VPS để copy model files vào containers

set -e

echo "🔧 Fixing Model Files in Docker Containers"
echo "========================================="
echo ""

cd /opt/SmartFarm

# Check if model files exist
if [ ! -f "RecommentCrop/RandomForest_RecomentTree.pkl" ]; then
    echo "❌ Crop model file not found!"
    exit 1
fi

if [ ! -f "PestAndDisease/best_vit_wheat_model_4classes.pth" ]; then
    echo "❌ Pest model file not found!"
    exit 1
fi

echo "✅ Model files found in repository"
echo ""

# Check current file sizes in containers
echo "📊 Current file sizes in containers:"
CROP_SIZE=$(docker compose exec -T crop-service ls -l RandomForest_RecomentTree.pkl 2>/dev/null | awk '{print $5}' || echo "0")
PEST_SIZE=$(docker compose exec -T pest-service ls -l best_vit_wheat_model_4classes.pth 2>/dev/null | awk '{print $5}' || echo "0")

echo "   Crop model in container: $CROP_SIZE bytes"
echo "   Pest model in container: $PEST_SIZE bytes"
echo ""

# Copy files
echo "📥 Copying model files into containers..."
docker cp RecommentCrop/RandomForest_RecomentTree.pkl smartfarm-crop-service:/app/RandomForest_RecomentTree.pkl
docker cp PestAndDisease/best_vit_wheat_model_4classes.pth smartfarm-pest-service:/app/best_vit_wheat_model_4classes.pth

echo "✅ Files copied"
echo ""

# Fix permissions (containers run as non-root user appuser with UID 1000)
echo "🔐 Fixing file permissions..."
docker compose exec -T crop-service chown appuser:appuser /app/RandomForest_RecomentTree.pkl 2>/dev/null || \
    docker compose exec -u root crop-service chown appuser:appuser /app/RandomForest_RecomentTree.pkl
docker compose exec -T pest-service chown appuser:appuser /app/best_vit_wheat_model_4classes.pth 2>/dev/null || \
    docker compose exec -u root pest-service chown appuser:appuser /app/best_vit_wheat_model_4classes.pth

echo "✅ Permissions fixed"
echo ""

# Verify file sizes
echo "📊 New file sizes in containers:"
docker compose exec -T crop-service ls -lh RandomForest_RecomentTree.pkl
docker compose exec -T pest-service ls -lh best_vit_wheat_model_4classes.pth
echo ""

# Restart services
echo "🔄 Restarting services..."
docker compose restart crop-service pest-service

echo ""
echo "⏳ Waiting for services to restart..."
sleep 10

# Check health
echo ""
echo "🏥 Checking health..."
curl -s http://localhost:5000/health | jq . || curl -s http://localhost:5000/health
echo ""
curl -s http://localhost:5001/health | jq . || curl -s http://localhost:5001/health
echo ""

echo "✅ Done! Check logs to verify models loaded:"
echo "   docker compose logs crop-service | grep -i model"
echo "   docker compose logs pest-service | grep -i model"





