# How Mercury fits together

```text
flake.nix
  └─ mkSystem { host = "laptop"; }          (lib/helpers/default.nix)
       ├─ nixosModules.default
       │    ├─ hosts/base.nix, hosts/boot.nix
       │    └─ modules/**  (every file auto-imported, all options off)
       ├─ nixpkgs: allowUnfree + pkgs.unstable overlay
       └─ hosts/laptop/configuration.nix     (turns options on)
              └─ mercury.system.home_manager.profile = [ home/users/mercury/linux.nix ]
                     └─ Home Manager loads home/home.nix (every home module, all off)
                        then the profile turns some on
```

The Mac follows the same shape with `mkDarwin`, `darwin/` instead of `modules/`,
and `home/users/mercury/darwin.nix`.

## Why everything is "off until enabled"

`getFiles` imports every `.nix` file in a folder. Each module looks like this:

```nix
{ config, lib, pkgs, ... }: let
  cfg = config.mercury.hardware.bluetooth;
in {
  options.mercury.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
```

Being imported only *declares* the option. Nothing happens until something sets
`mercury.hardware.bluetooth.enable = true`. That's why there are 200+ modules but
a machine only contains what its host and profile switch on.

**Consequence:** a module that imports a flake input at the top
(`imports = [ inputs.foo.nixosModules.default ];`) needs that input to exist even
when disabled. If you delete an input from `flake.nix`, delete the module files
that reference it too. `grep -rn "inputs.foo" .` finds them.

## Special arguments

`mkSystem`/`mkDarwin` pass these to every module, besides the usual
`config`, `lib`, `pkgs`:

| Argument | Value |
|----------|-------|
| `inputs` | all flake inputs (`inputs.self` is this repo) |
| `host` | the machine name, e.g. `"laptop"` |
| `stateVersion` | `"26.05"` — see [release upgrades](../maintain/release-upgrade.md) |
| `getFiles` | the auto-import helper |
| `platform` | `"linux"` or `"darwin"` |

Home Manager modules receive the same set.

## `pkgs.unstable`

Every machine also sees nixos-unstable as `pkgs.unstable`. Use it for the odd
package you want newer than the stable release:

```nix
home.packages = [ pkgs.unstable.some-tool ];
```

Keep this to a minimum — unstable packages are rebuilt and re-downloaded more often.
