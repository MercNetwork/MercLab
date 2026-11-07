{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.chat.teams;
in {
  options.mercury.home.apps.network.chat.teams.enable = lib.mkEnableOption "Microsoft Teams";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.teams-for-linux
    ];
  };
}
