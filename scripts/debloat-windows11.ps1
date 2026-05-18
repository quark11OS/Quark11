# Quark11 Windows 11 Debloat Script
# Downloads and debloats Windows 11 from MassGrave.dev sources
# Requires: Administrator privileges
# Usage: .\debloat-windows11.ps1 [-RemoveOnedrive] [-RemoveEdge] [-RemoveGamePass] [-RemoveCopilot] [-CleanupAll]

param(
    [switch]$RemoveOnedrive,
    [switch]$RemoveEdge,
    [switch]$RemoveGamePass,
    [switch]$RemoveCopilot,
    [switch]$CleanupAll
)

# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Quark11 Windows 11 Debloat Tool" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Function to remove app package
function Remove-AppPackage {
    param(
        [string]$AppName,
        [string]$DisplayName
    )
    
    try {
        Write-Host "Removing $DisplayName..." -ForegroundColor Yellow
        Get-AppxPackage -Name "*$AppName*" | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object DisplayName -like "*$AppName*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-Host "✓ $DisplayName removed" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠ Failed to remove $DisplayName: $_" -ForegroundColor Yellow
    }
}

# Function to disable service
function Disable-WindowsService {
    param(
        [string]$ServiceName,
        [string]$DisplayName
    )
    
    try {
        Write-Host "Disabling $DisplayName..." -ForegroundColor Yellow
        Stop-Service -Name $ServiceName -ErrorAction SilentlyContinue -Force
        Set-Service -Name $ServiceName -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "✓ $DisplayName disabled" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠ Failed to disable $DisplayName: $_" -ForegroundColor Yellow
    }
}

# Default bloatware removal
Write-Host "[1/5] Removing default bloatware..." -ForegroundColor Cyan
Remove-AppPackage "BingNews" "Bing News"
Remove-AppPackage "BingSports" "Bing Sports"
Remove-AppPackage "BingWeather" "Bing Weather"
Remove-AppPackage "GamingApp" "Xbox Game Pass"
Remove-AppPackage "XboxApp" "Xbox App"
Remove-AppPackage "Clipchamp" "Clipchamp"
Remove-AppPackage "MicrosoftSolitaire" "Solitaire & Casual Games"
Remove-AppPackage "MicrosoftMahjong" "Mahjong"
Remove-AppPackage "MicrosoftNews" "Microsoft News"
Remove-AppPackage "People" "People"
Remove-AppPackage "Photos" "Photos"
Remove-AppPackage "SkypeApp" "Skype"
Remove-AppPackage "Spotify" "Spotify"
Remove-AppPackage "Disney+" "Disney+"

Write-Host ""

# Disable telemetry services
Write-Host "[2/5] Disabling telemetry services..." -ForegroundColor Cyan
Disable-WindowsService "DiagTrack" "Diagnostic Tracking Service"
Disable-WindowsService "dmwappushservice" "dmwappushservice"
Disable-WindowsService "OneSync" "OneDrive Sync"

# Disable Cortana
Write-Host "[3/5] Disabling Cortana and search telemetry..." -ForegroundColor Cyan
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "AllowCortana" -Value 0 -ErrorAction SilentlyContinue
Write-Host "✓ Cortana disabled" -ForegroundColor Green

# Disable activity history
Write-Host "[4/5] Disabling activity history..." -ForegroundColor Cyan
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "PublishUserActivities" -Value 0 -ErrorAction SilentlyContinue
Write-Host "✓ Activity history disabled" -ForegroundColor Green

# Cleanup temporary files
Write-Host "[5/5] Cleaning up temporary files..." -ForegroundColor Cyan
try {
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✓ Temporary files cleaned" -ForegroundColor Green
}
catch {
    Write-Host "⚠ Some temporary files could not be deleted: $_" -ForegroundColor Yellow
}

Write-Host ""

# Optional: Remove OneDrive
if ($RemoveOnedrive -or $CleanupAll) {
    Write-Host "Removing OneDrive..." -ForegroundColor Cyan
    taskkill /f /im OneDrive.exe -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    & "$env:SystemRoot\System32\OneDriveSetup.exe" /uninstall -ErrorAction SilentlyContinue
    Write-Host "✓ OneDrive removed" -ForegroundColor Green
    Write-Host ""
}

# Optional: Remove Edge
if ($RemoveEdge -or $CleanupAll) {
    Write-Host "Removing Microsoft Edge..." -ForegroundColor Cyan
    Remove-AppPackage "MicrosoftEdge" "Microsoft Edge"
    Write-Host ""
}

# Optional: Remove Game Pass
if ($RemoveGamePass -or $CleanupAll) {
    Write-Host "Removing Xbox Game Pass..." -ForegroundColor Cyan
    Remove-AppPackage "GamePass" "Xbox Game Pass"
    Write-Host ""
}

# Optional: Remove Copilot
if ($RemoveCopilot -or $CleanupAll) {
    Write-Host "Removing Windows Copilot..." -ForegroundColor Cyan
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
    if (!(Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "TurnOffWindowsCopilot" -Value 1 -ErrorAction SilentlyContinue
    Write-Host "✓ Windows Copilot disabled" -ForegroundColor Green
    Write-Host ""
}

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Debloat Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Recommended next steps:" -ForegroundColor Yellow
Write-Host "1. Run 'Disk Cleanup' to remove more temporary files" -ForegroundColor White
Write-Host "2. Run 'Defrag' to optimize disk performance" -ForegroundColor White
Write-Host "3. Restart your computer for all changes to take effect" -ForegroundColor White
Write-Host ""
Write-Host "For Windows 11 installation from MassGrave.dev:" -ForegroundColor Cyan
Write-Host "Visit: https://massgrave.dev" -ForegroundColor White
Write-Host ""
