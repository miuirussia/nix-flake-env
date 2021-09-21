inputs: final: prev: let
  tree-sitter = prev.stdenv.mkDerivation {
    name = "tree-sitter";
    version = inputs.tree-sitter.shortRev;

    src = inputs.tree-sitter;
    makeFlags = [ "PREFIX=$(out)" ];

    meta = with prev.lib; {
      homepage = "https://github.com/tree-sitter/tree-sitter";
      description = "A parser generator tool and an incremental parsing library";
      longDescription = ''
        Tree-sitter is a parser generator tool and an incremental parsing library.
        It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.
        Tree-sitter aims to be:
        * General enough to parse any programming language
        * Fast enough to parse on every keystroke in a text editor
        * Robust enough to provide useful results even in the presence of syntax errors
        * Dependency-free so that the runtime library (which is written in pure C) can be embedded in any application
      '';
      license = licenses.mit;
      maintainers = [ maintainers.Profpatsch ];
    };
  };
in
{
  neovim-nightly = prev.neovim-unwrapped.overrideAttrs (
    prevAttrs: {
      pname = "neovim-nightly";
      version = inputs.neovim.shortRev;

      buildInputs = prevAttrs.buildInputs ++ [
        tree-sitter
      ];

      src = inputs.neovim;
    }
  );
}
