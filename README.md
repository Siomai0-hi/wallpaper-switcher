# Wallpaper Switcher

Quick wallpaper switcher & picker for **KDE Plasma (Wayland/X11)** using **rofi**.

Pick a wallpaper visually with a **Nord-themed grid** (Alt+Tab style), cycle with
terminal commands or hotkeys, and add new images directly from within the picker —
no system settings needed.

![CI](https://github.com/Siomai0-hi/wallpaper-switcher/actions/workflows/shellcheck.yml/badge.svg)

![Nord grid picker](https://raw.githubusercontent.com/Siomai0-hi/wallpaper-switcher/main/.github/picker.png)

## Features

- **Visual picker** — a Nord-themed rofi grid with actual image thumbnails (scrollable)
- **Alt+Tab-style switcher** — navigate with arrows + Enter, or click
- **Add images right in the picker** — multi-select a file, it is copied into your
  wallpaper library and the grid refreshes automatically
- **`wallpaper-cycle`** — quick `next / prev / random / <index>` cycling
- **`wallpaper-add`** — CLI helper to import images (auto-renames on name clashes)
- Scans multiple wallpaper folders — drop new images anywhere and they appear
- **Esc / Ctrl+Q / Ctrl+G** close the picker without changes (rofi default cancel)

## Dependencies

| Package | Reason |
|---|---|
| `rofi` | picker UI (v2 recommended) |
| `plasma-workspace` (`plasma-apply-wallpaperimage`) | applies the wallpaper |
| `zenity` | file picker for the add flow |
| `file` | image type validation |
| `libnotify` (`notify-send`) | notifications |

Install on Arch:

```bash
sudo pacman -S rofi plasma-workspace zenity file libnotify
```

## Install

```bash
git clone https://github.com/Siomai0-hi/wallpaper-switcher.git
cd wallpaper-switcher
./install.sh
```

The installer copies:

- scripts → `~/.local/bin/`
- rofi config → `~/.config/rofi/`
- Nord theme → `~/.local/share/rofi/themes/`
- app launcher → `~/.local/share/applications/`

If `~/.local/bin` is not in your `PATH`, add it (KDE Plasma has it by default):

```bash
# ~/.config/environment.d/10-path.conf
PATH=%h/.local/bin:$PATH
```

## AUR

On Arch, the package is on the AUR as `wallpaper-switcher`:

```bash
yay -S wallpaper-switcher     # or: paru -S wallpaper-switcher
```

or build it manually from the AUR repo:

```bash
git clone https://aur.archlinux.org/wallpaper-switcher.git
cd wallpaper-switcher
makepkg -si
```

The package installs to `/usr` (scripts, system theme, launcher); it depends on
`rofi`, `plasma-workspace`, `zenity`, `file`, `libnotify`. Packaging sources live
in `packaging/aur/`.

## Usage

### Open the picker

```bash
wallpaper-pick
```

Or add the **"Wallpaper Switcher"** launcher to your panel / assign a shortcut
(a good combo: `wallpaper-cycle next` on `Super+W`, `wallpaper-pick` on `Super+Shift+W`).

**In the picker:**

- `↑ ↓ ← →` navigate · `Enter` apply · `Esc` / `Ctrl+Q` / `Ctrl+G` cancel
- **"Нэмэх шинэ зураг..."** (Add) → pick image files (multi-select with `Ctrl`),
  the grid refreshes automatically

### Cycle wallpapers

```bash
wallpaper-cycle next      # next image
wallpaper-cycle prev      # previous image
wallpaper-cycle random    # random image
wallpaper-cycle 5         # 5th image in the sorted list
```

### Add images (CLI)

```bash
wallpaper-add ~/Downloads/photo.png
wallpaper-add a.jpg b.png c.webp
```

## Scanned folders

```
~/Desktop
~/.local/share/backgrounds
~/.local/share/wallpapers          <- main library (where the picker adds to)
~/Pictures/wallpapers
~/Pictures/Wallpapers
```

Supported formats: **jpg jpeg png webp bmp gif** — anything dropped into these
folders appears in the picker on the next launch. No config needed.

## Structure

```
bin/
  wallpaper-pick     # rofi grid picker (Nord) with add flow
  wallpaper-cycle    # next / prev / random / <index>
  wallpaper-add      # CLI image import
config/
  wallpaper-nord.rasi  # Nord theme for rofi (unique name, no clash with rofi-themes)
  config.rasi        # minimal rofi config (show-icons)
  wallpaper-pick.desktop
install.sh
.github/workflows/shellcheck.yml   # CI: shellcheck on every push/PR
packaging/aur/                     # PKGBUILD + .SRCINFO for the AUR
```

## Customization

- **Grid size / icon size** — edit `columns`, `lines`, `element-icon { size: … }`
  in `config/wallpaper-nord.rasi`
- **More folders** — add paths to the `find` command inside
  `bin/wallpaper-pick` / `bin/wallpaper-cycle`

## License

[MIT](LICENSE) © 2026 Siomai0-hi