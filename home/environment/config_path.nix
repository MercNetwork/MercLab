{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mercury.home.environment = {
    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "${config.home.homeDirectory}/MercLab/home/configs";
      example = null;
      description = ''
        Where the repo's home/configs directory lives on this machine.
        Apps that support it symlink their config here, so edits take effect
        without a rebuild. Set to `null` to use read-only copies from the flake.
      '';
    };
  };
}
