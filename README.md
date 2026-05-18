# Quark11 - Lightweight Windows 11

 **A highly customizable, lightweight version of Windows 11**

## Overview

Quark11 currently has tools and scripts ONLY. a FULL OS will be coming soon.

## Features

**Features:**
- Remove bloatware and unnecessary apps
-  Disable telemetry and tracking services
-  Optimize system performance
-  Highly customizable debloat script
-  Easy-to-use PowerShell scripts and executables

## What Gets Removed (Default)

### Bloatware Apps
- Bing News & Sports
- Bing Weather
- Xbox Game Pass & Xbox App
- Clipchamp
- Solitaire & Casual Games
- Mahjong
- Microsoft News
- People
- Photos
- Skype
- Spotify
- Disney+

### Services Disabled
- Diagnostic Tracking Service
- DMWAppPush Service
- Cortana
- Activity History
- OneDrive Sync (optional)

## Installation

### Prerequisites
- Windows 11 (any edition)
- Administrator privileges
- PowerShell 5.0 or later

### Quick Start

1. Clone the repository:
```bash
git clone https://github.com/quark11OS/Quark11.git
cd Quark11
```

2. Run PowerShell as Administrator

3. Execute the debloat script:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\scripts\debloat-windows11.ps1
```

## Usage

### Basic Debloat (Default)
```powershell
.\scripts\debloat-windows11.ps1
```

### With Optional Parameters

```powershell
# Remove OneDrive
.\scripts\debloat-windows11.ps1 -RemoveOnedrive

# Remove Microsoft Edge
.\scripts\debloat-windows11.ps1 -RemoveEdge

# Remove Xbox Game Pass
.\scripts\debloat-windows11.ps1 -RemoveGamePass

# Disable Windows Copilot
.\scripts\debloat-windows11.ps1 -RemoveCopilot

# Remove everything (aggressive)
.\scripts\debloat-windows11.ps1 -CleanupAll
```

## Script Parameters

| Parameter | Description |
|-----------|-------------|
| `-RemoveOnedrive` | Uninstalls Microsoft OneDrive |
| `-RemoveEdge` | Removes Microsoft Edge browser |
| `-RemoveGamePass` | Uninstalls Xbox Game Pass |
| `-RemoveCopilot` | Disables Windows Copilot |
| `-CleanupAll` | Performs all optional removals |

## Getting Windows 11

### From MassGrave.dev

For legitimate Windows 11 ISOs and installation tools, visit:
**[https://massgrave.dev](https://massgrave.dev)**

MassGrave.dev provides:
- Official Windows 11 ISO downloads
- Installation media creation tools
- Legitimate activation methods
- Comprehensive documentation

## WARNING:

**Before running this script:**

1. **Backup Your Data** - Create a system backup before running any scripts
2. **Administrator Required** - You must run PowerShell as Administrator
3. **Reversible Changes** - Most changes can be reversed by reinstalling removed apps, but some registry changes may require manual restoration
4. **Compatibility** - Some removed services may be required by certain applications; verify compatibility before proceeding
5. **System Updates** - Windows Update may restore some removed apps during updates
6. **Third-party Software** - Some software may depend on components being removed; test thoroughly before production use

## Troubleshooting

### Script Won't Run
```powershell
# If you get an "execution policy" error, run:
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

### Need Administrator Privileges
- Right-click PowerShell and select "Run as Administrator"
- Then navigate to the script folder and run again

### App Not Removed
- Some apps may require manual removal from Settings > Apps > Installed apps
- Restart Windows after running the script

## Additional Resources

- **MassGrave.dev** - https://massgrave.dev
- **Microsoft Official** - https://www.microsoft.com/windows
- **Windows 11 Documentation** - https://learn.microsoft.com/en-us/windows/

## License

This project is released under the Unlicense - see LICENSE file for details.

## Disclaimer

This software is provided as-is without any warranty. Users are responsible for:
- Creating backups before running scripts
- Understanding the implications of removing system components
- Ensuring compliance with local laws and regulations
- Testing in non-production environments first

## Support

Your help is greatly appreciated! For issues, questions, or suggestions:
- Open an issue
- Check existing documentation
- Review the MassGrave.dev resources

---

**Made with ❤️ for a lighter Windows 11**
