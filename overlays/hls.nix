inputs: final: prev: let
  mkHlsPackage = ghcVersion: inputs.hls-nix.lib."${final.system}"."${ghcVersion}";

  hls865 = mkHlsPackage "ghc865";
  hls884 = mkHlsPackage "ghc884";
  hls8106 = mkHlsPackage "ghc8106";
  hls8107 = mkHlsPackage "ghc8107";
in
{
  hls = prev.buildEnv {
    name = "haskell-language-server";

    paths = [
      hls865.hls-renamed
      hls884.hls-renamed
      hls8106.hls-renamed
      hls8107.hls-renamed
      hls8107.hls-wrapper
    ];
  };

  haskell = let
    mkGhcPackage = ghcVersion: inputs.hls-nix.lib."${final.system}"."${ghcVersion}".ghc;
  in
    prev.haskell // {
      compiler = prev.haskell.compiler // {
        ghc865 = mkGhcPackage "ghc865";
      };
    };
}
