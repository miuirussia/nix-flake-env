inputs: final: prev: with prev; {
  nix-cleanup-store = writeShellScriptBin "nix-cleanup-store" ''
    ${nixFlakes}/bin/nix-collect-garbage -d
    ${nixFlakes}/bin/nix store optimise 2>&1 | ${gnused}/bin/sed -E 's/.*'\'''(\/nix\/store\/[^\/]*).*'\'''/\1/g' | ${coreutils}/bin/uniq | ${parallel}/bin/parallel '${nixFlakes}/bin/nix-store --repair-path {}'
  '';
}
