inputs: final: prev:

let
  unstable = import inputs.nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = true;
    };
  };
in
rec {
  vscode-mp-extensions = with builtins; unstable.vscode-utils.extensionsFromVscodeMarketplace (fromJSON (readFile ./extensions.json));

  vscode-custom = unstable.vscode-with-extensions.override {
    vscode = unstable.vscodium;
    vscodeExtensions = vscode-mp-extensions;
  };
}
