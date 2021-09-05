{ fetchurl, vscode }:

vscode.overrideAttrs (
  _: {
    pname = "vscode-latest";
    version = builtins.readFile ./version;

    src = fetchurl (builtins.fromJSON (builtins.readFile ./source.json));
  }
)
