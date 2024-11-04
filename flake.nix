# flake.nix
{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-config.url = "https://github.com/bitcode/nixops";
  };

    outputs = { self, nixpkgs, nixpkgs-unstable, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    unstablePkgs = import nixpkgs-unstable {
      inherit system;
      config = pkgs.config;
    };

    makeConfig = { windowManager, gpu, cpu, hostName }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          {
            nixpkgs = pkgs;
            unstablePkgs = unstablePkgs;
            config.parameters = {
              inherit windowManager gpu cpu hostName;
            };

            # Additional options for specific configurations
            services.xserver.enable = windowManager == "xorg" || windowManager == "i3";
            services.wayland.enable = windowManager == "wayland" || windowManager == "sway";
            
            hardware.opengl = {
              enable = true;
              driSupport = true;
              driSupport32Bit = true;
              extraPackages = builtins.filter (pkg: pkg != null) (with pkgs; [
                (if gpu == "nvidia" then pkgs.nvidiaPackages.latest else null)
                (if gpu == "amd" then pkgs.amdgpu-pro else null)
                (if gpu == "intel" then pkgs.vaapiIntel else null)
              ]);
            };

            # CPU specific settings
            boot.kernelPackages = if cpu == "intel" then pkgs.linuxPackages_latest
                                  else if cpu == "ryzen" then pkgs.linuxPackages_zen
                                  else pkgs.linuxPackages;

            # Video drivers
            services.xserver.videoDrivers = if gpu == "nvidia" then [ "nvidia" ]
                                            else if gpu == "amd" then [ "amdgpu" ]
                                            else if gpu == "intel" then [ "modesetting" ]
                                            else [];

            # Microcode updates
            hardware.cpu.intel.updateMicrocode = cpu == "intel";
            hardware.cpu.amd.updateMicrocode = cpu == "ryzen";

            # Window manager settings
            services.xserver.windowManager.i3.enable = windowManager == "i3";
            services.xserver.windowManager.sway.enable = windowManager == "sway";
          }
        ];
      };
  in {
    nixosConfigurations = {
      # Xorg/NVIDIA/Intel
      nixops-xorg-nvidia-intel = makeConfig {
        windowManager = "xorg";
        gpu = "nvidia";
        cpu = "intel";
      };

      # Xorg/NVIDIA/Ryzen
      nixops-xorg-nvidia-ryzen = makeConfig {
        windowManager = "xorg";
        gpu = "nvidia";
        cpu = "ryzen";
      };

      # Xorg/AMD/Intel
      nixops-xorg-amd-intel = makeConfig {
        windowManager = "xorg";
        gpu = "amd";
        cpu = "intel";
      };

      # Xorg/AMD/Ryzen
      nixops-xorg-amd-ryzen = makeConfig {
        windowManager = "xorg";
        gpu = "amd";
        cpu = "ryzen";
      };

      # Xorg/Intel/Intel (for integrated graphics)
      nixops-xorg-intel-intel = makeConfig {
        windowManager = "xorg";
        gpu = "intel";
        cpu = "intel";
      };

      # Xorg/Intel/Ryzen (for mixed setups)
      nixops-xorg-intel-ryzen = makeConfig {
        windowManager = "xorg";
        gpu = "intel";
        cpu = "ryzen";
      };

      # Wayland/NVIDIA/Intel
      nixops-wayland-nvidia-intel = makeConfig {
        windowManager = "wayland";
        gpu = "nvidia";
        cpu = "intel";
      };

      # Wayland/NVIDIA/Ryzen
      nixops-wayland-nvidia-ryzen = makeConfig {
        windowManager = "wayland";
        gpu = "nvidia";
        cpu = "ryzen";
      };

      # Wayland/AMD/Intel
      nixops-wayland-amd-intel = makeConfig {
        windowManager = "wayland";
        gpu = "amd";
        cpu = "intel";
      };

      # Wayland/AMD/Ryzen
      nixops-wayland-amd-ryzen = makeConfig {
        windowManager = "wayland";
        gpu = "amd";
        cpu = "ryzen";
      };

      # Wayland/Intel/Intel
      nixops-wayland-intel-intel = makeConfig {
        windowManager = "wayland";
        gpu = "intel";
        cpu = "intel";
      };

      # Wayland/Intel/Ryzen
      nixops-wayland-intel-ryzen = makeConfig {
        windowManager = "wayland";
        gpu = "intel";
        cpu = "ryzen";
      };
    };
  };
}
