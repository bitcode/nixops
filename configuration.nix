# configuration.nix
{ config, pkgs, unstablePkgs, ... }:
let
  parameters = config.parameters or {
    windowManager = "xorg";
    gpu = "nvidia";
    cpu = "intel";
    hostName = "nixops";
  };
in
{
  imports = [
    ./modules/base.nix
    ./modules/services.nix

    # Conditionally include window environment
    (if parameters.windowManager == "xorg" || parameters.windowManager == "i3" then ./modules/window-environments/xorg.nix else null)
    (if parameters.windowManager == "wayland" || parameters.windowManager == "sway" then ./modules/window-environments/wayland.nix else null)

    # Conditionally include GPU configuration
    (if parameters.gpu == "nvidia" then ./modules/hardware/gpu/nvidia.nix else null)
    (if parameters.gpu == "amd" then ./modules/hardware/gpu/amd.nix else null)
    (if parameters.gpu == "intel" then ./modules/hardware/gpu/integrated-intel-graphics.nix else null)

    # Conditionally include CPU configuration
    (if parameters.cpu == "intel" then ./modules/hardware/cpu/intel.nix else null)
    (if parameters.cpu == "ryzen" then ./modules/hardware/cpu/ryzen.nix else null)
  ];

  # Common configurations
  networking = {
    hostName = parameters.hostName;
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";

  users.users.bit = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  fonts = {
    fontconfig.enable = true;
    packages = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # DPMS and screen saver settings
  services.xserver = {
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xset}/bin/xset s off
      ${pkgs.xorg.xset}/bin/xset -dpms
    '';
  };
}
