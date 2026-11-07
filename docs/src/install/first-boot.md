# First boot checklist

Work through this once per machine.

- [ ] **Log in** at SDDM: user `mercury`, password `chloe`, session
      *Hyprland (uwsm)*. Press `SUPER+T` for a terminal.
- [ ] **Check the repo is there**: `ls ~/MercLab`. If not:
      `git clone https://github.com/MercNetwork/MercLab.git ~/MercLab`, then
      `mcli switch` so the live dotfile links resolve.
- [ ] **Change the password** if you didn't before installing: put a new hash
      in `modules/system/users.nix`, then `mcli switch`. (`passwd` does not
      stick — passwords only come from the config.)
- [ ] **SSH key for GitHub**:
      ```bash
      ssh-keygen -t ed25519 -C "mercury@$(hostname)"
      cat ~/.ssh/id_ed25519.pub     # add at GitHub → Settings → SSH keys
      cd ~/MercLab && git remote set-url origin git@github.com:MercNetwork/MercLab.git
      ```
- [ ] **Commit the machine's hardware file**:
      `git add hosts/<name> && git commit -m "<name>: hardware config" && git push`
- [ ] **Monitors** (if the default layout is wrong): run `hyprctl monitors`, then
      add `hl.monitor({...})` lines to `home/configs/hypr/user/config.lua`.
      Takes effect on `hyprctl reload` — no rebuild needed.
- [ ] **Size looks wrong?** Everything is 100% by default. Try another scale
      live in `home/configs/hypr/user/vars.lua` (`return { monitorScale = 1.25 }`),
      then make it permanent — see [Look and feel](../desktop/theming.md).
- [ ] **Wayle icons**: if bar icons are missing, run `wayle icons setup` once.
- [ ] **Laptop**: `nvidia-offload glxinfo | grep renderer` should name the
      RTX 3050 Ti (`nix-shell -p mesa-demos` for glxinfo).
- [ ] **Desktop**: `vainfo` should report the iHD driver for the Arc B570
      (`nix-shell -p libva-utils`).
- [ ] **Read the keybinds**: [Hyprland and keybinds](../desktop/hyprland.md).
