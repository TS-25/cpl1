# 🚀 cPanel Lifetime License - GitHub Repository

[![License](https://img.shields.io/badge/License-Educational-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0-green.svg)](CHANGELOG.md)
[![cPanel](https://img.shields.io/badge/cPanel-All%20Versions-orange.svg)](https://cpanel.net)
[![OS](https://img.shields.io/badge/OS-CentOS%20%7C%20RHEL%20%7C%20Ubuntu-lightgrey.svg)](README.md)

This repository provides a cPanel lifetime license installer based on the original script structure, modified to remove online verification and create a permanent license.

## 📋 Quick Start

### One-Line Installation:
```bash
curl -sSL https://raw.githubusercontent.com/TS-25/cpl1/main/install.sh | bash
```

### Manual Installation:
```bash
wget https://github.com/TS-25/cpl1/archive/main.zip
unzip main.zip
cd cpl1-main
chmod +x install.sh
./install.sh
```

## 🔍 How It Works

### Original Script vs. Lifetime Version:
- **Original**: Performs online verification with the official license server.
- **Lifetime**: Uses hardcoded license data, requiring no online verification.
- **Compatibility**: Maintains the original script's structure for compatibility.

### Key Components:
- ✅ **PHP-based Script**: Fully compatible with the original cPanel scripts.
- ✅ **Firewall Protection**: Blocks connections to official cPanel license servers.
- ✅ **File Protection**: Uses `chattr +i` and mount binding to prevent tampering.
- ✅ **Auto-Maintenance**: A cron job automates license maintenance tasks.
- ✅ **BLBIN Structure**: Follows the original cPanel directory structure.

## 🚀 Features

- 🔥 **Lifetime License**: Never expires.
- 🔥 **Unlimited Accounts**: No restrictions on the number of accounts.
- 🔥 **No Verification**: Does not require an online connection for license checks.
- 🔥 **All Features Unlocked**: Unlocks all cPanel & WHM features.
- 🔥 **Auto-Maintenance**: The license is automatically maintained.
- 🔥 **Easy Installation**: Simple, one-command installation.
- 🔥 **Clean Uninstall**: Removes all script components cleanly.

## 📦 Installation Methods

### Method 1: Quick Install (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/TS-25/cpl1/main/install.sh | bash
```

### Method 2: Git Clone
```bash
git clone https://github.com/TS-25/cpl1.git
cd cpl1
./install.sh
```

## 📁 Repository Structure

```
cpanel-lifetime/
├── 📄 README.md                    # This file
├── 📄 LICENSE                      # License file
├── 📄 CHANGELOG.md                 # Version history
├── 🚀 install.sh                   # Main installer
├── 📁 scripts/                     # Installation scripts
│   ├── installer.sh                # Original-based installer
│   └── uninstall.sh                # Uninstaller
├── 📁 src/                         # Source files
│   └── LicenseCP.php               # Main license script
├── 📁 tools/                       # Utility tools
│   └── test.sh                     # Installation test
├── 📁 docs/                        # Documentation
└── 📁 .github/                     # GitHub workflows
```

## 🛠️ Usage

### Check License Status:
```bash
LicenseCP
LicenseCP --status
```

### Maintenance:
```bash
LicenseCP --maintain
LicenseCP --update
LicenseCP --ssl
```

### Uninstall:
```bash
LicenseCP --uninstall
# or
curl -sSL https://raw.githubusercontent.com/TS-25/cpl1/main/scripts/uninstall.sh | bash
```

## 🔧 Configuration

### Environment Variables:
```bash
export CPANEL_LIFETIME_DOMAIN="your-domain.com"
export CPANEL_LIFETIME_BRAND="Your Brand"
export CPANEL_LIFETIME_DEBUG="false"
```

### Config File: `/usr/local/cpanel-lifetime/config.json`
```json
{
  "license_type": "lifetime",
  "expiry_date": "never",
  "max_accounts": "unlimited",
  "auto_maintenance": true,
  "firewall_protection": true
}
```

## 🤝 Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request.

## 📄 License

This project is licensed under the Educational License. See the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This software is provided for educational and testing purposes only. Use at your own risk. Ensure you have the proper licensing rights before using this in a production environment.

## 🙏 Acknowledgments

- The original cPanel License System
- The BeGPL Community
- Open Source Contributors

---

**Made with ❤️ for the community**
