{
  config,
  pkgs,
  self,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  hardware.pulseaudio.enable = lib.mkForce false;

  networking.hostName = "helium";

  programs = {
    # enable hyprland and required options
    hyprland.enable = true;
    steam.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };
}
