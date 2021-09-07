inputs: final: prev: let
  mkHlsPackage = ghcVersion: (import inputs.hls-nix).build."${final.system}"."${ghcVersion}";

  hls865 = mkHlsPackage "ghc865";
  hls884 = mkHlsPackage "ghc884";
  hls8106 = mkHlsPackage "ghc8106";
  hls8107 = mkHlsPackage "ghc8107";
in
{
  hls = prev.buildEnv {
    name = "haskell-language-server";
    version = inputs.hls-nix.shortRev;

    paths = [
      hls865.hls-renamed
      hls884.hls-renamed
      hls8106.hls-renamed
      hls8107.hls-renamed
      hls8107.hls-wrapper
      hls8107.hls-wrapper-nix
    ];
  };

  haskell = let
    mkGhcPackage = ghcVersion: (import inputs.hls-nix).build."${final.system}"."${ghcVersion}".ghc;
  in
    prev.haskell // {
      compiler = prev.haskell.compiler // {
        ghc865 = mkGhcPackage "ghc865";
        ghc884 = mkGhcPackage "ghc884";
        ghc8104 = mkGhcPackage "ghc8104";
        ghc8105 = mkGhcPackage "ghc8105";
        ghc8106 = mkGhcPackage "ghc8106";
        ghc8107 = mkGhcPackage "ghc8107";
      };
    };
}
