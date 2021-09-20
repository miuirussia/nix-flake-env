{ pkgs, ... }:

{
  "diagnostic.errorSign" = "●";
  "diagnostic.hintSign" = "●";
  "diagnostic.infoSign" = "●";
  "diagnostic.warningSign" = "●";
  "git.addedSign.hlGroup" = "GitGutterAdd";
  "git.changeRemovedSign.hlGroup" = "GitGutterChangeDelete";
  "git.changedSign.hlGroup" = "GitGutterChange";
  "git.enableGutters" = true;
  "git.removedSign.hlGroup" = "GitGutterDelete";
  "git.topRemovedSign.hlGroup" = "GitGutterDelete";
  "tsserver.enableJavascript" = false;
  languageserver = {
    flow = {
      command = "${pkgs.flow}/bin/flow";
      args = [ "lsp" "--from" "coc-nvim" ];
      filetypes = [ "javascript" "javascript.jsx" "javascriptreact" ];
      initializationOptions = {};
      requireRootPattern = true;
      settings = {};
      rootPatterns = [ ".flowconfig" ];
    };
    haskell = {
      command = "${pkgs.hls}/bin/haskell-language-server-wrapper";
      args = [ "--lsp" ];
      filetypes = [ "hs" "lhs" "haskell" "lhaskell" ];
      requireRootPattern = true;
      rootPatterns = [ "*.cabal" "stack.yaml" "cabal.project" "package.yaml" "hie.yaml" ];
      initializationOptions = {
        haskell = {
          formattingProvider = "brittany";
          hlintOn = false;
        };
      };
    };
#   purescript = {
#     command = "${pkgs.nodePackages.purescript-language-server}/bin/purescript-language-server";
#     args = [ "--stdio" ];
#     filetypes = [ "purescript" ];
#     requireRootPattern = true;
#     rootPatterns = [ "bower.json" "psc-package.json" "spago.dhall" ];
#   };
    diagnostic = {
      command = "${pkgs.nodePackages.diagnostic-languageserver}/bin/diagnostic-languageserver";
      args = [ "--stdio" ];
      filetypes = [ "javascript" "javascript.jsx" "javascriptreact" "sh" "dockerfile" ];
      initializationOptions = {
        formatFiletypes = {
          javascript = [ "eslint" ];
          "javascript.jsx" = [ "eslint" ];
          javascriptreact = [ "eslint" ];
        };
        filetypes = let
          js-linters = [ "eslint" ];
        in {
          javascript = js-linters;
          "javascript.jsx" = js-linters;
          javascriptreact = js-linters;
          sh = [ "shellcheck" ];
          dockerfile = [ "hadolint" ];
        };
        formatters = {
          eslint = {
            command = "${pkgs.nodePackages.eslint_d}/bin/eslint_d";
            args = [ "--stdin" "--stdin-filename" "%filepath" "--fix-to-stdout" ];
            rootPatterns = [ "package.json" ];
          };
          prettier-js = {
            command = "${pkgs.nodePackages.prettier-eslint-cli}/bin/prettier-eslint";
            args = [ "--stdin" "--stdin-filename" "%filepath" ];
            rootPatterns = [ "package.json" ];
          };
        };
        linters = {
          eslint = {
            command = "${pkgs.nodePackages.eslint_d}/bin/eslint_d";
            rootPatterns = [ "package.json" ];
            debounce = 50;
            args = [ "--stdin" "--stdin-filename" "%filepath" "--format" "json" ];
            sourceName = "eslint";
            parseJson = {
              errorsRoot = "[0].messages";
              line = "line";
              column = "column";
              endLine = "endLine";
              endColumn = "endColumn";
              message = "\${message} [\${ruleId}]";
              security = "severity";
            };
            securities = {
              "2" = "error";
              "1" = "warning";
            };
          };
          shellcheck = {
            command = "${pkgs.shellcheck}/bin/shellcheck";
            debounce = 50;
            args = [ "--format" "json" "-" ];
            sourceName = "shellcheck";
            parseJson = {
              line = "line";
              column = "column";
              endLine = "endLine";
              endColumn = "endColumn";
              message = "\${message} [\${code}]";
              security = "level";
            };
            securities = {
              "error" = "error";
              "warning" = "warning";
              "info" = "info";
              "style" = "hint";
            };
          };
          hadolint = {
            command = "${pkgs.hadolint}/bin/hadolint";
            debounce = 50;
            args = [ "--format" "json" "-" ];
            sourceName = "hadolint";
            parseJson = {
              line = "line";
              column = "column";
              message = "\${message} [\${code}]";
              security = "level";
            };
            securities = {
              "error" = "error";
              "warning" = "warning";
              "info" = "info";
              "style" = "hint";
            };
          };
        };
      };
    };
    nix = {
      command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      filetypes = [ "nix" ];
    };
  };
}
