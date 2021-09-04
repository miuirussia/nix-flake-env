{ lib, stdenvNoCC, curl }:

{
  name ? "",
  baseURL,
  files ? [],
  downloads ? "",

  # Different ways of specifying the hash.
  sha256 ? "",

  # Shell code executed after the file has been fetched
  # successfully. This can do things like check or transform the file.
  postFetch ? "",

  nativeBuildInputs ? [],
... } @ args:

assert (builtins.isString downloads);
assert (builtins.isList files);
assert (files != [] || downloads != "");

#assert lib.assertMsg (builtins.isString downloads) "downloads should be a string";
#assert lib.assertMsg (builtins.isList files) "files should be a list";
#assert lib.assertMsg (files != [] || downloads != "") "either file or downloads should not be given";

let
  passthruAttrs = removeAttrs args [
	"name" "baseURL" "files" "downloads"
	"outputHash" "outputHashAlgo" "outputHashMode" "sha256"
	"postFetch"
	"nativeBuildInputs"
  ];
in
stdenvNoCC.mkDerivation ({
  name =
    if name != "" then name
    else (lib.replaceChars ["/"] ["-"] (builtins.elemAt (lib.splitString "://" baseURL) 0)) + "-files";

  inherit baseURL;

  nixpkgsVersion = lib.trivial.release;

  nativeBuildInputs = [ curl ] ++ nativeBuildInputs;
  downloads =
    if downloads != "" then downloads
    else (lib.concatMapStrings
      ({file, mode ? "644"}:
        "download \"${file}\" ${mode}\n"
      )
      files
    );

  builder = ./builder.sh;

  outputHash = sha256;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  inherit postFetch;

  # Doing the download on a remote machine just duplicates network
  # traffic, so don't do that.
  preferLocalBuild = true;
} // passthruAttrs)
