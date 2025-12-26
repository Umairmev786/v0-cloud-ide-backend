#!/bin/bash
set -e

echo "🛠️  Local Development Setup"
echo "=========================="

# Create .env files if they don't exist
if [ ! -f backend/.env ]; then
  echo "Creating backend/.env..."
  cp backend/.env.example backend/.env
  echo "⚠️  Please update backend/.env with your configuration"
fi

if [ ! -f dashboard/.env.local ]; then
  echo "Creating dashboard/.env.local..."
  echo "NEXT_PUBLIC_API_URL=http://localhost:3001" > dashboard/.env.local
fi

# Install dependencies
echo "Installing dependencies..."
cd backend && npm install && cd ..
cd dashboard && npm install && cd ..

# Run migrations
echo "Running database migrations..."
cd backend
npm run migrate
cd ..

echo "✅ Setup complete!"
echo ""
echo "To start development:"
echo "1. Backend: cd backend && npm run dev"
echo "2. Dashboard: cd dashboard && npm run dev"
echo "3. Database: docker run -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:16-alpine"
echo ""
echo "Or run everything with: docker-compose up"
