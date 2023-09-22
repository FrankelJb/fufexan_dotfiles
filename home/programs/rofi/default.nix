{ options
, config
, lib
, pkgs
, ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  xdg.configFile = {
    "rofi" = {
      source = lib.cleanSourceWith {
        src = lib.cleanSource ./config/.;
      };

      recursive = true;
    };
  };
}
