{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.docs.rnote;
in {
  options.mercury.home.apps.office.docs.rnote.enable = lib.mkEnableOption "Rnote";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.rnote
    ];
  };
}
