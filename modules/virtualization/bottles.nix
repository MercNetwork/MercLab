{
  config,
  lib,
  ...
}:

let
  cfg = config.mercury.virtualization.bottles;
  flatpakEnabled = lib.hasAttr "mercury" config && config.mercury.virtualization.flatpak.enable;
in
{
  options.mercury.virtualization = {
    bottles.enable = lib.mkEnableOption "Bottles";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = [ "com.usebottles.bottles" ];
  };
}
