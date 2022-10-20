inputs: final: prev:

let
  unstable = import inputs.nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = true;
    };
  };
in {
  vscode-custom = unstable.vscode-with-extensions.override {
    vscodeExtensions = with builtins;(
      [
        final.vscode-extensions.matklad.rust-analyzer-nightly
      ]
    ) ++ unstable.vscode-utils.extensionsFromVscodeMarketplace (fromJSON (readFile ./extensions.json));
  };
}
