{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };

    extraConfig = builtins.readFile ./theme.conf;

    settings = {
      font_size = 12;
      italic_font = "auto";
      bold_font = "auto";
      bold_italic_font = "auto";

      macos_titlebar_color = "background";

      cursor_shape = "block";

      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";
      mouse_hide_wait = "3.0";
      focus_follows_mouse = false;
      wheel_scroll_multiplier = "5.0";

      url_color = "#0087BD";
      url_style = "single";
      open_url_modifiers = "kitty_mod";
      open_url_with = "default";

      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      enable_audio_bell = false;
      visual_bell_duration = "0.2";
      window_alert_on_bell = true;

      remember_window_size = true;
      initial_window_width = 640;
      initial_window_height = 400;

      enabled_layouts = "*";

      window_border_width = "0.0";
      window_margin_width = "0.0";
      window_padding_width = "1.0";
      background_opacity = "1.0";
      dynamic_background_opacity = false;

      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";

      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = true;
    };
  };
}
