#!/bin/bash

# 🎵 Hyprsune Miku - Smart Installer
# This script provides a smart installation with user choices

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

echo -e "${BLUE}🎵 Hyprsune Miku - Smart Installer${NC}"
echo -e "${YELLOW}This installer will guide you through the setup process${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ This script should not be run as root${NC}"
   exit 1
fi

# Check if we're in the right directory
if [[ ! -f "hypr/hyprland.conf" ]]; then
    echo -e "${RED}❌ Please run this script from the hyprsune-miku directory${NC}"
    exit 1
fi

# Function to ask yes/no questions
ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"
    
    while true; do
        if [[ "$default" == "y" ]]; then
            read -p "$prompt [Y/n]: " yn
            yn=${yn:-y}
        else
            read -p "$prompt [y/N]: " yn
            yn=${yn:-n}
        fi
        
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Function to ask for choice
ask_choice() {
    local prompt="$1"
    shift
    local options=("$@")
    
    echo -e "${CYAN}$prompt${NC}"
    for i in "${!options[@]}"; do
        echo "  $((i+1)). ${options[i]}"
    done
    
    while true; do
        read -p "Choose an option [1-${#options[@]}]: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo $((choice-1))
            return
        else
            echo "Please enter a number between 1 and ${#options[@]}"
        fi
    done
}

echo -e "${BLUE}📋 Installation Options:${NC}"
echo ""

# Backup existing configuration
if [[ -d "$HOME/.config/hypr" ]] || [[ -d "$HOME/.config/quickshell" ]]; then
    echo -e "${YELLOW}📦 Backup existing configuration?${NC}"
    if ask_yes_no "Do you want to backup your current configuration?" "y"; then
        BACKUP_DIR="$HOME/.config/backup.$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        
        if [[ -d "$HOME/.config/hypr" ]]; then
            cp -r "$HOME/.config/hypr" "$BACKUP_DIR/"
            echo -e "${GREEN}✅ Hyprland backup created at $BACKUP_DIR/hypr${NC}"
        fi
        
        if [[ -d "$HOME/.config/quickshell" ]]; then
            cp -r "$HOME/.config/quickshell" "$BACKUP_DIR/"
            echo -e "${GREEN}✅ Quickshell backup created at $BACKUP_DIR/quickshell${NC}"
        fi
        
        if [[ -d "$HOME/.config/fish" ]]; then
            cp -r "$HOME/.config/fish" "$BACKUP_DIR/"
            echo -e "${GREEN}✅ Fish shell backup created at $BACKUP_DIR/fish${NC}"
        fi
    fi
fi

echo ""

# Choose installation type
INSTALL_TYPE=$(ask_choice "🎯 Choose installation type:" \
    "Full installation (Hyprland + Quickshell + Fish + All configs)" \
    "Hyprland only (Window manager configs)" \
    "Quickshell only (Shell configs)" \
    "Fish shell only (Terminal configs)" \
    "Custom selection")

case $INSTALL_TYPE in
    0) # Full installation
        INSTALL_HYPR=true
        INSTALL_QUICKSHELL=true
        INSTALL_FISH=true
        INSTALL_KITTY=true
        ;;
    1) # Hyprland only
        INSTALL_HYPR=true
        INSTALL_QUICKSHELL=false
        INSTALL_FISH=false
        INSTALL_KITTY=false
        ;;
    2) # Quickshell only
        INSTALL_HYPR=false
        INSTALL_QUICKSHELL=true
        INSTALL_FISH=false
        INSTALL_KITTY=false
        ;;
    3) # Fish only
        INSTALL_HYPR=false
        INSTALL_QUICKSHELL=false
        INSTALL_FISH=true
        INSTALL_KITTY=false
        ;;
    4) # Custom selection
        echo -e "${CYAN}🔧 Custom Selection:${NC}"
        INSTALL_HYPR=$(ask_yes_no "Install Hyprland configs?" "y")
        INSTALL_QUICKSHELL=$(ask_yes_no "Install Quickshell configs?" "y")
        INSTALL_FISH=$(ask_yes_no "Install Fish shell configs?" "y")
        INSTALL_KITTY=$(ask_yes_no "Install Kitty terminal configs?" "y")
        ;;
esac

echo ""

