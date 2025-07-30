# 🚀 cPanel Lifetime License - GitHub Repository

[![License](https://img.shields.io/badge/License-Educational-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0-green.svg)](CHANGELOG.md)
[![cPanel](https://img.shields.io/badge/cPanel-All%20Versions-orange.svg)](https://cpanel.net)
[![OS](https://img.shields.io/badge/OS-CentOS%20%7C%20RHEL%20%7C%20Ubuntu-lightgrey.svg)](README.md)

Installer lisensi cPanel lifetime berdasarkan struktur script original dengan modifikasi untuk menghapus verifikasi online dan membuat lisensi permanent.

## 📋 **Quick Start**

### One-Line Installation:
```bash
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash
```

### Manual Installation:
```bash
wget https://github.com/nu-dev2024/my-vpn/archive/main.zip
unzip main.zip
cd my-vpn-main
chmod +x install.sh
./install.sh
```

## 🔍 **Cara Kerja**

### **Script Original vs Lifetime:**
- **Original**: Verifikasi online ke server lisensi
- **Lifetime**: Data lisensi hardcoded, no verification
- **Compatibility**: Mempertahankan struktur original

### **Komponen Utama:**
- ✅ **PHP-based Script** - Kompatibel dengan original
- ✅ **Firewall Protection** - Blokir server cPanel resmi
- ✅ **File Protection** - chattr +i dan mount binding
- ✅ **Auto Maintenance** - Cron job otomatis
- ✅ **BLBIN Structure** - Directory structure original

## 🚀 **Fitur**

- 🔥 **Lifetime License** - Tidak pernah expired
- 🔥 **Unlimited Accounts** - Tanpa batas akun
- 🔥 **No Verification** - Tidak perlu koneksi online
- 🔥 **All Features** - Semua fitur cPanel terbuka
- 🔥 **Auto Maintenance** - Pemeliharaan otomatis
- 🔥 **Easy Install** - Instalasi satu perintah
- 🔥 **Clean Uninstall** - Penghapusan bersih

## 📦 **Installation Methods**

### Method 1: Quick Install (Recommended)
```bash
curl -sSL https://cpanel-lifetime.github.io/install | bash
```

### Method 2: GitHub Raw
```bash
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/scripts/installer.sh | bash
```

### Method 3: Download & Run
```bash
wget https://github.com/nu-dev2024/my-vpn/releases/latest/download/cpanel-lifetime.tar.gz
tar -xzf cpanel-lifetime.tar.gz
cd my-vpn
./install.sh
```

### Method 4: Git Clone
```bash
git clone https://github.com/nu-dev2024/my-vpn.git
cd my-vpn
./install.sh
```

## 📁 **Repository Structure**

```
cpanel-lifetime/
├── 📄 README.md                    # This file
├── 📄 LICENSE                      # License file
├── 📄 CHANGELOG.md                 # Version history
├── 🚀 install.sh                   # Main installer
├── 📁 scripts/                     # Installation scripts
│   ├── installer.sh                # Original-based installer
│   ├── deploy.sh                   # Manual deployment
│   ├── setup.php                   # PHP setup script
│   └── uninstall.sh                # Uninstaller
├── 📁 src/                         # Source files
│   ├── LicenseCP.php               # Main license script
│   ├── LicenseCP_v2.php            # V2 license script
│   └── config.json                 # Configuration
├── 📁 tools/                       # Utility tools
│   ├── test.sh                     # Installation test
│   ├── cleanup.sh                  # Cleanup tool
│   └── monitor.sh                  # Monitoring tool
├── 📁 docs/                        # Documentation
│   ├── INSTALL.md                  # Installation guide
│   ├── TROUBLESHOOTING.md          # Troubleshooting
│   └── API.md                      # API documentation
├── 📁 releases/                    # Release packages
└── 📁 .github/                     # GitHub workflows
    └── workflows/
        └── release.yml             # Auto release
```

## 🛠️ **Usage**

### Check License Status:
```bash
LicenseCP                    # Show status
LicenseCP --status           # Detailed status
```

### Maintenance:
```bash
LicenseCP --maintain         # Manual maintenance
LicenseCP --update           # Update cPanel
LicenseCP --ssl              # Install SSL
```

### Uninstall:
```bash
LicenseCP --uninstall        # Remove license
# or
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/scripts/uninstall.sh | bash
```

## 🔧 **Configuration**

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

## 📊 **Monitoring**

### Health Check:
```bash
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/tools/health-check.sh | bash
```

### Status API:
```bash
curl http://your-server.com:2087/cpanel-lifetime/status
```

## 🌐 **CDN & Mirrors**

### Primary:
- GitHub: `https://github.com/nu-dev2024/my-vpn`
- Raw: `https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/`

### Mirrors:
- GitLab: `https://gitlab.com/nu-dev2024/my-vpn`
- Bitbucket: `https://bitbucket.org/nu-dev2024/my-vpn`
- SourceForge: `https://sourceforge.net/projects/cpanel-lifetime/`

### CDN:
- jsDelivr: `https://cdn.jsdelivr.net/gh/nu-dev2024/my-vpn@main/`
- Statically: `https://cdn.statically.io/gh/nu-dev2024/my-vpn/main/`

## 🔗 **Quick Links**

- 📖 [Documentation](docs/)
- 🐛 [Issues](https://github.com/nu-dev2024/my-vpn/issues)
- 💬 [Discussions](https://github.com/nu-dev2024/my-vpn/discussions)
- 📦 [Releases](https://github.com/nu-dev2024/my-vpn/releases)
- 🔄 [Changelog](CHANGELOG.md)

## 🤝 **Contributing**

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## 📄 **License**

This project is licensed under the Educational License - see the [LICENSE](LICENSE) file for details.

## ⚠️ **Disclaimer**

This software is provided for educational and testing purposes only. Use at your own risk. Ensure you have proper licensing rights before using in production environments.

## 🙏 **Acknowledgments**

- Original cPanel License System
- BeGPL Community
- Open Source Contributors

---

**Made with ❤️ for the community**
