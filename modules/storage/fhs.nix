{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.storage.fhs;
in {
  options.mercury.storage = {
    fhs.enable = lib.mkEnableOption "FHS feature set";
  };

  config = lib.mkIf cfg.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };
}
