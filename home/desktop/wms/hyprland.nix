# Hyprland (user side): links the Lua config, runs the Wayle shell and the
# small helper services, and installs every program the keybinds call.
#
# Every key in home/configs/hypr/variables.lua points at something installed
# here or by the default user profile — if you change an app there, install
# its replacement too.
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.mercury.home.desktop.wms.hyprland;

  link = name:
    if cfg.configsPath != null
    then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/${name}"
    else "${inputs.self}/home/configs/${name}";

  powermenu = pkgs.writeShellApplication {
    name = "mercury-powermenu";
    runtimeInputs = with pkgs; [fuzzel systemd uwsm hyprlock procps];
    text = ''
      choice=$(printf '%s\n' "  Lock" "  Logout" "  Suspend" "  Reboot" "  Shutdown" \
        | fuzzel --dmenu --prompt "Power › " --lines 5 --width 20) || exit 0
      case "$choice" in
        *Lock)     pidof hyprlock || hyprlock ;;
        *Logout)   uwsm stop ;;
        *Suspend)  systemctl suspend ;;
        *Reboot)   systemctl reboot ;;
        *Shutdown) systemctl poweroff ;;
      esac
    '';
  };

  screenshot = pkgs.writeShellApplication {
    name = "mercury-screenshot";
    runtimeInputs = with pkgs; [grim slurp wl-clipboard libnotify coreutils];
    text = ''
      dir="''${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
      mkdir -p "$dir"
      file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
      case "''${1:-full}" in
        full)
          grim "$file"
          wl-copy < "$file"
          notify-send -i "$file" "Screenshot saved" "$file" ;;
        region)
          geometry=$(slurp) || exit 0
          grim -g "$geometry" - | wl-copy
          notify-send "Screenshot copied" "Region copied to clipboard" ;;
        region-save)
          geometry=$(slurp) || exit 0
          grim -g "$geometry" "$file"
          wl-copy < "$file"
          notify-send -i "$file" "Screenshot saved" "$file" ;;
        *) echo "usage: mercury-screenshot [full|region|region-save]" >&2; exit 1 ;;
      esac
    '';
  };

  record = pkgs.writeShellApplication {
    name = "mercury-record";
    runtimeInputs = with pkgs; [wf-recorder slurp libnotify procps coreutils];
    text = ''
      # Pressing any record key while recording stops the recording.
      if pgrep -x wf-recorder >/dev/null; then
        pkill -INT -x wf-recorder
        notify-send "Recording stopped"
        exit 0
      fi
      dir="''${XDG_VIDEOS_DIR:-$HOME/Videos}/Recordings"
      mkdir -p "$dir"
      file="$dir/$(date +%Y-%m-%d_%H-%M-%S).mp4"
      case "''${1:-screen}" in
        screen) notify-send "Recording screen"; wf-recorder -f "$file" ;;
        sound)  notify-send "Recording screen with audio"; wf-recorder --audio -f "$file" ;;
        region)
          geometry=$(slurp) || exit 0
          notify-send "Recording region"
          wf-recorder -g "$geometry" -f "$file" ;;
        *) echo "usage: mercury-record [screen|sound|region]" >&2; exit 1 ;;
      esac
    '';
  };

  clipboard = pkgs.writeShellApplication {
    name = "mercury-clipboard";
    runtimeInputs = with pkgs; [cliphist fuzzel wl-clipboard procps];
    text = ''
      pkill -x fuzzel && exit 0
      case "''${1:-pick}" in
        pick)   cliphist list | fuzzel --dmenu --prompt "Clipboard › " | cliphist decode | wl-copy ;;
        delete) cliphist list | fuzzel --dmenu --prompt "Delete › " | cliphist delete ;;
        *) echo "usage: mercury-clipboard [pick|delete]" >&2; exit 1 ;;
      esac
    '';
  };
