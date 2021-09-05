#!/usr/bin/env bash

cd "$(pwd)/$(dirname ${BASH_SOURCE})"
version=$(curl "https://api.github.com/repos/vadimcn/vscode-lldb/tags" | jq -r ".[0].name")
if [ -z "$version" ]
then
  echo "version fetch failed"
  exit 1
fi

url="https://github.com/vadimcn/vscode-lldb/releases/download/$version/codelldb-x86_64-darwin.vsix"
sha256=$(nix-prefetch-url $url)

echo -n $version | tee version
echo "{}" \
  | jq ".url=\"$url\" | .sha256=\"$sha256\" | .name=\"vscode-lldb.zip\"" \
  | tee source.json
