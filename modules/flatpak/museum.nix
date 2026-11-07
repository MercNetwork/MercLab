{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.flatpak.museum;
  flatpakEnabled = lib.hasAttr "mercury" config && config.mercury.virtualization.flatpak.enable;
in {
  options.mercury.flatpak = {
    museum.enable = lib.mkEnableOption "Museum";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = ["as.may.moat"];
  };
}
