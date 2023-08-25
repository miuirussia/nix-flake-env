inputs: final: prev: {
  haskellPackages = prev.haskellPackages.override {
    overrides = hsSelf: hsSuper: {
      dhall-lsp-server = prev.haskell.lib.overrideCabal hsSuper.dhall-lsp-server (dlPrev: {
        broken = false;
        patches = [ ./dhall-lsp-server.patch ];
      });
      ilist = prev.haskell.lib.overrideCabal hsSuper.ilist (_: {
        revision = "3";
        sha256 = "sha256-BEiFcpaXQxfuFiVR7z4vMcQ04RTfbRfX9qzTR2xS3AQ=";
        editedCabalFile = "sha256-EmAZ+vPQLzBcV2KulgK+HL92KRFToadGEnCtFClngRE=";
        broken = false;
      });
      spdx = prev.haskell.lib.overrideCabal hsSuper.spdx (_: {
        doCheck = false;
        broken = false;
        patches = [ ./spdx.patch ];
      });
    };
  };
}
