{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.utility.accessories.memorado;
in {
  options.mercury.home.apps.utility.accessories.memorado.enable = lib.mkEnableOption "Memorado";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.memorado
    ];
  };
}
