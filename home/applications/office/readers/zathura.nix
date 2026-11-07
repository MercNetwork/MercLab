{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.readers.zathura;
in {
  options.mercury.home.apps.office.readers.zathura.enable = lib.mkEnableOption "Zathura document viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zathura
    ];
  };
}
