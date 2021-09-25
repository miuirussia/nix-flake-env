inputs: final: prev: {
  vscode-custom = let
    extensions = with builtins;(
      [
        (prev.callPackage ./codelldb {})
      ]
    ) ++ prev.vscode-utils.extensionsFromVscodeMarketplace (fromJSON (readFile ./extensions.json));
  in
    prev.vscode-with-extensions.override {
      vscodeExtensions = extensions;
    };
}
