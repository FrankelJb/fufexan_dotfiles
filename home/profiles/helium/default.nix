{
  imports = [
    ../../editors/neovim
    ../../programs
    ../../programs/dunst.nix
    ../../programs/games.nix
    ../../programs/openrgb.nix
    ../../wayland
    ../../terminals/alacritty.nix
    ../../terminals/wezterm.nix
  ];

  home.sessionVariables = {
    GDK_SCALE = "1";
  };
}
