# Building Quark11 Debloat GUI

## Prerequisites

- **Windows 10/11**
- **.NET 6.0 SDK** or later - [Download](https://dotnet.microsoft.com/download)
- **PowerShell 5.0+** (pre-installed)
- **Administrator privileges**

## Quick Build

### Debug Build
```powershell
.\\build\\build.ps1
```

### Release Build
```powershell
.\\build\\build.ps1 -Release
```

### Self-Contained Executable
```powershell
.\\build\\build.ps1 -Release -Publish
```

## Running the Application

1. Right-click `QuarkDebloatGUI.exe`
2. Select "Run as Administrator"
3. Accept UAC prompt

## Features

- ✓ Point-and-click GUI interface
- ✓ Remove OneDrive
- ✓ Remove Microsoft Edge
- ✓ Remove Xbox Game Pass
- ✓ Remove Windows Copilot
- ✓ Aggressive cleanup option
- ✓ MassGrave.dev integration
- ✓ System restore rollback
- ✓ Color-coded logging
- ✓ Real-time progress tracking

## Troubleshooting

### .NET SDK not found
```powershell
# Install .NET 6.0 SDK
# https://dotnet.microsoft.com/download
```

### Build fails
```powershell
# Clean and rebuild
dotnet clean gui/QuarkDebloatGUI.csproj
.\\build\\build.ps1 -Release
```

### GUI won't start
- Ensure running as Administrator
- Check Windows Defender isn't blocking
- Restart computer

## File Structure

```
Quark11/
├── gui/
│   ├── QuarkDebloatGUI.cs
│   ├── Program.cs
│   └── QuarkDebloatGUI.csproj
├── build/
│   └── build.ps1
└── scripts/
    └── debloat-windows11.ps1
```

## Distribution

### Option 1: Standalone EXE
```
gui/bin/Release/net6.0-windows/publish/QuarkDebloatGUI.exe
```

### Option 2: Portable ZIP
- ZIP entire `publish` folder
- Users extract and run

## References

- [.NET Desktop Apps](https://learn.microsoft.com/en-us/dotnet/desktop/)
- [Windows Forms](https://learn.microsoft.com/en-us/dotnet/desktop/winforms/)
- [.NET CLI](https://learn.microsoft.com/en-us/dotnet/core/tools/)
