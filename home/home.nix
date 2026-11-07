# Collects every Mercury Home Manager module. Each file only declares options
# and does nothing until enabled from a user profile (home/users/...).
# Desktop and systemd-based service modules are Linux-only.
{
  lib,
  getFiles,
  platform,
  ...
}: {
  imports =
    getFiles ./applications
    ++ getFiles ./environment
    ++ lib.optionals (platform == "linux") (
      getFiles ./services
      ++ getFiles ./desktop
    );
}
