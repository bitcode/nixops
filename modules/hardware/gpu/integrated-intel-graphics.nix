{ config, pkgs, ... }:

{
  # Use modesetting driver for Intel integrated graphics
  services.xserver.videoDrivers = [ "modesetting" ];

  # Optional: Enable VAAPI drivers for video acceleration
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel ];

  # Additional integrated graphics settings can be added here
}
