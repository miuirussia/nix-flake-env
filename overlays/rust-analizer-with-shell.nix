input: final: prev:
let
  mkRustAnalyzerShell = pkg: final.writeShellScriptBin "rust-analyzer" ''
    wrapper=()
    if ${final.nixUnstable}/bin/nix eval --raw .#devShell.${prev.system}; then
      wrapper=(${final.nixUnstable}/bin/nix develop -c)
    fi
    "''${wrapper[@]}" ${pkg}/bin/rust-analyzer
  '';
in
{
  rust-analyzer-nightly-with-shell = mkRustAnalyzerShell final.rust-analyzer-nightly;
  rust-analyzer-with-shell = mkRustAnalyzerShell final.rust-analyzer;
}
