# PostgreSQL Password Reset Script
# Run this script AS ADMINISTRATOR

Write-Host "PostgreSQL Password Reset Script" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

$pgDataDir = "C:\Program Files\PostgreSQL\17\data"
$pgBinDir = "C:\Program Files\PostgreSQL\17\bin"
$pgHbaFile = "$pgDataDir\pg_hba.conf"
$pgHbaBackup = "$pgDataDir\pg_hba.conf.backup"

# Step 1: Backup pg_hba.conf
Write-Host "Step 1: Backing up pg_hba.conf..." -ForegroundColor Yellow
Copy-Item $pgHbaFile $pgHbaBackup -Force
Write-Host "Backup created: $pgHbaBackup" -ForegroundColor Green
Write-Host ""

# Step 2: Modify pg_hba.conf to allow trust authentication
Write-Host "Step 2: Modifying pg_hba.conf to allow passwordless local connections..." -ForegroundColor Yellow
$content = Get-Content $pgHbaFile
$content = $content -replace '^host\s+all\s+all\s+127\.0\.0\.1/32\s+scram-sha-256', 'host    all             all             127.0.0.1/32            trust'
$content | Set-Content $pgHbaFile
Write-Host "pg_hba.conf modified" -ForegroundColor Green
Write-Host ""

# Step 3: Restart PostgreSQL service
Write-Host "Step 3: Restarting PostgreSQL service..." -ForegroundColor Yellow
Restart-Service -Name "postgresql-x64-17" -Force
Start-Sleep -Seconds 3
Write-Host "PostgreSQL service restarted" -ForegroundColor Green
Write-Host ""

# Step 4: Reset password
Write-Host "Step 4: Resetting postgres password to 'admin'..." -ForegroundColor Yellow
& "$pgBinDir\psql.exe" -U postgres -c "ALTER USER postgres PASSWORD 'admin';"
if ($LASTEXITCODE -eq 0) {
    Write-Host "Password successfully changed to 'admin'" -ForegroundColor Green
} else {
    Write-Host "Failed to change password" -ForegroundColor Red
}
Write-Host ""

# Step 5: Restore pg_hba.conf
Write-Host "Step 5: Restoring pg_hba.conf..." -ForegroundColor Yellow
Copy-Item $pgHbaBackup $pgHbaFile -Force
Write-Host "pg_hba.conf restored" -ForegroundColor Green
Write-Host ""

# Step 6: Restart PostgreSQL again
Write-Host "Step 6: Restarting PostgreSQL service with restored settings..." -ForegroundColor Yellow
Restart-Service -Name "postgresql-x64-17" -Force
Start-Sleep -Seconds 3
Write-Host "PostgreSQL service restarted" -ForegroundColor Green
Write-Host ""

Write-Host "====================================" -ForegroundColor Green
Write-Host "Password reset complete!" -ForegroundColor Green
Write-Host "Username: postgres" -ForegroundColor Cyan
Write-Host "Password: admin" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "You can now run the OpenMU server:" -ForegroundColor Yellow
Write-Host "cd c:\Users\asger\Documents\GitHub\OpenMU\src\Startup\bin\Release" -ForegroundColor White
Write-Host ".\MUnique.OpenMU.Startup.exe" -ForegroundColor White
Write-Host ""
