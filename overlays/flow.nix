inputs: final: prev: {
  flow = final.writeShellScriptBin "flow"
    ''
      lookup() {
        local file="''${1}"
        local curr_path="''${2}"
        [[ -z "''${curr_path}" ]] && curr_path="''${PWD}"
        # Search recursively upwards for file.
        until [[ "''${curr_path}" == "/" ]]; do
          if [[ -e "''${curr_path}/''${file}" ]]; then
            echo "''${curr_path}/''${file}"
            break
          else
            curr_path=$(dirname "''${curr_path}")
          fi
        done
      }
      FLOW_EXEC=$(lookup "node_modules/.bin/flow")
      [[ -z "''${FLOW_EXEC}" ]] && FLOW_EXEC="${prev.flow}/bin/flow"
      $FLOW_EXEC "$@"
    '';
}
