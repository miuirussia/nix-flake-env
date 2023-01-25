inputs: final: prev: {
  nixUnstable = final.lowPrio inputs.nixUnstable.packages.${final.system}.nix;
}
