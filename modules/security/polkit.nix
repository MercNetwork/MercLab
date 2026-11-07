{
  config,
  lib,
  ...
}:

let
  cfg = config.mercury.security.polkit;
in
{
  options.mercury.security = {
    polkit.enable = lib.mkEnableOption "Polkit feature set";
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;
  };
}
