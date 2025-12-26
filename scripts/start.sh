#!/bin/bash
set -e

echo "🚀 Cloud IDE - Starting All Services"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to start service in background
start_service() {
    local name=$1
    local cmd=$2
    local dir=$3
    
    echo -e "${BLUE}Starting ${name}...${NC}"
    cd "$dir"
    eval "$cmd" &
    cd - > /dev/null
}

# Check if running with Docker
if [ "$1" == "docker" ]; then
    echo "Starting with Docker Compose..."
    docker-compose up
    exit 0
fi

# Check environment
if [ ! -f "backend/.env" ]; then
    echo "❌ Error: backend/.env not found"
    echo "Run: bash scripts/init-project.sh"
    exit 1
fi

# Source environment
set -a
source backend/.env
set +a

# Start services
start_service "Database" "docker run -p 5432:5432 -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD postgres:16-alpine" "."
sleep 2

start_service "Backend" "npm run dev" "backend"
sleep 3

start_service "Dashboard" "npm run dev" "dashboard"

# Wait for all background jobs
wait

echo -e "${GREEN}✅ All services stopped${NC}"
