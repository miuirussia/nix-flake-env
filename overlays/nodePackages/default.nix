inputs: final: prev: 

let
  unstable = import inputs.nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = true;
    };
  };
in
{
  nodePackages = prev.nodePackages // (unstable.callPackage ./lib { nodejs = unstable.nodejs-18_x; });
}
