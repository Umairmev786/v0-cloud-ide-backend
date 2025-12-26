#!/bin/bash

set -e

echo "💾 Database Backup"
echo "=================="

BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/cloud_ide_$TIMESTAMP.sql"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Get database URL
if [ -z "$DATABASE_URL" ]; then
    source backend/.env
fi

echo "Backing up database..."
pg_dump "$DATABASE_URL" > "$BACKUP_FILE"

echo "✅ Backup created: $BACKUP_FILE"
echo "File size: $(du -h "$BACKUP_FILE" | cut -f1)"

# Keep only last 7 backups
echo "Cleaning old backups..."
ls -t "$BACKUP_DIR"/cloud_ide_*.sql | tail -n +8 | xargs -r rm

echo "✅ Backup complete"
