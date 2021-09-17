{ config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    enableFzf = true;
    enableMouse = true;
    enableSensible = true;
    enableVim = true;

    extraConfig = ''
      ############################################################################
      # Misc                                                                     #
      ############################################################################

      # more colors and themes
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
      set -g default-terminal "xterm-kitty"

      # Rebind prefix key from C-b to C-s
      unbind C-b
      set -g prefix C-s
      bind s send-prefix
      bind C-s last-window


      # Hot-reload tmux when configuration changes
      bind r source-file /etc/tmux.conf\; display "Reloaded."

      # Set history length
      set -g history-limit 10000

      # Enable clipboard interactivity
      set -g set-clipboard on

      # Set window notifications
      set -g monitor-activity on
      set -g visual-activity on

      # Emulate scrolling by sending up and down keys if these commands are running in the pane
      # https://github.com/tmux/tmux/issues/1320#issuecomment-381952082
      tmux_commands_with_legacy_scroll="nano less more man git"
      bind-key -T root WheelUpPane \
        if-shell -Ft= '#{?mouse_any_flag,1,#{pane_in_mode}}' \
          'send -Mt=' \
          'if-shell -t= "#{?alternate_on,true,false} || echo \"#{tmux_commands_with_legacy_scroll}\" | grep -q \"#{pane_current_command}\"" \
            "send -t= Up; send -t= Up; send -t= Up; send -t= Up; send -t= Up" "copy-mode -et="'
      bind-key -T root WheelDownPane \
        if-shell -Ft = '#{?pane_in_mode,1,#{mouse_any_flag}}' \
          'send -Mt=' \
          'if-shell -t= "#{?alternate_on,true,false} || echo \"#{tmux_commands_with_legacy_scroll}\" | grep -q \"#{pane_current_command}\"" \
            "send -t= Down; send -t= Down; send -t= Down; send -t= Down; send -t= Down" "send -Mt="'

      # Update files on focus (using for neovim)
      set -g focus-events on

      # macOS Command+K (Clear scrollback buffer)
      bind -n C-k clear-history

      set -g pane-border-style fg=colour235
      set -g pane-active-border-style fg=colour237

      set -g message-style bg=default,fg=blue

      set -g status-justify centre
      set -g status-bg colour0
      set -g status-fg default
      set -g status-left ""
      set -g status-right-style "none"
      set -g status-right-length "100"
      set -g status-right "#[fg=#3E4452,bg=black,nobold]#[fg=white,bg=#3E4452] #(uptime | awk '{print $3}' | sed 's/,//') #[fg=brightblue,bg=#3E4452,nobold]#[fg=colour235,bg=brightblue] %Y-%m-%d %H:%M "

      setw -g window-status-style bg=default,fg=colour8,none
      setw -g window-status-format '#[fg=colour235,bg=colour235]#[default]#I #W   #[fg=colour235,bg=colour235]'
      setw -g window-status-current-format "#[fg=colour0]#[fg=colour1]#I #W #F #[fg=colour0]"
      set-option -g status-position bottom
    '';
  };
}
