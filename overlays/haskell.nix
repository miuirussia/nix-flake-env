inputs: final: prev:
let
  unstable = import inputs.nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = true;
    };
  };
in {
  haskell = unstable.haskell;
  haskell-ci = unstable.haskell-ci;
  haskell-ci-unstable = unstable.haskell-ci-unstable;
  haskell-language-server = unstable.haskell-language-server;
  shellcheck = unstable.shellcheck;
  pandoc = unstable.pandoc;
  haskellPackages = unstable.haskellPackages;
}
