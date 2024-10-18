# nvidia.nix
{ config, pkgs, ... }:

{
  # Allow unfree packages for NVIDIA drivers
  nixpkgs.config.allowUnfree = true;

  # Enable NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  # Optional: Enable modesetting
  hardware.nvidia.modesetting.enable = true;

  # Optional: Enable NVIDIA Persistence Daemon for better power management
  hardware.nvidia.powerManagement.enable = true;

  # Additional NVIDIA-specific settings can be added here
}
