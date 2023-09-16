{
  pkgs,
  lib,
  self,
  inputs,
  config,
  ...
}: let
  suspend-hyprland = pkgs.writeShellScriptBin "suspend-hyprland" ''
    #!/bin/bash
    case "$1" in
        suspend)
            killall -STOP Hyprland
            ;;
        resume)
            killall -CONT Hyprland
            ;;
    esac
  '';
in {
  boot.plymouth = {
    enable = true;
    themePackages = [self.packages.${pkgs.system}.catppuccin-plymouth];
    theme = "catppuccin-mocha";
  };

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols

      # normal fonts
      lexend
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto

      # nerdfonts
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Roboto Serif" "Noto Color Emoji"];
      sansSerif = ["Roboto" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # use Wayland where possible (electron)
  # environment.variables.NIXOS_OZONE_WL = "1"; # TODO remove this and uncomment below

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0"; # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  environment.systemPackages = with pkgs; [
    # shell scripts
    suspend-hyprland

    # packages
    cargo
    rustc
    dolphin
    nodejs_20
    virt-manager
    vscodium
  ];

  hardware = {
    nvidia = {
      # TODO uncomment
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };

    opentabletdriver.enable = true;

    pulseaudio.enable = lib.mkForce false;

    xpadneo.enable = true;
  };

  # enable location service
  location.provider = "geoclue2";

  nix = {
    settings = {
      substituters = [
        "https://nix-gaming.cachix.org"
        "https://hyprland.cachix.org"
        "https://cache.privatevoid.net"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      ];
    };
  };

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    seahorse.enable = true;
  };

  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr udisks2];
    };

    # provide location
    geoclue2.enable = true;

    gnome.gnome-keyring.enable = true;

    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;

      # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
      lowLatency.enable = true;
    };

    power-profiles-daemon.enable = true;

    # profile-sync-daemon
    psd = {
      enable = true;
      resyncTimer = "10m";
    };

    udev = {
      packages = with pkgs; [gnome.gnome-settings-daemon];
      extraRules = ''
        # add my android device to adbusers
        SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
      '';
    };
  };

  systemd = {
    services.hyprland-resume = {
      description = "Resume hyprland";
      wantedBy = ["systemd-suspend.service" "systemd-hibernate.service"];
      after = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
        "nvidia-suspend.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${suspend-hyprland} resume";
      };
    };
    services.hyprland-suspend = {
      description = "Suspend hyprland";
      wantedBy = ["systemd-suspend.service" "systemd-hibernate.service"];
      before = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
        "nvidia-suspend.service"
        "nvidia-hibernate.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${suspend-hyprland} suspend";
      };
    };
  };

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.gtklock.text = "auth include login";

    # userland niceness
    rtkit.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
