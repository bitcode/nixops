# NixOps Configuration Repository

This repository contains a NixOS configuration with modular options for different hardware (GPU and CPU) and desktop environments (Xorg/i3, Wayland/Sway) using the Nix flakes system. You can customize your system by setting parameters in `configuration.nix`.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Flake Commands](#flake-commands)
  - [Using nixos-rebuild with Remote Flakes](#using-nixos-rebuild-with-remote-flakes)
- [Modules](#modules)

## Features

- Supports multiple configurations for:
  - Window Managers: Xorg/i3, Wayland/Sway
  - GPUs: NVIDIA, AMD, Intel
  - CPUs: Intel, Ryzen
- Modular NixOS configuration using flakes
- Customizable settings based on user-defined parameters

## Prerequisites

- NixOS 24.05 or later
- Flakes enabled in your Nix configuration:
  ```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  ```
Ensure that SSH access is configured if using this repo as a remote.

Installation
Clone the repository:
```
git clone git@github.com:bitcode/nixops.git
cd nixops
```
Adjust configurations in configuration.nix as needed. This file uses conditional imports for GPU, CPU, and window manager modules, defined by parameters settings.

Usage
Flake Commands
To rebuild or switch configurations, use nixos-rebuild with flakes:

Rebuild the system:
```
sudo nixos-rebuild build --flake .#nixops-xorg-nvidia-intel
```
Switch to the configuration:
```
sudo nixos-rebuild switch --flake .#nixops-xorg-nvidia-intel
```
Test the configuration without applying changes:
```
sudo nixos-rebuild test --flake .#nixops-xorg-nvidia-intel
```
Boot to apply changes on next reboot:
```
sudo nixos-rebuild boot --flake .#nixops-xorg-nvidia-intel
```
Replace nixops-xorg-nvidia-intel with your desired configuration (e.g., nixops-wayland-amd-ryzen).

Using nixos-rebuild with Remote Flakes
If using a remote repository, you can directly specify the remote URL:
```
sudo nixos-rebuild switch --flake git@github.com:bitcode/nixops.git#nixops-xorg-nvidia-intel
```
If you need to fetch the flake updates before switching, use:
```
nix flake update
``````
This will pull any changes from the remote repository and update the lock file.

Modules
`base.nix`: Contains core system packages and configurations.
`services.nix`: Manages enabled services, SSH, display manager, and window manager settings.
hardware: Contains configurations for Intel, Ryzen CPUs, and NVIDIA, AMD, Intel GPUs.
window-environments: Sets up configurations for Xorg/i3 and Wayland/Sway.
Each module can be conditionally included based on parameters set in configuration.nix.

Example Configurations
Specify configurations in configuration.nix based on your setup:

For an Xorg/NVIDIA/Intel configuration, set:

```
parameters = {
  windowManager = "xorg";
  gpu = "nvidia";
  cpu = "intel";
  hostName = "nixops";
};
```
Use flake.nix presets for common configurations, such as:

`sudo nixos-rebuild switch --flake .#nixops-wayland-intel-ryzen`

Customize the parameters in configuration.nix to define your system's setup, and enjoy modular, flake-based NixOS configuration management.
