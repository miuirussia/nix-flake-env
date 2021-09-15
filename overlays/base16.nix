inputs: final: prev: {
  base16-shell = final.stdenv.mkDerivation {
    name = "base16-shell";
    version = inputs.base16-shell.shortRev;

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/opt/base16-shell
      cp -R ./ $out/opt/base16-shell
    '';

    src = inputs.base16-shell;
  };
}
