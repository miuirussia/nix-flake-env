# This file contains configuration that is shared across all hosts.
{ inputs, pkgs, lib, options, ... }: {
  nix = let
    caches = [
      { url = "https://cache.nixos.org"; key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="; }
      { url = "https://kdevlab.cachix.org"; key = "kdevlab.cachix.org-1:/Mxmbtc6KwP9ifFmetjkadaeeqTAtvzBXI81DGLAVIo="; }
      { url = "https://hardselius.cachix.org"; key = "hardselius.cachix.org-1:PoN90aQw2eVMwfAy0MS6V9T2exWlgtHOUBBSnthXAl4="; }
      { url = "https://hydra.iohk.io"; key = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="; }
      { url = "https://iohk.cachix.org"; key = "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="; }
    ];
  in {
    package = pkgs.nixUnstable;

    nixPath = [
      { nixpkgs = inputs.nixpkgs; }
      { nix-flake-env = inputs.self; }
    ];

    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';

    binaryCaches = builtins.map (a: a.url) caches;
    binaryCachePublicKeys = builtins.map (a: a.key) caches;

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
    cat > /etc/ssh/keys/nix-distributed-build <<- EOM
    ${builtins.readFile ./ssh/id_ed25519}
    EOM
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
      rage
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
          otf-apple
          opensans-ttf
        ];
      }
    ]
  );
}
