# Installation Guide - cPanel Lifetime License

## 🚀 Quick Installation

### One-Line Install (Recommended):
```bash
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash
```

### Alternative URLs:
```bash
# Using jsDelivr CDN
curl -sSL https://cdn.jsdelivr.net/gh/nu-dev2024/my-vpn@main/install.sh | bash

# Using Statically CDN
curl -sSL https://cdn.statically.io/gh/nu-dev2024/my-vpn/main/install.sh | bash
```

## 📋 Prerequisites

### System Requirements:
- **OS**: CentOS 7/8, RHEL 7/8, CloudLinux, Ubuntu 18.04+, Debian 9+
- **Root Access**: Required
- **cPanel**: Must be installed
- **PHP**: Required (will be installed if missing)
- **Internet**: Required for GitHub downloads

### Check Prerequisites:
```bash
# Check if running as root
whoami

# Check cPanel installation
ls /usr/local/cpanel/

# Check PHP
php --version

# Check internet connectivity
curl -s https://github.com
```

## 🛠️ Installation Methods

### Method 1: Direct GitHub Install
```bash
# Download and run installer
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash
```

### Method 2: Download and Inspect
```bash
# Download installer first
wget https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh

# Inspect the script
cat install.sh

# Run installer
chmod +x install.sh
./install.sh
```

### Method 3: Git Clone
```bash
# Clone repository
git clone https://github.com/nu-dev2024/my-vpn.git
cd cpanel-lifetime

# Run installer
./install.sh
```

### Method 4: Download Release
```bash
# Download latest release
wget https://github.com/nu-dev2024/my-vpn/releases/latest/download/cpanel-lifetime.tar.gz

# Extract and install
tar -xzf cpanel-lifetime.tar.gz
cd cpanel-lifetime
./install.sh
```

## 🔧 Manual Installation

### Step 1: Download Files
```bash
mkdir -p /usr/local/cpanel-lifetime
cd /usr/local/cpanel-lifetime

# Download main files
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/src/LicenseCP.php -o LicenseCP.php
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/scripts/installer.sh -o installer.sh

chmod +x *.php *.sh
```

### Step 2: Setup BLBIN
```bash
mkdir -p /usr/local/BLBIN/bin

# Create PHP wrapper
cat > /usr/local/BLBIN/bin/php << 'EOF'
#!/bin/bash
if [ -f "/usr/bin/php" ]; then
    /usr/bin/php "$@"
elif [ -f "/usr/local/bin/php" ]; then
    /usr/local/bin/php "$@"
else
    echo "PHP not found. Please install PHP."
    exit 1
fi
EOF

chmod +x /usr/local/BLBIN/bin/php
```

### Step 3: Install License
```bash
# Copy LicenseCP to system location
cp LicenseCP.php /usr/bin/LicenseCP
chmod +x /usr/bin/LicenseCP

# Create symbolic links
ln -sf /usr/bin/LicenseCP /usr/bin/LicenseCP_v2
ln -sf /usr/bin/LicenseCP /usr/bin/LicenseCP_update
ln -sf /usr/bin/LicenseCP /usr/bin/licensescc

# Run initial setup
/usr/bin/LicenseCP
```

## 🔍 Verification

### Test Installation:
```bash
# Download and run test script
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/tools/test.sh | bash
```

### Manual Verification:
```bash
# Check license status
LicenseCP

# Check license file
cat /usr/local/cpanel/cpanel.lisc

# Check license key
cat /usr/local/CL/.licensekeycp2

# Check cron job
cat /etc/cron.d/cpanel-lifetime-github
```

## 🌐 Network Configuration

### Firewall Requirements:
The installer will automatically block cPanel license servers:
- auth2.cpanel.net
- auth5.cpanel.net
- auth10.cpanel.net
- auth7.cpanel.net
- auth3.cpanel.net
- auth9.cpanel.net

### GitHub Access:
Ensure your server can access:
- github.com
- raw.githubusercontent.com
- cdn.jsdelivr.net (optional)
- cdn.statically.io (optional)

### Test GitHub Connectivity:
```bash
curl -s https://api.github.com/repos/nu-dev2024/my-vpn
```

## 🔄 Updates

### Auto Update from GitHub:
```bash
LicenseCP --github-update
```

### Manual Update:
```bash
# Re-run installer
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash
```

### Update Script:
```bash
# Use update script if available
/usr/local/cpanel-lifetime/update.sh
```

## 🐛 Troubleshooting

### Common Issues:

#### 1. Permission Denied
```bash
# Ensure running as root
sudo su -
```

#### 2. PHP Not Found
```bash
# Install PHP
yum install -y php  # CentOS/RHEL
apt-get install -y php-cli  # Ubuntu/Debian
```

#### 3. GitHub Access Issues
```bash
# Test connectivity
curl -v https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/README.md

# Try alternative CDN
curl -v https://cdn.jsdelivr.net/gh/nu-dev2024/my-vpn@main/README.md
```

#### 4. cPanel Not Found
```bash
# Check cPanel installation
ls -la /usr/local/cpanel/

# Install cPanel if needed
cd /home
wget http://layer1.cpanel.net/latest
sh latest
```

#### 5. License Not Working
```bash
# Run maintenance
LicenseCP --maintain

# Check file permissions
ls -la /usr/local/cpanel/cpanel.lisc
lsattr /usr/local/cpanel/cpanel.lisc

# Reinstall
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash
```

### Debug Mode:
```bash
# Run installer with debug
bash -x install.sh

# Check logs
tail -f /var/log/messages
tail -f /usr/local/cpanel/logs/error_log
```

## 🗑️ Uninstallation

### Quick Uninstall:
```bash
curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/scripts/uninstall.sh | bash
```

### Manual Uninstall:
```bash
# Use LicenseCP
LicenseCP --uninstall

# Or download uninstaller
wget https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/scripts/uninstall.sh
chmod +x uninstall.sh
./uninstall.sh
```

## 📞 Support

### GitHub Issues:
- Report bugs: https://github.com/nu-dev2024/my-vpn/issues
- Feature requests: https://github.com/nu-dev2024/my-vpn/discussions

### Documentation:
- README: https://github.com/nu-dev2024/my-vpn/blob/main/README.md
- Troubleshooting: https://github.com/nu-dev2024/my-vpn/blob/main/docs/TROUBLESHOOTING.md

### Community:
- Discussions: https://github.com/nu-dev2024/my-vpn/discussions
- Wiki: https://github.com/nu-dev2024/my-vpn/wiki

---

**Repository**: https://github.com/nu-dev2024/my-vpn  
**License**: Educational Use Only  
**Disclaimer**: Use at your own risk. Ensure proper licensing compliance.
