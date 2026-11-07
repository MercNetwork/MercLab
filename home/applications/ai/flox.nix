{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.ai.flox;
in {
  options.mercury.home.apps.ai.flox.enable = lib.mkEnableOption "Flox environments";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.flox.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.sessionVariables.FLOX_DISABLE_TELEMETRY = "1";
  };
}
