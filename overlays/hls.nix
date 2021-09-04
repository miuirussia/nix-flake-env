inputs: final: prev: let
  mkHlsPackage = { ghcVersion }: import inputs.hls-nix { inherit ghcVersion; };

  hls865 = mkHlsPackage { ghcVersion = "ghc865"; };
  hls884 = mkHlsPackage { ghcVersion = "ghc884"; };
  hls8106 = mkHlsPackage { ghcVersion = "ghc8106"; };
  hls8107 = mkHlsPackage { ghcVersion = "ghc8107"; };
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
      hls8107.hls-wrapper-nix
    ];
  };

  haskell = let
    mkGhcPackage = { ghcVersion }: (import inputs.hls-nix { inherit ghcVersion; }).ghc;
  in
    prev.haskell // {
      compiler = prev.haskell.compiler // {
        ghc865 = mkGhcPackage { ghcVersion = "ghc865"; };
        ghc884 = mkGhcPackage { ghcVersion = "ghc884"; };
        ghc8104 = mkGhcPackage { ghcVersion = "ghc8104"; };
        ghc8105 = mkGhcPackage { ghcVersion = "ghc8105"; };
        ghc8106 = mkGhcPackage { ghcVersion = "ghc8106"; };
        ghc8107 = mkGhcPackage { ghcVersion = "ghc8107"; };
      };
    };
}
