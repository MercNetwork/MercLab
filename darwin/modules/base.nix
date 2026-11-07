# Settings every Mercury Mac gets.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = lib.mkMerge [
    {
      # nix-darwin's own state version (an integer, unrelated to "26.05").
      # Leave it alone after the first switch.
      system.stateVersion = 6;

      programs.zsh.enable = true;

      environment.systemPackages = with pkgs; [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mcli
        git
        nvd
      ];

      # Touch ID for sudo
      security.pam.services.sudo_local.touchIdAuth = true;
    }

    # Only when nix-darwin manages Nix itself. If you installed Nix with the
    # Determinate installer, set `nix.enable = false;` in the host and these
    # settings are skipped (Determinate manages them).
    (lib.mkIf config.nix.enable {
      nix.settings = {
        experimental-features = ["nix-command" "flakes"];
        trusted-users = ["root" "@admin"];
      };
      nix.gc = {
        automatic = true;
        interval = {
          Weekday = 0;
          Hour = 3;
          Minute = 0;
        };
        options = "--delete-older-than 7d";
      };
      nix.optimise.automatic = true;
    })
  ];
}
