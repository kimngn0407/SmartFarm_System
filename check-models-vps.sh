#!/bin/bash

# Check Model Files trong Docker Containers
# Script để kiểm tra model files trên VPS

echo "🔍 Checking Model Files in Docker Containers"
echo "============================================="
echo ""

cd /opt/SmartFarm

# Check if model files exist in repository
echo "📁 1. Checking model files in repository:"
if [ -f "RecommentCrop/RandomForest_RecomentTree.pkl" ]; then
    CROP_REPO_SIZE=$(stat -c%s "RecommentCrop/RandomForest_RecomentTree.pkl" 2>/dev/null || stat -f%z "RecommentCrop/RandomForest_RecomentTree.pkl" 2>/dev/null)
    echo "   ✅ Crop model: $CROP_REPO_SIZE bytes ($(numfmt --to=iec-i --suffix=B $CROP_REPO_SIZE 2>/dev/null || echo "N/A"))"
else
    echo "   ❌ Crop model NOT found in repository!"
fi

if [ -f "PestAndDisease/best_vit_wheat_model_4classes.pth" ]; then
    PEST_REPO_SIZE=$(stat -c%s "PestAndDisease/best_vit_wheat_model_4classes.pth" 2>/dev/null || stat -f%z "PestAndDisease/best_vit_wheat_model_4classes.pth" 2>/dev/null)
    echo "   ✅ Pest model: $PEST_REPO_SIZE bytes ($(numfmt --to=iec-i --suffix=B $PEST_REPO_SIZE 2>/dev/null || echo "N/A"))"
else
    echo "   ❌ Pest model NOT found in repository!"
fi

echo ""

# Check files in containers
echo "🐳 2. Checking model files in containers:"
echo ""

# Crop service
if docker compose exec -T crop-service test -f RandomForest_RecomentTree.pkl 2>/dev/null; then
    CROP_CONTAINER=$(docker compose exec -T crop-service ls -lh RandomForest_RecomentTree.pkl 2>/dev/null | awk '{print $5, $9}')
    CROP_SIZE=$(docker compose exec -T crop-service stat -c%s RandomForest_RecomentTree.pkl 2>/dev/null || echo "0")
    echo "   Crop model: $CROP_CONTAINER"
    echo "   Size: $CROP_SIZE bytes"
    
    if [ "$CROP_SIZE" -lt 1000000 ]; then
        echo "   ⚠️  WARNING: File too small! Should be ~2.3 MB"
    fi
else
    echo "   ❌ Crop model NOT found in container!"
fi

echo ""

# Pest service
if docker compose exec -T pest-service test -f best_vit_wheat_model_4classes.pth 2>/dev/null; then
    PEST_CONTAINER=$(docker compose exec -T pest-service ls -lh best_vit_wheat_model_4classes.pth 2>/dev/null | awk '{print $5, $9}')
    PEST_SIZE=$(docker compose exec -T pest-service stat -c%s best_vit_wheat_model_4classes.pth 2>/dev/null || echo "0")
    echo "   Pest model: $PEST_CONTAINER"
    echo "   Size: $PEST_SIZE bytes"
    
    if [ "$PEST_SIZE" -lt 100000000 ]; then
        echo "   ⚠️  WARNING: File too small! Should be ~343 MB"
    fi
else
    echo "   ❌ Pest model NOT found in container!"
fi

echo ""

# Check permissions
echo "🔐 3. Checking file permissions:"
docker compose exec -T crop-service ls -l RandomForest_RecomentTree.pkl 2>/dev/null || echo "   Crop model: Cannot check"
docker compose exec -T pest-service ls -l best_vit_wheat_model_4classes.pth 2>/dev/null || echo "   Pest model: Cannot check"

echo ""

# Check health
echo "🏥 4. Health checks:"
curl -s http://localhost:5000/health | jq . 2>/dev/null || curl -s http://localhost:5000/health
echo ""
curl -s http://localhost:5001/health | jq . 2>/dev/null || curl -s http://localhost:5001/health
echo ""

# Check recent logs
echo "📝 5. Recent model-related logs:"
echo "   Crop service:"
docker compose logs crop-service --tail=10 | grep -i model || echo "   No model-related logs"
echo ""
echo "   Pest service:"
docker compose logs pest-service --tail=10 | grep -i model || echo "   No model-related logs"





