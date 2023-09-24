{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.pulseaudio.enable = lib.mkForce false;

  networking.hostName = "helium";

  programs = {
    # # enable hyprland and required options
    hyprland = {
      enable = true;

      xwayland = {
        enable = true;
      };
      nvidiaPatches = true;
    };

    steam = {
      enable = true;
      # fix gamescope inside steam
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
          ];
        # set correct scaling
        extraProfile = "export GDK_SCALE=2";
      };
    };

    ssh = {
      extraConfig = ''
        Host gitea.carbon.habanerojam.xyz
          IdentityFile ~/.ssh/gitkey_ed25519
      '';
    };
  };

  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      # desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      videoDrivers = ["nvidia"]; #TODO uncomment this
    };
  };
}
