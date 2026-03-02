#!/bin/sh
# NilWM status bar and keybindings test battery
# Tests status bar components and config.h correctness
# Usage: sh tests/test-statusbar-keybinds.sh
set -e

PASS=0
FAIL=0
WARN=0

pass() { PASS=$((PASS + 1)); printf "  \033[32mPASS\033[0m %s\n" "$1"; }
fail() { FAIL=$((FAIL + 1)); printf "  \033[31mFAIL\033[0m %s\n" "$1"; }
warn() { WARN=$((WARN + 1)); printf "  \033[33mWARN\033[0m %s\n" "$1"; }
section() { printf "\n\033[1m── %s ──\033[0m\n" "$1"; }

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STATUS_SCRIPT="$REPO_ROOT/scripts/nilwm-status.sh"
CONFIG_H="$REPO_ROOT/dwm/config.h"

# Helper: extract only function definitions from status script (skip the while loop)
STATUS_FUNCS=$(mktemp)
sed '/^while true/,$d' "$STATUS_SCRIPT" > "$STATUS_FUNCS"

# ════════════════════════════════════════════
section "1. Status bar script - CPU function"
# ════════════════════════════════════════════
if [ -f "$STATUS_SCRIPT" ]; then
    # get_cpu needs two samples; call twice with a small delay
    cpu_output=$(sh -c '. '"$STATUS_FUNCS"'; get_cpu; sleep 1; get_cpu' 2>/dev/null)

    if echo "$cpu_output" | grep -qE '^CPU: [0-9]+%$'; then
        pass "get_cpu() produces valid output: $cpu_output"
    else
        fail "get_cpu() output invalid or empty: '$cpu_output'"
    fi

    # Verify CPU reads from /proc/stat
    if grep -q '/proc/stat' "$STATUS_SCRIPT"; then
        pass "get_cpu() reads from /proc/stat"
    else
        fail "get_cpu() does not read from /proc/stat"
    fi
else
    fail "Status script not found: $STATUS_SCRIPT"
fi

# ════════════════════════════════════════════
section "2. Status bar script - RAM function"
# ════════════════════════════════════════════
if [ -f "$STATUS_SCRIPT" ]; then
    ram_output=$(sh -c '. '"$STATUS_FUNCS"'; get_ram' 2>/dev/null | head -1)

    if echo "$ram_output" | grep -qE '^RAM: [0-9]+\.[0-9]+/[0-9]+\.[0-9]+ GB$'; then
        pass "get_ram() produces valid output: $ram_output"
    else
        fail "get_ram() output invalid or empty: '$ram_output'"
    fi

    # Verify no awk printf issues
    if grep -q 'printf.*%.1f.*awk' "$STATUS_SCRIPT"; then
        warn "Status script still uses awk printf (may cause issues)"
    else
        pass "Status script avoids problematic awk printf"
    fi
else
    fail "Status script not found: $STATUS_SCRIPT"
fi

# ════════════════════════════════════════════
section "3. Status bar script - Date function"
# ════════════════════════════════════════════
date_output=$(sh -c '. '"$STATUS_FUNCS"'; get_datetime' 2>/dev/null)
if echo "$date_output" | grep -qE '^[A-Z][a-z]{2}, [A-Z][a-z]{2} [0-9]{2} - [0-9]+:[0-9]{2} (am|pm)$'; then
    pass "get_datetime() produces valid output: $date_output"
else
    fail "get_datetime() output invalid: '$date_output'"
fi

# ════════════════════════════════════════════
section "4. Status bar script - Battery function"
# ════════════════════════════════════════════
bat_output=$(sh -c '. '"$STATUS_FUNCS"'; get_battery' 2>/dev/null || true)
if [ -d "/sys/class/power_supply/BAT0" ] || [ -d "/sys/class/power_supply/BAT1" ]; then
    if [ -n "$bat_output" ]; then
        pass "get_battery() produces output: $bat_output"
    else
        warn "get_battery() returned empty (battery hardware present)"
    fi
else
    if [ -z "$bat_output" ]; then
        pass "get_battery() correctly returns empty (no battery hardware)"
    else
        warn "get_battery() returned '$bat_output' but no battery hardware detected"
    fi
fi

# ════════════════════════════════════════════
section "5. Status bar script - Integration test"
# ════════════════════════════════════════════
# Run the script for 1 iteration and check xsetroot would be called
if command -v timeout >/dev/null 2>&1; then
    # Mock xsetroot to capture what would be set
    MOCK_XSETROOT=$(mktemp)
    cat > "$MOCK_XSETROOT" << 'EOF'
