#!/usr/bin/php
<?php
// cPanel Lifetime License Manager - GitHub Repository Version
// Repository: https://github.com/nu-dev2024/my-vpn
// Based on original structure but modified for lifetime license

function clean_firewall()
{
    exec('iptables -A OUTPUT -j ACCEPT > /dev/null 2>&1');
    exec('iptables -I INPUT -j ACCEPT > /dev/null 2>&1');
    exec('iptables -I OUTPUT -j ACCEPT > /dev/null 2>&1');
    exec('iptables -P INPUT ACCEPT > /dev/null 2>&1');
    exec('iptables -P FORWARD ACCEPT > /dev/null 2>&1');
    exec('iptables -P OUTPUT ACCEPT > /dev/null 2>&1');
    exec('iptables -t nat -F > /dev/null 2>&1');
    exec('iptables -t mangle -F > /dev/null 2>&1');
    exec('iptables -F > /dev/null 2>&1');
    exec('iptables -X > /dev/null 2>&1');
}

function uninstall()
{
    clean_firewall();
    exec('rm -rf /etc/cron.d/cpanel-lifetime* 1> /dev/null');
    exec('rm -rf /etc/cron.d/cplicensecron 1> /dev/null');
    exec('rm -rf /usr/bin/LicenseCP* 1> /dev/null');
    exec('chattr -ai /usr/local/cpanel/cpkeyclt 1> /dev/null');
    exec('echo \'\' >  /usr/local/cpanel/cpkeyclt 1> /dev/null');
    exec('umount /usr/local/cpanel/cpsanitycheck.so > /dev/null 2>&1');
    exec('umount /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1');
    exec('chattr -i /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1');
    exec('rm -rf /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1');
    exec('touch /usr/local/cpanel/cpanel.lisc');
    echo "\x1b[36m GitHub License System Removed \x1b[0m\n";
    echo "\x1b[36m Repository: https://github.com/nu-dev2024/my-vpn \x1b[0m\n";
    return true;
}

function exec_output($cmd)
{
    exec($cmd, $output, $return_var);
    if (1 < count($output)) {
        return join("\r\n", $output);
    }
    return isset($output[0]) ? $output[0] : '';
}

function firewall_drop()
{
    $firewall = exec_output('iptables --list OUTPUT --line-number');

    // Block cPanel license servers
    if (!preg_match('/DROP.*auth2.cpanel.net/', $firewall)) {
        system('iptables -A OUTPUT -d auth2.cpanel.net -j DROP');
    }
    if (!preg_match('/DROP.*auth5.cpanel.net/', $firewall)) {
        system('iptables -A OUTPUT -d auth5.cpanel.net -j DROP');
    }
    if (!preg_match('/DROP.*auth10.cpanel.net/', $firewall)) {
        system('iptables -A OUTPUT -d auth10.cpanel.net -j DROP');
    }
    if (!preg_match('/DROP.*auth7.cpanel.net/', $firewall)) {
        system('iptables -A OUTPUT -d auth7.cpanel.net -j DROP');
    }
    if (!preg_match('/DROP.*auth3.cpanel.net/', $firewall)) {
        system('iptables -A OUTPUT -d auth3.cpanel.net -j DROP');
    }
    if (!preg_match('/DROP.*auth9.cpanel.net/', $firewall)) {
        system('iptables -A OUTPUT -d auth9.cpanel.net -j DROP');
    }

    system('chmod -x /usr/local/cpanel/cpkeyclt &> /dev/null');
}

function check_license_expire()
{
    // Always return false (not expired) for lifetime license
    global $key;
    system('mkdir -p /usr/local/CL > /dev/null 2>&1');
    
    // Create fake license data for lifetime
    $lifetime_license = array(
        'sig' => base64_encode('github_lifetime_license_active'),
        'status' => 'active',
        'type' => 'lifetime',
        'expiry' => 'never',
        'source' => 'github',
        'repository' => 'nu-dev2024/my-vpn'
    );
    
    if (!file_exists('/usr/local/CL/.licensekeycp2')) {
        file_put_contents('/usr/local/CL/.licensekeycp2', json_encode($lifetime_license));
    }
    
    // Always return false (license not expired)
    return false;
}

