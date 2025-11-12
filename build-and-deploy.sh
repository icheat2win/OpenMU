#!/bin/bash

# Build and deploy OpenMU using Docker
set -e

echo "=========================================="
echo "OpenMU Build and Deploy Script"
echo "=========================================="

# Change to repository root
cd "$(dirname "$0")"
REPO_ROOT=$(pwd)

echo ""
echo "Step 1: Building OpenMU solution with Docker..."
echo "------------------------------------------------"

# Use Docker to build the solution
docker run --rm \
  -v "$REPO_ROOT/src:/src" \
  -v "$REPO_ROOT/deploy/all-in-one/app:/app" \
  -w /src \
  mcr.microsoft.com/dotnet/sdk:9.0-alpine \
  sh -c "dotnet restore MUnique.OpenMU.sln && \
         dotnet build MUnique.OpenMU.sln -c Release && \
         dotnet publish Startup/MUnique.OpenMU.Startup.csproj -c Release -o /app --no-build"

echo ""
echo "Step 2: Setting permissions on app directory..."
echo "------------------------------------------------"
sudo chmod -R 755 "$REPO_ROOT/deploy/all-in-one/app"

echo ""
echo "Step 3: Building Docker images..."
echo "------------------------------------------------"
cd "$REPO_ROOT/deploy/all-in-one"
docker compose build --no-cache

echo ""
echo "Step 4: Starting Docker services..."
echo "------------------------------------------------"
docker compose up -d

echo ""
echo "Step 5: Waiting for services to start..."
echo "------------------------------------------------"
sleep 10

echo ""
echo "Step 6: Checking service status..."
echo "------------------------------------------------"
docker compose ps

echo ""
echo "=========================================="
echo "Build and deployment complete!"
echo "=========================================="
echo ""
echo "Services available at:"
echo "  - Admin Panel: http://192.168.4.71/"
echo "  - Admin Panel (port): http://192.168.4.71:8080/"
echo "  - Game Servers: 192.168.4.71:55901-55906"
echo "  - Connect Server: 192.168.4.71:44405"
echo "  - Database: 192.168.4.71:5432"
echo ""
echo "View logs with: docker compose logs -f"
echo "=========================================="
