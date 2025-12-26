#!/bin/bash
set -e

echo "🚀 Cloud IDE Backend - Render Deployment Script"
echo "=============================================="

# Check environment variables
required_vars=("DATABASE_URL" "JWT_SECRET")
for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "❌ Error: $var is not set"
    exit 1
  fi
done

echo "✓ Environment variables validated"

# Build backend
cd backend
echo "📦 Building backend..."
npm install
npm run build
echo "✓ Backend built"

cd ..

# Build dashboard
cd dashboard
echo "📦 Building dashboard..."
npm install
npm run build
echo "✓ Dashboard built"

cd ..

echo "✅ Deployment preparation complete!"
echo ""
echo "Environment Variables Set:"
echo "- DATABASE_URL: (configured)"
echo "- JWT_SECRET: (configured)"
echo "- ALLOWED_ORIGINS: (configure in Render)"
echo ""
echo "Next Steps:"
echo "1. Push to GitHub"
echo "2. Connect to Render"
echo "3. Set environment variables in Render dashboard"
echo "4. Deploy!"
