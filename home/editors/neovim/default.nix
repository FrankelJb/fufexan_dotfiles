{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [gcc ripgrep fd];

  };

  xdg.configFile = {
     # set config file for nvim
     "nvim".source = builtins.fetchGit {
       url = "https://github.com/AstroNvim/AstroNvim.git";
       ref = "main";
       rev = "87a05226b003c05369ca70ff7e7baf4910d0f8b1";
       shallow = true;
     };
     # set config for astro
     # "astronvim/lua/user".source = builtins.fetchGit {
     #   # your git repo here 
     #   url = "https://github.com/FrankelJb/astro_config.git";
     #   ref = "main";
     #   # your revision here
     #   rev = "a9c9b6f87ca32b5e7271280fbaef3a28a8c26bee";
     #   shallow = true;
     # };
  };
}
