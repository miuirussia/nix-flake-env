inputs: final: prev: let
  mkHlsPackage = ghcVersion: inputs.hls-nix.lib."${final.system}"."${ghcVersion}";

  hls884package = mkHlsPackage "ghc884";
  hls8107package = mkHlsPackage "ghc8107";
in
{
  hls = hls8107package.mkHlsWrapper [
    hls884package.hls-renamed
    hls8107package.hls-renamed
  ];

  hls884 = hls884package.hls;
  hls8107 = hls8107package.hls;
}
