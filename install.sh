#!/bin/bash
# cPanel Lifetime License - Main Installer
# GitHub Repository Version
# https://github.com/nu-dev2024/my-vpn

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/nu-dev2024/my-vpn"
RAW_URL="https://github.com/nu-dev2024/my-vpn/main"
CDN_URL="hhttps://github.com/nu-dev2024/my-vpn@main"
VERSION="1.0.0"
INSTALL_DIR="/usr/local/cpanel-lifetime"

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}ERROR: This script must be run as root!${NC}"
        echo "Usage: sudo bash $0"
        exit 1
    fi
}

# Display header
show_header() {
    clear
    echo ""
    echo -e "${BOLD}${CYAN}================================================================${NC}"
    echo -e "${BOLD}${CYAN}              cPanel Lifetime License Installer                ${NC}"
    echo -e "${BOLD}${CYAN}                    GitHub Repository Version                  ${NC}"
    echo -e "${BOLD}${CYAN}================================================================${NC}"
    echo ""
    echo -e "${YELLOW}Repository: ${REPO_URL}${NC}"
    echo -e "${YELLOW}Version: ${VERSION}${NC}"
    echo -e "${YELLOW}Install Directory: ${INSTALL_DIR}${NC}"
    echo ""
    echo -e "${CYAN}Features:${NC}"
    echo -e "  ${GREEN}✓${NC} Lifetime License (Never Expires)"
    echo -e "  ${GREEN}✓${NC} Unlimited Accounts"
    echo -e "  ${GREEN}✓${NC} No Online Verification"
    echo -e "  ${GREEN}✓${NC} All cPanel Features Unlocked"
    echo -e "  ${GREEN}✓${NC} Auto Maintenance"
    echo -e "  ${GREEN}✓${NC} GitHub-hosted & Updated"
    echo ""
}

# Detect OS
detect_os() {
    if [ -f /etc/redhat-release ]; then
        OS="centos"
        PKG_MANAGER="yum"
    elif [ -f /etc/debian_version ]; then
        OS="debian"
        PKG_MANAGER="apt-get"
    elif [ -f /etc/ubuntu-release ]; then
        OS="ubuntu"
        PKG_MANAGER="apt-get"
    else
        OS="unknown"
        PKG_MANAGER="unknown"
    fi
    
    echo -e "${CYAN}Detected OS: ${OS}${NC}"
}

# Install dependencies
install_dependencies() {
    echo -e "${CYAN}Installing dependencies...${NC}"
    
    case $PKG_MANAGER in
        "yum")
            yum update -y > /dev/null 2>&1
            yum install -y wget curl unzip tar php > /dev/null 2>&1
            ;;
        "apt-get")
            apt-get update > /dev/null 2>&1
            apt-get install -y wget curl unzip tar php-cli > /dev/null 2>&1
            ;;
        *)
            echo -e "${YELLOW}Unknown package manager. Please install wget, curl, unzip, tar, and php manually.${NC}"
            ;;
    esac
    
    echo -e "${GREEN}Dependencies installed.${NC}"
}

# Download files from GitHub
download_files() {
    echo -e "${CYAN}Downloading files from GitHub...${NC}"
    
    # Create install directory
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    # Try different download methods
    if command -v wget >/dev/null 2>&1; then
        echo -e "${YELLOW}Using wget...${NC}"
        
        # Download main installer
        wget -q "$RAW_URL/scripts/installer.sh" -O installer.sh
        wget -q "$RAW_URL/scripts/setup.php" -O setup.php
        wget -q "$RAW_URL/src/LicenseCP.php" -O LicenseCP.php
        wget -q "$RAW_URL/tools/test.sh" -O test.sh
        wget -q "$RAW_URL/scripts/uninstall.sh" -O uninstall.sh
        
    elif command -v curl >/dev/null 2>&1; then
        echo -e "${YELLOW}Using curl...${NC}"
        
        # Download main installer
        curl -sSL "$RAW_URL/scripts/installer.sh" -o installer.sh
        curl -sSL "$RAW_URL/scripts/setup.php" -o setup.php
        curl -sSL "$RAW_URL/src/LicenseCP.php" -o LicenseCP.php
        curl -sSL "$RAW_URL/tools/test.sh" -o test.sh
        curl -sSL "$RAW_URL/scripts/uninstall.sh" -o uninstall.sh
        
    else
        echo -e "${RED}Neither wget nor curl found. Please install one of them.${NC}"
        exit 1
    fi
    
    # Make scripts executable
    chmod +x *.sh
    chmod +x *.php
    
    echo -e "${GREEN}Files downloaded successfully.${NC}"
}

