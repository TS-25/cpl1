#!/bin/bash
# Uninstall cPanel Lifetime License - GitHub Repository Version
# Repository: https://github.com/nu-dev2024/my-vpn

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Repository info
REPO_URL="https://github.com/nu-dev2024/my-vpn"

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERROR: Run this script as root!${NC}"
    exit 1
fi

echo -e "${BOLD}${RED}================================================================${NC}"
echo -e "${BOLD}${RED}        cPanel Lifetime License Uninstaller (GitHub)           ${NC}"
echo -e "${BOLD}${RED}================================================================${NC}"
echo ""
echo -e "${YELLOW}Repository: ${REPO_URL}${NC}"
echo -e "${YELLOW}This script will remove ALL GitHub-based license components.${NC}"
echo ""

read -p "Are you sure you want to proceed? [y/N]: " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstall cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${CYAN}Starting GitHub license uninstall process...${NC}"
echo ""

# 1. Stop and kill all license processes
echo -e "${CYAN}[1/8] Stopping license processes...${NC}"
pkill -f "LicenseCP" > /dev/null 2>&1
pkill -f "cpkeyclt" > /dev/null 2>&1
pkill -f "licensescc" > /dev/null 2>&1
pkill -f "comp0" > /dev/null 2>&1
echo -e "${GREEN}License processes stopped.${NC}"

# 2. Remove cron jobs
echo -e "${CYAN}[2/8] Removing GitHub cron jobs...${NC}"
rm -rf /etc/cron.d/cpanel-lifetime* > /dev/null 2>&1
rm -rf /etc/cron.d/cplicensecron > /dev/null 2>&1
systemctl restart crond 2>/dev/null || service cron restart 2>/dev/null
echo -e "${GREEN}GitHub cron jobs removed.${NC}"

# 3. Remove license files
echo -e "${CYAN}[3/8] Removing GitHub license files...${NC}"
chattr -i /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1
chattr -a /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1
chattr -i /usr/local/CL/.licensekeycp2 > /dev/null 2>&1
chattr -a /usr/local/CL/.licensekeycp2 > /dev/null 2>&1

# Unmount any mounted files
umount /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1
umount /usr/local/cpanel/cpsanitycheck.so > /dev/null 2>&1

rm -rf /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1
rm -rf /usr/local/CL/.licensekeycp2 > /dev/null 2>&1
rm -rf /usr/local/CL > /dev/null 2>&1

# Create empty license file
touch /usr/local/cpanel/cpanel.lisc
chmod 644 /usr/local/cpanel/cpanel.lisc

echo -e "${GREEN}GitHub license files removed.${NC}"

# 4. Remove license scripts
echo -e "${CYAN}[4/8] Removing GitHub license scripts...${NC}"
rm -rf /usr/bin/LicenseCP* > /dev/null 2>&1
rm -rf /usr/bin/licensescc > /dev/null 2>&1
rm -rf /usr/bin/comp0 > /dev/null 2>&1
echo -e "${GREEN}GitHub license scripts removed.${NC}"

# 5. Remove BLBIN directory
echo -e "${CYAN}[5/8] Removing BLBIN directory...${NC}"
rm -rf /usr/local/BLBIN > /dev/null 2>&1
echo -e "${GREEN}BLBIN directory removed.${NC}"

# 6. Clean firewall rules
echo -e "${CYAN}[6/8] Cleaning firewall rules...${NC}"
if command -v iptables >/dev/null 2>&1; then
    # Remove cPanel blocking rules
    while iptables -L OUTPUT --line-numbers 2>/dev/null | grep -q "cpanel.net"; do
        rule_num=$(iptables -L OUTPUT --line-numbers 2>/dev/null | grep "cpanel.net" | head -1 | awk '{print $1}')
        iptables -D OUTPUT "$rule_num" 2>/dev/null
    done
    
    while iptables -L INPUT --line-numbers 2>/dev/null | grep -q "cpanel.net"; do
        rule_num=$(iptables -L INPUT --line-numbers 2>/dev/null | grep "cpanel.net" | head -1 | awk '{print $1}')
        iptables -D INPUT "$rule_num" 2>/dev/null
    done
    
    echo -e "${GREEN}Firewall rules cleaned.${NC}"
else
    echo -e "${YELLOW}iptables not available, skipping firewall cleanup.${NC}"
fi

# 7. Reset cPanel permissions
echo -e "${CYAN}[7/8] Resetting cPanel permissions...${NC}"
if [ -f "/usr/local/cpanel/cpkeyclt" ]; then
    chattr -i /usr/local/cpanel/cpkeyclt > /dev/null 2>&1
    chattr -a /usr/local/cpanel/cpkeyclt > /dev/null 2>&1
    chmod +x /usr/local/cpanel/cpkeyclt > /dev/null 2>&1
fi

if [ -f "/usr/local/cpanel/cpsrvd" ]; then
    chmod +x /usr/local/cpanel/cpsrvd > /dev/null 2>&1
fi

if [ -f "/usr/local/cpanel/cpanel" ]; then
    chmod +x /usr/local/cpanel/cpanel > /dev/null 2>&1
fi

echo -e "${GREEN}cPanel permissions reset.${NC}"

# 8. Clean GitHub installation directory
echo -e "${CYAN}[8/8] Cleaning GitHub installation files...${NC}"
rm -rf /usr/local/cpanel-lifetime > /dev/null 2>&1
rm -rf /tmp/cpanel-lifetime* > /dev/null 2>&1
echo -e "${GREEN}GitHub installation files cleaned.${NC}"

echo ""
echo -e "${BOLD}${GREEN}================================================================${NC}"
echo -e "${BOLD}${GREEN}                GitHub Uninstall Completed                     ${NC}"
echo -e "${BOLD}${GREEN}================================================================${NC}"
echo ""
echo -e "${GREEN}All GitHub-based license components have been removed.${NC}"
echo ""
echo -e "${CYAN}What was cleaned:${NC}"
echo -e "  ✓ GitHub license processes stopped"
echo -e "  ✓ GitHub cron jobs removed"
echo -e "  ✓ GitHub license files removed"
echo -e "  ✓ GitHub license scripts removed"
echo -e "  ✓ BLBIN directory removed"
echo -e "  ✓ Firewall rules cleaned"
echo -e "  ✓ cPanel permissions reset"
echo -e "  ✓ GitHub installation files cleaned"
echo ""
echo -e "${YELLOW}Repository: ${REPO_URL}${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. You can reinstall from GitHub: curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash"
echo -e "  2. Or install a legitimate cPanel license"
echo -e "  3. Run: /scripts/upcp --force (to update cPanel)"
echo ""
echo -e "${CYAN}To restart cPanel services:${NC}"
echo -e "  systemctl restart cpanel"
echo -e "  systemctl restart whostmgr"
echo ""

exit 0
