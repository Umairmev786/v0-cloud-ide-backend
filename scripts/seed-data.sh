#!/bin/bash

set -e

echo "🌱 Seeding Database"
echo "=================="

# Get database URL
if [ -z "$DATABASE_URL" ]; then
    source backend/.env
fi

echo "Creating test users..."

# Create test user
psql "$DATABASE_URL" << EOF
INSERT INTO users (email, username, password_hash) 
VALUES (
    'demo@example.com',
    'demo',
    '\$2a\$10\$K7L1OJ5f.a3lVGJ0G9M1uOJ9Z0e.X0Z0Y9Z0Y9Z0Y9Z0Y9Z0Y9Z0Y'
) ON CONFLICT DO NOTHING;
EOF

echo "Creating test project..."

# Get user ID
USER_ID=$(psql "$DATABASE_URL" -t -c "SELECT id FROM users WHERE email = 'demo@example.com';")

psql "$DATABASE_URL" << EOF
INSERT INTO projects (user_id, name, description, runtime)
VALUES (
    $USER_ID,
    'Sample Node Project',
    'A sample Node.js project for testing',
    'node'
) ON CONFLICT DO NOTHING;
EOF

echo "✅ Database seeded successfully"
echo "Demo User:"
echo "  Email: demo@example.com"
echo "  Password: demo123"
