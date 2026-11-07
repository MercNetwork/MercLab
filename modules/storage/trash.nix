{
  config,
  lib,
  ...
}:

let
  cfg = config.mercury.storage.trash;
in
{
  options.mercury.storage = {
    trash.enable = lib.mkEnableOption "Trash";
  };

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.udisks2.enable = true;
  };
}
