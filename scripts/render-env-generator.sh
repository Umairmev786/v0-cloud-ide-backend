#!/bin/bash

# Generate strong secrets for Render deployment

echo "🔐 Render Environment Variables Generator"
echo "=========================================="
echo ""

# Generate JWT Secret
JWT_SECRET=$(openssl rand -hex 32)
echo "Add these to your Render dashboard (Settings → Environment):"
echo ""
echo "JWT_SECRET=$JWT_SECRET"
echo ""

# Ask for database URL
echo "You need your Neon DATABASE_URL:"
echo "1. Go to https://console.neon.tech"
echo "2. Select your project"
echo "3. Copy the connection string"
echo "4. Add it as DATABASE_URL in Render"
echo ""

# Generate other values
echo "Other required variables:"
echo "PORT=3001"
echo "NODE_ENV=production"
echo "ALLOWED_ORIGINS=https://cloud-ide-dashboard-xxxxx.onrender.com,https://yourdomain.com"
echo "DOCKER_BACKEND_URL=unix:///var/run/docker.sock"
echo "DOCKER_REGISTRY=docker.io"
echo ""
echo "Optional:"
echo "GITHUB_TOKEN=(leave empty if not using Git integration)"
echo "OLLAMA_URL=(leave empty if not using local LLM)"
echo ""
