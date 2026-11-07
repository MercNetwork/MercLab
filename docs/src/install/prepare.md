# Before you install

Do these once, on whatever computer you have now.

## 1. Put the repo on GitHub (private)

MercLab lives at `github.com/MercNetwork/MercLab`. If that repo still holds the
older ZaneyOS-based config, keep it as a branch rather than deleting it:

```bash
# in your existing clone of the old config
git switch -c zaneyos-legacy && git push -u origin zaneyos-legacy

# then, in the new Mercury folder
cd ~/MercLab
git init -b main
git add -A
git commit -m "Mercury: initial import"
git remote add origin git@github.com:MercNetwork/MercLab.git
git push -u --force origin main     # replaces main with Mercury
```

Keep the repo **private**: it will contain your password hash, host names and,
later, encrypted secrets.

## 2. A way to clone it from the installer

The live installer has no SSH keys, so for a private repo use HTTPS with a
token:

1. GitHub → Settings → Developer settings → Fine-grained tokens → *Generate*.
2. Repository access: only `MercLab`. Permissions: *Contents: Read-only*.
3. Save the token in your password manager. At the `git clone` password prompt,
   paste the token.

Alternatively, copy the repo onto a USB stick and clone from there.

## 3. Personalise before the first build

| What | Where | Why now |
|------|-------|---------|
| Git name and email | `home/users/mercury/common.nix` (`tools.git`) | commits from the new machine |
| Password | `modules/system/users.nix` (`hashedPassword`) — optional | the default is `chloe` |
| Disk device | `hosts/<name>/disko.nix` (`device = …`) | **the installer erases this disk** |
| Time zone | hosts use automatic detection; set `mercury.system.timezone` and `autoTimezone = false` to pin one | |

To make a password hash: `nix-shell -p mkpasswd --run "mkpasswd -m sha-512"`
(or `openssl passwd -6`). Paste the whole `$6$…` string.

## 4. Make the USB stick

Download the **NixOS 26.05 graphical ISO** from <https://nixos.org/download>
(graphical, so you have a browser to read this book during the install). Write
it with `dd`, Ventoy, or balenaEtcher.

## 5. Firmware settings (both PCs)

- Boot mode **UEFI** (not legacy/CSM).
- **Secure Boot off** — systemd-boot is unsigned. (Lanzaboote can add Secure
  Boot later; not covered here.)
- Laptop: leave the GPU mode on *Hybrid/MSHybrid* (not "dGPU only") so PRIME
  offload works.
