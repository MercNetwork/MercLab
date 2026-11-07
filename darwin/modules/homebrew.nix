# Homebrew, managed declaratively. Requires Homebrew itself to be installed
# once by hand (https://brew.sh). Anything not listed here is uninstalled
# on switch when `cleanup = "zap"`.
{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.darwin.homebrew;
in {
  options.mercury.darwin.homebrew = {
    enable = lib.mkEnableOption "declarative Homebrew";

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["firefox" "raycast"];
      description = "GUI apps (Homebrew casks).";
    };

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "CLI formulae.";
    };

    cleanup = lib.mkOption {
      type = lib.types.enum ["none" "uninstall" "zap"];
      default = "none";
      description = "What to do with Homebrew packages not listed here.";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      inherit (cfg) casks brews;
      onActivation = {
        autoUpdate = false;
        upgrade = false;
        inherit (cfg) cleanup;
      };
    };
  };
}
