inputs: final: prev: {
  vscode-custom = prev.vscode-with-extensions.override {
    vscodeExtensions = with builtins;(
      [
        (prev.callPackage ./codelldb { })
      ]
    ) ++ prev.vscode-utils.extensionsFromVscodeMarketplace (fromJSON (readFile ./extensions.json));
  };
}
