#!/bin/bash
WALLPAPER_DIR="$HOME/.local/share/wallpapers"

option=$({
printf "Everforest\0icon\x1f%s\n"    ~/.config/rofi/swatches/everforest.png
printf "Gruvbox\0icon\x1f%s\n"       ~/.config/rofi/swatches/gruvbox.png
printf "Monochrome\0icon\x1f%s\n"    ~/.config/rofi/swatches/monochrome.png
printf "Tokyo Night\0icon\x1f%s\n"   ~/.config/rofi/swatches/tokyonight.png
printf "Catppuccin Mocha\0icon\x1f%s\n" ~/.config/rofi/swatches/catppuccin.png
printf "Dracula\0icon\x1f%s\n"       ~/.config/rofi/swatches/dracula.png
printf "Rose Pine\0icon\x1f%s\n"     ~/.config/rofi/swatches/rosepine.png
printf "Nord\0icon\x1f%s\n"          ~/.config/rofi/swatches/nord.png
} | rofi -dmenu -i -p "Wallpaper Themes" -show-icons -theme "$HOME/.config/rofi/themes/wallpaper-theme-selector.rasi")
[ -z "$option" ] && exit 1

TARGET_DIR="$WALLPAPER_DIR/$option"
if [ ! -d "$TARGET_DIR" ]; then
    notify-send "Wallpaper Error" "Directory does not exist:\n$TARGET_DIR"
    exit 1
fi

THUMB_DIR="$HOME/.cache/wallpaper-thumbs/$option"
mkdir -p "$THUMB_DIR"

selected_wallpaper=$(find "$WALLPAPER_DIR/$option" -type f -exec basename {} \; | \
    while read -r wallpaper; do
        thumb="$THUMB_DIR/$wallpaper"
        if [ ! -f "$thumb" ]; then
            tmp_flat="$THUMB_DIR/_tmp_flat_${wallpaper}.png"
            tmp_mask="$THUMB_DIR/_tmp_mask_${wallpaper}.png"
            magick "$WALLPAPER_DIR/$option/$wallpaper" \
                -resize 415x240^ -gravity center -extent 415x240 "$tmp_flat"
            magick -size 415x240 xc:none -fill white -draw "roundrectangle 0,0,414,239,20,20" "$tmp_mask"
            magick "$tmp_flat" "$tmp_mask" -alpha off -compose CopyOpacity -composite "$thumb"
            rm "$tmp_flat" "$tmp_mask"
        fi
        printf "%s\0icon\x1f%s\n" "$wallpaper" "$thumb"
    done | \
    rofi -dmenu -p "$option Wallpapers" -show-icons -theme "$HOME/.config/rofi/themes/wallpaper-selector.rasi")

[ -z "$selected_wallpaper" ] && exit 1

awww img "$WALLPAPER_DIR/$option/$selected_wallpaper" --transition-type wipe --transition-fps 60 --transition-angle 30

