# intel.nix
{ config, pkgs, ... }:

{
  # Enable Intel microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # Optionally, set CPU frequency scaling governor
  powerManagement.cpuFreqGovernor = "powersave";

  # Additional Intel-specific optimizations can be added here
}
