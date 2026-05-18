# Quark11 Debloat GUI Build Script
# Builds the C# GUI application into a standalone .exe

param(
    [switch]$Release,
    [switch]$Publish
)

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Quark11 Debloat GUI Build Tool" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Check if .NET SDK is installed
Write-Host "[1/4] Checking .NET SDK..." -ForegroundColor Yellow
try {
    $dotnetVersion = dotnet --version
    Write-Host "✓ .NET SDK found: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ .NET SDK not found!" -ForegroundColor Red
    Write-Host "Please install .NET 6.0 SDK from https://dotnet.microsoft.com/download" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Build configuration
$buildConfig = if ($Release) { "Release" } else { "Debug" }
Write-Host "[2/4] Building ($buildConfig)..." -ForegroundColor Yellow

cd "$PSScriptRoot\.."

try {
    dotnet build gui/QuarkDebloatGUI.csproj -c $buildConfig
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Build successful" -ForegroundColor Green
    } else {
        Write-Host "✗ Build failed" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Build error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Publish (create self-contained exe)
if ($Publish -or $Release) {
    Write-Host "[3/4] Publishing self-contained executable..." -ForegroundColor Yellow
    
    try {
        dotnet publish gui/QuarkDebloatGUI.csproj -c Release -r win-x64 --self-contained -p:PublishSingleFile=true
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Publish successful" -ForegroundColor Green
        } else {
            Write-Host "✗ Publish failed" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "✗ Publish error: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[3/4] Skipping publish (use -Publish to create standalone exe)" -ForegroundColor Gray
}

Write-Host ""

# Output summary
Write-Host "[4/4] Build Summary" -ForegroundColor Yellow
$buildOutput = "gui/bin/$buildConfig/net6.0-windows"
$publishOutput = "gui/bin/Release/net6.0-windows/publish"

if (Test-Path "$buildOutput/QuarkDebloatGUI.exe") {
    Write-Host "✓ Debug EXE: $buildOutput/QuarkDebloatGUI.exe" -ForegroundColor Green
}

if (Test-Path "$publishOutput/QuarkDebloatGUI.exe") {
    Write-Host "✓ Release EXE: $publishOutput/QuarkDebloatGUI.exe" -ForegroundColor Green
}

Write-Host ""
Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run: Right-click .exe and select 'Run as Administrator'" -ForegroundColor Yellow
Write-Host ""
