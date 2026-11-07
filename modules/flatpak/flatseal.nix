{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.flatpak.flatseal;
  flatpakEnabled = lib.hasAttr "mercury" config && config.mercury.virtualization.flatpak.enable;
in {
  options.mercury.flatpak = {
    flatseal.enable = lib.mkEnableOption "Flatseal";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = ["com.github.tchx84.Flatseal"];
  };
}