# Create local installer based on downloaded files
create_local_installer() {
    echo -e "${CYAN}Creating local installer...${NC}"
    
    # Copy files to proper locations
    mkdir -p /usr/local/BLBIN/bin
    
    # Create PHP wrapper
    cat > /usr/local/BLBIN/bin/php << 'PHPEOF'
#!/bin/bash
if [ -f "/usr/bin/php" ]; then
    /usr/bin/php "$@"
elif [ -f "/usr/local/bin/php" ]; then
    /usr/local/bin/php "$@"
else
    echo "PHP not found. Please install PHP."
    exit 1
fi
PHPEOF
    chmod +x /usr/local/BLBIN/bin/php
    
    # Create comp0 utility
    cat > /usr/local/BLBIN/bin/comp0 << 'COMP0EOF'
#!/bin/bash
case "$1" in
    -i|+i)
        chattr +i "$2" 2>/dev/null
        ;;
    -a)
        chattr -i "$2" 2>/dev/null
        ;;
    +a)
        chattr +i "$2" 2>/dev/null
        ;;
    *)
        echo "Usage: $0 [-i|+i|-a|+a] file"
        ;;
esac
COMP0EOF
    chmod +x /usr/local/BLBIN/bin/comp0
    
    # Create symbolic links
    ln -sf /usr/local/BLBIN/bin/comp0 /usr/bin/comp0 2>/dev/null
    
    echo -e "${GREEN}Local installer created.${NC}"
}

# Install license system
install_license() {
    echo -e "${CYAN}Installing cPanel Lifetime License...${NC}"
    
    # Copy LicenseCP to system location
    cp "$INSTALL_DIR/LicenseCP.php" /usr/bin/LicenseCP
    chmod +x /usr/bin/LicenseCP
    
    # Create symbolic links
    ln -sf /usr/bin/LicenseCP /usr/bin/LicenseCP_v2 2>/dev/null
    ln -sf /usr/bin/LicenseCP /usr/bin/LicenseCP_update 2>/dev/null
    ln -sf /usr/bin/LicenseCP /usr/bin/licensescc 2>/dev/null
    
    # Run the license installation
    if [ -f "$INSTALL_DIR/setup.php" ]; then
        /usr/local/BLBIN/bin/php "$INSTALL_DIR/setup.php"
    else
        # Fallback installation
        mkdir -p /usr/local/cpanel /usr/local/CL
        
        # Create license file
        cat > /usr/local/cpanel/cpanel.lisc << 'LICEOF'
# cPanel Lifetime License - GitHub Version
license_type=lifetime
expiry_date=never
max_accounts=unlimited
license_status=active
verification=disabled
source=github
repository=nu-dev2024/my-vpn
LICEOF
        
        # Create license key
        cat > /usr/local/CL/.licensekeycp2 << 'KEYEOF'
{
    "status": "active",
    "type": "lifetime",
    "expiry": "never",
    "accounts": "unlimited",
    "source": "github",
    "repository": "nu-dev2024/my-vpn"
}
KEYEOF
        
        # Set permissions
        chmod 644 /usr/local/cpanel/cpanel.lisc
        chmod 644 /usr/local/CL/.licensekeycp2
        chattr +i /usr/local/cpanel/cpanel.lisc 2>/dev/null
        chattr +i /usr/local/CL/.licensekeycp2 2>/dev/null
    fi
    
    # Create cron job
    cat > /etc/cron.d/cpanel-lifetime << 'CRONEOF'
# cPanel Lifetime License Maintenance - GitHub Version
*/30 * * * * root /usr/bin/LicenseCP --maintain > /dev/null 2>&1
CRONEOF
    chmod 644 /etc/cron.d/cpanel-lifetime
    
    echo -e "${GREEN}License system installed.${NC}"
}

