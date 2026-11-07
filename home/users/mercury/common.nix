# Everything mercury gets on EVERY machine (NixOS and macOS).
# Only cross-platform, terminal-first tools belong here.
{...}: {
  mercury.home = {
    environment.fonts.enable = true;

    apps = {
      development = {
        editors.nvim.enable = true;
        # Languages used to maintain MercLab itself. Each brings its LSP,
        # formatter and linter; Neovim and Zed pick them up automatically.
        # Turn on everything at once with:  langs.all.enable = true;
        langs = {
          bash.enable = true;
          lua.enable = true;
          markdown.enable = true;
          nix.enable = true;
          toml.enable = true;
          yaml.enable = true;
        };
        tools.git = {
          enable = true;
          userName = "mercury"; # TODO: your name for commits
          userEmail = "mercury@example.com"; # TODO: your commit email
          signByDefault = false;
        };
      };

      network.remote.dnsutils.enable = true;

      settings.security.pass.enable = true;

      system = {
        core = {
          sqlite.enable = true;
          zip.enable = true;
        };
        shell = {
          bat.enable = true;
          curl.enable = true;
          eza.enable = true;
          fastfetch.enable = true;
          file.enable = true;
          fzf.enable = true;
          glow.enable = true;
          jq.enable = true;
          kitty.enable = true;
          ripgrep.enable = true;
          starship.enable = true;
          tmux.enable = true;
          tree.enable = true;
          wget.enable = true;
          zoxide.enable = true;
          zsh.enable = true;
        };
      };

      utility.accessories.calculator.enable = true;
    };
  };
}
