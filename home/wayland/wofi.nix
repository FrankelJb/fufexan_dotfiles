{ pkgs
, inputs
, osConfig
, ...
}: {
  programs.wofi = {
    enable = true;

    settings = {
      ## Wofi Config

      ## General
      show = "drun";
      prompt = "Apps";
      normal_window = true;
      layer = "overlay";
      term = "foot";
      columns = 5;

      ## Geometry
      width = "60%";
      height = "40%";
      location = "bottom_left";
      orientation = "vertical";
      halign = "fill";
      line_wrap = "off";
      dynamic_lines = false;

      ## Images
      allow_markup = true;
      allow_images = true;
      image_size = 24;

      ## Search
      exec_search = false;
      hide_search = false;
      parse_search = false;
      insensitive = false;

      ## Other
      hide_scroll = true;
      no_actions = true;
      sort_order = "default";
      gtk_dark = true;
      filter_rate = 100;

      ## Keys
      key_expand = "Tab";
      key_exit = "Escape";
    };

    style = ''
      *{
        font-family: "JetBrainsMono Nerd Font";
        min-height: 0;
        font-size: 100%;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        padding: 0px;
        margin-top: 1px;
        margin-bottom: 1px;
      }


      #window {
      	/*background-color: #2F3741;*/
      	background-color: rgba(50, 50, 50, 0.8);
      	color: #d9e0ee;
      	/*border: 2px solid #2F3741;*/
      	border-radius: 0px;
      }

      #outer-box {
      	padding: 20px;
      }

      #input {
      	background-color: #d9e0ee;
      	/*border: 1px solid #4B87CD;*/
      	padding: 8px 12px;
      }

      #scroll {
      	margin-top: 20px;
      	margin-bottom: 20px;
      }

      #inner-box {
      }

      #img {
      	padding-right: 10px;
      }

      #text {
      	color: #d9e0ee;
      }

      #text:selected {
      	color: #2F3741;
      }

      #entry {
      	padding: 6px;
      }

      #entry:selected {
      	background-color: #4B87CD;
      	background: linear-gradient(90deg, #bbccdd, #cca5dd);
      	color: #2F3741;
      }

      #unselected {
      }

      #selected {
      }

      #input, #entry:selected {
      	border-radius: 8px;
      	border: 1px solid #cba6f7;
      }
    '';
  };
}
