#!/bin/bash

# Script simples para instalar e configurar teclado BR

echo "🇧🇷 Configurando Teclado BR (Brasil) 🇧🇷"
echo ""

echo "📦 1. Instalando fcitx5..."
sudo pacman -S --noconfirm fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt

echo ""
echo "⚙️ 2. Configurando layout do sistema..."
sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br abnt2

echo ""
echo "🔧 3. Configuração do Hyprland já foi atualizada!"
echo "   - Layout: br (já configurado em ~/.config/hypr/hyprland/general.conf)"
echo "   - Input method: fcitx5 (atualizado em ~/.config/hypr/hyprland/env.conf)"

echo ""
echo "🚀 4. Para aplicar as mudanças:"
echo "   - Faça logout/login do Hyprland"
echo "   - Ou reinicie o sistema"
echo "   - Use Ctrl+Space para alternar entre layouts"

echo ""
echo "✅ Configuração completa!"
echo "   Layouts disponíveis: US, BR, BR ABNT2"
