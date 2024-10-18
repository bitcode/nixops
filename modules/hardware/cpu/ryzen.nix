# ryzen.nix
{ config, pkgs, ... }:

{
  # Enable AMD microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Use the Zen kernel optimized for Ryzen CPUs
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Additional Ryzen-specific settings can be added here
}
