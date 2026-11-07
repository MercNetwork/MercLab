# mercury on NixOS machines: the shared profile plus the Hyprland desktop and
# the GUI apps its keybinds and file associations expect.
#
#   Keybind / role            App enabled here
#   SUPER+T  terminal         kitty            (common.nix)
#   SUPER+W  browser          firefox
#   SUPER+C  editor           nvim in kitty    (common.nix)
#   SUPER+E  files            nautilus         (gnome_files)
#   CTRL+ALT+V audio          pwvucontrol
#   CTRL+SHIFT+Esc sysmon     btop             (Hyprland module)
#   images / PDFs             loupe / sioyek / zathura
{...}: {
  imports = [./common.nix];

  mercury.home = {
    environment = {
      gtk.enable = true;
      xdg.enable = true;
    };

    desktop.wms.hyprland.enable = true;

    apps = {
      # ---- Required apps -------------------------------------------------
      development.editors.zed.enable = true;
      gaming.launchers.protonplus.enable = true; # Steam itself: hosts/*/configuration.nix
      media.audio.spotify.enable = true;
      network.chat.discord.enable = true;

      # ---- Desktop defaults (keybinds and file types rely on these) ------
      graphics.viewers.gnome_image_viewer.enable = true;

      media.audio.pwvucontrol.enable = true;

      network.browsers.firefox.enable = true;

      office.readers = {
        sioyek.enable = true;
        zathura.enable = true;
      };

      settings.security.gnome_seahorse.enable = true;

      system = {
        core.usbutils.enable = true;
        desktop = {
          gnome_files.enable = true;
          gnome_system_monitor.enable = true;
        };
      };
    };
  };
}
