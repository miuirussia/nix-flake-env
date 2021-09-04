inputs: final: prev: {
  kitty = prev.kitty.overrideAttrs (
    prevAttrs: {
      postInstall = prevAttrs.postInstall + (
        if prev.stdenv.isDarwin then ''
          cp -f "${./kitty.icns}" "$out/Applications/kitty.app/Contents/Resources/kitty.icns"
        '' else ""
      );
    }
  );
}
