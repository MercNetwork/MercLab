{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.chat.tut;
in {
  options.mercury.home.apps.network.chat.tut.enable = lib.mkEnableOption "tut (Mastodon TUI)";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.tut];
  };
}
