{ config
, pkgs
, lib
, ...
}: {
  xdg.configFile."zellij" = {
    source = lib.cleanSourceWith {
      src = lib.cleanSource ./configs;
    };
    recursive = true;
  };

  programs.zellij = {
    enable = true;
  };
}
