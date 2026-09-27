# Wallpaper Switcher

Quick wallpaper switcher & picker for **KDE Plasma, GNOME, Hyprland, Sway, XFCE + more**
using **rofi** — it auto-detects your desktop session and applies the wallpaper
with the right tool (swww / gsettings / xfconf / hyprctl / swaybg /
plasma-apply / feh).

Pick a wallpaper visually with a **Nord-themed grid** (Alt+Tab style), search it
by name, favourite it, rotate it on a timer, and add new images directly from
within the picker — no system settings needed.

![CI](https://github.com/Siomai0-hi/wallpaper-switcher/actions/workflows/shellcheck.yml/badge.svg)

![Nord grid picker](https://raw.githubusercontent.com/Siomai0-hi/wallpaper-switcher/main/.github/picker.png)

## Features

- **Visual picker** — a Nord-themed rofi grid where each tile is the wallpaper
  itself (image fills the tile, filename overlaid small at the bottom; scrollable)
- **Search box** — the picker's input bar filters the grid live by filename
  (case-insensitive, client-side — no extra process)
- **Shuffle** — "Shuffle" tile or `Ctrl+R` applies a random wallpaper instantly
- **Favorites** — mark wallpapers (`wallpaper-fav`), browse favorites only in the
  picker's "Favorites" view, or rotate through them (`wallpaper-cycle fav`)
- **Auto-rotate** — an optional systemd `--user` timer (default 30 min) rotates the
  wallpaper; toggle from the picker's "Auto-rotate" tile or `wallpaper-rotate on|off`
- **Multi-monitor** — on multi-monitor Hyprland/X11 the picker asks which monitor
  to apply to; `wallpaper-cycle ... <monitor>` accepts a monitor name (swww `-o`)
- **Pywal (optional)** — set `PYWAL=1` in the config; after applying, `wal -i`
  extracts a colorscheme in the background and notifies on success
- **Multi-DE support** — detects the session (GNOME, XFCE, Hyprland, Sway, KDE, …)
  and applies via the matching tool — **swww** gives smooth fades on Hyprland,
  with a `feh` fallback
- **Alt+Tab-style switcher** — navigate with arrows + Enter (`Ctrl+N`/`Ctrl+P`
  also move next/prev), or click
- **Add images right in the picker** — multi-select a file, it is copied into your
  wallpaper library and the grid refreshes automatically
- **`wallpaper-cycle`** — quick `next / prev / random / fav / <index>` cycling
- **`wallpaper-add`** — CLI helper to import images (auto-renames on name clashes)
- Scans multiple wallpaper folders — drop new images anywhere and they appear
- **Esc / Ctrl+Q / Ctrl+G** close the picker without changes (rofi default cancel)

## Dependencies

| Package | Reason |
|---|---|
| `rofi` | picker UI (v2 recommended) |
| `zenity` | file picker for the add flow |
| `file` | image type validation |
| `libnotify` (`notify-send`) | notifications |
| `python-pillow` | optional — baked filename captions + thumbnails in the picker |
| `pywal` | optional — colorscheme extraction (`PYWAL=1`) |
| desktop tool | one of: `swww`, `gsettings`, `xfconf`, `hyprctl`+`hyprpaper`, `swaybg`, `plasma-apply-wallpaperimage`, `feh` (picked automatically) |

Install on Arch (KDE example):

```bash
sudo pacman -S rofi zenity file libnotify python-pillow plasma-workspace
# Hyprland + smooth fades:
sudo pacman -S swww       # plus hyprland/hyprpaper if you prefer no transitions
# pywal (optional):
sudo pacman -S python-pywal
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
- Nord themes → `~/.local/share/rofi/themes/` (grid + list prompt)
- systemd user units → `~/.config/systemd/user/` (rotation timer)
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

The package installs to `/usr` (scripts, themes, launcher, systemd units); it
depends on `rofi`, `zenity`, `file`, `libnotify` (optionally `python-pillow` for
picker captions, `pywal` for colorschemes). Packaging sources live in
`packaging/aur/`.

## Usage

### Open the picker

```bash
wallpaper-pick
```

Or add the **"Wallpaper Switcher"** launcher to your panel / assign a shortcut
(a good combo: `wallpaper-cycle next` on `Super+W`, `wallpaper-pick` on `Super+Shift+W`).

**In the picker:**

- `↑ ↓ ← →` navigate · `Enter` apply · `Esc` / `Ctrl+Q` / `Ctrl+G` cancel
- **Type** to filter the grid by filename (live search)
- `Ctrl+R` — apply a random wallpaper immediately
- **"Add wallpaper"** → pick image files (multi-select with `Ctrl`), the grid
  refreshes automatically
- **"Shuffle"** → apply a random wallpaper
- **"Favorites" / "All images"** → toggle between all wallpapers and favorites only
- **"Auto-rotate: On/Off"** → enable/disable the rotation timer
- With **more than one monitor** connected, applying an image asks which monitor
  to set (or "All monitors")

### Cycle wallpapers

```bash
wallpaper-cycle next            # next image
wallpaper-cycle prev            # previous image
wallpaper-cycle random          # random image
wallpaper-cycle fav             # random favourite
wallpaper-cycle 5               # 5th image in the sorted list
wallpaper-cycle random DP-2     # apply to monitor DP-2 specifically (swww)
```

### Favorites

```bash
wallpaper-fav list              # show all favorites
wallpaper-fav add ~/.local/share/wallpapers/foo.jpg
wallpaper-fav remove foo.jpg    # remove by exact path
wallpaper-fav toggle foo.jpg    # star/unstar
```

Favorites are stored as plain absolute paths in
`~/.config/wallpaper-switcher/favorites` — easy to edit by hand.

### Auto-rotate

```bash
wallpaper-rotate on        # enable the 30-min rotation timer
wallpaper-rotate off       # disable it
wallpaper-rotate status    # systemctl is-active output
```

The timer (`wallpaper-rotate.timer`, user unit) fires 5 min after login and then
every 30 min; change the interval in `~/.config/systemd/user/wallpaper-rotate.timer`
(`OnUnitActiveSec=30min`) and run `systemctl --user daemon-reload`. Rotation is
event-driven by systemd — nothing polls or sleeps between rotations, so idle CPU
stays at 0%.

### Add images (CLI)

```bash
wallpaper-add ~/Downloads/photo.png
wallpaper-add a.jpg b.png c.webp
```

### Configuration file

Optional, `~/.config/wallpaper-switcher/config` (shell-sourced):

```bash
PYWAL=1          # run `wal -i <image>` after applying (pywal installed?)
MONITOR=DP-2     # always apply to this monitor (default: ask on multi-monitor)
FAV_ONLY=1       # wallpaper-rotate rotates favorites only
# ROT_INTERVAL is a display hint in the notification; edit the .timer for the real interval
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

## Performance notes

- Thumbnails are generated **once** per image into `~/.cache/wallpaper-pick/`
  and skipped via an mtime check — full-size images are only decoded on a cold
  cache, and the decoder uses `PIL.Image.draft()` so it never decodes more than
  thumbnail resolution.
- Wallpaper changes are short-lived external processes (`swww img`, …); the app
  never keeps a loop, poller, or image in memory between actions.
- Auto-rotate runs via a systemd `--user` timer, not a background thread — 0%
  CPU while idle.

## Structure

```
bin/
  wallpaper-pick     # rofi grid picker (Nord) with search / shuffle / favorites /
                     # auto-rotate tiles + add flow + monitor prompt
  wallpaper-cycle    # next / prev / random / fav / <index> [monitor]
  wallpaper-add      # CLI image import
  wallpaper-fav      # favorites list manager (add/remove/toggle/list)
  wallpaper-rotate   # systemd-timer entry point + on/off/status
config/
  wallpaper-nord.rasi      # Nord grid theme (search box + Ctrl+R binding in config.rasi)
  wallpaper-nord-list.rasi # small list theme for prompts (monitor selection)
  config.rasi              # minimal rofi config (show-icons, kb-custom-1)
  wallpaper-rotate.service # oneshot unit for the rotation timer
  wallpaper-rotate.timer   # 30-min rotation timer (user unit)
  wallpaper-pick.desktop
install.sh
.github/workflows/shellcheck.yml   # CI: shellcheck on every push/PR
packaging/aur/                     # PKGBUILD + .SRCINFO for the AUR
```

## Customization

- **Grid size / icon size** — edit `columns`, `lines`, `element-icon { size: … }`
  in `config/wallpaper-nord.rasi`
- **Rotation interval** — `~/.config/systemd/user/wallpaper-rotate.timer`
- **More folders** — add paths to the `find` command inside
  `bin/wallpaper-pick` / `bin/wallpaper-cycle`

## License

[MIT](LICENSE) © 2026 Siomai0-hi