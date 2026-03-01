#!/bin/sh
# NilWM installer for Debian/Ubuntu
# Installs Xorg, build tools, compiles and installs NilWM
# Usage: sudo sh install-debian.sh
set -e

REPO_URL="https://github.com/maximofernandezriera/nilwm.git"
SRC_DIR="$HOME/.local/src/nilwm"
TIMESTAMP=$(date +%s)

echo "=== NilWM Installer (Debian) ==="

# ── Must be root for package installation ──
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Run as root: sudo sh $0"
    exit 1
fi
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")
SRC_DIR="$REAL_HOME/.local/src/nilwm"

# ── 1. Install Xorg, xinit, fonts and build dependencies ──
echo "[1/6] Installing packages..."
apt-get update -qq
apt-get install -y -qq \
    xorg xinit \
    build-essential \
    libx11-dev libxft-dev libxinerama-dev libfreetype6-dev libfontconfig1-dev \
    fonts-dejavu fonts-liberation \
    dmenu suckless-tools \
    git xsetroot >/dev/null

# Install st terminal if not present
if ! command -v st >/dev/null 2>&1; then
    echo "[1b/6] Building st terminal..."
    tmpst=$(mktemp -d)
    git clone https://git.suckless.org/st "$tmpst/st" 2>/dev/null
    cd "$tmpst/st"
    make clean install >/dev/null 2>&1
    rm -rf "$tmpst"
fi

# ── 2. Clone or update NilWM ──
echo "[2/6] Fetching NilWM source..."
if [ -d "$SRC_DIR/.git" ]; then
    su -c "cd '$SRC_DIR' && git pull -q" "$REAL_USER"
else
    su -c "mkdir -p '$(dirname $SRC_DIR)' && git clone '$REPO_URL' '$SRC_DIR'" "$REAL_USER" 2>/dev/null
fi

# ── 3. Compile NilWM ──
echo "[3/6] Compiling NilWM..."
cd "$SRC_DIR/dwm"
make clean >/dev/null 2>&1 || true
make >/dev/null 2>&1

# ── 4. Install binary and scripts ──
echo "[4/6] Installing NilWM..."
make install
install -m 755 "$SRC_DIR/scripts/nilwm-status.sh"   /usr/local/bin/nilwm-status.sh
install -m 755 "$SRC_DIR/scripts/nilwm-keybinds.sh"  /usr/local/bin/nilwm-keybinds.sh

# ── 5. Set up session ──
echo "[5/6] Configuring session..."
# Desktop session file for display managers
mkdir -p /usr/share/xsessions
install -m 644 "$SRC_DIR/nilwm.desktop" /usr/share/xsessions/nilwm.desktop

# xinitrc (with backup)
XINITRC="$REAL_HOME/.xinitrc"
if [ -f "$XINITRC" ]; then
    cp "$XINITRC" "${XINITRC}.bak.${TIMESTAMP}"
    echo "  Backed up existing .xinitrc"
fi
cat > "$XINITRC" << 'XEOF'
#!/bin/sh
nilwm-status.sh &
exec nilwm
XEOF
chown "$REAL_USER:$REAL_USER" "$XINITRC"
chmod 755 "$XINITRC"

# ── 6. Done ──
echo "[6/6] Done!"
echo ""
echo "NilWM installed. Start with:"
echo "  startx"
echo ""
echo "Keybindings: Super+Return (terminal), Super+D (dmenu), Super+Shift+/ (help)"
