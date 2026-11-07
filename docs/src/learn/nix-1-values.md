# Nix 1: Values and expressions

Nix is a small language where **everything is an expression that produces a
value**. There are no statements, no loops, no variables you can change. A
`.nix` file is one big expression.

Open a REPL and type along:

```bash
nix repl
```

## Basic values

```nix
nix-repl> 1 + 2
3
nix-repl> "hello " + "world"
"hello world"
nix-repl> name = "mercury"          # repl-only shortcut for naming things
nix-repl> "user is ${name}"         # string interpolation
"user is mercury"
nix-repl> true && false
false
nix-repl> null
null
nix-repl> ./flake.nix               # a path (not a string)
/home/mercury/MercLab/flake.nix
```

Multi-line strings use two single quotes. Leading indentation is stripped,
which is why scripts and config files inside modules look tidy:

```nix
''
  line one
    indented line
''
```

To write a literal `${` inside a `''` string (common in Bash snippets), escape
it as `''${`. In `mercury-screenshot` you'll see `''${XDG_PICTURES_DIR:-…}`
for exactly this reason.

## Lists

Space-separated, no commas, can mix types:

```nix
nix-repl> [ 1 "two" ./three ]
nix-repl> [ 1 2 ] ++ [ 3 ]          # concatenate
[ 1 2 3 ]
```

## Attribute sets (the most important type)

Key–value maps, written with `=` and `;`:

```nix
nix-repl> user = { name = "mercury"; shell = "zsh"; }
nix-repl> user.name
"mercury"
nix-repl> user.editor or "nvim"     # default when missing
"nvim"
nix-repl> user // { shell = "fish"; }   # merge, right side wins
{ name = "mercury"; shell = "fish"; }
```

Dotted keys are shorthand for nesting. These two are identical:

```nix
{ mercury.hardware.bluetooth.enable = true; }
{ mercury = { hardware = { bluetooth = { enable = true; }; }; }; }
```

That's why host files can write `mercury.hardware.pipewire.enable = true;`
or group things under `mercury = { hardware = { … }; };` — same result.

## `if`, `let`

```nix
nix-repl> if 2 > 1 then "yes" else "no"
"yes"

nix-repl> let a = 2; b = 3; in a * b
6
```

`let … in` names values for the expression after `in`. Every module in
MercLab starts with `let cfg = config.mercury.…; in` to avoid typing the long
path repeatedly.

## Exercises

1. In `nix repl`, build the attribute set
   `{ desktop = "Ryzen"; laptop = "Intel"; }` and look up `laptop`.
2. Use `//` to change `laptop` to `"i7-11500H"` without retyping `desktop`.
3. Open `hosts/laptop/configuration.nix` and rewrite the
   `mercury.hardware.pipewire = { … };` block using dotted keys only. Run
   `mcli build` — the result should be "no changes".
