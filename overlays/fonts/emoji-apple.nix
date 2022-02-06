{ runCommand, requireFile }:

runCommand "emoji-apple" {
  src = requireFile {
    name = "AppleColorEmoji.ttf";
    sha256 = "1v4hdj4n01sbahbqa1k7l2843cr81an4zd2lc622bbxvyxmy0nvy";
    message = ''
      Get file from latest macOS from /System/Library/Fonts/Apple Color Emoji.ttc
      Unpack with https://github.com/kreativekorp/charset
      bin/ttc-unpack.py Apple Color Emoji.ttc
      Add AppleColorEmoji.ttf to nix store
      nix-store --add-fixed sha256 AppleColorEmoji.ttf
    '';
  };
} ''
  mkdir -p $out/share/fonts/truetype/AppleColorEmoji
  cp $src $out/share/fonts/truetype/AppleColorEmoji/AppleColorEmoji.ttf
''
