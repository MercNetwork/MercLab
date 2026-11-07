{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.chat.discord;
in {
  options.mercury.home.apps.network.chat.discord = {
    enable = lib.mkEnableOption "Discord";

    client = lib.mkOption {
      type = lib.types.enum ["discord" "vesktop" "equibop"];
      default = "discord";
      description = "Which Discord client: the official app, or the Vencord-based Vesktop / Equibop.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.${cfg.client}];
  };
}
