#!/bin/bash

# Render Deployment Checklist
# Run this before pushing to Render

echo "🚀 Cloud IDE - Render Deployment Checklist"
echo "=========================================="
echo ""

# Check 1: Git Status
echo "✓ Check 1: Git Status"
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not a git repository"
    exit 1
fi
echo "✅ Git repository found"
echo ""

# Check 2: Environment Variables
echo "✓ Check 2: Environment Variables (.env.example)"
if [ ! -f "backend/.env.example" ]; then
    echo "❌ backend/.env.example not found"
    exit 1
fi
echo "✅ .env.example found"
echo ""

# Check 3: Docker Files
echo "✓ Check 3: Docker Configuration"
if [ ! -f "backend/Dockerfile.prod" ] || [ ! -f "dashboard/Dockerfile" ]; then
    echo "❌ Dockerfile not found"
    exit 1
fi
echo "✅ Dockerfiles found"
echo ""

# Check 4: Build Scripts
echo "✓ Check 4: Build Scripts"
if ! grep -q "build" backend/package.json; then
    echo "❌ Build script not found in backend/package.json"
    exit 1
fi
echo "✅ Build scripts configured"
echo ""

# Check 5: Database Migrations
echo "✓ Check 5: Database Setup"
if [ ! -f "scripts/001_init_schema.sql" ]; then
    echo "❌ Database migration file not found"
    exit 1
fi
echo "✅ Database migrations ready"
echo ""

# Summary
echo "=========================================="
echo "✅ All checks passed! Ready for Render deployment"
echo ""
echo "Next steps:"
echo "1. Push to GitHub: git push origin main"
echo "2. Go to https://dashboard.render.com"
echo "3. Follow RENDER_DEPLOYMENT.md"
echo "4. Set environment variables (especially DATABASE_URL)"
echo "5. Deploy!"
echo ""
