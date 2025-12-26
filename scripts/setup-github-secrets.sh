#!/bin/bash

# Setup GitHub Secrets for Render Deployment
# Usage: bash scripts/setup-github-secrets.sh <GITHUB_OWNER> <GITHUB_REPO>

GITHUB_OWNER=$1
GITHUB_REPO=$2

if [ -z "$GITHUB_OWNER" ] || [ -z "$GITHUB_REPO" ]; then
  echo "Usage: bash scripts/setup-github-secrets.sh <GITHUB_OWNER> <GITHUB_REPO>"
  echo "Example: bash scripts/setup-github-secrets.sh myname my-cloud-ide"
  exit 1
fi

echo "=========================================="
echo "GitHub Secrets Setup for Render Deployment"
echo "=========================================="
echo ""
echo "This script will add secrets to: $GITHUB_OWNER/$GITHUB_REPO"
echo ""

# Collect secrets from user
read -p "Enter your Render API Key: " RENDER_API_KEY
read -p "Enter Backend Service ID (srv-...): " RENDER_BACKEND_SERVICE_ID
read -p "Enter Frontend Service ID (srv-...): " RENDER_FRONTEND_SERVICE_ID
read -p "Enter Backend URL (https://...onrender.com): " RENDER_BACKEND_URL
read -p "Enter Database URL (postgresql://...): " DATABASE_URL
read -p "Enter Internal API Key (or press enter to generate): " INTERNAL_API_KEY

if [ -z "$INTERNAL_API_KEY" ]; then
  INTERNAL_API_KEY=$(openssl rand -hex 32)
  echo "Generated Internal API Key: $INTERNAL_API_KEY"
fi

echo ""
echo "Adding secrets to GitHub..."
echo ""

# Use GitHub CLI (requires 'gh' installed and authenticated)
if ! command -v gh &> /dev/null; then
  echo "GitHub CLI not found. Please install it from: https://cli.github.com/"
  echo ""
  echo "Or add these secrets manually in GitHub:"
  echo "1. Go to: https://github.com/$GITHUB_OWNER/$GITHUB_REPO/settings/secrets/actions"
  echo "2. Click 'New repository secret' for each:"
  echo ""
  echo "RENDER_API_KEY=$RENDER_API_KEY"
  echo "RENDER_BACKEND_SERVICE_ID=$RENDER_BACKEND_SERVICE_ID"
  echo "RENDER_FRONTEND_SERVICE_ID=$RENDER_FRONTEND_SERVICE_ID"
  echo "RENDER_BACKEND_URL=$RENDER_BACKEND_URL"
  echo "DATABASE_URL=$DATABASE_URL"
  echo "INTERNAL_API_KEY=$INTERNAL_API_KEY"
  exit 0
fi

gh secret set RENDER_API_KEY --body "$RENDER_API_KEY" -R "$GITHUB_OWNER/$GITHUB_REPO"
gh secret set RENDER_BACKEND_SERVICE_ID --body "$RENDER_BACKEND_SERVICE_ID" -R "$GITHUB_OWNER/$GITHUB_REPO"
gh secret set RENDER_FRONTEND_SERVICE_ID --body "$RENDER_FRONTEND_SERVICE_ID" -R "$GITHUB_OWNER/$GITHUB_REPO"
gh secret set RENDER_BACKEND_URL --body "$RENDER_BACKEND_URL" -R "$GITHUB_OWNER/$GITHUB_REPO"
gh secret set DATABASE_URL --body "$DATABASE_URL" -R "$GITHUB_OWNER/$GITHUB_REPO"
gh secret set INTERNAL_API_KEY --body "$INTERNAL_API_KEY" -R "$GITHUB_OWNER/$GITHUB_REPO"

echo ""
echo "✅ All secrets added successfully!"
echo ""
echo "Next steps:"
echo "1. Go to: https://github.com/$GITHUB_OWNER/$GITHUB_REPO/actions"
echo "2. Push code or manually trigger deployment"
echo ""
