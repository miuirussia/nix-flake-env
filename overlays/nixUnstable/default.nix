inputs: final: prev: {
  nixUnstable = inputs.nixUnstable.defaultPackage.${final.system};
}
