inputs: final: prev: let
  list-nix-store = final.writeShellScriptBin "list-nix-store" ''
    # Small utility to replace `nix path-info --all`
    set -euo pipefail

    for file in /nix/store/*; do
      case "$file" in
      *.drv)
        # Avoid .drv as they are not generally useful
        continue
        ;;
      *.check)
        # Skip .check file produced by --keep-failed
        continue
        ;;
      *.lock)
        # Skip .lock files
        continue
        ;;
      *)
        echo "$file"
        ;;
      esac
    done
  '';

  snapshot-nix-store = final.writeShellScriptBin "snapshot-nix-store" ''
    ${list-nix-store}/bin/list-nix-store > /tmp/snapshot-nix-store
  '';

  push-snapshot-nix-to-cache = final.writeShellScriptBin "push-snapshot-nix-to-cache" ''
    set -euo pipefail
    PATHS=$(${final.coreutils}/bin/comm -13 <(${final.coreutils}/bin/sort /tmp/snapshot-nix-store) <(${list-nix-store}/bin/list-nix-store))
    echo "$PATHS" | xargs -P8 ${upload-nix}/bin/upload-nix
  '';

  all-nix-deps = final.writeShellScriptBin "all-nix-deps" ''
    set -eu
    set -f
    export IFS=' '
    ${final.nixUnstable}/bin/nix-store -qR --include-outputs $@ $(${final.nixUnstable}/bin/nix-store -q --deriver $@)
  '';

  upload-nix = final.writeShellScriptBin "upload-nix" ''
    set -eu
    set -f
    export IFS=' '
    STORE_PRIVATE_KEY=''$(mktemp)
    echo ''${NIX_UPLOAD_SECRET_KEY:?Please, define binary cache secret key} > $STORE_PRIVATE_KEY
    REMOTE_STORE_URL=''${NIX_UPLOAD_STORE_URL:?Please, define binary cache url. Example: s3://nix-cache?profile=default&endpoint=s3.server.m}
    echo "Signing store paths..."
    ${final.nix}/bin/nix sign-paths -v --recursive --key-file ''${STORE_PRIVATE_KEY} $@
    rm $STORE_PRIVATE_KEY
    echo "Uploading store paths..."
    ${final.nixUnstable}/bin/nix copy -v --to ''${REMOTE_STORE_URL} $@
    echo "...done!"
  '';
in
{
  nix-cache-tools = final.symlinkJoin {
    name = "nix-cache-tools";
    version = "0.2";
    paths = [
      all-nix-deps
      list-nix-store
      push-snapshot-nix-to-cache
      snapshot-nix-store
      upload-nix
    ];
  };
}
