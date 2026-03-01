# Layouts

NilWM provides four layouts matching OXWM's layout set.

## Tiling `[T]` (default)

Master/stack layout. The master window occupies the left portion; stack windows split the right vertically.

- **Switch**: `Super+C`
- **Adjust master width**: `Super+H` (shrink) / `Super+L` (grow)
- **Adjust master count**: `Super+I` (more) / `Super+P` (fewer)

OXWM equivalent: `oxwm.layout.set("tiling")`

## Floating `[F]`

All windows float freely. Move and resize with the mouse.

- **Switch**: `Super+F`
- **Move**: `Super+Button1` drag
- **Resize**: `Super+Button3` drag
- **Toggle single window**: `Super+Shift+Space`

OXWM equivalent: `oxwm.layout.set("normie")`

## Monocle `[M]`

Fullscreen stacking — one window visible at a time, filling the screen (respecting gaps if enabled).

- **Switch**: `Super+M`
- **Cycle windows**: `Super+J/K`

OXWM equivalent: `oxwm.layout.set("monocle")`

## Grid `[G]`

Windows arranged in an equal-sized grid. Columns and rows are computed automatically based on window count.

- **Switch**: `Super+G`

OXWM equivalent: `oxwm.layout.set("grid")`

## Cycling Layouts

Press `Super+N` to cycle through all available layouts in order: Tiling → Floating → Monocle → Grid → Tiling → ...

OXWM equivalent: `oxwm.layout.cycle()`

## Layout Symbols

The current layout is shown in the status bar:

| Symbol | Layout |
|--------|--------|
| `[T]` | Tiling |
| `[F]` | Floating |
| `[M]` | Monocle (shows window count, e.g. `[3]`) |
| `[G]` | Grid |

## Gaps in Layouts

All tiled layouts (Tiling, Monocle, Grid) respect the configured gaps:
- **Inner gaps**: space between windows (default: 5px)
- **Outer gaps**: space between windows and screen edges (default: 5px)
- **Smart gaps**: when only one window is visible, gaps are removed
- **Toggle**: `Super+A` to enable/disable gaps at runtime
