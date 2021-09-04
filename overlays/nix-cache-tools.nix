inputs: final: prev: let
  all-nix-deps = prev.writeShellScriptBin "all-nix-deps" ''
    set -eu
    set -f
    export IFS=' '
    nix-store -qR --include-outputs $@ $(nix-store -q --deriver $@)
  '';

  upload-nix = prev.writeShellScriptBin "upload-nix" ''
    set -eu
    set -f
    export IFS=' '
    STORE_PRIVATE_KEY=''$(mktemp)
    echo ''${NIX_UPLOAD_SECRET_KEY:?Please, define binary cache secret key} > $STORE_PRIVATE_KEY
    STORE_URL=''${NIX_UPLOAD_STORE_URL:?Please, define binary cache url. Example: s3://nix-cache?profile=default&endpoint=s3.server.m}
    echo "Signing store paths..."
    nix sign-paths -v --recursive --key-file ''${STORE_PRIVATE_KEY} $@
    rm $STORE_PRIVATE_KEY
    echo "Uploading store paths..."
    nix copy -v --to ''${STORE_URL} $@
    echo "...done!"
  '';
in
{
  nix-cache-tools = prev.symlinkJoin {
    name = "nix-cache-tools";
    version = "0.1";
    paths = [
      all-nix-deps
      upload-nix
    ];
  };
}
