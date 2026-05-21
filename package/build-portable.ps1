# Portable Package Build Script
# Creates a standalone ZIP package of Quark11 that requires no installation

param(
    [string]$OutputDir = ".\dist",
    [string]$BuildConfig = "Release"
)

$ErrorActionPreference = "Stop"

Write-Host "=== Building Portable Package ===" -ForegroundColor Cyan

# Paths
$GuiProjectPath = ".\gui\QuarkDebloatGUI.csproj"
$ScriptsDir = ".\scripts"
$DocsDir = "."
$PortableBuildDir = ".\gui\bin\$BuildConfig\net6.0-windows\publish"

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Build GUI application
Write-Host "Building GUI application..." -ForegroundColor Yellow
dotnet publish $GuiProjectPath -c $BuildConfig -f net6.0-windows --self-contained -r win-x64

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

# Create portable package directory
$PortableDir = Join-Path $OutputDir "Quark11-portable"
if (Test-Path $PortableDir) {
    Remove-Item $PortableDir -Recurse -Force
}
New-Item -ItemType Directory -Path $PortableDir | Out-Null

# Copy GUI binaries
Write-Host "Copying GUI binaries..." -ForegroundColor Yellow
Copy-Item -Path "$PortableBuildDir\*" -Destination $PortableDir -Recurse -Force

# Create subdirectories for organization
$ScriptPortableDir = Join-Path $PortableDir "scripts"
$DocsPortableDir = Join-Path $PortableDir "docs"
New-Item -ItemType Directory -Path $ScriptPortableDir -Force | Out-Null
New-Item -ItemType Directory -Path $DocsPortableDir -Force | Out-Null

# Copy scripts
Write-Host "Copying scripts..." -ForegroundColor Yellow
Copy-Item -Path "$ScriptsDir\*.ps1" -Destination $ScriptPortableDir -Force

# Copy documentation
Write-Host "Copying documentation..." -ForegroundColor Yellow
Copy-Item -Path "$DocsDir\README.md" -Destination $DocsPortableDir -Force
Copy-Item -Path "$DocsDir\USAGE.md" -Destination $DocsPortableDir -Force
Copy-Item -Path "$DocsDir\BUILD.md" -Destination $DocsPortableDir -Force
Copy-Item -Path "$DocsDir\CHANGELOG.md" -Destination $DocsPortableDir -Force
Copy-Item -Path "$DocsDir\LICENSE" -Destination $DocsPortableDir -Force

# Create README in portable package root
$ReadmeContent = @"
# Quark11 Windows 11 Debloat Tool - Portable Version

## Quick Start

1. **Run GUI (Recommended)**
   - Double-click `QuarkDebloatGUI.exe`
   - Must run as Administrator

2. **Run PowerShell Script**
   - Open PowerShell as Administrator
   - Navigate to the scripts folder
   - Run: `.\debloat-windows11.ps1`

3. **View Documentation**
   - See the `docs` folder for detailed guides

## Requirements

- Windows 11 (Build 22000 or higher)
- Administrator privileges
- .NET 6.0 Runtime (included in self-contained build)

## Features

✓ Remove 14+ bloatware applications
✓ Disable telemetry and tracking services
✓ Optional removal of OneDrive, Edge, GamePass, Copilot
✓ System restore point support
✓ Real-time progress tracking

## Support & Resources

- GitHub: https://github.com/quark11OS/Quark11
- Issues: https://github.com/quark11OS/Quark11/issues
- Wiki: https://github.com/quark11OS/Quark11/wiki
- Download Windows 11: https://massgrave.dev

## License

The Unlicense - See LICENSE file for details
"@

Set-Content -Path (Join-Path $PortableDir "README.txt") -Value $ReadmeContent -Encoding UTF8

# Create ZIP archive
$ZipPath = Join-Path $OutputDir "Quark11-1.0.0-x64-portable.zip"
Write-Host "Creating ZIP archive..." -ForegroundColor Yellow
Compress-Archive -Path $PortableDir -DestinationPath $ZipPath -Force

# Calculate SHA256
$FileHash = Get-FileHash -Path $ZipPath -Algorithm SHA256
Write-Host "SHA256: $($FileHash.Hash)" -ForegroundColor Green

# Cleanup
Remove-Item $PortableDir -Recurse -Force

Write-Host ""
Write-Host "✓ Portable package created successfully!" -ForegroundColor Green
Write-Host "  Location: $ZipPath"
Write-Host "  Size: $([math]::Round((Get-Item $ZipPath).Length / 1MB, 2)) MB"
Write-Host "  SHA256: $($FileHash.Hash)"
