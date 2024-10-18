# amd.nix
{ config, pkgs, ... }:

{
  # Enable AMD GPU support
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Optional: Firmware blobs for newer GPUs
  hardware.enableRedistributableFirmware = true;

  # Additional AMD GPU-specific settings can be added here
}
