# OpenMU Docker Build Instructions

This document explains how to build and deploy the OpenMU server using Docker.

## Prerequisites

- Docker installed and running
- Git repository cloned to `/home/asgerh/OpenMU-build/` (or your preferred location)

## Build Process

### 1. Stop Existing Containers (if running)

```bash
cd /home/asgerh/OpenMU-build/deploy/all-in-one
docker compose down
```

This stops and removes:
- `nginx-80` - Reverse proxy
- `openmu-startup` - Main OpenMU application
- `database` - PostgreSQL database

### 2. Build Docker Image

The Dockerfile uses a multi-stage build process:

```bash
cd /home/asgerh/OpenMU-build
docker build -t openmu:latest -f deploy/all-in-one/Dockerfile .
```

**Build stages:**
1. **Base stage:** ASP.NET 9.0 Alpine runtime
2. **Build stage:** .NET SDK 9.0 Alpine
   - Copies project files and build configurations
   - Runs `dotnet restore` to download dependencies
   - Runs `dotnet build` in Release mode
3. **Publish stage:** Creates deployment-ready output
   - Runs `dotnet publish` to package the application
4. **Final stage:** Copies published files to runtime container

**Build time:** ~3 minutes (183 seconds)

**Output:** Docker image tagged as `openmu:latest`

### 3. Start Services

```bash
cd /home/asgerh/OpenMU-build/deploy/all-in-one
docker compose up -d
```

This starts all services in detached mode:
- `database` - PostgreSQL 16 Alpine (port 5432)
- `openmu-startup` - OpenMU application
- `nginx-80` - Nginx reverse proxy (port 80)

### 4. Verify Deployment

**Check running containers:**
```bash
docker ps
```

You should see three containers:
- `nginx-80` - Status: Up
- `openmu-startup` - Status: Up
- `database` - Status: Up (healthy)

**Check logs:**
```bash
docker logs openmu-startup --tail 50
```

You should see:
- Server listeners started
- Connect servers started (ports 44405, 44406)
- Game servers initialized
- AI bot system spawning bots (if enabled)

**Access points:**
- Web UI: http://192.168.4.71/
- Admin Panel: http://192.168.4.71:8080/
- Game Servers: 192.168.4.71 ports 55901-55906
- Connect Servers: 192.168.4.71 ports 44405-44406
- Chat Server: 192.168.4.71 port 55980

## Dockerfile Structure

The Dockerfile is located at `deploy/all-in-one/Dockerfile`:

```dockerfile
# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS base
WORKDIR /app
EXPOSE 8080
# ... (other ports)

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
WORKDIR /src
COPY ["src/Startup/MUnique.OpenMU.Startup.csproj", "src/Startup/"]
COPY ["src/Directory.Build.props", "src/"]
# ... (other build files)
RUN dotnet restore "src/Startup/MUnique.OpenMU.Startup.csproj"
COPY . .
WORKDIR "/src/src/Startup"
RUN dotnet build "MUnique.OpenMU.Startup.csproj" -c Release -o /app/build -p:ci=true

# Publish stage
FROM build AS publish
RUN dotnet publish "MUnique.OpenMU.Startup.csproj" -c Release -o /app/publish -p:ci=true

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN mkdir /app/logs
RUN chmod 777 /app/logs
USER $APP_UID
ENTRYPOINT ["dotnet", "MUnique.OpenMU.Startup.dll", "-autostart"]
```

## Key Configuration Files

### docker-compose.yml
Orchestrates the three services:
- Defines service dependencies (startup depends on database)
- Maps ports to host IP (192.168.4.71)
- Configures volumes for persistent data
- Sets up health checks

### docker-compose.override.yml
Environment-specific overrides:
- Development settings
- Custom port mappings
- Volume mounts for development

## Troubleshooting

### Build Fails

**Issue:** `dotnet restore` fails
**Solution:** Check internet connection, NuGet package sources

**Issue:** Source generator errors
**Solution:** These are expected in Docker build, use the multi-stage Dockerfile which handles them correctly

### Services Won't Start

**Issue:** Port conflicts
**Solution:** Check if ports 80, 5432, 8080, 44405-44406, 55901-55906 are available

**Issue:** Database connection fails
**Solution:** Ensure database container started first (docker compose handles this automatically)

### Application Errors

**Issue:** AI bot spawn errors for certain maps
**Solution:** This is normal for maps without configured spawn areas (e.g., Crywolf Fortress)

**Issue:** Web UI not accessible
**Solution:** 
- Check nginx container is running: `docker ps`
- Check nginx logs: `docker logs nginx-80`
- Verify network configuration in docker-compose.yml

## Updating the Application

When you make code changes:

1. **Rebuild the Docker image:**
   ```bash
   cd /home/asgerh/OpenMU-build
   docker build -t openmu:latest -f deploy/all-in-one/Dockerfile .
   ```

2. **Restart services:**
   ```bash
   cd /home/asgerh/OpenMU-build/deploy/all-in-one
   docker compose down
   docker compose up -d
   ```

3. **Verify update:**
   ```bash
   docker logs openmu-startup --tail 50
   ```

## Database Persistence

The database data is stored in a Docker volume named `all-in-one_db-data`.

**Backup database:**
```bash
docker exec database pg_dump -U openmu openmu > backup.sql
```

**Restore database:**
```bash
cat backup.sql | docker exec -i database psql -U openmu openmu
```

## Performance Tuning

### Resource Limits
Edit `docker-compose.yml` to add resource limits:

```yaml
services:
  openmu-startup:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
```

### Logging
Reduce log verbosity by editing `appsettings.json` in the container or mounting a custom configuration file.

## Recent Changes (December 11, 2025)

- **Dockerfile path fix:** Updated COPY commands to use correct `src/Startup/` paths
- **Build configuration:** Added `Directory.Build.props` and shared files to build context
- **Modern UI:** Deployed AccountEdit.razor with dark gradient theme
- **All commits pushed:** Changes committed to GitHub with proper documentation

## Support

For issues or questions:
- Check container logs: `docker logs <container-name>`
- Review PROJECT_STATUS_FINAL.md for current status
- Check GitHub issues: https://github.com/icheat2win/OpenMU

---

**Last Updated:** December 11, 2025  
**OpenMU Version:** 0.9.8  
**Docker Base Images:** .NET 9.0 Alpine
