final: prev: {
  pure-prompt = prev.pure-prompt.overrideAttrs (old: {
    name = "TEST PURE";
    patches = (old.patches or [ ]);
  });
}