# GPU detection and optimization choice
echo -e "${BLUE}🎮 GPU Detection:${NC}"
if command -v nvidia-smi >/dev/null 2>&1; then
    echo -e "${GREEN}✅ NVIDIA GPU detected${NC}"
    if ask_yes_no "Apply NVIDIA optimizations for better performance?" "y"; then
        APPLY_NVIDIA_OPT=true
    else
        APPLY_NVIDIA_OPT=false
    fi
elif command -v lspci >/dev/null 2>&1 && lspci | grep -i vga | grep -i amd >/dev/null; then
    echo -e "${GREEN}✅ AMD GPU detected${NC}"
    APPLY_NVIDIA_OPT=false
elif command -v lspci >/dev/null 2>&1 && lspci | grep -i vga | grep -i intel >/dev/null; then
    echo -e "${GREEN}✅ Intel GPU detected${NC}"
    APPLY_NVIDIA_OPT=false
else
    echo -e "${YELLOW}⚠️  GPU not detected or unknown${NC}"
    APPLY_NVIDIA_OPT=false
fi

echo ""

# Package installation choice
echo -e "${BLUE}📦 Package Installation:${NC}"
if ask_yes_no "Do you want to install required packages automatically?" "y"; then
    INSTALL_PACKAGES=true
    
    # Choose package manager
    if command -v pacman >/dev/null 2>&1; then
        PACKAGE_MANAGER="pacman"
        echo -e "${GREEN}✅ Arch Linux detected (pacman)${NC}"
    elif command -v apt >/dev/null 2>&1; then
        PACKAGE_MANAGER="apt"
        echo -e "${GREEN}✅ Debian/Ubuntu detected (apt)${NC}"
    elif command -v dnf >/dev/null 2>&1; then
        PACKAGE_MANAGER="dnf"
        echo -e "${GREEN}✅ Fedora detected (dnf)${NC}"
    else
        echo -e "${YELLOW}⚠️  Unknown package manager. Please install packages manually.${NC}"
        INSTALL_PACKAGES=false
    fi
else
    INSTALL_PACKAGES=false
    echo -e "${YELLOW}⚠️  Skipping package installation. Please install required packages manually.${NC}"
fi

echo ""

# Timezone configuration
echo -e "${BLUE}🌍 Timezone Configuration:${NC}"
if ask_yes_no "Do you want to configure timezone?" "y"; then
    CONFIGURE_TIMEZONE=true
    
    # Common timezones
    TIMEZONE_CHOICE=$(ask_choice "Choose your timezone:" \
        "America/Sao_Paulo (Brazil)" \
        "America/New_York (US East)" \
        "America/Los_Angeles (US West)" \
        "Europe/London (UK)" \
        "Europe/Paris (France)" \
        "Asia/Tokyo (Japan)" \
        "Custom timezone")
    
    case $TIMEZONE_CHOICE in
        0) TIMEZONE="America/Sao_Paulo" ;;
        1) TIMEZONE="America/New_York" ;;
        2) TIMEZONE="America/Los_Angeles" ;;
        3) TIMEZONE="Europe/London" ;;
        4) TIMEZONE="Europe/Paris" ;;
        5) TIMEZONE="Asia/Tokyo" ;;
        6) 
            read -p "Enter your timezone (e.g., America/Sao_Paulo): " TIMEZONE
            ;;
    esac
else
    CONFIGURE_TIMEZONE=false
fi

echo ""

# Summary
echo -e "${BLUE}📋 Installation Summary:${NC}"
echo -e "  Hyprland configs: $([ "$INSTALL_HYPR" = true ] && echo -e "${GREEN}✅ Yes${NC}" || echo -e "${RED}❌ No${NC}")"
echo -e "  Quickshell configs: $([ "$INSTALL_QUICKSHELL" = true ] && echo -e "${GREEN}✅ Yes${NC}" || echo -e "${RED}❌ No${NC}")"
echo -e "  Fish shell configs: $([ "$INSTALL_FISH" = true ] && echo -e "${GREEN}✅ Yes${NC}" || echo -e "${RED}❌ No${NC}")"
echo -e "  Kitty terminal configs: $([ "$INSTALL_KITTY" = true ] && echo -e "${GREEN}✅ Yes${NC}" || echo -e "${RED}❌ No${NC}")"
echo -e "  NVIDIA optimizations: $([ "$APPLY_NVIDIA_OPT" = true ] && echo -e "${GREEN}✅ Yes${NC}" || echo -e "${RED}❌ No${NC}")"
echo -e "  Install packages: $([ "$INSTALL_PACKAGES" = true ] && echo -e "${GREEN}✅ Yes${NC}" || echo -e "${RED}❌ No${NC}")"
echo -e "  Configure timezone: $([ "$CONFIGURE_TIMEZONE" = true ] && echo -e "${GREEN}✅ Yes${NC}" || echo -e "${RED}❌ No${NC}")"

