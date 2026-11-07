# Zed editor. The FHS build lets Zed run the language servers and extensions
# it downloads itself; servers installed by the `langs.*` modules are on PATH
# and Zed uses those first where it supports it.
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.editors.zed;
in {
  options.mercury.home.apps.development.editors.zed.enable = lib.mkEnableOption "Zed editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (
        if pkgs.stdenv.hostPlatform.isLinux
        then pkgs.zed-editor-fhs
        else pkgs.zed-editor
      )
    ];
  };
}
