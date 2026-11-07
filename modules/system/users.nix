# The primary user and root. One place to change the username, password,
# groups and SSH keys for every machine.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.system.user;
  usesFile = cfg.hashedPasswordFile != null;
in {
  options.mercury.system.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "mercury";
      description = "Login name of the primary user.";
    };

    description = lib.mkOption {
      type = lib.types.str;
      default = "Mercury";
      description = "Full name / GECOS field.";
    };

    hashedPassword = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      # Default password: "chloe". Replace with your own hash:
      #   mkpasswd -m sha-512        (or: openssl passwd -6)
      default = "$6$mercurylab$Q8edhZ/zU3KqTP4SO4KbJc9fM8GM4kasPnjl/Qy85GH79cA.OxGo5a02K40ztFfZL47LB6UsSHYchKuO.mmio.";
      description = "Password hash for the primary user and root (ignored if hashedPasswordFile is set).";
    };

    hashedPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/run/secrets/mercury-password";
      description = "File containing the password hash (e.g. a sops-nix secret). Overrides hashedPassword.";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Groups in addition to wheel, networkmanager, video, audio and input.";
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "SSH public keys allowed to log in as the primary user (applied by mercury.services.ssh).";
    };
  };

  config = {
    # Passwords only come from this file; `passwd` changes do not survive a rebuild.
    users.mutableUsers = false;

    programs.zsh.enable = true;

    users.users.${cfg.name} = {
      isNormalUser = true;
      createHome = true;
      inherit (cfg) description;
      extraGroups = ["wheel" "networkmanager" "video" "audio" "input"] ++ cfg.extraGroups;
      shell = pkgs.zsh;
      hashedPassword = lib.mkIf (!usesFile) cfg.hashedPassword;
      hashedPasswordFile = lib.mkIf usesFile cfg.hashedPasswordFile;
    };

    # Root keeps a password so the emergency shell is usable.
    users.users.root = {
      hashedPassword = lib.mkIf (!usesFile) cfg.hashedPassword;
      hashedPasswordFile = lib.mkIf usesFile cfg.hashedPasswordFile;
    };
  };
}
