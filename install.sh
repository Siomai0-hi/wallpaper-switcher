#!/usr/bin/env bash
# wallpaper-switcher installer
# Usage: ./install.sh
set -euo pipefail

cd "$(dirname "$0")"

PREFIX="${PREFIX:-$HOME}"
BIN_DIR="$PREFIX/.local/bin"
CONFIG_DIR="$PREFIX/.config/rofi"
THEME_DIR="$PREFIX/.local/share/rofi/themes"
APPLICATIONS_DIR="$PREFIX/.local/share/applications"

mkdir -p "$BIN_DIR" "$CONFIG_DIR" "$THEME_DIR" "$APPLICATIONS_DIR"

echo "Installing to $BIN_DIR ..."
install -m755 bin/wallpaper-pick bin/wallpaper-cycle bin/wallpaper-add "$BIN_DIR/"
install -m644 config/config.rasi "$CONFIG_DIR/config.rasi"
install -m644 config/nord.rasi "$THEME_DIR/nord.rasi"

# Generate the panel/menu launcher with an absolute Exec path
sed "s|Exec=wallpaper-pick|Exec=$BIN_DIR/wallpaper-pick|" \
    config/wallpaper-pick.desktop > "$APPLICATIONS_DIR/wallpaper-pick.desktop"

# Refresh the KDE desktop-file database (optional)
if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 >/dev/null 2>&1 || true
fi

echo
echo "Installed:"
echo "  $BIN_DIR/wallpaper-pick"
echo "  $BIN_DIR/wallpaper-cycle"
echo "  $BIN_DIR/wallpaper-add"
echo "  $CONFIG_DIR/config.rasi"
echo "  $THEME_DIR/nord.rasi"
echo "  $APPLICATIONS_DIR/wallpaper-pick.desktop"
echo
echo "Usage:"
echo "  wallpaper-pick                 # open the grid picker"
echo "  wallpaper-cycle next|prev|random|<number>"
echo "  wallpaper-add <image file> ..."
echo
echo "Note: if ~/.local/bin is not in PATH, add it:"
echo "  echo 'PATH=%h/.local/bin:\$PATH' > ~/.config/environment.d/10-path.conf"
echo "  (re-login afterwards)"