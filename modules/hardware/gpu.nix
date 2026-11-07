# Graphics drivers. Enable the vendor(s) present in the machine.
#
#   Intel iGPU / Arc dGPU : mercury.hardware.gpu.intel.enable = true;
#   AMD                   : mercury.hardware.gpu.amd.enable = true;
#   NVIDIA (incl. hybrid) : mercury.hardware.gpu.nvidia.enable = true;
#                           mercury.hardware.gpu.nvidia.prime.enable = true;  # laptops
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.hardware.gpu;
in {
  options.mercury.hardware.gpu = {
    intel.enable = lib.mkEnableOption "Intel graphics (iGPU and Arc) with VA-API / QSV / OpenCL";

    amd.enable = lib.mkEnableOption "AMD graphics (amdgpu, RADV)";

    nvidia = {
      enable = lib.mkEnableOption "the proprietary NVIDIA driver";

      open = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use NVIDIA's open kernel modules (Turing / RTX 20 series and newer).";
      };

      prime = {
        enable = lib.mkEnableOption "PRIME render offload (hybrid laptops). Run apps on the dGPU with `nvidia-offload <cmd>`";

        intelBusId = lib.mkOption {
          type = lib.types.str;
          default = "PCI:0:2:0";
          description = ''
            Bus ID of the integrated GPU. Find it with `lspci | grep -E "VGA|3D"`:
            "00:02.0" becomes "PCI:0:2:0" (hex fields converted to decimal).
          '';
        };

        nvidiaBusId = lib.mkOption {
          type = lib.types.str;
          default = "PCI:1:0:0";
          description = "Bus ID of the NVIDIA GPU, same format as intelBusId.";
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.intel.enable || cfg.amd.enable || cfg.nvidia.enable) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    (lib.mkIf cfg.intel.enable {
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver # VA-API (iHD) for Broadwell and newer, incl. Arc
        vpl-gpu-rt # Quick Sync (oneVPL) for Tiger Lake / Arc and newer
        intel-compute-runtime # OpenCL / Level Zero
      ];
      environment.sessionVariables.LIBVA_DRIVER_NAME = lib.mkIf (!cfg.nvidia.enable) "iHD";
    })

    (lib.mkIf cfg.amd.enable {
      boot.initrd.kernelModules = ["amdgpu"];
      services.xserver.videoDrivers = lib.mkBefore ["amdgpu"];
    })

    (lib.mkIf cfg.nvidia.enable {
      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        modesetting.enable = true;
        inherit (cfg.nvidia) open;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement.enable = true;
        powerManagement.finegrained = cfg.nvidia.prime.enable;

        prime = lib.mkIf cfg.nvidia.prime.enable {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          inherit (cfg.nvidia.prime) intelBusId nvidiaBusId;
        };
      };
    })
  ];
}
