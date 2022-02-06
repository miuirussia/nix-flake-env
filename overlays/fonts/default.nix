inputs: final: prev: {
  font-patcher = prev.callPackage ./font-patcher.nix { };

  otf-apple = prev.callPackage ./otf-apple.nix { };

  emoji-apple = prev.callPackage ./emoji-apple.nix { };

  jetbrains-mono = prev.callPackage ./jetbrains-mono.nix { inherit inputs; };
}
