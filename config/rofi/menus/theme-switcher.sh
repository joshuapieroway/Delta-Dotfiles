#!/bin/bash
COLORSCHEMES_DIR="$HOME/.config/colorschemes"

option=$({
printf "Everforest\0icon\x1f%s\n"    ~/.config/rofi/swatches/everforest.png
printf "Gruvbox\0icon\x1f%s\n"       ~/.config/rofi/swatches/gruvbox.png
printf "Monochrome\0icon\x1f%s\n"    ~/.config/rofi/swatches/monochrome.png
printf "Tokyo Night\0icon\x1f%s\n"   ~/.config/rofi/swatches/tokyonight.png
printf "Catppuccin Mocha\0icon\x1f%s\n" ~/.config/rofi/swatches/catppuccin.png
printf "Dracula\0icon\x1f%s\n"       ~/.config/rofi/swatches/dracula.png
printf "Rose Pine\0icon\x1f%s\n"     ~/.config/rofi/swatches/rosepine.png
printf "Nord\0icon\x1f%s\n"          ~/.config/rofi/swatches/nord.png
} | rofi -dmenu -i -p "Themes" -show-icons -theme "$HOME/.config/rofi/themes/wallpaper-theme-selector.rasi")
[ -z "$option" ] && exit 0

# Apply a matching wallpaper
WALLPAPER_DIR="$HOME/.local/share/wallpapers/$option"
if [ -d "$WALLPAPER_DIR" ]; then
    # Populate array with image paths (supports jpg, jpeg, png, webp)
    shopt -s nullglob
    wallpapers=( "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp} )
    shopt -u nullglob

    if [ ${#wallpapers[@]} -gt 0 ]; then
        # Pick a random index
        random_index=$(( RANDOM % ${#wallpapers[@]} ))
        selected_wallpaper="${wallpapers[$random_index]}"
        if command -v awww &> /dev/null; then
            awww img "$selected_wallpaper" --transition-type center --transition-fps 60
	fi
	echo "nigga"
    else
        notify-send "Theme switcher" "Warning: No images found in $WALLPAPER_DIR"
    fi
else
    notify-send "Theme switcher" "Warning: Wallpaper directory $WALLPAPER_DIR does not exist"
fi

# Apply Kitty colors
KITTY_SRC="$COLORSCHEMES_DIR/$option/kitty/colors.conf"
KITTY_DEST="$HOME/.config/kitty/colors.conf"
if [ -f "$KITTY_SRC" ]; then
    cp -f "$KITTY_SRC" "$KITTY_DEST"
    echo "kitty confirm"
else
    notify-send "Theme switcher" "Warning: Kitty config not found for $option"
fi

# Apply Hyprland colors
HYPR_SRC="$COLORSCHEMES_DIR/$option/hyprland/colors.lua"
HYPR_DEST="$HOME/.config/hypr/colors.lua"
if [ -f "$HYPR_SRC" ]; then
    cp -f "$HYPR_SRC" "$HYPR_DEST"
    hyprctl reload &
    echo "hyprland confirm"
else
    notify-send "Theme switcher" "Warning: Hyprland config not found for $option"
fi

# Apply Waybar colors
WAYBAR_SRC="$COLORSCHEMES_DIR/$option/waybar/colors.css"
WAYBAR_DEST="$HOME/.config/waybar/colors.css"
if [ -f "$WAYBAR_SRC" ]; then
    cp -f "$WAYBAR_SRC" "$WAYBAR_DEST"
    killall waybar
    waybar &
    echo "waybar confirm"
else
    notify-send "Theme switcher" "Warning: Waybar config not found for $option"
fi

# Apply Rofi colors
ROFI_SRC="$COLORSCHEMES_DIR/$option/rofi/colors.rasi"
ROFI_DEST="$HOME/.config/rofi/themes/colors.rasi"
if [ -f "$ROFI_SRC" ]; then
    cp -f "$ROFI_SRC" "$ROFI_DEST"
    echo "rofi confirm"
else
    notify-send "Theme switcher" "Warning: Rofi config not found for $option"
fi

declare -A GTK_THEMES=(
    ["Everforest"]="Everforest-B-MB-Dark"
    ["Gruvbox"]="gruvbox-dark-gtk"
    ["Monochrome"]="Adwaita-dark"
    ["Tokyo Night"]="Tokyonight-Dark"
    ["Catppuccin Mocha"]="catppuccin-mocha-lavender-standard+default"
    ["Dracula"]="Dracula"
    ["Rose Pine"]="rose-pine-gtk"
    ["Nord"]="Nordic-darker"
)

target_gtk="${GTK_THEMES[$option]}"
if [ -n "$target_gtk" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "$target_gtk"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

    GTK3_INI="$HOME/.config/gtk-3.0/settings.ini"
    if [ -f "$GTK3_INI" ]; then
        sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$target_gtk/" "$GTK3_INI"
    else
        mkdir -p "$HOME/.config/gtk-3.0"
        echo -e "[Settings]\ngtk-theme-name=$target_gtk\ngtk-application-prefer-dark-theme=1" > "$GTK3_INI"
    fi
    echo "gtk theme confirm"
else
    notify-send "Theme switcher" "Switched to $option (No explicit GTK theme mapped)"
fi
