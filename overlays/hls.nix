inputs: final: prev: let
  mkHlsPackage = ghcVersion: inputs.hls-nix.lib."${final.system}"."${ghcVersion}";

  hls884package = mkHlsPackage "ghc884";
  hls8107package = mkHlsPackage "ghc8107";
  hls921package = mkHlsPackage "ghc921";
in
{
  hls = hls921package.mkHlsWrapper [
    hls884package.hls-renamed
    hls8107package.hls-renamed
    hls921package.hls-renamed
  ];

  hls884 = hls884package.hls;
  hls8107 = hls8107package.hls;
  hls921 = hls921package.hls;
}
