#!/bin/bash
# cPanel Lifetime License - Original-based Installer
# GitHub Repository Version

ERR_NOT_ROOT=1;
ERR_NOT_KNOWN_OS_ID=2;
ERR_CANNOT_INSTALL_DEPENDENCIES=3;
ERR_CANNOT_DOWNLOAD_INSTALLER=4;

export INSTALLER="/usr/bin/setup";
export REPO_URL="https://raw.githubusercontent.com/nu-dev2024/my-vpn/main";

main() {
    echo "";
    echo "";
    echo -e '\E[37;32m''\033[1m*********************************************************************\033[0m';
    echo -e '\E[37;32m''\033[1m              cPanel Lifetime License Installer                  \033[0m';
    echo -e '\E[37;32m''\033[1m                     GitHub Repository Version                   \033[0m';
    echo -e '\E[37;32m''\033[1m*********************************************************************\033[0m';
    echo "";
    echo "";

    if [ "${EUID}" != 1 -a "$(id -u)" -ne 0 ]; then
        echo "ERROR: Please run installer as root.";
        echo "";
        exit ${ERR_NOT_ROOT};
    fi

    echo "Please note License Installer checks and installs your license requirements." \
         "It might take few minutes to finish installation!";
    echo "Repository: https://github.com/nu-dev2024/my-vpn";
    echo "Installation begins in 3 seconds...";
    echo "";

    sleep 3;

    if ! install_dependencies "$(get_os_id)"; then
        echo 1>&2 "Cannot install dependencies.";
        exit ${ERR_CANNOT_INSTALL_DEPENDENCIES};
    fi

    download;

    if ! chmod +x "${INSTALLER}"; then
      echo -e "\n${RED}Failed to execute 'chmod +x ${INSTALLER}'. Contact support ${NC}";
      return 1;
    fi

    "${INSTALLER}";
}

get_os_id() {
    if [ -f /etc/redhat-release ]; then
        echo "centos"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

install_dependencies() {
    local os_id="$1"
    
    case "$os_id" in
        "centos")
            yum install -y wget curl php > /dev/null 2>&1
            ;;
        "debian")
            apt-get update > /dev/null 2>&1
            apt-get install -y wget curl php-cli > /dev/null 2>&1
            ;;
        *)
            echo "Unknown OS. Please install wget, curl, and php manually."
            return 1
            ;;
    esac
    
    return 0
}

download() {
    echo "";
    echo -n "Installing required binary files from GitHub repository... ";
    
    # Create BLBIN directory structure
    rm -rf /usr/local/BLBIN >/dev/null 2>&1;
    rm -rf /root/BLBIN.tar.gz >/dev/null 2>&1;

    if [ ! -d /usr/local/BLBIN ]; then
        echo "";
        echo -n "Setting up binary files from GitHub!"
        mkdir -p /usr/local/BLBIN/bin
        
        # Download PHP binary wrapper from GitHub
        if command -v wget >/dev/null 2>&1; then
            wget -q "$REPO_URL/bin/php" -O /usr/local/BLBIN/bin/php 2>/dev/null || create_php_wrapper
            wget -q "$REPO_URL/bin/comp0" -O /usr/local/BLBIN/bin/comp0 2>/dev/null || create_comp0_wrapper
        elif command -v curl >/dev/null 2>&1; then
            curl -sSL "$REPO_URL/bin/php" -o /usr/local/BLBIN/bin/php 2>/dev/null || create_php_wrapper
            curl -sSL "$REPO_URL/bin/comp0" -o /usr/local/BLBIN/bin/comp0 2>/dev/null || create_comp0_wrapper
        else
            create_php_wrapper
            create_comp0_wrapper
        fi
        
        chmod +x /usr/local/BLBIN/bin/php
        chmod +x /usr/local/BLBIN/bin/comp0
        
        # Create symbolic link for comp0
        ln -sf /usr/local/BLBIN/bin/comp0 /usr/bin/comp0 2>/dev/null
        
    else
        echo "";
        echo -n "Preinstalled binary found! ignoring this step"
        echo "";
        echo "";
    fi

    # Download setup script from GitHub
    download_setup_script;

    echo -e "\n${GREEN}Completed!${NC}";

    if [ ! -f "${INSTALLER}" ]; then
        echo -e "${RED} File ${INSTALLER} not found. Contact support ${NC}";
        return 1;
    fi
}

create_php_wrapper() {
    cat > /usr/local/BLBIN/bin/php << 'PHPEOF'
#!/bin/bash
# PHP wrapper for cPanel Lifetime License - GitHub Version
if [ -f "/usr/bin/php" ]; then
    /usr/bin/php "$@"
elif [ -f "/usr/local/bin/php" ]; then
    /usr/local/bin/php "$@"
else
    echo "PHP not found. Please install PHP."
    exit 1
fi
PHPEOF
}

create_comp0_wrapper() {
    cat > /usr/local/BLBIN/bin/comp0 << 'COMP0EOF'
#!/bin/bash
# File operations utility for cPanel license - GitHub Version
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
}

