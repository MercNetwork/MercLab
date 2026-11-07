{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.mercury.home.apps.ai.antigravity;
  agPkgs = inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.mercury.home.apps.ai.antigravity.enable = lib.mkEnableOption "Google Antigravity (IDE and CLI)";

  config = lib.mkIf cfg.enable {
    home.packages = [
      agPkgs.google-antigravity-cli
      agPkgs.google-antigravity
    ];
  };
}
