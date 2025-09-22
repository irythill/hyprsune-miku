#!/usr/bin/env fish

# Hatsune Miku themed Fish greeting
# Based on hyprsune-miku dotfile

function fish_greeting
    echo -e (set_color -o cyan)"╔════════════════════════════════════════════════════╗"
    echo -e "║  🎵 One, two, three, ready? Miku Miku Miiiiiiii 🎵 ║"
    echo -e "╚════════════════════════════════════════════════════╝"(set_color normal)
    echo ""
    
    echo -e (set_color -o magenta)"🎵 Welcome to your Hatsune Miku themed system!"(set_color normal)
    echo -e (set_color cyan)"💚 Volume controls: Super+Shift+↑/↓ (2%), Super+Shift+←/→ (5%)"(set_color normal)
    echo -e (set_color cyan)"🎶 Media controls: Super+Shift+N/B/P/S"(set_color normal)
    echo -e (set_color cyan)"🔇 Mute: Super+Shift+M, Mic: Super+Alt+M"(set_color normal)
    echo -e (set_color cyan)"🎨 Waybar switcher: Super+Shift+W"(set_color normal)
    echo -e (set_color cyan)"📋 Cheatsheet: Super+Slash"(set_color normal)
    echo ""
    
    # Show system info with fastfetch if available
    if command -v fastfetch >/dev/null 2>&1
        if test -f ~/.config/fastfetch/hatsune_ascii.txt
            fastfetch --file ~/.config/fastfetch/hatsune_ascii.txt
        else
            fastfetch
        end
    else
        echo -e (set_color yellow)"💡 Install fastfetch for a beautiful system info display!"(set_color normal)
    end
end