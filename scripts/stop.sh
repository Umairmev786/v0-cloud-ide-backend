#!/bin/bash

echo "🛑 Stopping all services..."

# Kill all Node processes started by this script
pkill -f "npm run dev" || true
pkill -f "node" || true

# Stop Docker containers if using docker-compose
if docker ps | grep -q "cloud-ide"; then
    docker-compose down
fi

echo "✅ All services stopped"
