#!/bin/bash
set -e

echo "🚀 Cloud IDE - Project Initialization"
echo "===================================="
echo ""

# Detect if running from root directory
if [ ! -d "backend" ] || [ ! -d "dashboard" ]; then
    echo "❌ Error: Must run from project root directory"
    exit 1
fi

echo "Step 1: Install Dependencies"
echo "----------------------------"
cd backend && npm install && cd ..
cd dashboard && npm install && cd ..
echo "✅ Dependencies installed"
echo ""

echo "Step 2: Setup Database"
echo "---------------------"

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo "⚠️  DATABASE_URL not set. Using default PostgreSQL"
    export DATABASE_URL="postgresql://postgres:password@localhost:5432/cloud_ide"
    echo "To use Neon: export DATABASE_URL=postgresql://..."
fi

echo "Database: $DATABASE_URL"
cd backend && npm run migrate && cd ..
echo "✅ Database migrations complete"
echo ""

echo "Step 3: Environment Setup"
echo "------------------------"

if [ ! -f "backend/.env" ]; then
    cp backend/.env.example backend/.env
    echo "✅ Created backend/.env (please update with your config)"
fi

if [ ! -f "dashboard/.env.local" ]; then
    echo "NEXT_PUBLIC_API_URL=http://localhost:3001" > dashboard/.env.local
    echo "✅ Created dashboard/.env.local"
fi

echo ""
echo "✅ Initialization Complete!"
echo ""
echo "📝 Next Steps:"
echo "1. Update backend/.env with your configuration"
echo "2. Start backend: cd backend && npm run dev"
echo "3. Start dashboard: cd dashboard && npm run dev"
echo "4. Visit: http://localhost:3000"
echo ""
echo "Or run with Docker:"
echo "docker-compose up"
