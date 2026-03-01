# NilWM

A tiling window manager that replicates [OXWM](https://github.com/tonybanters/oxwm)'s look and behavior, built entirely on [DWM](https://dwm.suckless.org/) — no Zig or Rust required.

NilWM gives you OXWM's Tokyo Night aesthetic, keybindings, gaps, layouts, and status bar on any system with a C compiler and X11.

## Features (OXWM parity)

- **9 tag workspaces** with multi-tag viewing and sticky windows
- **Layouts**: Tiling `[T]`, Floating `[F]`, Monocle `[M]`, Grid `[G]`
- **Configurable gaps** (inner/outer) with smart gaps and runtime toggle (`Super+A`)
- **Tokyo Night color scheme** — `#1a1b26` background, `#6dade3` focused border, `#bbbbbb` unfocused
- **OXWM-matching keybindings** — `Super+Return`, `Super+D`, `Super+Q`, `Super+J/K`, etc.
- **Status bar** with RAM, battery, and datetime blocks (shell-pure, via `xsetroot`)
- **Multi-monitor** support (Xinerama)
- **Focus follows mouse**
- **Move windows in stack** (`Super+Shift+J/K`)
- **Toggle fullscreen** (`Super+Shift+F`)
- **Keybind overlay** (`Super+Shift+/`)
- **Self-restart** (`Super+Shift+R`) without killing X

## Quick Install

Each script installs **Xorg + xinit + fonts + build tools**, compiles NilWM, and sets up `.xinitrc`. No graphical environment needed beforehand.

### Debian / Ubuntu
```sh
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/maximofernandezriera/nilwm/master/scripts/install-debian.sh)"
```
Or clone and run locally:
```sh
git clone https://github.com/maximofernandezriera/nilwm.git
sudo sh nilwm/scripts/install-debian.sh
```

### Alpine Linux
```sh
git clone https://github.com/maximofernandezriera/nilwm.git
doas sh nilwm/scripts/install-alpine.sh
```

### Void Linux
```sh
git clone https://github.com/maximofernandezriera/nilwm.git
sudo sh nilwm/scripts/install-void.sh
```

### Arch Linux
```sh
git clone https://github.com/maximofernandezriera/nilwm.git
sudo sh nilwm/scripts/install-arch.sh
```

After installation, start with:
```sh
startx
```

## Default Keybindings

| Key | Action |
|-----|--------|
| `Super+Return` | Spawn terminal (st) |
| `Super+D` | Launch dmenu |
| `Super+Q` | Kill focused window |
| `Super+Shift+Q` | Quit NilWM |
| `Super+Shift+R` | Restart NilWM |
| `Super+J/K` | Focus next/prev window |
| `Super+Shift+J/K` | Move window in stack |
| `Super+H/L` | Shrink/grow master area |
| `Super+I/P` | Inc/dec master count |
| `Super+C` | Tiling layout |
| `Super+F` | Floating layout |
| `Super+M` | Monocle layout |
| `Super+G` | Grid layout |
| `Super+N` | Cycle layouts |
| `Super+A` | Toggle gaps |
| `Super+Shift+F` | Toggle fullscreen |
| `Super+Shift+Space` | Toggle floating |
| `Super+1-9` | View tag |
| `Super+Shift+1-9` | Move window to tag |
| `Super+Ctrl+1-9` | Toggle view tag |
| `Super+Comma/Period` | Focus prev/next monitor |
| `Super+Shift+Comma/Period` | Send to prev/next monitor |
| `Super+Shift+/` | Keybind overlay |
| `Super+B` | Toggle bar |
| `Super+Button1` | Move window (mouse) |
| `Super+Button3` | Resize window (mouse) |

## Documentation

- [Installation](docs/installation.md)
- [Keybindings](docs/keybindings.md)
- [Layouts](docs/layouts.md)
- [Status Bar](docs/status-bar.md)
- [Theming](docs/theming.md)
- [Window Rules](docs/window-rules.md)
- [Limitations vs OXWM](docs/limitations.md)

## How It Works

NilWM is a patched build of DWM 6.5 with:
- **Vanitygaps** — inner/outer gaps with smart gaps and runtime toggle
- **Grid layout** — equal-sized grid arrangement
- **Movestack** — move windows up/down in the stack
- **Fullscreen toggle** — actual fullscreen (not just monocle)
- **Self-restart** — re-exec without killing X session
- **Cycle layout** — rotate through available layouts

The status bar is a standalone shell script (`nilwm-status.sh`) that updates `xsetroot -name` every 5 seconds with RAM usage, battery status, and date/time.

## License

MIT — see [dwm/LICENSE](dwm/LICENSE)
