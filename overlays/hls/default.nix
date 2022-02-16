inputs: final: prev:
let
  planConfigFor = ghcVersion: {
    compiler-nix-name = ghcVersion;
    name = "haskell-language-server";
    version = "latest";
    index-state = "2022-02-16T00:00:00Z";
    materialized = ./materialized + "/${final.system}/${ghcVersion}";
  };

  longDesc = suffix: ''
    Haskell Language Server (HLS) is the latest attempt make an IDE-like
    experience for Haskell that's compatible with different editors. HLS
    implements Microsoft's Language Server Protocol (LSP). With this
    approach, a background service is launched for a project that answers
    questions needed by an editor for common IDE features.
    Note that you need a version of HLS compiled specifically for the GHC
    compiler used by your project.  If you have multiple versions of GHC and
    HLS installed in your path, then a provided wrapper can be used to
    select the right one for the version of GHC used by your project.
    ${suffix}
  '';

  hls-renamed = ghcVersion:
    let
      trueVersion = {
        "ghc861" = "8.6.1";
        "ghc862" = "8.6.2";
        "ghc863" = "8.6.3";
        "ghc864" = "8.6.4";
        "ghc865" = "8.6.5";
        "ghc881" = "8.8.1";
        "ghc882" = "8.8.2";
        "ghc883" = "8.8.3";
        "ghc884" = "8.8.4";
        "ghc8101" = "8.10.1";
        "ghc8102" = "8.10.2";
        "ghc8103" = "8.10.3";
        "ghc8104" = "8.10.4";
        "ghc8105" = "8.10.5";
        "ghc8106" = "8.10.6";
        "ghc8107" = "8.10.7";
        "ghc901" = "9.0.1";
        "ghc902" = "9.0.2";
        "ghc921" = "9.2.1";
      }."${ghcVersion}" or (throw "unsupported GHC Version: ${ghcVersion}");
      hls = (final.haskell-nix.hackage-package (planConfigFor ghcVersion)).components.exes.haskell-language-server;
    in
    final.stdenv.mkDerivation {
      name = "haskell-language-server-${ghcVersion}";
      version = hls.version;
      phases = [ "installPhase" ];
      nativeBuildInputs = [ final.makeWrapper ];
      installPhase = ''
        mkdir --parents $out/bin
        makeWrapper \
          "${hls}/bin/haskell-language-server" \
          "$out/bin/haskell-language-server-${trueVersion}" \
          --prefix PATH : ${final.lib.makeBinPath [(final.stack-with-args "--no-nix --system-ghc --no-install-ghc") final.haskell-nix.compiler."${ghcVersion}" final.cabal-install]}
      '';
      meta = hls.meta // {
        description =
          "Haskell Language Server (HLS) for GHC ${trueVersion}, renamed binary";
        longDescription = longDesc ''
          This package provides the server executable compiled against
          ${trueVersion}.  The binary has been renamed from
          "haskell-language-server" to "haskell-language-server-${ghcVersion}" to
          allow Nix to install multiple versions to the same profile for those
          that wish to use the HLS wrapper.
        '';
      };
    };

  hls-wrapper = ghcVersion: injectPackages:
    let
      wrapper = (final.haskell-nix.hackage-package (planConfigFor ghcVersion)).components.exes.haskell-language-server-wrapper;
    in
    final.stdenv.mkDerivation {
      name = "haskell-language-server-wrapper-${ghcVersion}";
      version = wrapper.version;
      phases = [ "installPhase" ];
      nativeBuildInputs = [ final.makeWrapper ];
      installPhase = ''
        mkdir --parents $out/bin
        makeWrapper \
           "${wrapper}/bin/haskell-language-server-wrapper" \
           "$out/bin/haskell-language-server-wrapper" \
           --prefix PATH : ${final.lib.makeBinPath injectPackages}
      '';
    };

  hls884 = hls-renamed "ghc884";
  hls8107 = hls-renamed "ghc8107";
in
{
  hls = hls-wrapper "ghc8107" [
    hls884
    hls8107
  ];

  inherit hls884 hls8107;
}
