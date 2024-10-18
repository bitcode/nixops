# xorg_based.nix
{ config, pkgs, unstablePkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    feh
    xorg.xrandr
    i3status
    i3
    i3blocks
    picom
    rofi
    xclip
    xsel
    dunst
  ];

}
