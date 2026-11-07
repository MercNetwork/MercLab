# Nix 2: Functions, `inherit`, `with`, imports

## Functions

A function is `argument: body`. It always takes exactly one argument:

```nix
nix-repl> double = x: x * 2
nix-repl> double 21
42
```

Multiple arguments are done by returning another function (or by taking an
attribute set):

```nix
nix-repl> add = a: b: a + b
nix-repl> add 1 2
3
```

### Attribute-set arguments

Most Nix functions take one attribute set and pull out named fields. This is
the shape of every module file:

```nix
{ config, lib, pkgs, ... }:    # take these fields, ignore the rest (...)
{ /* body */ }
```

Defaults use `?`:

```nix
greet = { name ? "mercury" }: "hi ${name}";
greet {}                 # "hi mercury"
greet { name = "chloe"; } # "hi chloe"
```

`mkSystem` in `lib/helpers/default.nix` is exactly this:
`{ host, system ? "x86_64-linux", modules ? [], specialArgs ? {} }: …`.
That's why a new x86 host is just `mkSystem { host = "server"; }` and the Pi
is `mkSystem { host = "piserver"; system = "aarch64-linux"; }`.

## `inherit`

Shorthand for `x = x;`:

```nix
let stateVersion = "26.05"; in { inherit stateVersion; }
# same as { stateVersion = stateVersion; }

{ inherit (cfg) theme defaultSession; }
# same as { theme = cfg.theme; defaultSession = cfg.defaultSession; }
```

## `with`

Brings an attribute set's names into scope. Used for package lists:

```nix
home.packages = with pkgs; [ ripgrep fd bat ];
# same as [ pkgs.ripgrep pkgs.fd pkgs.bat ]
```

Use `with` only for short lists — in big blocks it hides where names come from.

## `import` and paths

`import ./file.nix` evaluates another file and returns its value. If that
value is a function, you call it:

```nix
helpers = import ./lib/helpers { inherit lib inputs stateVersion; };
```

(Importing a directory imports its `default.nix`.)

In modules you rarely call `import` directly; you list files in `imports = [ … ];`
and the module system calls them for you with the right arguments.

## Useful built-ins you'll meet

| Expression | Result |
|------------|--------|
| `builtins.map (x: x + 1) [ 1 2 ]` | `[ 2 3 ]` |
| `builtins.filter (x: x > 1) [ 1 2 3 ]` | `[ 2 3 ]` |
| `lib.genAttrs [ "a" "b" ] (n: n + "!")` | `{ a = "a!"; b = "b!"; }` |
| `lib.optional cond x` | `[ x ]` or `[]` |
| `lib.optionalString cond "s"` | `"s"` or `""` |
| `lib.concatStringsSep ", " [ "a" "b" ]` | `"a, b"` |
| `builtins.toJSON { a = 1; }` | `"{\"a\":1}"` |

`lib` isn't loaded in a bare `nix repl`. In `mcli repl` the repo is loaded, and
nixpkgs' library is at `inputs.nixpkgs.lib` (the top-level `lib` there is
Mercury's own small library with `mkSystem`). Name it once and use it:

```nix
nix-repl> nlib = inputs.nixpkgs.lib
nix-repl> nlib.genAttrs [ "a" "b" ] (n: n + "!")
```

## Exercises

1. Write a function `hostname = name: "merc-${name}";` in the repl and apply it.
2. Read `home/applications/development/langs/all.nix`. Explain to yourself
   what `lib.genAttrs every (_: { enable = lib.mkDefault true; })` produces.
3. In `home/users/mercury/common.nix`, replace the six `langs.<x>.enable = true;`
   lines with one `langs = lib.genAttrs [ … ] (_: { enable = true; });`
   (you'll need to add `lib` to the file's arguments). `mcli build` should show
   no change.
