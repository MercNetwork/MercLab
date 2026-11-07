# Nix 3: Modules and options

This is the chapter that makes the whole repo readable.

## What a module is

A module is a file (or attribute set) with up to three parts:

```nix
{ config, lib, pkgs, ... }: {
  imports = [ ./other.nix ];       # 1. more modules to include

  options = { /* … */ };            # 2. settings this module invents

  config = { /* … */ };             # 3. settings this module sets
}
```

If a file has no `options`, you can leave out the `config =` wrapper and write
settings directly at the top — that's what host files do.

NixOS, nix-darwin and Home Manager each collect **all** modules, merge every
`config`, check values against every `options` declaration, and produce one
final configuration. `config` (the function argument) is that final, merged
result — which is how one module can read what another set.

## Declaring options

```nix
options.mercury.hardware.gpu.nvidia = {
  enable = lib.mkEnableOption "the proprietary NVIDIA driver";   # bool, default false

  open = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Use NVIDIA's open kernel modules.";
  };
};
```

Common types: `bool`, `str`, `int`, `port`, `path`, `package`,
`listOf str`, `attrsOf str`, `nullOr str`, `enum [ "a" "b" ]`, `submodule {…}`.
A wrong type is a build error that names the option — that's free checking.

## Setting config conditionally

```nix
config = lib.mkIf cfg.enable {
  hardware.nvidia.modesetting.enable = true;
};
```

Several conditional blocks in one module:

```nix
config = lib.mkMerge [
  { /* always */ }
  (lib.mkIf cfg.intel.enable { /* … */ })
  (lib.mkIf cfg.nvidia.enable { /* … */ })
];
```

`modules/hardware/gpu.nix` is a complete, short example of both.

## Merging and priorities

When two modules set the same option:

| Option type | What happens |
|-------------|--------------|
| list | concatenated (`environment.systemPackages` from many modules) |
| attribute set | merged key by key |
| single value, same priority, different values | **error: conflicting definitions** |

Priorities resolve conflicts:

```nix
lib.mkDefault "astronaut"    # weak — anyone else wins
"astronaut"                  # normal
lib.mkForce "astronaut"      # strong — beats normal definitions
```

Rule of thumb: modules use `mkDefault` for opinions; hosts use plain values;
`mkForce` is the last resort.

## How Mercury modules talk to each other

Modules can set *other modules'* options. Many Mercury modules add to the
impermanence persist list:

```nix
mercury.storage.impermanence.directories = [ "/var/lib/bluetooth" ];
```

That list does nothing unless impermanence is enabled — but every module
registers what it needs, so turning impermanence on later just works.

## Reading an option's final value

```bash
nix eval .#nixosConfigurations.laptop.config.hardware.nvidia.prime.offload.enable
nix eval .#nixosConfigurations.desktop.config.environment.systemPackages --apply 'map (p: p.name)'
```

## Exercises

1. Open `modules/hardware/bluetooth.nix`. Identify the three parts.
2. Add an option `mercury.hardware.bluetooth.powerOnBoot` (bool, default
   `true`) and use it instead of the hard-coded `true`. Build.
3. In `hosts/desktop/configuration.nix`, set
   `services.power-profiles-daemon.enable = false;`. Build — no conflict,
   because the Hyprland module used `mkDefault`. Now set it in the Hyprland
   module without `mkDefault` and build again to see a conflict error. Revert.
