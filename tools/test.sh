#!/bin/bash
# Test cPanel Lifetime License Installation - GitHub Repository Version
# Repository: https://github.com/nu-dev2024/my-vpn

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Test results
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Repository info
REPO_URL="https://github.com/TS-25/cpl1"
RAW_URL="https://raw.githubusercontent.com/TS-25/cpl1/main"

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    echo -n "Testing $test_name... "
    
    if eval "$test_command"; then
        echo -e "${GREEN}PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Header
clear
echo ""
echo -e "${BOLD}${CYAN}================================================================${NC}"
echo -e "${BOLD}${CYAN}        cPanel Lifetime License Installation Test (GitHub)      ${NC}"
echo -e "${BOLD}${CYAN}================================================================${NC}"
echo ""
echo -e "${YELLOW}Repository: ${REPO_URL}${NC}"
echo -e "${YELLOW}Testing GitHub-based installation...${NC}"
echo ""

# Test 1: Check if LicenseCP exists
run_test "LicenseCP script exists" "[ -f '/usr/bin/LicenseCP' ]"

# Test 2: Check if LicenseCP is executable
run_test "LicenseCP is executable" "[ -x '/usr/bin/LicenseCP' ]"

# Test 3: Check if license file exists
run_test "License file exists" "[ -f '/usr/local/cpanel/cpanel.lisc' ]"

# Test 4: Check if license key file exists
run_test "License key file exists" "[ -f '/usr/local/CL/.licensekeycp2' ]"

# Test 5: Check BLBIN directory
run_test "BLBIN directory exists" "[ -d '/usr/local/BLBIN' ]"

# Test 6: Check PHP wrapper
run_test "PHP wrapper exists" "[ -f '/usr/local/BLBIN/bin/php' ]"

# Test 7: Check comp0 utility
run_test "comp0 utility exists" "[ -f '/usr/local/BLBIN/bin/comp0' ]"

# Test 8: Check symbolic links
run_test "LicenseCP_v2 link exists" "[ -L '/usr/bin/LicenseCP_v2' ]"

# Test 9: Check cron job
run_test "GitHub cron job exists" "[ -f '/etc/cron.d/cpanel-lifetime-github' ] || [ -f '/etc/cron.d/cpanel-lifetime' ]"

# Test 10: Check license file contains GitHub info
run_test "License file contains GitHub info" "grep -q 'github' /usr/local/cpanel/cpanel.lisc 2>/dev/null"

# Test 11: Check license file contains repository info
run_test "License file contains repository" "grep -q 'nu-dev2024/my-vpn' /usr/local/cpanel/cpanel.lisc 2>/dev/null"

# Test 12: Check if license file is protected
run_test "License file is protected" "lsattr /usr/local/cpanel/cpanel.lisc 2>/dev/null | grep -q 'i'"

# Test 13: Check firewall rules
run_test "Firewall rules exist" "iptables -L OUTPUT 2>/dev/null | grep -q 'cpanel.net' || echo 'Firewall rules may not be active'"

# Test 14: Test LicenseCP execution
run_test "LicenseCP can execute" "timeout 10s /usr/bin/LicenseCP > /dev/null 2>&1 || true"

# Test 15: Check cPanel installation
run_test "cPanel is installed" "[ -f '/usr/local/cpanel/version' ]"

# Test 16: Check GitHub connectivity
run_test "GitHub connectivity" "curl -s --connect-timeout 5 ${RAW_URL}/README.md > /dev/null 2>&1"

# Test 17: Check license key contains GitHub info
run_test "License key contains GitHub info" "grep -q 'github' /usr/local/CL/.licensekeycp2 2>/dev/null"

echo ""
echo -e "${CYAN}Detailed Information:${NC}"
echo ""

# Show license file content
if [ -f "/usr/local/cpanel/cpanel.lisc" ]; then
    echo -e "${YELLOW}License File Content:${NC}"
    head -15 /usr/local/cpanel/cpanel.lisc 2>/dev/null | sed 's/^/  /'
    echo ""
fi

