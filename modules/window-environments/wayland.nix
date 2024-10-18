{ config, pkgs, unstablePkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    interception-tools
    interception-tools-plugins.caps2esc
    wl-clipboard
    weston
    wofi
  ];
}

