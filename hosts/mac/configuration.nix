# Mac — nix-darwin (Apple Silicon). Not purchased yet; this is ready for it.
# First build: see docs/src/install/mac.md. Afterwards: `mcli switch`.
{...}: {
  networking = {
    hostName = "mac";
    localHostName = "mac";
    computerName = "Mac";
  };

  mercury = {
    darwin = {
      defaults.enable = true;
      homebrew = {
        enable = false; # needs Homebrew installed first (docs/src/install/mac.md)
        casks = [
          # "discord"
          # "spotify"
          # "zed"
        ];
        brews = [];
      };
    };

    system.home_manager = {
      enable = true;
      profile = [../../home/users/mercury/darwin.nix];
    };
  };
}
