inputs: final: prev: {
  gnupg = prev.gnupg.overrideAttrs (prevAttrs: rec {
    version = "2.3.4";
    src = prev.fetchurl {
      url = "mirror://gnupg/gnupg/${prevAttrs.pname}-${version}.tar.bz2";
      sha256 = "1bh2ai04v6zky9fa1a7gsa4ynz7ixdxdpl8znpbrlzqxzg58wipk";
    };
  });
}
