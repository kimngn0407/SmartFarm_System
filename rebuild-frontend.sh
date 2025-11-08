#!/bin/bash

echo "🔄 Starting frontend rebuild process..."

# Stop and remove existing frontend container and image
echo "⏹️  Stopping and removing frontend service..."
docker compose stop frontend
docker compose rm -f frontend
docker rmi smartfarm-frontend 2>/dev/null || true

# Pull latest code
echo "📥 Pulling latest code..."
git pull origin main

# Build frontend with no cache
echo "🔨 Building frontend service (no cache)..."
docker compose build --no-cache frontend

# Start frontend
echo "🚀 Starting frontend service..."
docker compose up -d frontend

# Wait for service to stabilize
echo "⏳ Waiting for frontend to stabilize (20 seconds)..."
sleep 20

# Check service status
echo "📊 Checking service status:"
docker compose ps | grep frontend

echo "✅ Frontend rebuild completed!"
echo ""
echo "🧪 Test steps:"
echo "1. Clear browser cache (Incognito mode)"
echo "2. Open: http://173.249.48.25"
echo "3. Login and check Console for API logs"

