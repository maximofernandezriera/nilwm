#!/bin/sh
# NilWM status bar — shell-pure status generator
# Mimics OXWM bar blocks: CPU, RAM, datetime, battery (if available)
# Updates xsetroot -name every 5 seconds

# CPU state from previous sample (for delta calculation)
prev_total=0
prev_idle=0

get_cpu() {
    read cpu user nice sys idle iow irq sirq _rest < /proc/stat
    total=$((user + nice + sys + idle + iow + irq + sirq))
    idle_all=$((idle + iow))

    if [ "$prev_total" -gt 0 ]; then
        total_d=$((total - prev_total))
        idle_d=$((idle_all - prev_idle))
        if [ "$total_d" -gt 0 ]; then
            usage=$(( (total_d - idle_d) * 100 / total_d ))
            printf "CPU: %d%%" "$usage"
        fi
    fi

    prev_total=$total
    prev_idle=$idle_all
}

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
        Discharging) printf -- "🔋 %s%%" "$cap" ;;
        Full)        printf "✓ %s%%" "$cap" ;;
        *)           printf "Bat: %s%%" "$cap" ;;
    esac
}

get_datetime() {
    date "+%a, %b %d - %-I:%M %P"
}

while true; do
    cpu=$(get_cpu)
    ram=$(get_ram)
    bat=$(get_battery)
    dt=$(get_datetime)

    # Build status string (mimic OXWM block order)
    status=""
    [ -n "$cpu" ] && status="$cpu"
    [ -n "$ram" ] && status="${status:+$status | }$ram"
    [ -n "$bat" ] && status="${status:+$status | }$bat"
    [ -n "$dt" ]  && status="${status:+$status | }$dt"

    xsetroot -name "$status"
    sleep 5
done
