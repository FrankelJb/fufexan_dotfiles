{
  config,
  pkgs,
  self,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

 # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.pulseaudio.enable = lib.mkForce false;

  networking.hostName = "helium";

  programs = {
    # enable hyprland and required options
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # enabledNvidiaPatches = true; TODO enable this
      xwayland.enable = true;
    };
    steam.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      # videoDrivers = ["nvidia"]; TODO uncomment this 
    };
  };
}