in {
  options.mercury.home.desktop.wms.hyprland = {
    enable = lib.mkEnableOption "the Mercury Hyprland desktop (Wayle shell, hyprlock, hypridle, fuzzel)";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.mercury.home.environment.configsPath;
      defaultText = lib.literalExpression "config.mercury.home.environment.configsPath";
      description = ''
        Where home/configs lives on disk. When set, ~/.config/hypr is a live
        symlink into the repo (edit + `hyprctl reload`, no rebuild).
        Set to null to use the read-only copy from the flake.
      '';
    };

    scale = lib.mkOption {
      type = lib.types.either lib.types.int lib.types.float;
      default = 1;
      example = 1.25;
      description = ''
        UI scale for the whole desktop: Hyprland monitor scale and the Wayle
        bar. 1 = 100%. Use 1.25 / 1.5 / 2 for high-DPI screens.
      '';
    };

    wayle.settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra Wayle settings merged over Mercury's defaults (see https://wayle.app/config).";
    };

    idle = {
      lockAfter = lib.mkOption {
        type = lib.types.int;
        default = 600;
        description = "Seconds of inactivity before the screen locks.";
      };
      suspendAfter = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 1800;
        description = "Seconds of inactivity before suspending (null = never).";
      };
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra packages to install alongside Hyprland.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        hyprpolkitagent
        hyprpicker
        brightnessctl
        playerctl
        wireplumber # wpctl (volume keys)
        libnotify # notify-send
        trash-cli
        btop # sysmon scratchpad
        grim
        slurp
        wl-clipboard
        wf-recorder
        bibata-cursors
      ])
      ++ [powermenu screenshot record clipboard]
      ++ cfg.extraPackages;

    # ---- Hyprland config (Lua) -------------------------------------------
    xdg.configFile."hypr".source = link "hypr";
    xdg.configFile."mercury/scale.lua".text = "return ${toString cfg.scale}\n";

    # UWSM starts Hyprland outside a login shell: hand it Home Manager's env.
    xdg.configFile."uwsm/env".text = ''
      if [ -f "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh" ]; then
        . "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"
      fi
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';

    # ---- Wayle: bar, notifications, OSD, wallpaper -----------------------
    services.wayle = {
      enable = true;
      autoInstallDependencies = true;
      settings = lib.recursiveUpdate {
        bar.layout = [
          {
            monitor = "*";
            left = ["dashboard" "hyprland-workspaces" "window-title"];
            center = ["clock" "media"];
            right = ["systray" "volume" "network" "bluetooth" "battery" "notifications" "power"];
          }
        ];
        bar.scale = cfg.scale;
        modules.clock.format = "%a %d %b  %H:%M";
      }
      cfg.wayle.settings;
    };

    # ---- Launcher --------------------------------------------------------
    programs.fuzzel = {
      enable = true;
      settings.main = {
        terminal = "kitty";
        layer = "overlay";
      };
    };

    # ---- Lock & idle -----------------------------------------------------
    programs.hyprlock = {
      enable = true;
      settings = {
        general.hide_cursor = true;
        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        input-field = [
          {
            size = "300, 50";
            position = "0, -80";
            halign = "center";
            valign = "center";
            outline_thickness = 2;
            placeholder_text = "Password";
          }
        ];
        label = [
          {
            text = "$TIME";
            font_size = 64;
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
        };
        listener =
          [
            {
              timeout = cfg.idle.lockAfter;
              on-timeout = "loginctl lock-session";
            }
          ]
          ++ lib.optional (cfg.idle.suspendAfter != null) {
            timeout = cfg.idle.suspendAfter;
            on-timeout = "systemctl suspend";
          };
      };
    };

    # ---- Small background services ---------------------------------------
    services.cliphist.enable = true;
    services.mpris-proxy.enable = true; # Bluetooth headset media buttons

    systemd.user.services.hyprpolkitagent = {
      Unit = {
        Description = "Hyprland polkit authentication agent";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
