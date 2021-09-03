{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:miuirussia/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          {
            packages.hello = pkgs.hello;

            defaultPackage = pkgs.hello;
          }
    );
}
