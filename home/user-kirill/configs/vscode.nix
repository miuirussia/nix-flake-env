{ pkgs }:

{
  telemetry = {
    enableCrashReporter = false;
    enableTelemetry = false;
  };

  files = {
    autoSave = "off";
    insertFinalNewline = true;
    trimFinalNewlines = true;
    trimTrailingWhitespace = true;
  };

  exclude = {
    "**/.bazel-cache" = true;
    "**/bazel*" = true;
    "**/bower_components" = true;
    "**/node_modules" = true;
  };

  watcherExclude = {
    "**/.bazel-cache" = true;
    "**/bazel*" = true;
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
    scrollBeyondLastLine = false;
    semanticHighlighting.enabled = true;
    tabSize = 2;
  };

  workbench = {
    colorTheme = "Atom One Dark";
    editor = {
      highlightModifiedTabs = true;
      enablePreview = false;
    };
    enableExperiments = false;
    fontAliasing = "auto";
    iconTheme = "material-icon-theme";
    settings.enableNaturalLanguageSearch = false;
    tree.indent = 20;
  };

  search = {
    location = "panel";
  };

  extensions = {
    autoCheckUpdates = false;
    autoUpdate = false;
    ignoreRecommendations = true;
  };

  update = {
    channel = "none";
    mode = "none";
    showReleaseNotes = false;
  };

  terminal.integrated.shell = {
    linux = "${pkgs.zsh}/bin/zsh";
    osx = "${pkgs.zsh}/bin/zsh";
  };

  shellcheck = {
    enable = true;
    executablePath = "${pkgs.shellcheck}/bin/shellcheck";
  };

  nix = {
    enableLanguageServer = true;
    serverPath = "${pkgs.rnix-lsp}/bin/rnix-lsp";
  };

  haskell.serverExecutablePath = "${pkgs.hls}/bin/haskell-language-server-wrapper";
  haskell.updateBehavior = "never-check";

  git.path = "${pkgs.git}/bin/git";

  gitlens = {
    showWelcomeOnInstall = false;
    showWhatsNewAfterUpgrades = false;
  };

  javascript.validate.enable = false;

  flow.pathToFlow = "${pkgs.flow}/bin/flow";

  rust-client.rustupPath = "${pkgs.rustup}/bin/rustup";

  purescript.pursExe = "${pkgs.nodePackages.purescript}/bin/purs";

  hadolint.hadolintPath = "${pkgs.hadolint}/bin/hadolint";

  rust-analyzer.server.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
}
