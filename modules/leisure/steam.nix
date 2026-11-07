# Steam with Proton, Gamescope session and GameMode.
# On the laptop, run a game on the NVIDIA GPU with launch options:
#   nvidia-offload %command%
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.leisure.steam;
in {
  options.mercury.leisure.steam.enable = lib.mkEnableOption "Steam (Proton, Remote Play, Gamescope session, GameMode)";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.gamescope.enable = true;
    programs.gamemode.enable = true;

    environment.systemPackages = [pkgs.mangohud];
  };
}
