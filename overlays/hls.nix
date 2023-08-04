inputs: final: prev:

{
  hls = (prev.haskell-language-server.override {
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