echo ""
if ! ask_yes_no "Proceed with installation?" "y"; then
    echo -e "${YELLOW}Installation cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}🚀 Starting installation...${NC}"

# Install packages
if [ "$INSTALL_PACKAGES" = true ]; then
    echo -e "${YELLOW}📦 Installing packages...${NC}"
    
    case $PACKAGE_MANAGER in
        "pacman")
            # Core packages (essential for the dotfile to work)
            echo -e "${YELLOW}📦 Installing core packages...${NC}"
            sudo pacman -S --needed hyprland quickshell fish fastfetch
            
            # Audio
            echo -e "${YELLOW}🎵 Installing audio packages...${NC}"
            sudo pacman -S --needed pipewire pipewire-pulse wireplumber
            
            # Utilities
            echo -e "${YELLOW}🔧 Installing utility packages...${NC}"
            sudo pacman -S --needed wlogout fuzzel playerctl brightnessctl
            
            # Essential applications
            echo -e "${YELLOW}💻 Installing essential applications...${NC}"
            sudo pacman -S --needed kitty
            
            # Web browsers
            echo -e "${YELLOW}🌐 Installing web browsers...${NC}"
            if ask_yes_no "Install Google Chrome?" "y"; then
                # Install Chrome from AUR
                if command -v yay >/dev/null 2>&1; then
                    yay -S google-chrome
                elif command -v paru >/dev/null 2>&1; then
                    paru -S google-chrome
                else
                    echo -e "${YELLOW}⚠️  Please install yay or paru to install Chrome from AUR${NC}"
                    echo -e "${YELLOW}   Or install manually: https://www.google.com/chrome/${NC}"
                fi
            fi
            
            # Development tools
            echo -e "${YELLOW}💻 Installing development tools...${NC}"
            if ask_yes_no "Install Cursor (VS Code alternative)?" "y"; then
                # Install Cursor from AUR
                if command -v yay >/dev/null 2>&1; then
                    yay -S cursor
                elif command -v paru >/dev/null 2>&1; then
                    paru -S cursor
                else
                    echo -e "${YELLOW}⚠️  Please install yay or paru to install Cursor from AUR${NC}"
                    echo -e "${YELLOW}   Or download from: https://cursor.sh/${NC}"
                fi
            fi
            
            # Communication and media
            echo -e "${YELLOW}📱 Installing communication and media apps...${NC}"
            if ask_yes_no "Install Discord and Spotify?" "y"; then
                sudo pacman -S --needed discord spotify
            fi
            
            # API testing
            echo -e "${YELLOW}🔌 Installing API testing tools...${NC}"
            if ask_yes_no "Install Insomnia (API testing tool)?" "y"; then
                # Install Insomnia from AUR
                if command -v yay >/dev/null 2>&1; then
                    yay -S insomnia-bin
                elif command -v paru >/dev/null 2>&1; then
                    paru -S insomnia-bin
                else
                    echo -e "${YELLOW}⚠️  Please install yay or paru to install Insomnia from AUR${NC}"
                    echo -e "${YELLOW}   Or download from: https://insomnia.rest/download${NC}"
                fi
            fi
            
            # AUR helper installation
            if ! command -v yay >/dev/null 2>&1 && ! command -v paru >/dev/null 2>&1; then
                echo -e "${YELLOW}📦 AUR helper not found. Installing yay...${NC}"
                if ask_yes_no "Install yay (AUR helper) for installing packages from AUR?" "y"; then
                    cd /tmp
                    git clone https://aur.archlinux.org/yay.git
                    cd yay
                    makepkg -si
                    cd "$OLDPWD"
                fi
            fi
            ;;
        "apt")
            echo -e "${YELLOW}⚠️  Please install packages manually on Debian/Ubuntu${NC}"
            echo "Required packages: hyprland, quickshell, fish, fastfetch, pipewire, wlogout, fuzzel, playerctl, brightnessctl"
            ;;
        "dnf")
            echo -e "${YELLOW}⚠️  Please install packages manually on Fedora${NC}"
            echo "Required packages: hyprland, quickshell, fish, fastfetch, pipewire, wlogout, fuzzel, playerctl, brightnessctl"
            ;;
    esac
