{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.docs.marktext;
in {
  options.mercury.home.apps.office.docs.marktext.enable = lib.mkEnableOption "Marktext";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.marktext
    ];
  };
}
