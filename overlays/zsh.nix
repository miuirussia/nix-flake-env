inputs: final: prev: {
  zshPlugins = {
    zsh-syntax-highlighting = {
      name = "zsh-syntax-highlighting";
      src = inputs.zsh-syntax-highlighting;
    };

    fast-syntax-highlighting = {
      name = "fast-syntax-highlighting";
      src = inputs.fast-syntax-highlighting;
    };

    zsh-history-substring-search = {
      name = "zsh-history-substring-search";
      src = inputs.zsh-history-substring-search;
    };
  };
}
