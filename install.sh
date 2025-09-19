#!/bin/bash

# Hatsune Miku Hyprland Configuration Installer
# This script installs the Hyprland configuration with Hatsune Miku theme

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art
echo -e "${CYAN}"
cat << "EOF"
╔════════════════════════════════════════════════════╗
║  🎵 One, two, three, ready? Miku Miku Miiiiiiii 🎵 ║
╚════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${BLUE}🎵 Installing Hatsune Miku Hyprland Configuration...${NC}"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ This script should not be run as root${NC}"
   exit 1
fi

# Check if we're in the right directory
if [[ ! -f "hypr/hyprland.conf" ]]; then
    echo -e "${RED}❌ Please run this script from the hyprland-dotfiles directory${NC}"
    exit 1
fi

# Backup existing configuration
echo -e "${YELLOW}📦 Backing up existing configuration...${NC}"
if [[ -d "$HOME/.config/hypr" ]]; then
    mv "$HOME/.config/hypr" "$HOME/.config/hypr.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✅ Hyprland backup created${NC}"
fi

if [[ -d "$HOME/.config/quickshell" ]]; then
    mv "$HOME/.config/quickshell" "$HOME/.config/quickshell.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✅ Quickshell backup created${NC}"
fi

# Install Hyprland configuration
echo -e "${YELLOW}🔧 Installing Hyprland configuration...${NC}"
cp -r hypr "$HOME/.config/"
echo -e "${GREEN}✅ Hyprland configuration installed${NC}"

# Install Quickshell configuration
echo -e "${YELLOW}🎨 Installing Quickshell configuration...${NC}"
cp -r quickshell "$HOME/.config/"
echo -e "${GREEN}✅ Quickshell configuration installed${NC}"

# Install Fish configuration
echo -e "${YELLOW}🐟 Installing Fish shell configuration...${NC}"
mkdir -p "$HOME/.config/fish/functions"
mkdir -p "$HOME/.config/fastfetch"

if [[ -f "fish/functions/fish_greeting.fish" ]]; then
    cp fish/functions/fish_greeting.fish "$HOME/.config/fish/functions/"
    echo -e "${GREEN}✅ Fish greeting installed${NC}"
fi

if [[ -f "fish/config.fish" ]]; then
    cp fish/config.fish "$HOME/.config/fish/"
    echo -e "${GREEN}✅ Fish config installed${NC}"
fi

if [[ -f "fastfetch/hatsune_ascii.txt" ]]; then
    cp fastfetch/hatsune_ascii.txt "$HOME/.config/fastfetch/"
    echo -e "${GREEN}✅ Hatsune ASCII art installed${NC}"
fi

# Make scripts executable
echo -e "${YELLOW}🔐 Making scripts executable...${NC}"
find "$HOME/.config/hypr" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
echo -e "${GREEN}✅ Scripts made executable${NC}"

# Check for required packages
echo -e "${YELLOW}📋 Checking for required packages...${NC}"
MISSING_PACKAGES=()

# Check Hyprland
if ! command -v hyprland &> /dev/null; then
    MISSING_PACKAGES+=("hyprland")
fi

# Check Quickshell
if ! command -v quickshell &> /dev/null; then
    MISSING_PACKAGES+=("quickshell")
fi

# Check Fish
if ! command -v fish &> /dev/null; then
    MISSING_PACKAGES+=("fish")
fi

# Check Fastfetch
if ! command -v fastfetch &> /dev/null; then
    MISSING_PACKAGES+=("fastfetch")
fi

# Check Pipewire
if ! command -v wpctl &> /dev/null; then
    MISSING_PACKAGES+=("pipewire pipewire-pulse wireplumber")
fi

if [[ ${#MISSING_PACKAGES[@]} -gt 0 ]]; then
    echo -e "${YELLOW}⚠️  Missing packages detected:${NC}"
    for package in "${MISSING_PACKAGES[@]}"; do
        echo -e "${YELLOW}   - $package${NC}"
    done
    echo -e "${BLUE}💡 Install them with:${NC}"
    echo -e "${CYAN}   sudo pacman -S ${MISSING_PACKAGES[*]}${NC}"
else
    echo -e "${GREEN}✅ All required packages are installed${NC}"
fi

# Final instructions
echo -e "${PURPLE}🎉 Installation completed!${NC}"
echo -e "${BLUE}📝 Next steps:${NC}"
echo -e "${CYAN}   1. Log out and log back in to start Hyprland${NC}"
echo -e "${CYAN}   2. Or restart your system${NC}"
echo -e "${CYAN}   3. Use Super + L to test the lock screen${NC}"
echo -e "${CYAN}   4. Use Super + Shift + ↑/↓ for volume control${NC}"
echo ""
echo -e "${GREEN}🎵 Enjoy your Hatsune Miku themed Hyprland setup! 🎵${NC}"
