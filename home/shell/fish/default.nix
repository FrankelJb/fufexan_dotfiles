{ config
, pkgs
, lib
, ...
}: {
  xdg.configFile."fish/functions" = {
    source = lib.cleanSourceWith {
      src = lib.cleanSource ./functions/.;
    };
    recursive = true;
  };

  xdg.configFile."fish/themes" = {
    source = lib.cleanSourceWith {
      src = lib.cleanSource ./themes/.;
    };
    recursive = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      pbcopy = "xsel --clipboard --input";
      pbpaste = "xsel --clipboard --output";
    };
    shellAbbrs = {
      cat = "bat";
      diff = "delta -s";
      k = "kubectl";
      ka = "kubectl apply -f";
      kd = "kubectl delete -f";
      less = "bat";
      l = "exa";
      ls = "exa";
      lll = "exa -la";
      pip = "pip3";
      sshk = "kitty +kitten ssh";
      vim = "nvim";
    };

    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      # { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
      {
        name = "fzf-fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
      {
        name = "forgit";
        inherit (pkgs.fishPlugins.forgit) src;
      }
      {
        name = "wakatime";
        inherit (pkgs.fishPlugins.wakatime-fish) src;
      }
    ];
  };
}
