{ config
, default
, theme
, ...
}:
let
  c = theme.colors.colors_android.${theme.variant};
  pointer = config.home.pointerCursor;
  # scriptDir = "${config.home.homeDirectory}/.config/eww/scripts";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      "$kw" = "dwindle:no_gaps_when_only";
      animations = {
        enabled = "yes";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "overshot, 0.13, 0.99, 0.29, 1.1"
          "scurve, 0.98, 0.01, 0.02, 0.98"
          "easein, 0.47, 0, 0.745, 0.715"
        ];

        animation = [
          "windowsOut, 1, 7, default, popin 10%"
          "windows, 1, 5, overshot, popin 10%"
          "border, 1, 10, default"
          "fade, 1, 10, default"
          "workspaces, 1, 6, overshot, slide"
        ];
      };
      # mouse movements
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bind =
        [
          # compositor commands
          "$mod SHIFT, E, exec, pkill Hyprland"
          "$mod, Q, killactive,"
          "$mod, F, fullscreen,"
          "$mod, G, togglegroup,"
          "$mod SHIFT, N, changegroupactive, f"
          "$mod SHIFT, P, changegroupactive, b"
          "$mod, R, togglesplit,"
          "$mod, T, togglefloating,"
          "$mod, P, pseudo,"
          "$mod ALT, ,resizeactive,"
          # toggle "monocle" (no_gaps_when_only)
          "$mod, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))"

          # utility
          # launcher
          "$mod, SPACE, exec, pkill.${default.launcher}-wrapped || run-as-service ${default.launcher}"
          # terminal
          "$mod, Return, exec, run-as-service ${default.terminal.name}"
          # cliphist
          "CTRL ALT, C, exec, "
          # logout menu
          "$mod, Escape, exec, wlogout -p layer-shell"
          # lock screen
          "$mod CTRL, Q, exec, loginctl lock-session"
          # select area to perform OCR on
          "$mod, O, exec, run-as-service wl-ocr"

          # move focus
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          # Move (vim style)
          "$mod CTRL, H, movewindow, l"
          "$mod CTRL, L, movewindow, r"
          "$mod CTRL, K, movewindow, u"
          "$mod CTRL, J, movewindow, d"

          # screenshot
          ", Print, exec, $screenshotarea"
          "$mod SHIFT, R, exec, $screenshotarea"
          "CTRL, Print, exec, grimblast --notify --cursor copysave output"
          "$mod SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output"
          "ALT, Print, exec, grimblast --notify --cursor copysave screen"
          "$mod SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen"

          # workspaces
          "$mod, TAB, workspace, m+1"
          "$mod SHIFT, TAB, workspace, m-1"

          # special workspace
          "$mod, S , movetoworkspace, special"
          "$mod, N , togglespecialworkspace,"

          # cycle workspaces
          "$mod, bracketleft, workspace, m-1"
          "$mod, bracketright, workspace, m+1"

          # cycle monitors
          "$mod SHIFT, bracketleft, focusmonitor, l"
          "$mod SHIFT, bracketright, focusmonitor, r"
        ]
        ++
        # binds mod + [shift +] {1..10} to [move to] ws {1..10}
        (builtins.concatLists (builtins.genList
          (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10));

      # media controls
      binde = [
        # volume controls
        ",XF86AudioRaiseVolume, exec, volume -i 5"
        ",XF86AudioLowerVolume, exec, volume -d 5"
        ",XF86AudioMute, exec, volume -t"
      ];
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];

      exec-once = [
        "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
        "eww open bar"
        "eww open osd"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "[workspace 1 silent] firefox"
        "[silent] signal-desktop --ozone-platform-hint=auto"
        "[silent] virt-manager"
      ];
      input = {
        kb_layout = "us";
        sensitivity = 0;
        force_no_accel = 1;
        # focus change on cursor move
        follow_mouse = 1;
        accel_profile = "flat";
      };

      misc = {
        # disable auto polling for config file changes
        disable_hyprland_logo = true;
        disable_splash_rendering = true;

        # disable dragging animation
        animate_mouse_windowdragging = false;

        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;

        enable_swallow = true;
        no_direct_scanout = true; #for fullscreen games
        focus_on_activate = true;

        # enable variable refresh rate (effective depending on hardware)
        vrr = 1;

        # groupbar
        groupbar_titles_font_size = 16;
        groupbar_gradients = false;
      };
      general = {
        monitor = [
          ",highrr,auto,1"
          "DP-3, 2560x1440@240, 0x0, 1"
        ];
        gaps_in = 5;
        gaps_out = 15;
        border_size = 2;
        "col.inactive_border" = "rgb(5e6798)";
        "col.active_border" = "rgba(7793D1FF)";
        layout = "dwindle";
        no_cursor_warps = true;
      };

      decoration = {
        rounding = 10;
        multisample_edges = true;

        active_opacity = 0.95;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = "yes";
          size = 5;
          passes = 4;
        };

        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "0x55161925";
        "col.shadow_inactive" = "0x22161925";
      };

      dwindle = {
        # keep floating dimentions while tiling
        pseudotile = true;
        preserve_split = true;
      };
      windowrulev2 = [
        # make Firefox PiP window floating and sticky
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        # throw sharing indicators away
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(mpv|.+exe)$"
        "idleinhibit always, class:^(firefox)$, title:^(.*YouTube.*|.*Twitch.*)$"
        "idleinhibit fullscreen, class:^(firefox)$"

        # start VSCodium and Signal on ws2
        "workspace 2 silent, class:^(VSCodium)$"
        "workspace 2 silent, class:^(Signal)$"
        # virt-manager on ws3
        "workspace 3 silent, class:^(virt-manager)$"

        # Steam rules
        "workspace 5 silent, class:^(steam)$"
        "workspace 5 silent, class:^(steam.*)$"
        "fullscreen, class:^(steam)$,title:^(Steam Big Picture Mode)"
        "idleinhibit fullscreen, class:^(steam.*)"

        "dimaround, class: ^(gcr-prompter)$"

        # fix xwayland apps
        "rounding 0, xwayland:1, floating:1"
        "center, class: ^(. * jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 641 400, class: ^(. * jetbrains.*)$, title:^(splash)$"
      ];
      xwayland = {
        force_zero_scaling = true;
      };

      "$layers" = "^(eww-.+|bar|system-menu|anyrun|gtk-layer-shell)$";
      layerrule = [
        "blur, $layers"
        "ignorealpha 0, $layers"
        "ignorealpha 0.5, ^(eww-(music|calendar)|system-menu|anyrun)$"
        "xray 1, ^(bar|gtk-layer-shell)$"
      ];

      # screenshot
      # stop animations while screenshotting; makes black border go away
      "$screenshotarea" = "hyprctl keyword animation \"fadeOut,0,0,default\"; grimblast --notify copysave area; hyprctl keyword animation \"fadeOut,1,4,default\"";
    };

    extraConfig = ''
      env = _JAVA_AWT_WM_NONREPARENTING,1
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      # window submap resize
      bind = $mod, S, submap, resize
      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , escape, submap, reset
      submap = reset
    '';
  };
}
