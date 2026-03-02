#!/bin/sh
# NilWM status bar — shell-pure status generator
# Mimics OXWM bar blocks: RAM, datetime, battery (if available)
# Updates xsetroot -name every 5 seconds

get_ram() {
    if [ -f /proc/meminfo ]; then
        totalk=$(awk '/^MemTotal/ {print $2}' /proc/meminfo)
        availk=$(awk '/^MemAvailable/ {print $2}' /proc/meminfo)
        usedk=$((totalk - availk))
        # Convert KB to GB with one decimal
        total=$(awk "BEGIN {print $totalk/1048576}")
        used=$(awk "BEGIN {print $usedk/1048576}")
        printf "RAM: %.1f/%.1f GB" "$used" "$total"
    fi
}

get_battery() {
    bat="/sys/class/power_supply/BAT0"
    [ -d "$bat" ] || bat="/sys/class/power_supply/BAT1"
    [ -d "$bat" ] || return

    cap=$(cat "$bat/capacity" 2>/dev/null) || return
    status=$(cat "$bat/status" 2>/dev/null)

    case "$status" in
        Charging)    printf "⚡ %s%%" "$cap" ;;
        Discharging) printf "- %s%%" "$cap" ;;
        Full)        printf "✓ %s%%" "$cap" ;;
        *)           printf "Bat: %s%%" "$cap" ;;
    esac
}

get_datetime() {
    date "+%a, %b %d - %-I:%M %P"
}

while true; do
    ram=$(get_ram)
    bat=$(get_battery)
    dt=$(get_datetime)

    # Build status string (mimic OXWM block order)
    status=""
    [ -n "$ram" ] && status="$ram"
    [ -n "$bat" ] && status="$status | $bat"
    [ -n "$dt" ]  && status="$status | $dt"

    xsetroot -name "$status"
    sleep 5
done
