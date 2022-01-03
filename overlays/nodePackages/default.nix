inputs: final: prev: {
  nodePackages = prev.nodePackages // (prev.callPackage ./lib { nodejs = prev.nodejs-14_x; });
}
