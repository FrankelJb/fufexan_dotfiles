{ pkgs, ... }: {
  home.packages = with pkgs; [
    # messaging
    signal-desktop

    # misc
    libnotify
    xdg-utils
  ];
}
