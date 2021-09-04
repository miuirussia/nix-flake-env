inputs: final: prev: {
  emux = prev.writeShellScriptBin "emux" ''
    SESSION=$(${final.tmux}/bin/tmux display-message -p "#S")
    OIFS=$IFS
    IFS=$'\n'
    for line in $(grep '^# exit:' ~/.config/tmuxinator/$SESSION.yml); do
      IFS=' '
      elems=($line)
      window="''${elems[2]}"
      pane=''${elems[3]}
      unset 'elems[0]'
      unset 'elems[1]'
      unset 'elems[2]'
      unset 'elems[3]'
      cmd="''${elems[*]}"
      echo "${final.tmux}/bin/tmux send-keys -t $SESSION:$window.$pane $cmd"
      ${final.tmux}/bin/tmux send-keys -t $SESSION:$window.$pane $cmd
      sleep 0.5
    done
    IFS=$OIFS
    ${final.tmux}/bin/tmux kill-session
  '';
}
