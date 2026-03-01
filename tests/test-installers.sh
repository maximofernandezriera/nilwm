#!/bin/sh
# NilWM installer test battery
# Runs WITHOUT root: syntax checks, shellcheck, package-name validation, URL checks
# Usage: sh tests/test-installers.sh
set -e

PASS=0
FAIL=0
WARN=0

pass() { PASS=$((PASS + 1)); printf "  \033[32mPASS\033[0m %s\n" "$1"; }
fail() { FAIL=$((FAIL + 1)); printf "  \033[31mFAIL\033[0m %s\n" "$1"; }
warn() { WARN=$((WARN + 1)); printf "  \033[33mWARN\033[0m %s\n" "$1"; }
section() { printf "\n\033[1m── %s ──\033[0m\n" "$1"; }

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS="$REPO_ROOT/scripts"

# ════════════════════════════════════════════
section "1. Shell syntax check (sh -n)"
# ════════════════════════════════════════════
for f in "$SCRIPTS"/install-*.sh "$SCRIPTS"/nilwm-*.sh; do
    name=$(basename "$f")
    if sh -n "$f" 2>/dev/null; then
        pass "$name syntax OK"
    else
        fail "$name has syntax errors"
    fi
done

# ════════════════════════════════════════════
section "2. Shellcheck (if available)"
# ════════════════════════════════════════════
if command -v shellcheck >/dev/null 2>&1; then
    for f in "$SCRIPTS"/install-*.sh "$SCRIPTS"/nilwm-*.sh; do
        name=$(basename "$f")
        if shellcheck -S warning -s sh "$f" >/dev/null 2>&1; then
            pass "$name shellcheck clean"
        else
            warn "$name has shellcheck warnings"
            shellcheck -S warning -s sh "$f" 2>&1 | head -20
        fi
    done
else
    warn "shellcheck not installed — skipping lint (install with: sudo apt-get install shellcheck)"
fi

# ════════════════════════════════════════════
section "3. Debian package names validation"
# ════════════════════════════════════════════
# Verify install-debian.sh does NOT reference bare 'xsetroot' as a package
if grep -qE '^\s*git xsetroot' "$SCRIPTS/install-debian.sh"; then
    fail "install-debian.sh still references bare 'xsetroot' package (should be x11-xserver-utils)"
else
    pass "install-debian.sh uses correct package for xsetroot"
fi

# Verify x11-xserver-utils IS present
if grep -q 'x11-xserver-utils' "$SCRIPTS/install-debian.sh"; then
    pass "install-debian.sh includes x11-xserver-utils"
else
    fail "install-debian.sh missing x11-xserver-utils"
fi

# ════════════════════════════════════════════
section "4. Arch package names validation"
# ════════════════════════════════════════════
if grep -q 'xorg-xsetroot' "$SCRIPTS/install-arch.sh"; then
    pass "install-arch.sh uses xorg-xsetroot (correct)"
else
    fail "install-arch.sh missing xorg-xsetroot"
fi

# ════════════════════════════════════════════
section "5. Error handling in installers"
# ════════════════════════════════════════════
for f in "$SCRIPTS"/install-*.sh; do
    name=$(basename "$f")
    if grep -qE '(WARNING|Continuing anyway|may not have installed)' "$f"; then
        pass "$name has package-manager error handling"
    else
        fail "$name lacks package-manager error handling"
    fi
done

# ════════════════════════════════════════════
section "6. set -e present in all installers"
# ════════════════════════════════════════════
for f in "$SCRIPTS"/install-*.sh; do
    name=$(basename "$f")
    if grep -q '^set -e' "$f"; then
        pass "$name has 'set -e'"
    else
        fail "$name missing 'set -e'"
    fi
done

# ════════════════════════════════════════════
section "7. Root check present in all installers"
# ════════════════════════════════════════════
for f in "$SCRIPTS"/install-*.sh; do
    name=$(basename "$f")
    if grep -q 'id -u' "$f"; then
        pass "$name has root check"
    else
        fail "$name missing root check"
    fi
done

# ════════════════════════════════════════════
section "8. README raw URL uses correct branch"
# ════════════════════════════════════════════
README="$REPO_ROOT/README.md"
if grep -q 'raw.githubusercontent.com.*nilwm/main/' "$README"; then
    fail "README.md still uses /main/ branch (should be /master/)"
else
    pass "README.md does not use /main/ branch"
fi
if grep -q 'raw.githubusercontent.com.*nilwm/master/' "$README"; then
    pass "README.md uses /master/ branch"
else
    warn "README.md has no raw URL (check manually)"
fi

# ════════════════════════════════════════════
section "9. Raw URL reachability (curl HEAD)"
# ════════════════════════════════════════════
RAW_URL="https://raw.githubusercontent.com/maximofernandezriera/nilwm/master/scripts/install-debian.sh"
if command -v curl >/dev/null 2>&1; then
    # Note: this will fail until the fix is pushed — that's expected pre-push
    HTTP_CODE=$(curl -sI -o /dev/null -w "%{http_code}" "$RAW_URL" 2>/dev/null || echo "000")
    if [ "$HTTP_CODE" = "200" ]; then
        pass "Raw URL returns HTTP 200: $RAW_URL"
    elif [ "$HTTP_CODE" = "404" ]; then
        warn "Raw URL returns 404 (expected if not yet pushed): $RAW_URL"
    else
        warn "Raw URL returned HTTP $HTTP_CODE: $RAW_URL"
    fi
else
    warn "curl not available — skipping URL check"
fi

# ════════════════════════════════════════════
section "10. NilWM binary compiles"
# ════════════════════════════════════════════
DWM_DIR="$REPO_ROOT/dwm"
if [ -f "$DWM_DIR/Makefile" ]; then
    if make -C "$DWM_DIR" clean >/dev/null 2>&1 && make -C "$DWM_DIR" >/dev/null 2>&1; then
        pass "nilwm binary compiles successfully"
        if [ -x "$DWM_DIR/nilwm" ]; then
            pass "nilwm binary is executable"
        else
            fail "nilwm binary not found or not executable after build"
        fi
    else
        fail "nilwm compilation failed"
    fi
else
    fail "dwm/Makefile not found"
fi

# ════════════════════════════════════════════
section "RESULTS"
# ════════════════════════════════════════════
printf "\n\033[32m%d passed\033[0m, \033[31m%d failed\033[0m, \033[33m%d warnings\033[0m\n\n" "$PASS" "$FAIL" "$WARN"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
