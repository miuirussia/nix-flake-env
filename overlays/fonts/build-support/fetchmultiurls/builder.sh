source $stdenv/setup

curlVersion=$(curl -V | head -1 | cut -d' ' -f2)

# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway).
curl=(
    curl
    --location
    --max-redirs 20
    --retry 3
    --disable-epsv
    --cookie-jar cookies
    --insecure
    --user-agent "curl/$curlVersion Nixpkgs/$nixpkgsVersion"
    $curlOpts
    $NIX_CURL_FLAGS
)

downloadPath="$out"
if [ -n "$downloadToTemp" ]; then downloadPath="$TMPDIR"; fi

download() {
    local file=$1
    local mode=$2
    local url="$baseURL/$file"

    local out="$downloadPath/$file"
    mkdir -p $(dirname $out)

    # if we get error code 18, resume partial download
    local curlexit=18;
    while [ $curlexit -eq 18 ]; do
       # keep this inside an if statement, since on failure it doesn't abort the script
       "${curl[@]}" -C - --fail "${url// /%20}" --output "$out"
       curlexit=$?;
    done

    if [ $curlexit -ne 0 ]; then
        echo "error: cannot download $url" 1>&2
        exit 1
    fi

    if [[ $mode != "" ]]; then
        chmod "$mode" "$out"
    fi
}


# URL list may contain ?. No glob expansion for that, please
set -o noglob
eval "$downloads"
set +o noglob

runHook postFetch