#!/bin/bash

# Check Model Files trong Docker Containers
# Script để kiểm tra model files trên VPS

echo "🔍 Checking Model Files in Docker Containers"
echo "============================================="
echo ""

cd /opt/SmartFarm

# Check if model files exist in repository
echo "📁 1. Checking model files in repository:"
if [ -f "RecommentCrop/RandomForest_RecomentTree.pkl" ]; then
    CROP_REPO_SIZE=$(stat -c%s "RecommentCrop/RandomForest_RecomentTree.pkl" 2>/dev/null || stat -f%z "RecommentCrop/RandomForest_RecomentTree.pkl" 2>/dev/null)
    echo "   ✅ Crop model: $CROP_REPO_SIZE bytes ($(numfmt --to=iec-i --suffix=B $CROP_REPO_SIZE 2>/dev/null || echo "N/A"))"
else
    echo "   ❌ Crop model NOT found in repository!"
fi

if [ -f "PestAndDisease/best_vit_wheat_model_4classes.pth" ]; then
    PEST_REPO_SIZE=$(stat -c%s "PestAndDisease/best_vit_wheat_model_4classes.pth" 2>/dev/null || stat -f%z "PestAndDisease/best_vit_wheat_model_4classes.pth" 2>/dev/null)
    echo "   ✅ Pest model: $PEST_REPO_SIZE bytes ($(numfmt --to=iec-i --suffix=B $PEST_REPO_SIZE 2>/dev/null || echo "N/A"))"
else
    echo "   ❌ Pest model NOT found in repository!"
fi

echo ""

# Check files in containers
echo "🐳 2. Checking model files in containers:"
echo ""

# Crop service
if docker compose exec -T crop-service test -f RandomForest_RecomentTree.pkl 2>/dev/null; then
    CROP_CONTAINER=$(docker compose exec -T crop-service ls -lh RandomForest_RecomentTree.pkl 2>/dev/null | awk '{print $5, $9}')
    CROP_SIZE=$(docker compose exec -T crop-service stat -c%s RandomForest_RecomentTree.pkl 2>/dev/null || echo "0")
    echo "   Crop model: $CROP_CONTAINER"
    echo "   Size: $CROP_SIZE bytes"
    
    if [ "$CROP_SIZE" -lt 1000000 ]; then
        echo "   ⚠️  WARNING: File too small! Should be ~2.3 MB"
    fi
else
    echo "   ❌ Crop model NOT found in container!"
fi

echo ""

# Pest service
if docker compose exec -T pest-service test -f best_vit_wheat_model_4classes.pth 2>/dev/null; then
    PEST_CONTAINER=$(docker compose exec -T pest-service ls -lh best_vit_wheat_model_4classes.pth 2>/dev/null | awk '{print $5, $9}')
    PEST_SIZE=$(docker compose exec -T pest-service stat -c%s best_vit_wheat_model_4classes.pth 2>/dev/null || echo "0")
    echo "   Pest model: $PEST_CONTAINER"
    echo "   Size: $PEST_SIZE bytes"
    
    if [ "$PEST_SIZE" -lt 100000000 ]; then
        echo "   ⚠️  WARNING: File too small! Should be ~343 MB"
    fi
else
    echo "   ❌ Pest model NOT found in container!"
fi

echo ""

# Check permissions
echo "🔐 3. Checking file permissions:"
docker compose exec -T crop-service ls -l RandomForest_RecomentTree.pkl 2>/dev/null || echo "   Crop model: Cannot check"
docker compose exec -T pest-service ls -l best_vit_wheat_model_4classes.pth 2>/dev/null || echo "   Pest model: Cannot check"

echo ""

# Check health
echo "🏥 4. Health checks:"
curl -s http://localhost:5000/health | jq . 2>/dev/null || curl -s http://localhost:5000/health
echo ""
curl -s http://localhost:5001/health | jq . 2>/dev/null || curl -s http://localhost:5001/health
echo ""

# Check recent logs
echo "📝 5. Recent model-related logs:"
echo "   Crop service:"
docker compose logs crop-service --tail=10 | grep -i model || echo "   No model-related logs"
echo ""
echo "   Pest service:"
docker compose logs pest-service --tail=10 | grep -i model || echo "   No model-related logs"





