{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.mercury.virtualization."compose2nix";
in {
  options.mercury.virtualization.compose2nix.enable = lib.mkEnableOption "Compose2nix";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.compose2nix.packages.x86_64-linux.default
    ];
  };
}
