# Limitations vs OXWM

NilWM replicates OXWM's behavior as closely as possible using DWM, but some differences are inherent to the architecture.

## Configuration

| Feature | OXWM | NilWM | Notes |
|---------|------|-------|-------|
| Config language | Lua | C (config.h) | Requires recompile after changes |
| Hot reload | Yes (`Mod+Shift+R` instant) | Restart only | `Mod+Shift+R` restarts WM (no X restart) |
| LSP autocomplete | Yes | N/A | — |
| Runtime config changes | Yes | No | Must edit config.h and recompile |

## Layouts

| Feature | OXWM | NilWM | Notes |
|---------|------|-------|-------|
| Tiling | Yes | Yes | Identical behavior |
| Floating (Normie) | Yes | Yes | Identical behavior |
| Monocle | Yes | Yes | Identical behavior |
| Grid | Yes | Yes | Equivalent behavior |
| Tabbed | Yes | **No** | DWM tabbed patch is complex; not included in v0.1 |
| Scrolling | Yes | **No** | Unique to OXWM; no DWM equivalent |

## Status Bar

| Feature | OXWM | NilWM | Notes |
|---------|------|-------|-------|
| Block system | Built-in Lua API | Shell script | Functional parity, different implementation |
| Per-block colors | Yes | **No** | Plain text via xsetroot |
| Underline indicators | Yes | **No** | DWM bar doesn't support underlines without status2d patch |
| Per-block intervals | Yes | **No** | Single 5s interval for all blocks |
| Tag color schemes (3 states) | Yes | Partial | DWM supports normal/selected; "occupied" uses a dot indicator |

## Keybindings

| Feature | OXWM | NilWM | Notes |
|---------|------|-------|-------|
| Keychords (multi-key) | Yes | **No** | `Mod+Space then T` not supported; would require keychord patch |
| Keybind overlay | Yes (built-in) | Yes (dmenu-based) | Same functionality, different presentation |

## Window Rules

| Feature | OXWM | NilWM | Notes |
|---------|------|-------|-------|
| Match by class | Yes | Yes | — |
| Match by instance | Yes | Yes | — |
| Match by title | Yes | Yes | — |
| Match by role | Yes | **No** | DWM doesn't check WM_WINDOW_ROLE |
| Force fullscreen in rules | Yes | **No** | Use keybind instead |

## Window Management

| Feature | OXWM | NilWM | Notes |
|---------|------|-------|-------|
| Sticky windows | Yes | **No** | Would require sticky patch; planned for future |
| Persistent tags across restart | Yes (X11 properties) | **No** | Tags reset on restart |

## Planned for Future Versions

- Tabbed layout (DWM tab patch)
- Keychord support (keychord patch)
- Sticky windows (sticky patch)
- Tag persistence across restarts
- status2d for per-block colors
- Scrolling layout (custom implementation)
