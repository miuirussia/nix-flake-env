inputs: final: prev:
let
  unstable = import inputs.nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = true;
    };
  };
in {
  haskell = prev.haskell // {
    compiler = prev.haskell.compiler // {
      ghc925 = unstable.haskell.compiler.ghc925;
      ghc944 = unstable.haskell.compiler.ghc944;
    };
  };
}