fi

# Install Hyprland configs
if [ "$INSTALL_HYPR" = true ]; then
    echo -e "${YELLOW}🎨 Installing Hyprland configuration...${NC}"
    
    # Remove existing config if it exists
    if [[ -d "$HOME/.config/hypr" ]]; then
        rm -rf "$HOME/.config/hypr"
    fi
    
    # Copy new config
    cp -r hypr "$HOME/.config/"
    
    # Apply NVIDIA optimizations if requested
    if [ "$APPLY_NVIDIA_OPT" = true ]; then
        echo -e "${GREEN}✅ NVIDIA optimizations applied${NC}"
    else
        # Remove NVIDIA config if not needed
        rm -f "$HOME/.config/hypr/custom/nvidia.conf"
        # Remove NVIDIA reference from main config
        sed -i '/source=custom\/nvidia.conf/d' "$HOME/.config/hypr/hyprland.conf"
    fi
    
    echo -e "${GREEN}✅ Hyprland configuration installed${NC}"
fi

# Install Quickshell configs
if [ "$INSTALL_QUICKSHELL" = true ]; then
    echo -e "${YELLOW}🎨 Installing Quickshell configuration...${NC}"
    
    # Remove existing config if it exists
    if [[ -d "$HOME/.config/quickshell" ]]; then
        rm -rf "$HOME/.config/quickshell"
    fi
    
    # Copy new config
    cp -r quickshell "$HOME/.config/"
    
    echo -e "${GREEN}✅ Quickshell configuration installed${NC}"
fi

# Install Fish shell configs
if [ "$INSTALL_FISH" = true ]; then
    echo -e "${YELLOW}🐟 Installing Fish shell configuration...${NC}"
    
    # Create fish config directory if it doesn't exist
    mkdir -p "$HOME/.config/fish/functions"
    
    # Copy fish configs
    if [[ -f "fish/config.fish" ]]; then
        cp fish/config.fish "$HOME/.config/fish/"
    fi
    
    if [[ -f "fish/functions/fish_greeting.fish" ]]; then
        cp fish/functions/fish_greeting.fish "$HOME/.config/fish/functions/"
        chmod +x "$HOME/.config/fish/functions/fish_greeting.fish"
    fi
    
    echo -e "${GREEN}✅ Fish shell configuration installed${NC}"
fi

# Install Kitty configs
if [ "$INSTALL_KITTY" = true ]; then
    echo -e "${YELLOW}🐱 Installing Kitty terminal configuration...${NC}"
    
    # Create kitty config directory if it doesn't exist
    mkdir -p "$HOME/.config/kitty"
    
    # Copy kitty config
    if [[ -f "kitty/kitty.conf" ]]; then
        cp kitty/kitty.conf "$HOME/.config/kitty/"
    fi
    
    echo -e "${GREEN}✅ Kitty terminal configuration installed${NC}"
fi

# Configure timezone
if [ "$CONFIGURE_TIMEZONE" = true ]; then
    echo -e "${YELLOW}🌍 Configuring timezone...${NC}"
    if timedatectl set-timezone "$TIMEZONE" 2>/dev/null; then
        echo -e "${GREEN}✅ Timezone set to $TIMEZONE${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not set timezone automatically. Please run: sudo timedatectl set-timezone $TIMEZONE${NC}"
    fi
fi

echo ""
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo ""
echo -e "${CYAN}🎵 Welcome to Hyprsune Miku!${NC}"
echo ""
echo -e "${BLUE}📋 What's next:${NC}"
echo -e "  1. Restart your session or reboot"
echo -e "  2. Test the volume controls: Super+Shift+↑/↓"
echo -e "  3. Test media controls: Super+Shift+P (play/pause)"
echo -e "  4. Open terminal to see the Fish greeting"
echo ""
echo -e "${YELLOW}💡 Tips:${NC}"
echo -e "  • Use Super+Shift+W to switch Waybar layouts"
echo -e "  • Use Super+Slash to open the cheatsheet"
echo -e "  • Use Super+A/N to toggle sidebars"
echo ""
echo -e "${GREEN}Enjoy your new Hatsune Miku themed system! 🎵💚${NC}"
