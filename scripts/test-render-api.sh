#!/bin/bash

# Test deployed Render API

BACKEND_URL="${1:-http://localhost:3001}"
EMAIL="test@example.com"
PASSWORD="Test123!"

echo "🧪 Testing Render Deployment"
echo "Backend URL: $BACKEND_URL"
echo ""

# Test 1: Health Check
echo "Test 1: Health Check"
curl -s "$BACKEND_URL/health" | jq . || echo "❌ Failed"
echo ""

# Test 2: Register
echo "Test 2: Register User"
REGISTER_RESPONSE=$(curl -s -X POST "$BACKEND_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")
echo "$REGISTER_RESPONSE" | jq .
echo ""

# Test 3: Login
echo "Test 3: Login"
LOGIN_RESPONSE=$(curl -s -X POST "$BACKEND_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')
echo "Token received: ${TOKEN:0:20}..."
echo ""

# Test 4: Create Project
echo "Test 4: Create Project"
curl -s -X POST "$BACKEND_URL/api/projects" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"test-project","description":"Test"}' | jq .
echo ""

echo "✅ All tests completed!"
