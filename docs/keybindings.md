# Keybindings

NilWM replicates OXWM's default keybindings. All bindings use `Super` (Mod4) as the modifier key.

## Window Management

| Key | Action | OXWM equivalent |
|-----|--------|-----------------|
| `Super+Return` | Spawn terminal (st) | `oxwm.spawn("st")` |
| `Super+D` | Launch dmenu | `oxwm.spawn("dmenu_run")` |
| `Super+Q` | Kill focused window | `oxwm.client.kill()` |
| `Super+Shift+Q` | Quit NilWM | `oxwm.quit()` |
| `Super+Shift+R` | Restart NilWM | `oxwm.restart()` |

## Focus & Stack

| Key | Action | OXWM equivalent |
|-----|--------|-----------------|
| `Super+J` | Focus next window | `oxwm.client.focus_stack(1)` |
| `Super+K` | Focus previous window | `oxwm.client.focus_stack(-1)` |
| `Super+Shift+J` | Move window down in stack | `oxwm.client.move_stack(1)` |
| `Super+Shift+K` | Move window up in stack | `oxwm.client.move_stack(-1)` |
| `Super+Tab` | Toggle last viewed tag | — |

## Fullscreen & Floating

| Key | Action | OXWM equivalent |
|-----|--------|-----------------|
| `Super+Shift+F` | Toggle fullscreen | `oxwm.client.toggle_fullscreen()` |
| `Super+Shift+Space` | Toggle floating | `oxwm.client.toggle_floating()` |

## Layouts

| Key | Action | OXWM equivalent |
|-----|--------|-----------------|
| `Super+C` | Tiling layout `[T]` | `oxwm.layout.set("tiling")` |
| `Super+F` | Floating layout `[F]` | `oxwm.layout.set("normie")` |
| `Super+M` | Monocle layout `[M]` | `oxwm.layout.set("monocle")` |
| `Super+G` | Grid layout `[G]` | `oxwm.layout.set("grid")` |
| `Super+N` | Cycle to next layout | `oxwm.layout.cycle()` |

## Master Area

| Key | Action | OXWM equivalent |
|-----|--------|-----------------|
| `Super+H` | Shrink master area | `oxwm.set_master_factor(-5)` |
| `Super+L` | Grow master area | `oxwm.set_master_factor(5)` |
| `Super+I` | Increase master count | `oxwm.inc_num_master(1)` |
| `Super+P` | Decrease master count | `oxwm.inc_num_master(-1)` |

## Gaps

| Key | Action | OXWM equivalent |
|-----|--------|-----------------|
| `Super+A` | Toggle gaps on/off | `oxwm.toggle_gaps()` |
| `Super+Shift+A` | Reset gaps to defaults | — |

## Tags

| Key | Action | OXWM equivalent |
|-----|--------|-----------------|
| `Super+1-9` | View tag | `oxwm.tag.view(n)` |
| `Super+Shift+1-9` | Move window to tag | `oxwm.tag.move_to(n)` |
| `Super+Ctrl+1-9` | Toggle view tag | `oxwm.tag.toggleview(n)` |
| `Super+Ctrl+Shift+1-9` | Toggle tag on window | `oxwm.tag.toggletag(n)` |
| `Super+0` | View all tags | — |
| `Super+Shift+0` | Tag window to all tags | — |

## Multi-Monitor

| Key | Action | OXWM equivalent |
|-----|--------|-----------------|
| `Super+Comma` | Focus previous monitor | `oxwm.monitor.focus(-1)` |
| `Super+Period` | Focus next monitor | `oxwm.monitor.focus(1)` |
| `Super+Shift+Comma` | Send to previous monitor | `oxwm.monitor.tag(-1)` |
| `Super+Shift+Period` | Send to next monitor | `oxwm.monitor.tag(1)` |

## Mouse

| Input | Action | OXWM equivalent |
|-------|--------|-----------------|
| `Super+Button1` | Move window (drag) | Same |
| `Super+Button3` | Resize window (drag) | Same |
| Hover | Focus follows mouse | Same |
| Click tag in bar | Switch to tag | Same |

## System

| Key | Action |
|-----|--------|
| `Super+B` | Toggle status bar |
| `Super+Shift+/` | Show keybind overlay |

## Customizing

Edit `dwm/config.h` and recompile:
```sh
cd ~/.local/src/nilwm/dwm
# edit config.h
sudo make clean install
```
Then restart with `Super+Shift+R`.
