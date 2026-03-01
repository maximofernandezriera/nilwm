# Installation

NilWM supports four Linux distributions. Each installer handles everything from a **minimal system with no graphical environment**.

## What the installer does

1. Installs **Xorg + xinit** (display server)
2. Installs **fonts** (DejaVu)
3. Installs **C toolchain** and X11 development headers
4. Builds **st** terminal (if not present)
5. Clones the NilWM repo to `~/.local/src/nilwm`
6. Compiles and installs the `nilwm` binary to `/usr/local/bin`
7. Installs helper scripts (`nilwm-status.sh`, `nilwm-keybinds.sh`)
8. Creates `~/.xinitrc` (with backup of any existing one)
9. Creates `/usr/share/xsessions/nilwm.desktop` for display managers

## Debian / Ubuntu

```sh
git clone https://github.com/maximofernandezriera/nilwm.git
sudo sh nilwm/scripts/install-debian.sh
```

## Alpine Linux

```sh
git clone https://github.com/maximofernandezriera/nilwm.git
doas sh nilwm/scripts/install-alpine.sh
```

After install, you may need to enable udev:
```sh
rc-update add udev
rc-service udev start
```

## Void Linux

```sh
git clone https://github.com/maximofernandezriera/nilwm.git
sudo sh nilwm/scripts/install-void.sh
```

## Arch Linux

```sh
git clone https://github.com/maximofernandezriera/nilwm.git
sudo sh nilwm/scripts/install-arch.sh
```

## Starting NilWM

### Without a display manager (startx)

The installer creates `~/.xinitrc` automatically. Just run:

```sh
startx
```

### With a display manager

NilWM should appear in your session list (LightDM, GDM, SDDM) after installation.

## Re-running the installer

The scripts are idempotent. Running them again will:
- Update packages
- Pull the latest NilWM source
- Recompile
- Backup and recreate `.xinitrc`

## Uninstalling

```sh
sudo rm /usr/local/bin/nilwm
sudo rm /usr/local/bin/nilwm-status.sh
sudo rm /usr/local/bin/nilwm-keybinds.sh
sudo rm /usr/share/xsessions/nilwm.desktop
```
