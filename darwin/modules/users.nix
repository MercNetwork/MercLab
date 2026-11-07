# The primary macOS user. macOS creates the account itself (Setup Assistant);
# this just tells nix-darwin about it.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.system.user;
in {
  options.mercury.system.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "mercury";
      description = "Short name of the macOS account (must already exist).";
    };
  };

  config = {
    system.primaryUser = cfg.name;

    users.users.${cfg.name} = {
      inherit (cfg) name;
      home = "/Users/${cfg.name}";
      shell = pkgs.zsh;
    };
  };
}
