inputs: self: super: {
  nixUnstable = self.lib.lowPrio (
    super.nixUnstable.overrideAttrs (
      old: {
        patches = old.patches or [] ++ [
          ./revert-769ca4e.patch
        ];
      }
    )
  );
}
