inputs: final: prev: {
  haskellPackages = prev.haskellPackages.override {
    overrides = hsSelf: hsSuper: {
      dhall-lsp-server = prev.haskell.lib.overrideCabal hsSuper.dhall-lsp-server (_: {
        broken = false;
      });
      ilist = prev.haskell.lib.overrideCabal hsSuper.ilist (_: {
        broken = false;
      });
      spdx = prev.haskell.lib.overrideCabal hsSuper.spdx (_: {
        broken = false;
      });
    };
  };
}
