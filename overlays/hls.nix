inputs: final: prev: let
  mkHlsPackage = ghcVersion: inputs.hls-nix.lib."${final.system}"."${ghcVersion}";

  hls865package = mkHlsPackage "ghc865";
  hls884package = mkHlsPackage "ghc884";
  hls8106package = mkHlsPackage "ghc8106";
  hls8107package = mkHlsPackage "ghc8107";
in
{
  hls = hls8107package.mkHlsWrapper [
    hls865package.hls-renamed
    hls884package.hls-renamed
    hls8106package.hls-renamed
    hls8107package.hls-renamed
  ];

  hls865 = hls865package.hls;
  hls884 = hls884package.hls;
  hls8106 = hls8106package.hls;
  hls8107 = hls8107package.hls;

  haskell = let
    mkGhcPackage = ghcVersion: inputs.hls-nix.lib."${final.system}"."${ghcVersion}".ghc;
  in
    prev.haskell // {
      compiler = prev.haskell.compiler // {
        ghc865 = mkGhcPackage "ghc865";
      };
    };
}
