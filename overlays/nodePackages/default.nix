inputs: final: prev: {
  nodePackages = prev.nodePackages // (prev.callPackage ./env { nodejs = prev.nodejs; });
}
