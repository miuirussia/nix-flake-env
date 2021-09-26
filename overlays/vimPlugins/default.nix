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

  mkTreeSitterGrammars = packages: buildVimPluginFrom2Nix rec {
    pname = "tree-sitter-grammars";
    version = final.tree-sitter.version;
    enabled = map (v: "tree-sitter-${v}") packages;
    src = final.runCommandNoCC "tree-sitter-grammars" {} ''
      mkdir -p $out/parser
      ${builtins.concatStringsSep "\n" (
      builtins.attrValues (
        builtins.mapAttrs
          (
            n: v: "ln -s ${v}/parser $out/parser/${
            builtins.replaceStrings [ "-" ] [ "_" ] (final.lib.removePrefix "tree-sitter-" n)
            }.so"
          )
          (final.lib.filterAttrs (n: _: builtins.elem n enabled) final.tree-sitter.builtGrammars)
      )
    )}
    '';
    dependencies = [];
  };
in
{
  vimPlugins = prev.vimPlugins // {
    tree-sitter-grammars = mkTreeSitterGrammars [
      "bash"
      "c"
      "cpp"
      "css"
      "haskell"
      "html"
      "java"
      "javascript"
      "json"
      "lua"
      "markdown"
      "nix"
      "ocaml"
      "ocaml_interface"
      "python"
      "regex"
      "ruby"
      "rust"
      "toml"
      "tsx"
      "typescript"
      "yaml"
    ];
  } // (
    final.lib.genAttrs [
      "coc-nvim"

      "vim-bufferline"
      "vim-dhall"
      "vim-haskell"
      "vim-js"
      "vim-json5"
      "vim-jsx-pretty"
      "vim-lualine"
      "vim-matchup"
      "vim-nginx"
      "vim-nui"
      "vim-package-info"
      "vim-purescript"
      "vim-rooter"
      "vim-rust"
      "vim-sandwich"
      "vim-styled-components"
      "vim-tabular"
      "vim-toml"
      "vim-treesitter"
      "vim-typescript"
      "vim-vista"
      "vim-web-devicons"
      "vim-which-key"
    ] (name: buildVimPlugin name)
  ) // (
    final.lib.genAttrs [
      "coc-tsserver"
      "coc-json"
      "coc-yaml"
      "coc-git"
      "coc-markdown-preview-enhanced"
      "coc-webview"
    ] (name: buildNodeVimPlugin name)
  );
}
