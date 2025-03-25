#!/bin/bash

# Database backup script
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/var/backups/postgresql"
DB_NAME="your_database_name"

# Create backup directory if not exists
mkdir -p $BACKUP_DIR

# Perform pg_dump
pg_dump -U postgres -d $DB_NAME -f "$BACKUP_DIR/${DB_NAME}_${DATE}.sql"

# Compress backup
gzip "$BACKUP_DIR/${DB_NAME}_${DATE}.sql"

# Optional: Remove backups older than 7 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete