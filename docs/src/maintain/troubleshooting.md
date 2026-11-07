# Troubleshooting

Add to this page every time you fix something non-obvious.

## Build / evaluation

| Symptom | Fix |
|---------|-----|
| `path … does not exist` | `git add` the new file |
| `option … does not exist` | typo, or the module file was deleted; check the [module index](../reference/modules.md) |
| `conflicting definition values` | two places set one value; keep one or use `lib.mkForce` |
| `attribute 'xyz' missing` after an update | package renamed/removed — search.nixos.org; the error often suggests the new name |
| `infinite recursion` | `config` used inside `imports` or in an `mkIf` controlling its own option |
| Mac build fails on a Linux-only package | it was enabled in `common.nix`; move it to `linux.nix` |
| first evaluation says "updating lock file" | normal after adding/removing inputs; commit `flake.lock` |
| hash mismatch | replace the hash with the "got:" value Nix prints |

## Boot

| Symptom | Fix |
|---------|-----|
| black screen after an update | pick the previous generation in the boot menu, then `mcli rollback` |
| no boot menu entry / "no bootable device" | firmware in UEFI mode? Secure Boot off? Reinstall bootloader ([recovery](../daily/recovery.md#4-repair-from-the-installer-usb)) |
| switched an existing install to MercLab and it won't boot | `mercury.storage.disko.enable = false;` was missing — boot the previous generation and add it ([existing install](../install/existing-nixos.md)) |
| waits forever for a disk | wrong `device` in `disko.nix`; fix from the ISO |
| passphrase prompt never appears | add `"usbhid"` and your keyboard's module to `boot.initrd.availableKernelModules` |

## Login and desktop

| Symptom | Fix |
|---------|-----|
| password `chloe` rejected | you changed `hashedPassword`; boot an older generation to log in |
| SDDM returns to login after entering password | `journalctl -b -u display-manager`; try a TTY (`CTRL+ALT+F2`) and run `Hyprland` to see errors |
| Hyprland red error banner | Lua error in `home/configs/hypr/…`; the banner names file and line |
| everything too big or too small | set `mercury.home.desktop.wms.hyprland.scale` ([Look and feel](../desktop/theming.md)); check `hyprctl monitors` shows the scale you expect |
| no bar | `systemctl --user status wayle` (name may vary: `systemctl --user list-units \| grep -i wayle`); restart with `wayle panel restart` |
| bar icons missing | `wayle icons setup` |
| keybind does nothing | run its command in a terminal to see the error; check the app is enabled |
| config changes don't apply | `ls -l ~/.config/hypr` must point into `~/MercLab/home/configs/hypr`; if the repo moved, set `configsPath` |
| apps look unthemed (Qt) | `qt.platformTheme` in `home/environment/gtk.nix` |
| screen tearing / flicker on NVIDIA | make sure the laptop panel is driven by Intel (offload mode) |

## Hardware

| Symptom | Fix |
|---------|-----|
| `nvidia-offload` missing | `mercury.hardware.gpu.nvidia.prime.enable` off, or bus IDs wrong |
| Arc B570 not detected | kernel too old: keep `linuxPackages_latest` on the desktop |
| no sound | `wpctl status`; pick the output in pwvucontrol (`CTRL+ALT+V`) |
| Bluetooth headset buttons do nothing | `mpris-proxy` service: `systemctl --user status mpris-proxy` |
| Wi-Fi gone after impermanence | NetworkManager state is persisted only if impermanence was on before you connected — reconnect once |

## Getting more information

```bash
journalctl -b -p err                # system errors this boot
journalctl --user -b -p err         # your session's errors
systemctl --failed; systemctl --user --failed
nix log /nix/store/<hash>-<name>.drv   # full build log of a failed package
```

## Asking for help

When you do ask (forum, Discourse, or an assistant), include: the command you
ran, the **last 30 lines** of output, `git log --oneline -3`, and the host name.
Run with `--show-trace` first.
