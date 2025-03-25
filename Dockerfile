# Use an official PostgreSQL base image with a specific version
ARG POSTGRES_VERSION=13
FROM postgres:${POSTGRES_VERSION}

# Install build arguments with default values
ARG DB_NAME=migrationdb
ARG DB_USER=dbadmin
ARG DB_PASSWORD=securepassword
ARG MIGRATION_STRATEGY=rolling

# Environment variables can override build arguments
ENV POSTGRES_DB=${DB_NAME}
ENV POSTGRES_USER=${DB_USER}
ENV POSTGRES_PASSWORD=${DB_PASSWORD}
ENV MIGRATION_STRATEGY=${MIGRATION_STRATEGY}

# Install additional tools
RUN apt-get update && apt-get install -y \
    liquibase \
    postgresql-client \
    curl \
    wget \
    python3 \
    python3-pip \
    golang-go

# Create a script to load .env variables
COPY scripts/load-env.sh /docker-entrypoint-initdb.d/load-env.sh
RUN chmod +x /docker-entrypoint-initdb.d/load-env.sh

# Copy migration scripts and configuration
COPY ./src/migrations /liquibase/changelog
COPY ./src/scripts /scripts
COPY .env.example /.env

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Set working directory
WORKDIR /liquibase

# Expose PostgreSQL default port
EXPOSE 5432

# Entry point is inherited from the base PostgreSQL image