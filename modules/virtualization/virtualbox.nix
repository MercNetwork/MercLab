{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.virtualization.virtualbox;
in {
  options.mercury.virtualization.virtualbox.enable = lib.mkEnableOption "Virtualbox";

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
    };
  };
}
