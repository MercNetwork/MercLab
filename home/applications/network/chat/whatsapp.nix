{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.chat.whatsapp;
in {
  options.mercury.home.apps.network.chat.whatsapp.enable = lib.mkEnableOption "Whatsapp";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zapzap
    ];
  };
}
