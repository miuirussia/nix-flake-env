{ lib, fontforge, font-patcher, stdenv, inputs }:

stdenv.mkDerivation {
  name = "jetbrains-mono";
  version = inputs.jetbrains-mono.shortRev;

  src = inputs.jetbrains-mono;

  buildPhase = ''
    export PYTHONIOENCODING=utf8
    for filename in ./fonts/ttf/*.ttf; do
      ${fontforge}/bin/fontforge -script ${font-patcher}/bin/font-patcher $filename -c -out ./out
    done
  '';

  installPhase = ''
    mkdir -p $out/share/fonts $out/share/fonts/truetype $out/share/fonts/woff2
    cp ./out/*.ttf -d $out/share/fonts/truetype
    cp ./fonts/webfonts/*.woff2 -d $out/share/fonts/woff2
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
