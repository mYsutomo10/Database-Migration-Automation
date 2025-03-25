#!/bin/bash
set -e

# Function to load environment variables from .env file
load_env_file() {
    local env_file=$1
    
    # Check if file exists
    if [ ! -f "$env_file" ]; then
        echo "ENV file not found: $env_file"
        return 1

    # Read .env file line by line
    while IFS='=' read -r key value
    do
        # Skip comments and empty lines
        [[ $key = \#* ]] && continue
        [[ -z "$key" ]] && continue

        # Trim whitespace
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        # Remove quotes from value if present
        value="${value%\"}"
        value="${value#\"}"

        # Export variable if not already set
        if [ -z "${!key}" ]; then
            export "$key"="$value"
            echo "Loaded: $key"
        fi
    done < "$env_file"
}

# Load .env file
load_env_file /.env

# Optional: Additional setup based on environment variables
if [ "$MIGRATION_STRATEGY" = "rolling" ]; then
    echo "Preparing for rolling migration strategy"
    # Add any specific configuration for rolling migration
fi

# Execute the main container entrypoint
exec "$@"