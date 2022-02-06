{ callPackage, python3, stdenvNoCC }:
let
  fetchGitHubFiles = callPackage ./build-support/fetchgithubfiles { };

  font-patcher-repo = {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "ac5a5f0b591170dbecfcd503aa22a564cd88be1d";
  };

  font-patcher-src = fetchGitHubFiles {
    name = "font-patcher-${font-patcher-repo.rev}-src";
    inherit (font-patcher-repo) owner repo rev;
    paths = [
      "font-patcher"
      "src/glyphs"
    ];
    sha256 = "1yf12p4dsfy5pqnmn28q7pbadr63dpymmx8xzck21sbwl5qhlfzm";
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
  '';

  installPhase = ''
    install -m 755 -D font-patcher $out/bin/font-patcher
    install -m 644 -D src/glyphs/* -t $out/share/nerdfonts/glyphs/
  '';
}
