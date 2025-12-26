#!/bin/bash

BASE_URL=${1:-http://localhost:3001}
EMAIL="test@example.com"
PASSWORD="password123"
USERNAME="testuser"

echo "🧪 Cloud IDE API Test Suite"
echo "============================"
echo "Base URL: $BASE_URL"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

test_endpoint() {
    local method=$1
    local endpoint=$2
    local data=$3
    local expected_status=$4
    
    echo -n "Testing $method $endpoint... "
    
    if [ -n "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" \
            "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $TOKEN" \
            -d "$data")
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" \
            "$BASE_URL$endpoint" \
            -H "Authorization: Bearer $TOKEN")
    fi
    
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" = "$expected_status" ]; then
        echo -e "${GREEN}✓ (Status: $status)${NC}"
        echo "$body"
    else
        echo -e "${RED}✗ (Expected: $expected_status, Got: $status)${NC}"
        echo "$body"
    fi
    echo ""
}

# Test 1: Register
echo "1️⃣  Authentication Tests"
test_endpoint "POST" "/api/auth/register" \
    "{\"email\":\"$EMAIL\",\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}" \
    "201"

# Extract token from response
TOKEN=$(curl -s -X POST "$BASE_URL/api/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

echo "Token obtained: ${TOKEN:0:20}..."
echo ""

# Test 2: Projects
echo "2️⃣  Project Management Tests"
test_endpoint "POST" "/api/projects" \
    "{\"name\":\"Test Project\",\"description\":\"Testing\",\"runtime\":\"node\"}" \
    "201"

test_endpoint "GET" "/api/projects" "" "200"

# Test 3: Files
echo "3️⃣  File Management Tests"
test_endpoint "POST" "/api/files/1/file" \
    "{\"path\":\"test.txt\",\"content\":\"Hello World\",\"is_directory\":false}" \
    "201"

test_endpoint "GET" "/api/files/1" "" "200"

# Test 4: Terminal
echo "4️⃣  Terminal Tests"
test_endpoint "POST" "/api/terminal/1/session" "" "201"

# Test 5: Health
echo "5️⃣  Health Check"
curl -s "$BASE_URL/health" | jq .
echo ""

echo -e "${GREEN}✅ API tests completed${NC}"
