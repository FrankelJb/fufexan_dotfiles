{
  imports = [
    ../../editors/neovim
    ../../programs
    ../../programs/dunst
    ../../programs/games.nix
    ../../programs/vscode.nix
    ../../wayland
    ../../terminals/alacritty.nix
    ../../terminals/wezterm.nix
  ];

  home.sessionVariables = {
    GDK_SCALE = "1";
  };
}
