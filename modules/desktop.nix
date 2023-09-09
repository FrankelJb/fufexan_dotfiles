{
  pkgs,
  self,
  inputs,
  ...
}: {
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
  environment.variables.NIXOS_OZONE_WL = "1"; # TODO remove this and uncomment below

  # environment.variables = {
  #   GBM_BACKEND = "nvidia-drm";
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #   __GL_GSYNC_ALLOWED = "1";
  #   __GL_VRR_ALLOWED = "0"; # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.
  # };

  # environment.sessionVariables = {
  #   NIXOS_OZONE_WL = "1";
  #   WLR_NO_HARDWARE_CURSORS = "1";
  # };

  hardware = {
    # nvidia = { TODO uncomment
    #   modesetting.enable = true;
    #   nvidiaSettings = true;
    #   open = true;
    #   package = config.boot.kernelPackages.nvidiaPackages.stable;
    #   powerManagement.enable = true;
    # };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };

    opentabletdriver.enable = true;

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

    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = [pkgs.gcr];

    udev = {
      packages = with pkgs; [gnome.gnome-settings-daemon];
      extraRules = ''
        # add my android device to adbusers
        SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
      '';
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
    # extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
