# Window Rules

NilWM supports automatic window configuration based on WM_CLASS properties, matching OXWM's `oxwm.rule.add()` functionality.

## Default Rules

| Class | Tags | Floating | OXWM equivalent |
|-------|------|----------|-----------------|
| `Gimp` | current | Yes | `oxwm.rule.add({ instance = "gimp", floating = true })` |
| `mpv` | current | Yes | `oxwm.rule.add({ instance = "mpv", floating = true })` |
| `Spotify` | tag 9 | No | `oxwm.rule.add({ class = "Spotify", tag = 8 })` |
| `discord` | tag 8 | No | `oxwm.rule.add({ class = "discord", tag = 7 })` |

## Adding Rules

Edit the `rules[]` array in `dwm/config.h`:

```c
static const Rule rules[] = {
    /* class      instance    title       tags mask     isfloating   monitor */
    { "Gimp",     NULL,       NULL,       0,            1,           -1 },
    { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
    { "Steam",    NULL,       NULL,       1 << 4,       1,           -1 },
};
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `class` | string/NULL | Match WM_CLASS class (second value) |
| `instance` | string/NULL | Match WM_CLASS instance (first value) |
| `title` | string/NULL | Match WM_NAME |
| `tags mask` | bitmask | Tag to send window to (`1 << n` for tag n+1, `0` = current) |
| `isfloating` | 0/1 | Force floating mode |
| `monitor` | int | Target monitor (`-1` = any) |

### Tag Bitmask Examples

| Expression | Tag |
|-----------|-----|
| `0` | Current tag |
| `1 << 0` | Tag 1 |
| `1 << 1` | Tag 2 |
| `1 << 8` | Tag 9 |
| `(1 << 2) \| (1 << 3)` | Tags 3 and 4 |

## Finding Window Properties

Use `xprop` to discover a window's class and instance:

```sh
xprop | grep WM_CLASS
```

Click on the target window. Output format:
```
WM_CLASS(STRING) = "Navigator", "firefox"
                    ^instance    ^class
```

The first value is `instance`, the second is `class`.

## Comparison with OXWM

| Feature | OXWM | NilWM |
|---------|------|-------|
| Match by class | Yes | Yes |
| Match by instance | Yes | Yes |
| Match by title | Yes | Yes |
| Match by role | Yes | Not supported (DWM limitation) |
| Force floating | Yes | Yes |
| Send to tag | Yes | Yes |
| Force fullscreen | Yes | Not in rules (use keybind) |
