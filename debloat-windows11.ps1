# Windows 11 Debloat Script
# Downloads and applies Windows 11 debloat from massgrave.dev
# Run as Administrator

# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

# Set error action preference
$ErrorActionPreference = "Stop"

# Massgrave repository
$MassgraveRepo = "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master"
$DebloatScript = "https://raw.githubusercontent.com/massgravel/Windows-11-Debloat/main/Windows11Debloat.ps1"

Write-Host "Windows 11 Debloat Script Installer" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""

# Create temporary directory for downloads
$TempDir = Join-Path $env:TEMP "Win11Debloat"
if (Test-Path $TempDir) {
    Remove-Item $TempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $TempDir | Out-Null

Write-Host "[1] Downloading debloat script..." -ForegroundColor Cyan

try {
    # Download the debloat script
    $DebloatPath = Join-Path $TempDir "debloat.ps1"
    Invoke-WebRequest -Uri $DebloatScript -OutFile $DebloatPath -UseBasicParsing
    Write-Host "[✓] Downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "[✗] Failed to download: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2] Running debloat script..." -ForegroundColor Cyan
Write-Host ""

try {
    # Execute the debloat script
    & $DebloatPath
    Write-Host ""
    Write-Host "[✓] Debloat complete" -ForegroundColor Green
} catch {
    Write-Host "[✗] Error during debloat: $_" -ForegroundColor Red
    exit 1
}

# Cleanup
Write-Host ""
Write-Host "[3] Cleaning up..." -ForegroundColor Cyan
Remove-Item $TempDir -Recurse -Force
Write-Host "[✓] Cleanup complete" -ForegroundColor Green

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "Debloat process completed!" -ForegroundColor Green
Write-Host "You may need to restart your computer for all changes to take effect." -ForegroundColor Yellow
Write-Host ""