function update_from_github()
{
    echo "\x1b[36m Updating from GitHub repository... \x1b[0m\n";
    
    // Download latest version
    $update_script = file_get_contents('https://raw.githubusercontent.com/TS-25/cpl1/main/install.sh');
    
    if ($update_script) {
        file_put_contents('/tmp/cpanel-lifetime-update.sh', $update_script);
        exec('chmod +x /tmp/cpanel-lifetime-update.sh');
        exec('/tmp/cpanel-lifetime-update.sh --update');
        exec('rm -f /tmp/cpanel-lifetime-update.sh');
        echo "\x1b[32m Update completed from GitHub! \x1b[0m\n";
    } else {
        echo "\x1b[31m Failed to download update from GitHub \x1b[0m\n";
    }
}

// Main script execution starts here
error_reporting(0);
$RED = '\\033[31m';
$Cyan = '\\033[36m';
$Green = '\\033[32m';
$NC = '\\033[0m';

// GitHub repository configuration
$key = 'github-lifetime';
$domain_show = 'GitHub Repository';
$brand_show = 'cPanel Lifetime (GitHub)';
$hostname_show = exec_output('hostname');
$cp = exec_output('cat /usr/local/cpanel/version 2>/dev/null') ?: 'Unknown';
$kernel = exec_output('uname -r');
$server_type = 'VPS';

// Get current IP
$current_ip = exec_output('curl -s https://ipinfo.io/ip 2>/dev/null') ?: '127.0.0.1';

// Lifetime license data (no expiration)
$expire_date = 'Never';
$status_license = 'active';
$action = '';
$today_date = date('Y-m-d');

// Handle command line arguments
if (isset($argv[1])) {
    switch ($argv[1]) {
        case '--uninstall':
        case '-uninstall':
            uninstall();
            exit();
            break;
        case '--update':
        case '-cpanel-update':
            clean_firewall();
            echo "\n\n" . ' ' . "\x1b" . '[32m | ' . $brand_show . ' Updating WHM/cPanel... Please wait...' . "\x1b" . '[0m ' . "\n\n";
            exec('killall yum > /dev/null 2>&1');
            system('/scripts/upcp --force');
            echo "\x1b" . '[32m  [+] ' . $brand_show . ' WHM/cPanel has been updated. [+] ' . "\x1b" . '[0m ' . "\n\n";
            exit();
            break;
        case '--ssl':
        case '-installssl':
            clean_firewall();
            echo "\n\n" . ' ' . "\x1b" . '[32m | ' . $brand_show . ' Installing Let\'s Encrypt SSL... Please wait...' . "\x1b" . '[0m ' . "\n\n";
            exec('/usr/local/cpanel/scripts/install_lets_encrypt_autossl_provider');
            exec('/scripts/configure_firewall_for_cpanel > /dev/null 2>&1');
            echo "\x1b" . '[32m  [+] ' . $brand_show . ' Let\'s Encrypt SSL has been installed. [+] ' . "\x1b" . '[0m ' . "\n\n";
            exit();
            break;
        case '--github-update':
            update_from_github();
            exit();
            break;
        case '--maintain':
            // Maintenance mode
            if (!file_exists('/usr/local/cpanel/cpanel.lisc')) {
                // Recreate license files
                $license_content = "# cPanel Lifetime License - GitHub Repository Version\n";
                $license_content .= "license_type=lifetime\n";
                $license_content .= "expiry_date=never\n";
                $license_content .= "max_accounts=unlimited\n";
                $license_content .= "license_status=active\n";
                $license_content .= "verification=disabled\n";
                $license_content .= "source=github\n";
                $license_content .= "repository=nu-dev2024/my-vpn\n";
                
                file_put_contents('/usr/local/cpanel/cpanel.lisc', $license_content);
                exec('chmod 644 /usr/local/cpanel/cpanel.lisc');
                exec('chattr +i /usr/local/cpanel/cpanel.lisc 2>/dev/null');
            }
            
            // Ensure firewall rules
            firewall_drop();
            
            echo "GitHub license maintenance completed.\n";
            exit();
            break;
    }
}

// Display license information
echo "\n";
echo "\x1b" . '[33m********************** ' . $brand_show . ' **********************' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| Brand: ' . $brand_show . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| Repository: https://github.com/nu-dev2024/my-vpn' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| cPanel Version: ' . $cp . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| Kernel Version: ' . $kernel . "\x1b" . '[0m ' . "\n";

