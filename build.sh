#!/bin/bash

set -e

# --- Configuration ---
COMPOSE_FILE="./app/docker-compose.yml"
DOCKERFILE="./app/Dockerfile"
IMAGE_NAME="students_api"
VERSION="1.0.0"
REPOSITORY_NAME="mangaliso98"
BLUE='\033[34m'
RED='\033[31m'
RESET='\033[0m'
# --- Functions ---

# Standard logger
info() {
    echo -e "\n${BLUE}[$(date +'%H:%M:%S')]  INFO: $*${RESET}"
}

warn() {
    echo -e "\n${RED}[$(date +'%H:%M:%S')]  WARN: $*${RESET}" >&2
}

err() {
    echo -e "\n${RED}[$(date +'%H:%M:%S')]  ERROR: $*${RESET}" >&2
    exit 1
}

# Check if required files exist before trying to use them
check_files() {
    [[ -f "$DOCKERFILE" ]] || err "Dockerfile not found at $DOCKERFILE"
    [[ -f "$COMPOSE_FILE" ]] || err "Docker Compose file not found at $COMPOSE_FILE"
}

# Check if required binaries are insalled
check_binaries() {
    if command -v docker &> /dev/null; then 
        info "Docker is installed."
    else 
        err "Docker is not installed. You may use the convienence script to install it. https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script"
    fi
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
    echo "🔨 Building Docker image: "$REPOSITORY_NAME/$IMAGE_NAME:$VERSION"..."
    docker build -f "$DOCKERFILE" -t "$REPOSITORY_NAME/$IMAGE_NAME:$VERSION" ./app || err "Docker build failed!"
}

push_dockerhub() {
    echo "🔨 Preparing to push "$REPOSITORY_NAME/$IMAGE_NAME:$VERSION" to Dockerhub registry."
    docker push "$REPOSITORY_NAME/$IMAGE_NAME:$VERSION"
}

# --- Execution ---

# 1. Initial Checks
check_binaries
check_files


# 2. Argument Handling
# We use a case statement here because it's cleaner than nested IFs
case "$1" in
    "up")
        build
        echo "🚀 Starting the containers..."
        # We use "${@:1}" to pass all arguments (like -d) to docker compose
        check_env
        docker compose -f "$COMPOSE_FILE" up "${@:2}"
        ;;

    "down")
        echo "🗑️ Destroying the containers..."
        # Using -v ensures volumes are cleaned up to avoid "ghost data"
        docker compose -f "$COMPOSE_FILE" down -v
        ;;
    "push")
        push_dockerhub
        ;;

    "")
        # Default behavior: build only
        build
        echo "✅ Build complete. Use './build.sh up' to run."
        ;;

    *)
        # Catch-all for typos
        echo "Usage: $0 {up|up -d |down}"
        err "Unexpected expression: '$1'"
        ;;
esac