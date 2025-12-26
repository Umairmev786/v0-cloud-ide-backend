#!/bin/bash
set -e

echo "🚀 Cloud IDE - Railway Deployment"
echo "=================================="

# Install Railway CLI if not present
if ! command -v railway &> /dev/null; then
    echo "Installing Railway CLI..."
    npm i -g @railway/cli
fi

# Login to Railway
echo "Logging in to Railway..."
railway login

# Link project
echo "Linking to Railway project..."
railway link

# Set environment variables
echo "Setting environment variables..."
railway variables set DATABASE_URL
railway variables set JWT_SECRET
railway variables set GITHUB_TOKEN
railway variables set NEXT_PUBLIC_API_URL

# Deploy
echo "Deploying to Railway..."
railway up

echo "✅ Deployment complete!"
railway open
