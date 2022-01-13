inputs: final: prev: {
  # nixUnstable = final.lowPrio (inputs.nixUnstable.defaultPackage.${final.system}.overrideAttrs (pAttrs: {
  #  patches = (pAttrs.patches or []) ++ [ ./fix-segfault.patch ];
  # }));
}
