# TOML, YAML and JSON

Three plain-text data formats other tools read. You mostly *write Nix* that
generates them, but you'll read them in logs, docs and secrets files.

## The same data three ways

```toml
# TOML — Wayle's config.toml
[bar]
location = "top"

[[bar.layout]]            # [[ ]] = one entry in a list of tables
monitor = "*"
left = ["dashboard"]
```

```yaml
# YAML — .sops.yaml and secrets files (indentation matters, spaces only)
bar:
  location: top
  layout:
    - monitor: "*"
      left: [dashboard]
```

```json
{ "bar": { "location": "top", "layout": [ { "monitor": "*", "left": ["dashboard"] } ] } }
```

…and in Nix, which is what you actually write:

```nix
{
  bar = {
    location = "top";
    layout = [ { monitor = "*"; left = [ "dashboard" ]; } ];
  };
}
```

| Concept | Nix | TOML | YAML | JSON |
|---------|-----|------|------|------|
| map | `{ a = 1; }` | `[a]` table / `a = 1` | `a: 1` | `{"a": 1}` |
| list | `[ 1 2 ]` | `[1, 2]` | `- 1` or `[1, 2]` | `[1, 2]` |
| list of maps | `[ { … } ]` | `[[name]]` | `- key: v` | `[{…}]` |
| string | `"x"` | `"x"` | `x` or `"x"` | `"x"` |

## Converting

```bash
# TOML → Nix (from the Wayle docs — paste the output into wayle.settings)
nix-instantiate --eval --expr 'builtins.fromTOML (builtins.readFile ./config.toml)' | nixfmt

# Nix → JSON
nix eval --json .#nixosConfigurations.desktop.config.networking.hostName

jq . file.json          # pretty-print / query JSON
```

## Where each appears in MercLab

| File | Format | Notes |
|------|--------|-------|
| `~/.config/wayle/config.toml` | TOML | generated from `wayle.settings` |
| `~/.config/wayle/runtime.toml` | TOML | written by the Wayle settings GUI |
| `.sops.yaml`, `secrets/*.yaml` | YAML | see [Secrets](../customise/secrets.md) |
| `home/configs/hypr/user/scratchpads.json` | JSON | optional scratchpad overrides |
| `flake.lock` | JSON | never edit by hand |
