{ config, pkgs, ... }:

{
  window.menuBarVisibility = "toggle";

  telemetry.telemetryLevel = "off";

  extensions.experimental = {
    affinity = {
      "asvetliakov.vscode-neovim" = 1;
      "nwolverson.ide-purescript" = 2;
    };
    useUtilityProcess = true;
  };

  files = {
    autoSave = "off";
    insertFinalNewline = true;
    trimFinalNewlines = true;
    trimTrailingWhitespace = true;
    watcherExclude = {
      "**/.bazel-cache" = true;
      "**/.git/objects/**" = true;
      "**/.git/subtree-cache/**" = true;
      "**/.spago/**" = true;
      "**/bazel*" = true;
      "**/node_modules" = true;
      "**/output" = true;
    };
    exclude = {
      "**/.bazel-cache" = true;
      "**/.psc-ide-port" = true;
      "**/.psci_modules" = true;
      "**/.purs-repl" = true;
      "**/bazel*" = true;
    };
  };

  search = {
    exclude = {
      "**/.spago" = true;
      "**/bower_components" = true;
      "**/node_modules" = true;
      "**/output" = true;
    };
  };

  emmet = {
    includeLanguages = {
      javascript = "javascriptreact";
    };
    triggerExpansionOnTab = true;
  };

  editor = {
    accessibilitySupport = "off";
    cursorBlinking = "solid";
    fontFamily = "JetBrainsMono Nerd Font";
    fontLigatures = true;
    fontSize = 12;
    formatOnPaste = true;
    formatOnSave = false;
    formatOnSaveMode = "modifications";
    lineNumbers = "relative";
    minimap.enabled = false;
    renderControlCharacters = true;
    renderWhitespace = "boundary";
    rulers = [ 120 ];
    scrollBeyondLastLine = true;
    semanticHighlighting.enabled = true;
    tabSize = 2;
  };

  workbench = {
    colorTheme = "Ayu Mirage Bordered";
    editor = {
      highlightModifiedTabs = true;
      enablePreview = false;
    };
    enableExperiments = false;
    fontAliasing = "auto";
    iconTheme = "ayu";
    settings.enableNaturalLanguageSearch = false;
    tree.indent = 20;
  };

  extensions = {
    autoCheckUpdates = false;
    autoUpdate = false;
    ignoreRecommendations = true;
  };

  update = {
    mode = "none";
    showReleaseNotes = false;
  };

  shellcheck = {
    enable = true;
    executablePath = "${pkgs.shellcheck}/bin/shellcheck";
  };

  nix = {
    enableLanguageServer = true;
    serverPath = "${pkgs.rnix-lsp}/bin/rnix-lsp";
  };

  haskell = {
    serverExecutablePath = "${pkgs.hls}/bin/haskell-language-server-wrapper";
    updateBehavior = "never-check";
  };

  git = {
    path = "${pkgs.git}/bin/git";
    confirmSync = false;
  };

  gitlens = {
    showWelcomeOnInstall = false;
    showWhatsNewAfterUpgrades = false;
  };

  javascript = {
    validate.enable = false;
  };

  flow = {
    pathToFlow = "${pkgs.flow}/bin/flow";
  };

  purescript = {
    addNpmPath = true;
    addSpagoSources = true;
    autoStartPscIde = false;
    autocompleteAddImport = false;
    buildCommand = "spago build --purs-args --json-errors";
  };

  hadolint = {
    hadolintPath = "${pkgs.hadolint}/bin/hadolint";
  };

  rust-analyzer = {
    server.path = "${pkgs.rust-analyzer-nightly}/bin/rust-analyzer";
  };

  vscode-neovim = {
    neovimExecutablePaths =
      let
        vscode-neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          withNodeJs = true;
          withPython3 = true;
          withRuby = true;

          configure = {
            customRC = builtins.readFile ./vscode.vim;
            packages = {
              kdevlab = with pkgs.vimPlugins; {
                start = [
                  vim-sandwich
                ];
                opt = [ ];
              };
            };
          };
        };
      in
      {
        linux = "${vscode-neovim}/bin/nvim";
        darwin = "${vscode-neovim}/bin/nvim";
      };
  };

  jest = {
    nodeEnv = {
      TZ = "UTC";
    };
  };

  vitest = {
    enable = true;
    nodeEnv = {
      TZ = "UTC";
    };
  };

  intelephense = {
    telemetry.enabled = false;
    runtime = "${pkgs.nodejs}/bin/node";
  };

  terminal = {
    integrated = {
      defaultProfile.linux = "zsh";
      env.linux = {
        TZ = "UTC";
      };
    };

  };

  vscode-dhall-lsp-server.executable = "${pkgs.dhall-lsp-server}/bin/dhall-lsp-server";
}
