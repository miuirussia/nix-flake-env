inputs: final: prev: {
  nixUnstable = final.lowPrio (inputs.nixUnstable.defaultPackage.${final.system}.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
    disallowedReferences = [ ];
  }));
}
