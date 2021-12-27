inputs: final: prev: {
  nixUnstable = final.lowPrio ((inputs.nixUnstable.defaultPackage.${final.system}).overrideAttrs (_: {
    patches = [ ./toml-fix.patch ];
  }));
}
