{
  config,
  lib,
  ...
}: {
  options = {
    mercury.system.keymap = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard layout for the system console.";
    };
  };

  config = {
    console.keyMap = config.mercury.system.keymap;
  };
}
