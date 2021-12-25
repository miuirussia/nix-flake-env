inputs: final: prev: {
  vscode-custom = prev.vscode-with-extensions.override {
    vscodeExtensions = with builtins;(
      [
        (prev.callPackage ./codelldb { })
        final.vscode-extensions.matklad.rust-analyzer-nightly
      ]
    ) ++ prev.vscode-utils.extensionsFromVscodeMarketplace (fromJSON (readFile ./extensions.json));
  };
}
