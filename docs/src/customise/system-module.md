# Writing a system module

Same shape as a home module, but it lives in `modules/` and sets NixOS options.

```nix
# modules/services/jellyseerr.nix
{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.services.jellyseerr;
in {
  options.mercury.services.jellyseerr = {
    enable = lib.mkEnableOption "Jellyseerr media requests";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "Web UI port.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      inherit (cfg) port;
      openFirewall = true;
    };

    # If impermanence is ever enabled, keep its state
    mercury.storage.impermanence.directories = [ "/var/lib/jellyseerr" ];
  };
}
```

`git add` it, then enable in a host: `mercury.services.jellyseerr.enable = true;`.

## Checklist for a good module

- Option path matches the folder path.
- Everything inside `lib.mkIf cfg.enable`.
- Opinions use `lib.mkDefault` so hosts can override.
- State directories added to `mercury.storage.impermanence.directories`.
- Firewall ports opened only by an option (default to the safe choice).
- One-line comment at the top saying what it is.

## macOS modules

Same idea in `darwin/modules/`, using nix-darwin options
(`system.defaults…`, `homebrew…`, `launchd…`).
