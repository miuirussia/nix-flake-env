# This file contains configuration that is shared across all hosts.
{ inputs, pkgs, lib, options, ... }: {
  nix = {
    package = pkgs.nixUnstable;

    nixPath = [
      { nixpkgs = inputs.nixpkgs; }
      { nix-flake-env = inputs.self; }
    ];

    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';

    binaryCaches = [
      "https://cache.nixos.org/"
      "https://nix-cache.s3.kdevlab.com"
      "https://kdevlab.cachix.org"
      "https://hardselius.cachix.org"
      "https://hydra.iohk.io"
      "https://iohk.cachix.org"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "s3.kdevlab.com:PhuKrzVfCsS0T1R4FnslJy2qUBul9oQ2CTSO/fg/llM="
      "kdevlab.cachix.org-1:/Mxmbtc6KwP9ifFmetjkadaeeqTAtvzBXI81DGLAVIo="
      "hardselius.cachix.org-1:PoN90aQw2eVMwfAy0MS6V9T2exWlgtHOUBBSnthXAl4="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    ];

    distributedBuilds = true;

    buildMachines = [
      {
        system = "x86_64-linux";
        hostName = "nix-build1";
      }
    ];
  };

  environment.etc."ssh/ssh_config.d/nix-distributed-build".text = ''
    Host nix-build1
      HostName 127.0.0.1
      IdentityFile /etc/ssh/keys/nix-distributed-build
      Port 2233
      User nix-build1
  '';

  system.activationScripts.postActivation.text = ''
    echo "setting up nix-distributed-build..." >&2

    mkdir -p /etc/ssh/keys
    cp -f ${./ssh/id_ed25519} /etc/ssh/keys/nix-distributed-build
    chmod 0600 /etc/ssh/keys/nix-distributed-build
  '';

  environment = {
    systemPackages = with pkgs; [
      autoconf
      automake
      coreutils
      curl
      findutils
      gnugrep
      gnupatch
      gnupg
      gnused
      gnutar
      htop
      jq
      rename
      rsync
      shellcheck
      tmuxinator
      tree
      wget
      xz
      zlib

      gitAndTools.diff-so-fancy
      git-crypt

      nix-prefetch-git

    ];
  };

  programs = {
    zsh = {
      enable = true;
      promptInit = "";
    };
  };

  fonts = (
    lib.mkMerge [
      # NOTE: Remove this condition when `nix-darwin` aligns with NixOS
      (
        if (builtins.hasAttr "fontDir" options.fonts) then {
          fontDir.enable = true;
        } else {
          enableFontDir = true;
        }
      )
      {
        fonts = with pkgs; [
          jetbrains-mono
        ];
      }
    ]
  );
}