download_setup_script() {
    # Try to download setup script from GitHub
    if command -v wget >/dev/null 2>&1; then
        wget -q "$REPO_URL/scripts/setup.php" -O "${INSTALLER}" 2>/dev/null || create_local_setup
    elif command -v curl >/dev/null 2>&1; then
        curl -sSL "$REPO_URL/scripts/setup.php" -o "${INSTALLER}" 2>/dev/null || create_local_setup
    else
        create_local_setup
    fi
    
    chmod +x "${INSTALLER}"
}

create_local_setup() {
    # Create setup script inline if download fails
    cat > "${INSTALLER}" << 'SETUPEOF'
#!/usr/local/BLBIN/bin/php
<?php
// cPanel Lifetime License Setup - GitHub Repository Version
// Repository: https://github.com/nu-dev2024/my-vpns

error_reporting(0);

echo "\n\n";
echo "\x1b[36m | GitHub Lifetime License is now installing... Please wait...\x1b[0m\n\n";

// Create directories
exec('mkdir -p /usr/local/cpanel');
exec('mkdir -p /usr/local/CL');

// Create lifetime license file
$license_content = "# cPanel Lifetime License - GitHub Repository Version\n";
$license_content .= "# Repository: https://github.com/nu-dev2024/my-vpn\n";
$license_content .= "license_type=lifetime\n";
$license_content .= "expiry_date=never\n";
$license_content .= "max_accounts=unlimited\n";
$license_content .= "license_status=active\n";
$license_content .= "verification=disabled\n";
$license_content .= "source=github\n";
$license_content .= "repository=nu-dev2024/my-vpn\n";
$license_content .= "installed_date=" . date('Y-m-d H:i:s') . "\n";

file_put_contents('/usr/local/cpanel/cpanel.lisc', $license_content);

// Create license key
$license_key = array(
    'status' => 'active',
    'type' => 'lifetime',
    'expiry' => 'never',
    'accounts' => 'unlimited',
    'source' => 'github',
    'repository' => 'nu-dev2024/my-vpn',
    'installed' => date('Y-m-d H:i:s')
);

file_put_contents('/usr/local/CL/.licensekeycp2', json_encode($license_key));

// Set permissions
exec('chmod 644 /usr/local/cpanel/cpanel.lisc');
exec('chmod 644 /usr/local/CL/.licensekeycp2');
exec('chattr +i /usr/local/cpanel/cpanel.lisc 2>/dev/null');
exec('chattr +i /usr/local/CL/.licensekeycp2 2>/dev/null');

// Block cPanel license servers
exec('iptables -A OUTPUT -d auth2.cpanel.net -j DROP 2>/dev/null');
exec('iptables -A OUTPUT -d auth5.cpanel.net -j DROP 2>/dev/null');
exec('iptables -A OUTPUT -d auth10.cpanel.net -j DROP 2>/dev/null');
exec('iptables -A OUTPUT -d auth7.cpanel.net -j DROP 2>/dev/null');
exec('iptables -A OUTPUT -d auth3.cpanel.net -j DROP 2>/dev/null');
exec('iptables -A OUTPUT -d auth9.cpanel.net -j DROP 2>/dev/null');

// Download and install main LicenseCP script
$licensecp_url = 'https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/src/LicenseCP.php';
$licensecp_content = file_get_contents($licensecp_url);

if ($licensecp_content) {
    file_put_contents('/usr/bin/LicenseCP', $licensecp_content);
    exec('chmod +x /usr/bin/LicenseCP');
    
    // Create symbolic links
    exec('ln -sf /usr/bin/LicenseCP /usr/bin/LicenseCP_v2 2>/dev/null');
    exec('ln -sf /usr/bin/LicenseCP /usr/bin/LicenseCP_update 2>/dev/null');
    exec('ln -sf /usr/bin/LicenseCP /usr/bin/licensescc 2>/dev/null');
} else {
    echo "\x1b[33m Warning: Could not download LicenseCP script from GitHub \x1b[0m\n";
}

// Create cron job
exec('echo "*/30 * * * * root /usr/bin/LicenseCP --maintain > /dev/null 2>&1" > /etc/cron.d/cpanel-lifetime-github');
exec('chmod 644 /etc/cron.d/cpanel-lifetime-github');

echo "\x1b[32m  [+] GitHub Lifetime License has been installed on your server. Enjoy :) [+] \x1b[0m\n\n";
echo "\n\n";
echo "\x1b[32mRepository: https://github.com/nu-dev2024/my-vpn \x1b[0m\n";
echo "\x1b[32mTo check your cPanel License status use: \x1b[0m\n";
echo "\x1b[36m    LicenseCP  \x1b[0m\n";
echo "\n";
echo "\x1b[32mTo Update WHM/cPanel use: \x1b[0m\n";
echo "\x1b[36m    LicenseCP --update  \x1b[0m\n";
echo "\n";
echo "\x1b[32mFor WHM/cPanel SSL use: \x1b[0m\n";
echo "\x1b[36m    LicenseCP --ssl  \x1b[0m\n";
echo "\n";
echo "\x1b[32mTo update license from GitHub: \x1b[0m\n";
echo "\x1b[36m    curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash \x1b[0m\n";
echo "\n";

?>
SETUPEOF
}

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Run main function
main "$@"
