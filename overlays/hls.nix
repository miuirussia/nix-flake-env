inputs: final: prev:

let
  unstable = import inputs.nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = true;
    };
  };
in
{
  hls = (unstable.haskell-language-server.override {
    supportedGhcVersions = [
      "8107"
      "902"
    ];
  }).overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs or [ ] ++ [ prev.makeWrapper ];
    buildCommand = oldAttrs.buildCommand or "" + ''
      wrapProgram $out/bin/haskell-language-server-wrapper \
        --prefix PATH : $out/bin
    '';
  });
}
