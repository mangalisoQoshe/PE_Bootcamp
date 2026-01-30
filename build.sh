#!/bin/bash

set -e

# --- Configuration ---
COMPOSE_FILE="./app/docker-compose.yml"
DOCKERFILE="./app/Dockerfile"
IMAGE_NAME="pe_bootcamp/backend:1.0.0"

# --- Functions ---

# Standard error logger
err() {
    echo -e "\n[$(date +'%Y-%m-%dT%H:%M:%S%z')] ERROR: $*" >&2
    exit 1
}

# Check if required files exist before trying to use them
check_files() {
    [[ -f "$DOCKERFILE" ]] || err "Dockerfile not found at $DOCKERFILE"
    [[ -f "$COMPOSE_FILE" ]] || err "Docker Compose file not found at $COMPOSE_FILE"
}

check_env() {
    echo "🔎 Checking Environment Variables..."
    local missing_vars=0
    for var in POSTGRES_PWD POSTGRES_USER POSTGRES_DB; do
        if [ -z "${!var}" ]; then
            echo "  ❌ Missing: $var"
            missing_vars=1
        fi
    done

    if [ $missing_vars -ne 0 ]; then
        err "Required environment variables are missing. Please export them and try again."
    fi
    echo "✅ Environment variables verified."
}

build() {
    echo "🔨 Building Docker image: $IMAGE_NAME..."
    docker build -f "$DOCKERFILE" -t "$IMAGE_NAME" ./app || err "Docker build failed!"
}

# --- Execution ---

# 1. Initial Checks
check_files
check_env

# 2. Argument Handling
# We use a case statement here because it's cleaner than nested IFs
case "$1" in
    "up")
        build
        echo "🚀 Starting the containers..."
        # We use "${@:1}" to pass all arguments (like -d) to docker compose
        docker compose -f "$COMPOSE_FILE" up "${@:2}"
        ;;

    "down")
        echo "🗑️ Destroying the containers..."
        # Using -v ensures volumes are cleaned up to avoid "ghost data"
        docker compose -f "$COMPOSE_FILE" down -v
        ;;

    "")
        # Default behavior: build only
        build
        echo "✅ Build complete. Use './build.sh up' to run."
        ;;

    *)
        # Catch-all for typos
        echo "Usage: $0 {up|up -d|down}"
        err "Unexpected expression: '$1'"
        ;;
esac