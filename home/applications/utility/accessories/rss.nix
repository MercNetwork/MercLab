{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.utility.accessories.rss;
in {
  options.mercury.home.apps.utility.accessories.rss.enable = lib.mkEnableOption "RSS Client";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fluent-reader
    ];
  };
}
