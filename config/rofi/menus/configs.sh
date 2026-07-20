#!/bin/bash
option=$(printf "Hyprland\nKitty\nWaybar\nNeovim\nRofi\nSwayNC\nWlogout" | rofi -dmenu -i -p "Edit Config")

case "$option" in
    "Hyprland") kitty --hold nvim "$HOME/.config/hypr/" ;;
    "Kitty") kitty --hold nvim "$HOME/.config/kitty/" ;;
    "Waybar") kitty --hold nvim "$HOME/.config/waybar/" ;;
    "Neovim") kitty --hold nvim "$HOME/.config/nvim/" ;;
    "Rofi") kitty --hold nvim "$HOME/.config/rofi/" ;;
    "SwayNC") kitty --hold nvim "$HOME/.config/swaync/" ;;
    "Wlogout") kitty --hold nvim "$HOME/.config/wlogout/" ;;
esac
