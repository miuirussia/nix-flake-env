inputs: final: prev: {
  sumneko-lua-language-server = let
    mainSrc = (builtins.fromJSON (builtins.readFile ./lua-language-server/hash.json));
    src = prev.fetchgit {
      inherit (mainSrc) url rev sha256 fetchSubmodules;
    };
  in
    prev.stdenv.mkDerivation rec {
      name = "sumneko-lua-language-server";
      version = src.rev;

      nativeBuildInputs = with final; [
        pkg-config
        makeWrapper
      ];

      platform = if final.stdenv.isDarwin then "macOS" else "Linux";

      buildPhase = ''
        cp -R ${./lua-language-server} ./bin/
      '';

      installPhase = ''
        mkdir -p $out/share/sumneko-lua-language-server/
        cp -R bin $out/share/sumneko-lua-language-server/
        # cp -R libs $out/share/sumneko-lua-language-server/
        cp -R locale $out/share/sumneko-lua-language-server/
        cp -R script $out/share/sumneko-lua-language-server/
        cp -R test $out/share/sumneko-lua-language-server/
        cp -R meta $out/share/sumneko-lua-language-server/

        cp main.lua platform.lua test.lua debugger.lua $out/share/sumneko-lua-language-server/

        mkdir -p $out/bin
        chmod a+x $out/share/sumneko-lua-language-server/bin/$platform/lua-language-server
        makeWrapper $out/share/sumneko-lua-language-server/bin/$platform/lua-language-server \
          $out/bin/lua-language-server \
          --add-flags "-E -e LANG=en $out/share/sumneko-lua-language-server/main.lua \
          --logpath='~/.cache/sumneko_lua/log' \
          --metapath='~/.cache/sumneko_lua/meta'"
      '';

      inherit src;

      meta = with final.lib; {
        description = "Lua language server";
        homepage = "https://github.com/sumneko/lua-language-server";
        platforms = with platforms; linux ++ darwin;
      };
    };
}
