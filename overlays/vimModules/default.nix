inputs: final: prev: let
  buildVimPluginFrom2Nix = final.vimUtils.buildVimPluginFrom2Nix;

  buildVimPlugin = name: let
    input = inputs."${name}";
  in
    buildVimPluginFrom2Nix {
      pname = name;
      version = input.shortRev;
      src = input;
    };

  buildNodeVimPlugin = name: buildVimPluginFrom2Nix {
    pname = name;
    inherit (final.nodePackages.${name}) version meta;
    src = "${final.nodePackages.${name}}/lib/node_modules/${name}";
  };
in
{
  vimPlugins = prev.vimPlugins // {
    coc-tsserver = buildNodeVimPlugin "coc-tsserver";
    coc-json = buildNodeVimPlugin "coc-json";
    coc-yaml = buildNodeVimPlugin "coc-yaml";
    coc-git = buildNodeVimPlugin "coc-git";
    coc-markdown-preview-enhanced = buildNodeVimPlugin "coc-markdown-preview-enhanced";
    coc-webview = buildNodeVimPlugin "coc-webview";

    coc-nvim = buildVimPlugin "coc-nvim";

    vim-dhall = buildVimPlugin "vim-dhall";
    vim-js = buildVimPlugin "vim-js";
    vim-json5 = buildVimPlugin "vim-json5";
    vim-jsx-pretty = buildVimPlugin "vim-jsx-pretty";
    vim-lualine = buildVimPlugin "vim-lualine";
    vim-matchup = buildVimPlugin "vim-matchup";
    vim-nginx = buildVimPlugin "vim-nginx";
    vim-purescript = buildVimPlugin "vim-purescript";
    vim-rooter = buildVimPlugin "vim-rooter";
    vim-rust = buildVimPlugin "vim-rust";
    vim-sandwich = buildVimPlugin "vim-sandwich";
    vim-styled-components = buildVimPlugin "vim-styled-components";
    vim-tabular = buildVimPlugin "vim-tabular";
    vim-toml = buildVimPlugin "vim-toml";
    vim-treesitter = buildVimPlugin "vim-treesitter";
    vim-typescript = buildVimPlugin "vim-typescript";
    vim-vista = buildVimPlugin "vim-vista";
  };
}
