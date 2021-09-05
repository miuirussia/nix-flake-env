#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.requests python3Packages.pyyaml python3Packages.libversion python3Packages.packaging

from packaging.version import Version, parse
from requests import post, get
from yaml import load, dump
from functools import cmp_to_key
from libversion import version_compare
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper
import json
import re
import subprocess
import xml.etree.ElementTree as ET

def getLatestVersionInfo(publisher, name):
    url = 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery'
    data = { 'assetTypes': None
           , 'filters': [
               { 'criteria': [{'filterType': 7, 'value': '{}.{}'.format(publisher,name)}]
               , 'direction': 2
               , 'pageSize': 100
               , 'pageNumber': 1
               , 'sortBy': 0
               , 'sortOrder': 0
               , 'pagingToken': None
               }
             ]
           , 'flags': 103
           }
    headers = { 'Content-type': 'application/json', 'Accept': 'application/json;api-version=6.1-preview.1;excludeUrls=true' }
    r = post(url, data=json.dumps(data), headers=headers)
    versions = r.json()['results'][0]['extensions'][0]['versions']
    latest_version = sorted(versions, key=lambda x: parse(x['version']), reverse=True)[0]
    ver = latest_version['version']
    files = latest_version['files']
    vsix = list(filter(lambda x: x['assetType'] == 'Microsoft.VisualStudio.Services.VSIXPackage', files))[0]
    url = vsix['source']
    return ver, url

def prefetchUrl(url):
    args = ["nix-prefetch-url", url]
    o = subprocess.check_output(args).decode("utf-8")
    return o.strip()

def getExtension(name, publisher):
    ver, url = getLatestVersionInfo(publisher, name)
    sha256 = prefetchUrl(url)
    return {'name': name, 'publisher': publisher, 'version': ver, 'sha256': sha256}

def main():
    with open('extensions.yaml') as f:
        exts = load(f.read(), Loader=Loader)
        result = [getExtension(name=ext['name'], publisher=ext['publisher']) for ext in exts]
        with open('extensions.json', 'w+') as target:
            json.dump(result, target, indent=2, sort_keys=True)

if __name__ == '__main__':
    main()
