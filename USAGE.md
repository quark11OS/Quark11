# Quark11 Debloat Tool - Complete Usage Guide

## Getting Started

### System Requirements

- **OS**: Windows 11 (any edition)
- **Privileges**: Administrator
- **Storage**: 2-5 GB free
- **RAM**: 2 GB minimum
- **Internet**: For Windows 11 ISO download

## GUI Application

### Installation

1. Download `QuarkDebloatGUI.exe`
2. Right-click → "Run as Administrator"
3. Accept UAC prompt

### Basic Usage

1. Select debloat options (checkboxes)
2. Click **"▶ Start Debloat"**
3. Monitor progress in console
4. Restart computer when complete

### Options

| Option | Effect |
|--------|--------|
| Remove OneDrive | Uninstalls cloud storage |
| Remove Edge | Removes browser |
| Remove GamePass | Uninstalls Game Pass |
| Remove Copilot | Disables AI assistant |
| Aggressive Cleanup | All of above |

## PowerShell Script

### Basic Usage

```powershell
cd scripts
.\\debloat-windows11.ps1
```

### With Options

```powershell
# Remove specific apps
.\\debloat-windows11.ps1 -RemoveOnedrive -RemoveEdge

# Aggressive cleanup
.\\debloat-windows11.ps1 -CleanupAll
```

## What Gets Removed

**Default:**
- Bing News, Weather, Sports
- Xbox apps and Game Pass
- Clipchamp
- Solitaire & Games
- Telemetry services
- Cortana
- Activity History

**Optional:**
- OneDrive
- Microsoft Edge
- Windows Copilot

## Important Notes

⚠️ **Before Running:**
1. Create backup
2. Enable System Restore Point
3. Close running applications
4. Don't interrupt process

## Getting Windows 11

Visit **[https://massgrave.dev](https://massgrave.dev)** for legitimate ISOs

Or click "⬇ Download Win11" button in GUI

## Troubleshooting

### Won't Run
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\\debloat-windows11.ps1
```

### Need to Rollback
```
Settings → System → Recovery → System Restore
```

### Individual App Removal
```
Settings → Apps → Installed apps → App → Uninstall
```

## FAQ

**Q: Is this safe?**  
A: Yes, with backup and restore point enabled

**Q: Can I undo changes?**  
A: Yes, via System Restore

**Q: Will updates reinstall apps?**  
A: Some may, rerun script after major updates

**Q: How much disk space saved?**  
A: 500MB - 2GB depending on options

---

For more info, see README.md or visit GitHub
