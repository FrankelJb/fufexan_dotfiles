{ config
, pkgs
, lib
, ...
}: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(zellij setup --generate-auto-start bash)"
      . "$HOME/.cargo/env"

      export EDITOR=nvim
    '';
  };
}
