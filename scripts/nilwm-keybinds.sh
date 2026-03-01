#!/bin/sh
# NilWM keybind overlay — displays keybindings via dmenu or xmessage
# Triggered by Super+Shift+/ (matching OXWM's show_keybinds)

KEYBINDS="Super+Return     Spawn terminal
Super+D          Launch dmenu
Super+Q          Kill window
Super+Shift+Q    Quit NilWM
Super+Shift+R    Restart NilWM
Super+J/K        Focus next/prev window
Super+Shift+J/K  Move window in stack
Super+H/L        Shrink/grow master area
Super+I/P        Inc/dec master count
Super+Shift+F    Toggle fullscreen
Super+Shift+Space Toggle floating
Super+C          Tiling layout
Super+F          Floating layout
Super+M          Monocle layout
Super+G          Grid layout
Super+N          Cycle layout
Super+A          Toggle gaps
Super+Shift+A    Reset gaps
Super+B          Toggle bar
Super+1-9        View tag
Super+Shift+1-9  Move window to tag
Super+Ctrl+1-9   Toggle view tag
Super+Ctrl+Shift+1-9 Toggle tag on window
Super+Comma      Focus prev monitor
Super+Period     Focus next monitor
Super+Shift+Comma  Send to prev monitor
Super+Shift+Period Send to next monitor
Super+Tab        Toggle last tag
Super+0          View all tags
Super+Button1    Move window (mouse)
Super+Button3    Resize window (mouse)
Super+Shift+/    Show this overlay"

if command -v dmenu >/dev/null 2>&1; then
    echo "$KEYBINDS" | dmenu -l 35 -p "NilWM Keybindings:" -fn "monospace:style=Bold:size=10" -nb "#1a1b26" -nf "#bbbbbb" -sb "#1a1b26" -sf "#0db9d7"
elif command -v xmessage >/dev/null 2>&1; then
    echo "$KEYBINDS" | xmessage -file - -title "NilWM Keybindings"
else
    notify-send "NilWM Keybindings" "$KEYBINDS" 2>/dev/null || echo "$KEYBINDS"
fi
