{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.mercury.home.services.caddy;
in {
  options.mercury.home.services.caddy = {
    enable = lib.mkEnableOption "Caddy user configuration and dotfile linking";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.mercury.home.environment.configsPath;
      description = "Path to configs for out-of-store symlinking. Set null for pure flake store.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."caddy/Caddyfile" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/caddy/Caddyfile"
        else "${inputs.self}/home/configs/caddy/Caddyfile";
    };

    home.shellAliases = {
      caddy-reload = "caddy reload --config ~/.config/caddy/Caddyfile";
      caddy-validate = "caddy validate --adapter caddyfile --config ~/.config/caddy/Caddyfile";
      caddy-fmt = "caddy fmt --overwrite ~/.config/caddy/Caddyfile";
    };
  };
}