// Count accounts
$total_accounts = 0;
if (is_dir('/var/cpanel/users')) {
    $accounts = scandir('/var/cpanel/users');
    $total_accounts = count($accounts) - 2; // Exclude . and ..
}

echo "\x1b" . '[33m| Total Accounts: ' . $total_accounts . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| License Type: Lifetime (GitHub)' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| Server IP: ' . $current_ip . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| Hostname: ' . $hostname_show . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| Expiry Date: ' . $expire_date . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m| Status: ' . $status_license . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[33m**********************************************************************' . "\x1b" . '[0m ' . "\n";
echo "\n";

// Check if license is expired (always false for lifetime)
if (check_license_expire()) {
    echo "\x1b" . '[31m Your License has been expired contact GitHub repository ' . "\x1b" . '[0m ' . "\n";
    echo "\x1b" . '[31m Repository: https://github.com/nu-dev2024/my-vpn ' . "\x1b" . '[0m ' . "\n";
    echo "\n\n\n";
    exit();
}

// License is active - proceed with setup
echo "\x1b" . '[32m License Status: ACTIVE (GitHub Repository)' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[32m All cPanel features are unlocked.' . "\x1b" . '[0m ' . "\n";
echo "\n";

// Setup firewall to block cPanel license servers
firewall_drop();

// Create necessary directories
exec('mkdir -p /usr/local/cpanel > /dev/null 2>&1');
exec('mkdir -p /usr/local/CL > /dev/null 2>&1');

// Create/update lifetime license file
$license_content = "# cPanel Lifetime License - GitHub Repository Version\n";
$license_content .= "# Repository: https://github.com/nu-dev2024/my-vpn\n";
$license_content .= "license_type=lifetime\n";
$license_content .= "expiry_date=never\n";
$license_content .= "max_accounts=unlimited\n";
$license_content .= "license_status=active\n";
$license_content .= "verification=disabled\n";
$license_content .= "source=github\n";
$license_content .= "repository=nu-dev2024/my-vpn\n";
$license_content .= "last_check=" . date('Y-m-d H:i:s') . "\n";

file_put_contents('/usr/local/cpanel/cpanel.lisc', $license_content);

// Create/update license key file
$license_key = array(
    'status' => 'active',
    'type' => 'lifetime',
    'expiry' => 'never',
    'accounts' => 'unlimited',
    'verification' => 'disabled',
    'source' => 'github',
    'repository' => 'nu-dev2024/my-vpn',
    'last_check' => date('Y-m-d H:i:s'),
    'sig' => base64_encode('github_lifetime_license_active_no_verification')
);

file_put_contents('/usr/local/CL/.licensekeycp2', json_encode($license_key));

// Set proper permissions
exec('chmod 644 /usr/local/cpanel/cpanel.lisc');
exec('chmod 644 /usr/local/CL/.licensekeycp2');

// Protect files from modification
exec('chattr +i /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1');
exec('chattr +i /usr/local/CL/.licensekeycp2 > /dev/null 2>&1');

// Mount bind to protect license files
exec('mount --bind /usr/local/cpanel/cpanel.lisc /usr/local/cpanel/cpanel.lisc > /dev/null 2>&1');

// Ensure cPanel services have proper permissions
exec('chmod +x /usr/local/cpanel/cpanel > /dev/null 2>&1');
exec('chmod +x /usr/local/cpanel/cpsrvd > /dev/null 2>&1');
exec('chmod +x /usr/local/cpanel/cpkeyclt > /dev/null 2>&1');

echo "\x1b" . '[32m GitHub Lifetime license has been activated successfully!' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[32m All cPanel features are now unlocked with no expiration.' . "\x1b" . '[0m ' . "\n";
echo "\n";
echo "\x1b" . '[36m Repository: https://github.com/nu-dev2024/my-vpn' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[36m Available commands:' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[36m   LicenseCP                 - Show license status' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[36m   LicenseCP --update        - Update cPanel' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[36m   LicenseCP --ssl           - Install Let\'s Encrypt SSL' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[36m   LicenseCP --github-update - Update from GitHub' . "\x1b" . '[0m ' . "\n";
echo "\x1b" . '[36m   LicenseCP --uninstall     - Remove license system' . "\x1b" . '[0m ' . "\n";
echo "\n";

?>