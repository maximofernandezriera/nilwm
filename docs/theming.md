# Theming

NilWM ships with the **Tokyo Night** color scheme, matching OXWM's defaults.

## Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| Background | `#1a1b26` | Bar background, dmenu background |
| Foreground | `#bbbbbb` | Normal text, unfocused border |
| Gray | `#444444` | — |
| Cyan | `#0db9d7` | Selected tag text |
| Blue | `#6dade3` | Focused window border |
| Purple | `#ad8ee6` | — |
| Red | `#f7768e` | — |
| Green | `#9ece6a` | — |

## Borders

| Property | Value | OXWM equivalent |
|----------|-------|-----------------|
| Border width | 2px | `oxwm.border.set_width(2)` |
| Focused border | `#6dade3` | `oxwm.border.set_focused_color("#6dade3")` |
| Unfocused border | `#bbbbbb` | `oxwm.border.set_unfocused_color("#bbbbbb")` |

## Gaps

| Property | Value | OXWM equivalent |
|----------|-------|-----------------|
| Inner horizontal | 5px | `oxwm.gaps.set_inner(5, 5)` |
| Inner vertical | 5px | |
| Outer horizontal | 5px | `oxwm.gaps.set_outer(5, 5)` |
| Outer vertical | 5px | |
| Smart gaps | On | `oxwm.gaps.set_smart(true)` |
| Toggle | `Super+A` | `oxwm.toggle_gaps()` |

## Font

The bar and dmenu use: `monospace:style=Bold:size=10`

This matches OXWM's `oxwm.bar.set_font("monospace:style=Bold:size=10")`.

## Customizing Colors

Edit `dwm/config.h` and change the color definitions:

```c
static const char col_bg[]     = "#1a1b26";  /* background */
static const char col_fg[]     = "#bbbbbb";  /* foreground / unfocused border */
static const char col_cyan[]   = "#0db9d7";  /* selected tag text */
static const char col_blue[]   = "#6dade3";  /* focused window border */
```

Then recompile:
```sh
cd ~/.local/src/nilwm/dwm
sudo make clean install
```

Restart NilWM with `Super+Shift+R`.

## Customizing Gaps

In `dwm/config.h`:

```c
static const int gappih = 5;   /* horizontal inner gap */
static const int gappiv = 5;   /* vertical inner gap */
static const int gappoh = 5;   /* horizontal outer gap */
static const int gappov = 5;   /* vertical outer gap */
static const int smartgaps = 1; /* no gaps with single window */
```

## Customizing Border Width

In `dwm/config.h`:

```c
static const unsigned int borderpx = 2;  /* border pixel of windows */
```
