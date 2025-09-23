#!/bin/bash

# 🔍 NVIDIA Driver Readiness Checker
# Verifies system readiness for NVIDIA driver installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
cat << "EOF"
╔════════════════════════════════════════════════════╗
║  🔍 NVIDIA Driver Readiness Checker 🔍            ║
║  Verifying system readiness for safe installation ║
╚════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${BLUE}🔍 Checking system readiness for NVIDIA driver installation...${NC}"
echo ""

# Check results
CHECKS_PASSED=0
TOTAL_CHECKS=0

# Function to run check
run_check() {
    local check_name="$1"
    local check_command="$2"
    local success_message="$3"
    local failure_message="$4"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    echo -e "${BLUE}🔍 $check_name...${NC}"
    
    if eval "$check_command" >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅ $success_message${NC}"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
        return 0
    else
        echo -e "  ${RED}❌ $failure_message${NC}"
        return 1
    fi
}

# Check 1: GPU Detection
echo -e "${PURPLE}📋 Hardware Checks:${NC}"
run_check "GPU Detection" "lspci | grep -i nvidia" "NVIDIA GPU detected" "No NVIDIA GPU found"

# Check 2: Current Driver Status
run_check "Current Driver Check" "lsmod | grep nouveau" "Nouveau driver active (will be replaced)" "Nouveau not active"

# Check 3: System Architecture
run_check "Architecture Check" "uname -m | grep x86_64" "x86_64 architecture supported" "Architecture not supported"

# Check 4: Kernel Version
echo -e "${PURPLE}📋 System Checks:${NC}"
KERNEL_VERSION=$(uname -r)
echo -e "${BLUE}🔍 Kernel Version...${NC}"
echo -e "  ${GREEN}✅ Running kernel: $KERNEL_VERSION${NC}"
CHECKS_PASSED=$((CHECKS_PASSED + 1))
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

# Check 5: Package Manager
run_check "Package Manager" "command -v pacman" "Pacman package manager available" "Pacman not found"

# Check 6: Sudo Access
run_check "Sudo Access" "sudo -n true" "Sudo access available" "Sudo access required"

# Check 7: Available Disk Space
echo -e "${BLUE}🔍 Disk Space Check...${NC}"
AVAILABLE_SPACE=$(df / | awk 'NR==2 {print $4}')
if [[ $AVAILABLE_SPACE -gt 1048576 ]]; then  # 1GB in KB
    echo -e "  ${GREEN}✅ Sufficient disk space available ($(($AVAILABLE_SPACE / 1024))MB)${NC}"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "  ${RED}❌ Insufficient disk space (need at least 1GB)${NC}"
fi
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

# Check 8: Internet Connection
run_check "Internet Connection" "ping -c 1 archlinux.org" "Internet connection available" "No internet connection"

# Check 9: Hyprland Configuration
echo -e "${PURPLE}📋 Configuration Checks:${NC}"
run_check "Hyprland Config" "test -f hypr/hyprland.conf" "Hyprland configuration found" "Hyprland configuration missing"

run_check "NVIDIA Config" "test -f hypr/hyprland/nvidia.conf" "NVIDIA configuration found" "NVIDIA configuration missing"

# Check 10: Install Script
run_check "Install Script" "test -f install-nvidia-driver.sh" "Installation script found" "Installation script missing"

# Check 11: Script Permissions
run_check "Script Permissions" "test -x install-nvidia-driver.sh" "Installation script is executable" "Installation script not executable"

# Check 12: Backup Space
echo -e "${BLUE}🔍 Backup Space Check...${NC}"
HOME_SPACE=$(df "$HOME" | awk 'NR==2 {print $4}')
if [[ $HOME_SPACE -gt 524288 ]]; then  # 512MB in KB
    echo -e "  ${GREEN}✅ Sufficient space for backup ($(($HOME_SPACE / 1024))MB)${NC}"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "  ${RED}❌ Insufficient space for backup (need at least 512MB)${NC}"
fi
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

# Summary
echo ""
echo -e "${PURPLE}📊 Summary:${NC}"
echo -e "  Checks passed: ${GREEN}$CHECKS_PASSED${NC}/${BLUE}$TOTAL_CHECKS${NC}"

if [[ $CHECKS_PASSED -eq $TOTAL_CHECKS ]]; then
    echo ""
    echo -e "${GREEN}🎉 All checks passed! Your system is ready for NVIDIA driver installation.${NC}"
    echo ""
    echo -e "${YELLOW}📋 Ready to proceed with:${NC}"
    echo -e "  ${BLUE}./install-nvidia-driver.sh${NC}"
    echo ""
    echo -e "${GREEN}✅ Safe to install NVIDIA drivers${NC}"
    exit 0
elif [[ $CHECKS_PASSED -gt $((TOTAL_CHECKS / 2)) ]]; then
    echo ""
    echo -e "${YELLOW}⚠️  Most checks passed, but some issues were found.${NC}"
    echo -e "${YELLOW}   Review the failed checks above before proceeding.${NC}"
    echo ""
    echo -e "${YELLOW}📋 You can still try:${NC}"
    echo -e "  ${BLUE}./install-nvidia-driver.sh${NC}"
    echo -e "${YELLOW}   But proceed with caution.${NC}"
    exit 1
else
    echo ""
    echo -e "${RED}❌ Multiple critical checks failed.${NC}"
    echo -e "${RED}   Please resolve the issues above before attempting installation.${NC}"
    echo ""
    echo -e "${RED}🚫 Not safe to install NVIDIA drivers${NC}"
    exit 1
fi
