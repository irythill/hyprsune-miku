# 🎵 Hyprsune Miku - A Hatsune Miku themed Hyprland Config!

A beautiful and optimized Hyprland configuration themed with Hatsune Miku colors, designed for performance on weaker hardware.

![Hatsune Miku](https://img.shields.io/badge/Theme-Hatsune%20Miku-86cecb?style=for-the-badge&logo=archlinux)
![Hyprland](https://img.shields.io/badge/Window%20Manager-Hyprland-86cecb?style=for-the-badge&logo=archlinux)
![Arch Linux](https://img.shields.io/badge/Distribution-Arch%20Linux-86cecb?style=for-the-badge&logo=archlinux)

## ✨ Features

- 🎨 **Modern Color Palette** - Clean and professional theme
- ⚡ **Performance Optimized** - Reduced effects for weaker GPUs (NVIDIA GT 710)
- 🔒 **Quickshell Integration** - Beautiful lock screen with custom wallpaper
- 🎵 **Custom Volume Controls** - Keyboard shortcuts for volume control
- 🐟 **Fish Shell** - Custom greeting with system instructions
- 🖼️ **Wallpaper Management** - Automatic wallpaper theming
- 🎯 **Smart Installer** - Interactive installation with user choices
- 📦 **Complete Package List** - All necessary applications included

## 🎨 Color Palette

```css
Background:  #373b3e (55,59,62)
Foreground:  #bec8d1 (190,200,209)
Accent:      #86cecb (134,206,203) - Hatsune Turquoise
Secondary:   #137a7f (19,122,127) - Deep Blue
Special:     #e12885 (225,40,133) - Hatsune Pink
```

## 📦 Required Packages

### Essential Packages (Core functionality)
- **hyprland** - Window manager
- **quickshell** - Shell and lock screen
- **fish** - Terminal shell
- **fastfetch** - System information display
- **kitty** - Terminal emulator

### Audio Packages
- **pipewire** - Audio server
- **pipewire-pulse** - PulseAudio compatibility
- **wireplumber** - Session manager

### Utility Packages
- **wlogout** - Logout menu
- **fuzzel** - Application launcher
- **playerctl** - Media control
- **brightnessctl** - Brightness control

### Applications (Optional but recommended)
- **google-chrome** - Web browser (from AUR)
- **cursor** - Code editor (from AUR)
- **discord** - Communication
- **spotify** - Music streaming
- **insomnia-bin** - API testing (from AUR)

### AUR Helper (Required for AUR packages)
- **yay** or **paru** - AUR package manager

## 🚀 Quick Start

### Prerequisites

- Arch Linux (or compatible distribution)
- NVIDIA drivers (for optimizations)
- AUR helper (yay or paru) for installing packages from AUR

### Installation

#### 🎯 Smart Installation (Recommended)

1. **Clone the repository:**

   ```bash
   git clone https://github.com/YOUR_USERNAME/hyprsune-miku.git
   cd hyprsune-miku
   ```

2. **Run the smart installer:**

   ```bash
   ./install-smart.sh
   ```

   The smart installer will:
   - Detect your GPU and apply appropriate optimizations
   - Let you choose what to install (Hyprland, Quickshell, Fish, etc.)
   - Automatically backup your existing configuration
   - Install required packages
   - Configure timezone
   - Guide you through the entire process

#### 🔧 Manual Installation

1. **Backup your current config:**

   ```bash
   mv ~/.config/hypr ~/.config/hypr.backup
   mv ~/.config/quickshell ~/.config/quickshell.backup
   ```

2. **Install the configuration:**

   ```bash
   cp -r hypr ~/.config/
   cp -r quickshell ~/.config/
   cp -r kitty ~/.config/
   ```

3. **Install required packages:**

   ```bash
   # Core packages (essential)
   sudo pacman -S hyprland quickshell fish fastfetch

   # Audio
   sudo pacman -S pipewire pipewire-pulse wireplumber

   # Utilities
   sudo pacman -S wlogout fuzzel playerctl brightnessctl

   # Essential applications
   sudo pacman -S kitty

   # Web browsers (from AUR)
   yay -S google-chrome

   # Development tools (from AUR)
   yay -S cursor

   # Communication and media
   sudo pacman -S discord spotify

   # API testing (from AUR)
   yay -S insomnia-bin
   ```

4. **Set up Fish shell:**
   ```bash
   # Install Fish greeting
   cp fish/functions/fish_greeting.fish ~/.config/fish/functions/
   cp fish/config.fish ~/.config/fish/
   cp fastfetch/hatsune_ascii.txt ~/.config/fastfetch/
   ```

## ⌨️ Key Bindings

### System

- `Super + L` - Lock screen (Quickshell)
- `Super + Q` - Close window
- `Super + Shift + Q` - Kill window
- `Super + Enter` - Open terminal
- `Super + D` - Application launcher

### Volume Control

- `Super + Shift + ↑` - Volume up (2%)
- `Super + Shift + ↓` - Volume down (2%)
- `Super + Shift + →` - Volume up (5%)
- `Super + Shift + ←` - Volume down (5%)
- `Super + Shift + M` - Toggle mute
- `Super + Alt + M` - Toggle microphone
- `Ctrl + Super + V` - Volume mixer

### Media

- `Super + Shift + N` - Next track
- `Super + Shift + B` - Previous track
- `Super + Shift + P` - Play/Pause

### Workspaces

- `Super + 1-9` - Switch to workspace
- `Super + Shift + 1-9` - Move window to workspace

## 🎯 Performance Optimizations

This configuration is optimized for weaker hardware:

- **Reduced blur effects** - Disabled for better performance
- **Simplified animations** - Faster, less resource-intensive
- **NVIDIA optimizations** - Specific settings for NVIDIA GPUs
- **Reduced shadows** - Lighter shadow effects
- **Optimized transparency** - Balanced transparency levels

## 🎵 Hatsune Miku Theme

The configuration includes a complete Hatsune Miku theme:

- **Custom color palette** in Quickshell
- **Hatsune Miku wallpaper** on lock screen
- **Custom Fish greeting** with ASCII art
- **Themed terminal** (Kitty) with matching colors
- **Material You colors** adapted for the theme

## 📁 File Structure

```
hyprland-dotfiles/
├── hypr/
│   ├── hyprland.conf          # Main configuration
│   ├── hyprland/
│   │   ├── general.conf       # General settings
│   │   ├── keybinds.conf      # Key bindings
│   │   ├── nvidia.conf        # NVIDIA optimizations
│   │   └── scripts/           # Custom scripts
│   └── custom/                # Custom configurations
├── quickshell/                # Quickshell configuration
│   └── ii/
│       ├── config.json        # Main Quickshell config
│       ├── modules/           # Quickshell modules
│       └── services/          # Quickshell services
├── fish/                      # Fish shell configuration
├── fastfetch/                 # System info display
├── install.sh                 # Automated installer
└── README.md                  # This file
```

## 🔧 Customization

### Changing Colors

Edit the color palette in:

- `hypr/hyprland/colors.conf` - Hyprland colors
- `quickshell/ii/modules/common/Appearance.qml` - Quickshell colors
- `quickshell/ii/config.json` - Quickshell appearance settings

### Adding Key Bindings

Add new key bindings in:

- `hypr/hyprland/keybinds.conf`

### Wallpaper

Replace the wallpaper at:

- `~/Imagens/Wallpapers/hatsune.jpg`

## 🐛 Troubleshooting

### Volume Controls Not Working

```bash
# Check if pipewire is running
systemctl --user status pipewire

# Restart audio services
systemctl --user restart pipewire
```

### Lock Screen Issues

```bash
# Restart Quickshell
pkill quickshell
quickshell -c ii &
```

### Performance Issues

- Check NVIDIA drivers: `nvidia-smi`
- Monitor GPU usage: `nvidia-smi -l 1`
- Adjust transparency in Quickshell settings

## 📸 Screenshots

_Add screenshots of your setup here_

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🔄 Updating

### Smart Update System

This repository includes a smart update script that preserves your Hatsune Miku customizations while updating from the latest end-4/dots-hyprland configuration.

#### Usage:

```bash
# Full update (recommended)
./update.sh

# Only create backup
./update.sh --backup

# Restore from latest backup
./update.sh --restore

# Show help
./update.sh --help
```

#### What gets preserved:

- **Quickshell Appearance** - Your Hatsune Miku color palette
- **Lock Screen** - Custom wallpaper and blur effects
- **Fish Greeting** - ASCII art and custom message
- **Keybinds** - Volume controls and custom shortcuts
- **Wallpapers** - Your custom wallpaper collection
- **Systemd Services** - Lock screen persistence

#### How it works:

1. Creates a backup of your current configuration
2. Downloads the latest end-4/dots-hyprland configuration
3. Preserves your Hatsune Miku customizations
4. Installs the updated configuration
5. Restores your custom files
6. Cleans up temporary files

This ensures you get the latest features and fixes while keeping your personal theme! 🎵

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [end-4](https://github.com/end-4/dots-hyprland) - Base files for my customization
- [Hyprland](https://hyprland.org/) - Amazing Wayland compositor
- [Quickshell](https://github.com/Quickshell/Quickshell) - Beautiful shell
- [Hatsune Miku](https://www.crypton.co.jp/miku_eng) - The inspiration for this theme

---

**Made with ❤️ by [irythill](https://linkedin.com/in/hsp), for all the Hatsune Miku enjoyers**
