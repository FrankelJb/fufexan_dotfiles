{
  lib,
  pkgs,
  theme,
  ...
}: let
  volume = let
    pamixer = lib.getExe pkgs.pamixer;
    notify-send = pkgs.libnotify + "/bin/notify-send";
  in
    pkgs.writeShellScriptBin "volume" ''
      #!/bin/sh

      ${pamixer} "$@"

      volume="$(${pamixer} --get-volume-human)"

      if [ "$volume" = "muted" ]; then
          ${notify-send} -r 69 \
              -a "Volume" \
              "Muted" \
              -i ${./mute.svg} \
              -t 888 \
              -u low
      else
          ${notify-send} -r 69 \
              -a "Volume" "Currently at $volume" \
              -h int:value:"$volume" \
              -i ${./volume.svg} \
              -t 888 \
              -u low
      fi
    '';
in {
  home.packages = [volume];
  services.dunst = let
    c = theme.xcolors.colors.${theme.variant};
  in {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        alignment = "center";
        corner_radius = 16;
        follow = "mouse";
        font = "Roboto 10";
        format = "<b>%s</b>\\n%b";
        frame_width = 1;
        offset = "5x5";
        horizontal_padding = 8;
        icon_position = "left";
        indicate_hidden = "yes";
        markup = "yes";
        max_icon_size = 64;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        padding = 8;
        plain_text = "no";
        separator_color = "auto";
        separator_height = 1;
        show_indicators = false;
        shrink = "no";
        word_wrap = "yes";
      };

      fullscreen_delay_everything = {fullscreen = "delay";};

      urgency_critical = {
        background = c.error_container;
        foreground = c.on_error_container;
        frame_color = c.error;
      };
      urgency_low = {
        background = c.secondary_container;
        foreground = c.on_secondary_container;
        frame_color = c.secondary;
      };
      urgency_normal = {
        background = c.primary_container;
        foreground = c.on_primary_container;
        frame_color = c.primary;
      };
    };
  };
}
