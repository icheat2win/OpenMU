# Build custom OpenMU Docker image with fixes
Write-Host "Building OpenMU Docker image..." -ForegroundColor Cyan

# Change to src directory
Set-Location "$PSScriptRoot\src"

# Build the Docker image
docker build -t openmu-custom:latest -f Startup/Dockerfile .

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nDocker image built successfully!" -ForegroundColor Green
    Write-Host "Image name: openmu-custom:latest" -ForegroundColor Yellow
} else {
    Write-Host "`nDocker build failed!" -ForegroundColor Red
    exit 1
}

Set-Location $PSScriptRoot
