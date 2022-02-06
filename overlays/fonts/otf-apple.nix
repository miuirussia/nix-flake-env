{ fetchurl, lib, p7zip, stdenv }:

stdenv.mkDerivation {
  name = "otf-apple";
  version = "1.0";

  buildInputs = [ p7zip ];
  src = [(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"; sha256 = "0na81kwdcyja39s8hjcp8dzs3rpp10m2w6x8wqk4j2lqa2zq6iwv";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg"; sha256 = "0cz6wbdl1jcavh00sdd6hfcg3xws6sv55ypm6ynjgx9b4gbih05r";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"; sha256 = "0spqlf4ndxh8k6dr7vcrhqrsb8b767mgab12a6sz46g19lz8jy7j";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg"; sha256 = "1nh2l8md9dcbj0ifc9knh0x9way2xs33kx5wjw1qblbqsj8m031h";})];

  sourceRoot = "./";

  preUnpack = "mkdir fonts";

  unpackCmd = ''
    7z x $curSrc >/dev/null
    dir="$(find . -not \( -path ./fonts -prune \) -type d | sed -n 2p)"
    cd $dir 2>/dev/null
    7z x *.pkg >/dev/null
    7z x Payload~ >/dev/null
    mv Library/Fonts/*.otf ../fonts/
    cd ../
    rm -R $dir
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/{SF\ Pro,SF\ Mono,SF\ Compact,New\ York}
    cp -a fonts/SF-Pro*.otf $out/share/fonts/opentype/SF\ Pro
    cp -a fonts/SF-Mono*.otf $out/share/fonts/opentype/SF\ Mono
    cp -a fonts/SF-Compact*.otf $out/share/fonts/opentype/SF\ Compact
    cp -a fonts/NewYork*.otf $out/share/fonts/opentype/New\ York
  '';
}
