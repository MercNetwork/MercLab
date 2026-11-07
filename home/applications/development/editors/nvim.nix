{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.mercury.home.apps.development.editors.nvim;
  envIgnores = config.mercury.home.environment.ignores;

in {
  imports = [inputs.mnw.homeManagerModules.mnw];

  options.mercury.home.apps.development.editors.nvim = {
    enable = lib.mkEnableOption "Neovim";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.mercury.home.environment.configsPath;
      example = null;
      description = ''
        Path to this app's configs for out-of-store symlinking.
        Defaults to global `mercury.home.environment.configsPath`.
        Set to `null` to use the pure flake store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.mnw = {
      enable = true;
      initLua = ''
        vim.g.mercury_ignore_directories = vim.json.decode('${builtins.toJSON envIgnores.directories}')
        vim.g.mercury_ignore_files = vim.json.decode('${builtins.toJSON envIgnores.files}')

        require("mercury")
      '';

      extraLuaPackages = ps: [];

      extraBinPath = [
        pkgs.ripgrep
        pkgs.fd
      ];

      providers = {
        nodeJs = {
          enable = true;
          package = pkgs.nodejs_22;
        };
        python3 = {
          enable = true;
          package = pkgs.python3.withPackages (ps: [ps.pynvim]);
        };
      };
      plugins = {
        dev.mercury = {
          pure = "${inputs.self}/home/configs/nvim";
          impure =
            if cfg.configsPath != null
            then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/nvim"
            else null;
        };
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
