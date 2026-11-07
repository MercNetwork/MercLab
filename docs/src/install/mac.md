# Setting up the Mac

For when the Mac arrives. Assumes Apple Silicon.

## 1. Account

During macOS setup, create the account with the short name **`mercury`**
(Mercury's nix-darwin config assumes it; change `mercury.system.user.name` in
`darwin/modules/users.nix` if you pick another).

## 2. Command-line tools and Nix

```bash
xcode-select --install          # git, compilers
curl -L https://nixos.org/nix/install | sh -s -- --daemon
```

Open a new terminal afterwards.

> If you prefer the Determinate Systems installer, it manages Nix itself — add
> `nix.enable = false;` to `hosts/mac/configuration.nix`, otherwise nix-darwin
> and Determinate will fight over `/etc/nix/nix.conf`.

## 3. Clone and switch

```bash
git clone https://github.com/MercNetwork/MercLab.git ~/MercLab
cd ~/MercLab
sudo nix --extra-experimental-features "nix-command flakes" \
  run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/MercLab#mac
```

If it refuses because `/etc/zshrc` or `/etc/bashrc` already exist, rename them
as it suggests (`sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin`) and run again.

From now on: `mcli switch`.

## 4. Homebrew (optional, for GUI apps)

Most Mac GUI apps are easiest as Homebrew casks. Install Homebrew from
<https://brew.sh>, then in `hosts/mac/configuration.nix`:

```nix
mercury.darwin.homebrew = {
  enable = true;
  casks = [ "firefox" "raycast" ];
  cleanup = "zap";   # remove casks not listed here
};
```

## 5. What's different from the Linux machines

- Your profile is `home/users/mercury/darwin.nix`, which imports `common.nix` —
  the same shell, Neovim, git and CLI tools as everywhere else.
- No Hyprland, GTK, XDG or systemd user services (`home/home.nix` skips
  `home/desktop` and `home/services` on macOS).
- If a Linux-only app module breaks evaluation on the Mac, it's because it was
  enabled in `common.nix`; move it to `linux.nix`.
