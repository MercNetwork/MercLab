{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.services.vnc;
in {
  options.mercury.services = {
    vnc.enable = lib.mkEnableOption "Wayvnc feature set";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wayvnc
    ];
  };
}
