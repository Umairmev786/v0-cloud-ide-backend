#!/bin/bash

set -e

echo "⚠️  WARNING: This will delete all data!"
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled"
    exit 0
fi

# Get database URL
if [ -z "$DATABASE_URL" ]; then
    source backend/.env
fi

echo "Dropping all tables..."

psql "$DATABASE_URL" << EOF
DROP TABLE IF EXISTS webhooks;
DROP TABLE IF EXISTS deploy_logs;
DROP TABLE IF EXISTS agent_actions;
DROP TABLE IF EXISTS terminal_sessions;
DROP TABLE IF EXISTS files;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS users;
EOF

echo "Running migrations..."
cd backend && npm run migrate && cd ..

echo "✅ Database reset complete"
