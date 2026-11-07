{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.tmux;
in {
  options.mercury.home.apps.system.shell.tmux.enable = lib.mkEnableOption "Tmux terminal multiplexer";

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
    };
  };
}
