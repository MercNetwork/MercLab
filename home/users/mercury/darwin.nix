# mercury on macOS: the shared profile plus Mac-only tweaks.
# GUI apps on macOS are usually best installed as Homebrew casks
# (see mercury.darwin.homebrew in hosts/mac/configuration.nix).
{...}: {
  imports = [./common.nix];

  # Linux-only modules (Hyprland, GTK, XDG mime apps, systemd services)
  # are not loaded on macOS, so nothing to disable here.
}