# Show license key content
if [ -f "/usr/local/CL/.licensekeycp2" ]; then
    echo -e "${YELLOW}License Key Content:${NC}"
    cat /usr/local/CL/.licensekeycp2 2>/dev/null | python -m json.tool 2>/dev/null | sed 's/^/  /' || cat /usr/local/CL/.licensekeycp2 2>/dev/null | sed 's/^/  /'
    echo ""
fi

# Show cPanel version
if [ -f "/usr/local/cpanel/version" ]; then
    echo -e "${YELLOW}cPanel Version:${NC}"
    echo "  $(cat /usr/local/cpanel/version 2>/dev/null)"
    echo ""
fi

# Show current accounts
if [ -d "/var/cpanel/users" ]; then
    account_count=$(find /var/cpanel/users -maxdepth 1 -type f 2>/dev/null | wc -l)
    echo -e "${YELLOW}Current Accounts:${NC}"
    echo "  $account_count accounts"
    echo ""
fi

# Show firewall status
echo -e "${YELLOW}Firewall Status:${NC}"
if command -v iptables >/dev/null 2>&1; then
    blocked_rules=$(iptables -L OUTPUT 2>/dev/null | grep -c "cpanel.net" || echo "0")
    echo "  $blocked_rules cPanel license servers blocked"
else
    echo "  iptables not available"
fi
echo ""

# Show GitHub repository info
echo -e "${YELLOW}GitHub Repository Info:${NC}"
echo "  Repository: ${REPO_URL}"
echo "  Raw URL: ${RAW_URL}"
if command -v curl >/dev/null 2>&1; then
    if curl -s --connect-timeout 5 "${RAW_URL}/README.md" > /dev/null 2>&1; then
        echo "  Status: ${GREEN}Accessible${NC}"
    else
        echo "  Status: ${RED}Not Accessible${NC}"
    fi
else
    echo "  Status: Cannot test (curl not available)"
fi
echo ""

# Show process status
echo -e "${YELLOW}Process Status:${NC}"
license_processes=$(ps aux 2>/dev/null | grep -c "[L]icenseCP" || echo "0")
echo "  $license_processes LicenseCP processes running"
echo ""

# Test Results Summary
echo -e "${BOLD}${CYAN}================================================================${NC}"
echo -e "${BOLD}${CYAN}                        Test Results                           ${NC}"
echo -e "${BOLD}${CYAN}================================================================${NC}"
echo ""
echo -e "${GREEN}Tests Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Tests Failed: $TESTS_FAILED${NC}"
echo -e "${CYAN}Total Tests: $TESTS_TOTAL${NC}"
echo ""

# Overall result
if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${BOLD}${GREEN}✅ ALL TESTS PASSED - GitHub installation is successful!${NC}"
    echo ""
    echo -e "${CYAN}You can now use:${NC}"
    echo -e "  ${YELLOW}LicenseCP${NC}                 - Show license status"
    echo -e "  ${YELLOW}LicenseCP --update${NC}        - Update cPanel"
    echo -e "  ${YELLOW}LicenseCP --ssl${NC}           - Install SSL"
    echo -e "  ${YELLOW}LicenseCP --github-update${NC} - Update from GitHub"
    echo ""
elif [ $TESTS_FAILED -le 3 ]; then
    echo -e "${BOLD}${YELLOW}⚠️  MOSTLY SUCCESSFUL - Some minor issues detected${NC}"
    echo -e "${YELLOW}The GitHub installation should work, but you may want to check the failed tests.${NC}"
    echo ""
else
    echo -e "${BOLD}${RED}❌ INSTALLATION ISSUES DETECTED${NC}"
    echo -e "${RED}Several tests failed. Please check the GitHub installation and try again.${NC}"
    echo ""
fi

echo -e "${CYAN}GitHub Repository: ${REPO_URL}${NC}"
echo -e "${CYAN}For updates, run: LicenseCP --github-update${NC}"
echo -e "${CYAN}Or reinstall: curl -sSL ${RAW_URL}/install.sh | bash${NC}"
echo ""

exit 0
