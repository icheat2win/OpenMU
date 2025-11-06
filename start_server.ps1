# OpenMU Server Startup Script

Write-Host "`n================================" -ForegroundColor Green
Write-Host "Starting OpenMU Server..." -ForegroundColor Green
Write-Host "================================`n" -ForegroundColor Green

$serverPath = "c:\Users\asger\Documents\GitHub\OpenMU\src\Startup\bin\Release"

# Check if ConnectionSettings.xml exists
if (-not (Test-Path "$serverPath\ConnectionSettings.xml")) {
    Write-Host "ERROR: ConnectionSettings.xml not found!" -ForegroundColor Red
    Write-Host "Location: $serverPath\ConnectionSettings.xml" -ForegroundColor Yellow
    exit 1
}

# Check if PostgreSQL is running
$pgService = Get-Service -Name "postgresql-x64-17" -ErrorAction SilentlyContinue
if ($pgService.Status -ne "Running") {
    Write-Host "ERROR: PostgreSQL service is not running!" -ForegroundColor Red
    Write-Host "Please start the service first." -ForegroundColor Yellow
    exit 1
}

Write-Host "PostgreSQL Status: " -NoNewline -ForegroundColor Yellow
Write-Host "Running" -ForegroundColor Green
Write-Host "ConnectionSettings: " -NoNewline -ForegroundColor Yellow
Write-Host "Found" -ForegroundColor Green
Write-Host ""

Set-Location $serverPath

Write-Host "Starting OpenMU Server..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server`n" -ForegroundColor Yellow

.\MUnique.OpenMU.Startup.exe