#!/bin/sh
echo "xsetroot called with: $*" >> /tmp/nilwm-test-xsetroot.log
EOF
    chmod +x "$MOCK_XSETROOT"
    
    rm -f /tmp/nilwm-test-xsetroot.log
    PATH="$(dirname $MOCK_XSETROOT):$PATH" timeout 1 sh "$STATUS_SCRIPT" 2>/dev/null || true
    
    if [ -f /tmp/nilwm-test-xsetroot.log ]; then
        log_content=$(cat /tmp/nilwm-test-xsetroot.log)
        if echo "$log_content" | grep -q "RAM:"; then
            pass "Status bar integration: RAM block present"
        else
            fail "Status bar integration: RAM block missing from output"
        fi
        rm -f /tmp/nilwm-test-xsetroot.log
    else
        warn "Status bar integration test skipped (timeout or xsetroot mock failed)"
    fi
    rm -f "$MOCK_XSETROOT"
else
    warn "timeout command not available - skipping integration test"
fi

# ════════════════════════════════════════════
section "6. config.h - layouts array termination"
# ════════════════════════════════════════════
if [ -f "$CONFIG_H" ]; then
    # Check for NULL terminator in layouts array
    if grep -A 10 'static const Layout layouts' "$CONFIG_H" | grep -q 'NULL.*NULL.*terminator'; then
        pass "layouts[] array has NULL terminator (prevents cyclelayout overflow)"
    else
        fail "layouts[] array missing NULL terminator (will cause Super+N bug)"
    fi
    
    # Count layout entries (excluding terminator)
    layout_count=$(grep -A 10 'static const Layout layouts' "$CONFIG_H" | grep -c '^\s*{.*tile\|monocle\|grid\|NULL.*}' || echo 0)
    if [ "$layout_count" -ge 4 ]; then
        pass "layouts[] has $layout_count entries (4 layouts + terminator expected)"
    else
        warn "layouts[] has only $layout_count entries"
    fi
else
    fail "config.h not found: $CONFIG_H"
fi

# ════════════════════════════════════════════
section "7. config.h - Super+N keybinding"
# ════════════════════════════════════════════
if grep -q 'XK_n.*cyclelayout' "$CONFIG_H"; then
    pass "Super+N mapped to cyclelayout"
else
    fail "Super+N not mapped to cyclelayout"
fi

# ════════════════════════════════════════════
section "8. config.h - Window rules sanity"
# ════════════════════════════════════════════
# Verify Gimp rule exists but is separate from layouts
if grep -q '"Gimp"' "$CONFIG_H"; then
    pass "Gimp window rule present"
    
    # Check that Gimp is in rules[] not layouts[]
    gimp_in_layouts=$(grep -A 10 'static const Layout layouts' "$CONFIG_H" | grep -c 'Gimp' || true)
    if [ "$gimp_in_layouts" = "0" ]; then
        pass "Gimp is NOT in layouts[] array (correct)"
    else
        fail "Gimp found in layouts[] array (memory corruption risk)"
    fi
else
    warn "Gimp window rule not found (expected for OXWM compatibility)"
fi

# ════════════════════════════════════════════
section "9. Compilation test with fixed config"
# ════════════════════════════════════════════
DWM_DIR="$REPO_ROOT/dwm"
if [ -f "$DWM_DIR/Makefile" ]; then
    if make -C "$DWM_DIR" clean >/dev/null 2>&1 && make -C "$DWM_DIR" >/dev/null 2>&1; then
        pass "nilwm compiles successfully with fixed config.h"
        
        if [ -x "$DWM_DIR/nilwm" ]; then
            pass "nilwm binary is executable"
        else
            fail "nilwm binary not executable after build"
        fi
    else
        fail "nilwm compilation failed with new config.h"
    fi
else
    fail "dwm/Makefile not found"
fi

# ════════════════════════════════════════════
section "10. Status script syntax and executability"
# ════════════════════════════════════════════
if sh -n "$STATUS_SCRIPT" 2>/dev/null; then
    pass "nilwm-status.sh has valid shell syntax"
else
    fail "nilwm-status.sh has syntax errors"
fi

if [ -x "$STATUS_SCRIPT" ]; then
    pass "nilwm-status.sh is executable"
else
    warn "nilwm-status.sh not executable (will be fixed on install)"
fi

# ════════════════════════════════════════════
section "11. Verify xsetroot availability"
# ════════════════════════════════════════════
if command -v xsetroot >/dev/null 2>&1; then
    pass "xsetroot command available"
else
    warn "xsetroot not available (install x11-xserver-utils on Debian)"
fi

# ════════════════════════════════════════════
section "RESULTS"
# ════════════════════════════════════════════
printf "\n\033[32m%d passed\033[0m, \033[31m%d failed\033[0m, \033[33m%d warnings\033[0m\n\n" "$PASS" "$FAIL" "$WARN"

if [ "$FAIL" -gt 0 ]; then
    echo "FAILED: Fix the issues above before deploying."
    exit 1
fi

if [ "$WARN" -gt 0 ]; then
    echo "WARNINGS: Review warnings but build is acceptable."
fi

echo "SUCCESS: All critical tests passed."
rm -f "$STATUS_FUNCS"
exit 0
