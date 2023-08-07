{ callPackage, python3, stdenvNoCC }:
let
  fetchGitHubFiles = callPackage ./build-support/fetchgithubfiles { };

  font-patcher-repo = {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "ef2ff04a3ec28f522950a6c486715accc0601478";
  };

  font-patcher-src = fetchGitHubFiles {
    name = "font-patcher-${font-patcher-repo.rev}-src";
    inherit (font-patcher-repo) owner repo rev;
    paths = [
      "bin/scripts/name_parser"
      "font-patcher"
      "src/glyphs"
    ];
    sha256 = "sha256-SnHgJFtvVgxUlvlLY6W6uHf37cjv8Aa65d3WaBZP0vA=";
  };
in
stdenvNoCC.mkDerivation {
  name = "font-patcher-${font-patcher-repo.rev}";

  src = font-patcher-src;

  phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];
  propagatedBuildInputs = [
    (python3.withPackages (ps: with ps; [ fontforge fonttools configparser ]))
  ];

  buildPhase = ''
    substituteInPlace font-patcher \
      --replace '__dir__ + "/src/glyphs/"' "\"$out/share/nerdfonts/glyphs/\""
    substituteInPlace font-patcher \
      --replace '/bin/scripts/name_parser/' "/scripts/name_parser/"
  '';

  installPhase = ''
    install -m 755 -D font-patcher $out/bin/font-patcher
    mkdir -p $out/bin/scripts/
    cp --no-preserve=mode,ownership -r bin/scripts/* $out/bin/scripts/
    chmod -R 755 $out/bin/scripts/
    mkdir -p $out/share/nerdfonts/glyphs/
    cp -r src/glyphs/* $out/share/nerdfonts/glyphs/
  '';
}
