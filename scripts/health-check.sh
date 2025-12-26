#!/bin/bash

BACKEND_URL=${1:-http://localhost:3001}

echo "🔍 Cloud IDE Health Check"
echo "========================"

# Check backend
echo -n "Backend: "
if curl -s "$BACKEND_URL/health" > /dev/null; then
  echo "✅ Running"
else
  echo "❌ Down"
fi

# Check API endpoints
endpoints=("/api/projects" "/api/terminal" "/api/deploy")
for endpoint in "${endpoints[@]}"; do
  echo -n "API $endpoint: "
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL$endpoint" \
    -H "Authorization: Bearer fake-token")
  
  if [ "$status" = "401" ]; then
    echo "✅ Working (auth protected)"
  elif [ "$status" = "200" ]; then
    echo "✅ Working"
  else
    echo "⚠️  Status: $status"
  fi
done

echo ""
echo "✅ Health check complete"