# Setup firewall
setup_firewall() {
    echo -e "${CYAN}Setting up firewall protection...${NC}"
    
    if command -v iptables >/dev/null 2>&1; then
        # Block cPanel license servers
        iptables -A OUTPUT -d auth2.cpanel.net -j DROP 2>/dev/null || true
        iptables -A OUTPUT -d auth5.cpanel.net -j DROP 2>/dev/null || true
        iptables -A OUTPUT -d auth10.cpanel.net -j DROP 2>/dev/null || true
        iptables -A OUTPUT -d auth7.cpanel.net -j DROP 2>/dev/null || true
        iptables -A OUTPUT -d auth3.cpanel.net -j DROP 2>/dev/null || true
        iptables -A OUTPUT -d auth9.cpanel.net -j DROP 2>/dev/null || true
        
        echo -e "${GREEN}Firewall rules applied.${NC}"
    else
        echo -e "${YELLOW}iptables not found. Firewall protection skipped.${NC}"
    fi
}

# Test installation
test_installation() {
    echo -e "${CYAN}Testing installation...${NC}"
    
    if [ -f "$INSTALL_DIR/test.sh" ]; then
        bash "$INSTALL_DIR/test.sh"
    else
        # Basic test
        if [ -f "/usr/bin/LicenseCP" ] && [ -f "/usr/local/cpanel/cpanel.lisc" ]; then
            echo -e "${GREEN}Basic test passed.${NC}"
        else
            echo -e "${RED}Basic test failed.${NC}"
            return 1
        fi
    fi
}

# Create update script
create_update_script() {
    cat > "$INSTALL_DIR/update.sh" << 'UPDATEEOF'
#!/bin/bash
# Update cPanel Lifetime License from GitHub

echo "Updating cPanel Lifetime License..."
cd /usr/local/cpanel-lifetime

# Download latest version
curl -sSL "https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh" -o install-new.sh
chmod +x install-new.sh

# Run update
./install-new.sh --update

echo "Update completed."
UPDATEEOF
    chmod +x "$INSTALL_DIR/update.sh"
}

# Main installation function
main() {
    show_header
    
    echo -e "${YELLOW}This will install cPanel Lifetime License from GitHub repository.${NC}"
    echo -e "${YELLOW}The installation will download files from: ${REPO_URL}${NC}"
    echo ""
    
    read -p "Do you want to proceed? [Y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        exit 0
    fi
    
    echo ""
    echo -e "${BOLD}${CYAN}Starting installation...${NC}"
    echo ""
    
    detect_os
    echo ""
    
    install_dependencies
    echo ""
    
    download_files
    echo ""
    
    create_local_installer
    echo ""
    
    install_license
    echo ""
    
    setup_firewall
    echo ""
    
    create_update_script
    echo ""
    
    test_installation
    echo ""
    
    echo -e "${BOLD}${GREEN}================================================================${NC}"
    echo -e "${BOLD}${GREEN}              Installation Completed Successfully!             ${NC}"
    echo -e "${BOLD}${GREEN}================================================================${NC}"
    echo ""
    echo -e "${CYAN}License Information:${NC}"
    echo -e "  Type: Lifetime"
    echo -e "  Expiry: Never"
    echo -e "  Accounts: Unlimited"
    echo -e "  Source: GitHub Repository"
    echo -e "  Repository: ${REPO_URL}"
    echo ""
    echo -e "${CYAN}Available Commands:${NC}"
    echo -e "  ${YELLOW}LicenseCP${NC}                 - Check license status"
    echo -e "  ${YELLOW}LicenseCP --update${NC}        - Update cPanel"
    echo -e "  ${YELLOW}LicenseCP --ssl${NC}           - Install SSL"
    echo -e "  ${YELLOW}$INSTALL_DIR/update.sh${NC}    - Update license from GitHub"
    echo -e "  ${YELLOW}$INSTALL_DIR/uninstall.sh${NC} - Uninstall license"
    echo ""
    echo -e "${GREEN}Your cPanel now has a lifetime license with no restrictions!${NC}"
    echo -e "${GREEN}Repository: ${REPO_URL}${NC}"
    echo ""
}

# Handle command line arguments
case "${1:-}" in
    --update)
        echo "Running update mode..."
        # Skip confirmation for updates
        ;;
    --help|-h)
        echo "cPanel Lifetime License Installer"
        echo "Usage: $0 [--update|--help]"
        echo ""
        echo "Options:"
        echo "  --update    Update existing installation"
        echo "  --help      Show this help message"
        echo ""
        echo "Repository: $REPO_URL"
        exit 0
        ;;
    *)
        # Normal installation
        ;;
esac

# Check root and run
check_root
main "$@"
