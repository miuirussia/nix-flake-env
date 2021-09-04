{ pkgs, lib, stdenvNoCC, subversion, jq }:

{
  name ? "",
  owner,
  repo,
  rev,
  paths,

  sha256,

... } @ args:
let
  fetchMultiURLs = pkgs.callPackage ../fetchmultiurls {};
  passthruAttrs = removeAttrs args [ "name" "owner" "repo" "rev" "paths" "sha256" ];
  nameRev = if (builtins.stringLength rev) != 52 then rev
    else (builtins.substring 0 8 rev);
in
fetchMultiURLs {
  name =
    if name != "" then name
    else "github-${owner}-${repo}-${nameRev}-files";

  baseURL = "https://github.com/${owner}/${repo}/raw/${rev}";

  nativeBuildInputs = [ jq ];

  downloads = ''
    set -e

    tree_url="https://api.github.com/repos/${owner}/${repo}/git/trees/${rev}"
    paths=$(
      "''${curl[@]}" -C - --fail "''${tree_url// /%20}?recursive=true" |
        jq -r '.tree[] | select(.type == "blob") | (.mode[2:]  + " " + .path)'
    )

    downloadPath() {
      header "downloading $1"
      escaped_path=$(sed 's/[^^]/[&]/g; s/\^/\\^/g' <<< $1)

      echo "$paths" | grep -E "[0-9]+ $escaped_path(/|\$)" |
        while read mode file; do
          download "$file" "$mode"
        done
    }

  '' + (lib.concatMapStrings (path: "downloadPath \"${path}\"\n") paths);

  inherit sha256;
} // passthruAttrs
