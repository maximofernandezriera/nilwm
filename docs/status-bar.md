# Status Bar

NilWM uses the built-in DWM bar for tags and layout symbol, and a **shell-pure script** (`nilwm-status.sh`) to display status blocks via `xsetroot -name`.

## Default Blocks

The status bar shows (matching OXWM's default blocks):

1. **RAM usage** — `RAM: 3.2/15.6 GB`
2. **Battery** (if available) — `⚡ 85%` / `- 42%` / `✓ 100%`
3. **Date/Time** — `Sat, Mar 01 - 3:10 pm`

Blocks are separated by ` | `.

## How It Works

The script runs in a loop, updating every 5 seconds:

```sh
while true; do
    # gather RAM, battery, datetime
    xsetroot -name "$status"
    sleep 5
done
```

It is started automatically by `~/.xinitrc`.

## Customizing

Edit `/usr/local/bin/nilwm-status.sh` (or `scripts/nilwm-status.sh` in the repo) to:

- Change update interval (modify `sleep 5`)
- Add new blocks (e.g., CPU, volume, network)
- Change date format (modify the `date` format string)
- Remove blocks you don't need

### Adding a custom block

Example — add CPU temperature:

```sh
get_temp() {
    temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
    [ -n "$temp" ] && printf "CPU: %s°C" "$((temp / 1000))"
}
```

Then add `$(get_temp)` to the status string in the main loop.

## Bar Appearance

The DWM bar uses the Tokyo Night color scheme:

| Element | Foreground | Background |
|---------|-----------|------------|
| Normal tags | `#bbbbbb` | `#1a1b26` |
| Selected tag | `#0db9d7` | `#1a1b26` |
| Status text | `#bbbbbb` | `#1a1b26` |

The bar font is `monospace:style=Bold:size=10`.

## Toggle Bar

Press `Super+B` to show/hide the bar.

## Comparison with OXWM

| Feature | OXWM | NilWM |
|---------|------|-------|
| Block system | Built-in Lua API | Shell script + xsetroot |
| Colors per block | Yes (per-block color) | Plain text (single color) |
| Underlines | Yes | Not supported |
| Update mechanism | Per-block intervals | Single interval (5s) |
| Click-to-switch tags | Yes | Yes (native DWM) |
