{ fetchurl, lib, p7zip, stdenv }:

stdenv.mkDerivation {
  name = "otf-apple";
  version = "1.0";

  buildInputs = [ p7zip ];
  src = [(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"; sha256 = "1ch7bi43fb95yz9742ba7k7sckgifl96p7xj3r7k01br561xx12y";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg"; sha256 = "1aqz9g6ndgb4ilqbqbw7ps0zf4kafbhlwk8py6sgqn42gs5khsgf";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"; sha256 = "0vjdpl3xyxl2rmfrnjsxpxdizpdr4canqa1nm63s5d3djs01iad6";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg"; sha256 = "1hgxyizpgam7y1xh36fsypd3a1nn417wdnnfk1zahq9vhxrrds2w";})];

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
