inputs: final: prev: let
  stack-with-args = args: (
    final.writeScriptBin "stack" ''
      #!${final.runtimeShell}
      exec "${final.stack}/bin/stack" ${args} "$@"
    ''
  ) // {
    name = "stack-with-args";
    version = final.stack.version;
    meta.description = "Haskell Stack with args: ${args}";
    meta.longDescription = ''
      	This package provides a wrapper script around the Haskell Stack
              executable that tacks on `${args}` to every
              call.  This forces disablment of Nix across all platforms.
    '';
  };
in {
  stack-in-nix = stack-with-args "--no-nix --system-ghc";
}
