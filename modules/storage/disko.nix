# Whether this host's hosts/<name>/disko.nix describes its real disks.
#
#   true  (default) — the machine was installed with mercury-install; Disko
#                     generates fileSystems, LUKS and swap from disko.nix.
#   false           — the machine was installed some other way (e.g. the
#                     graphical NixOS installer); filesystems come from
#                     hardware-configuration.nix instead.
{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.storage.disko;
in {
  options.mercury.storage.disko.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Use hosts/<name>/disko.nix for filesystems (set false for machines not installed with mercury-install).";
  };

  config.disko.enableConfig = lib.mkDefault cfg.enable;
}
