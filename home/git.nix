{ config, pkgs, ... }: {
  programs.git = {
    enable = true;

    aliases = {
      authors = "!${pkgs.git}/bin/git log --pretty=format:%aN"
      + " | ${pkgs.coreutils}/bin/sort" + " | ${pkgs.coreutils}/bin/uniq -c"
      + " | ${pkgs.coreutils}/bin/sort -rn";
      b = "branch --color -v";
      ca = "commit --amend";
      changes = "diff --name-status -r";
      clone = "clone --recursive";
      co = "checkout";
      root = "!pwd";
      spull = "!${pkgs.git}/bin/git stash" + " && ${pkgs.git}/bin/git pull"
      + " && ${pkgs.git}/bin/git stash pop";
      su = "submodule update --init --recursive";
      undo = "reset --soft HEAD^";
      w = "status -sb";
      wdiff = "diff --color-words";
      l = "log --graph --pretty=format:'%Cred%h%Creset"
      + " —%Cblue%d%Creset %s %Cgreen(%cr)%Creset'"
      + " --abbrev-commit --date=relative --show-notes=*";
      s = "status";
      st = "status -sb";
      feature = "!feature() { git checkout -b feature/$1 2>/dev/null || git checkout feature/$1; 2>/dev/null }; feature";
    };

    extraConfig = {
      core = {
        editor = "nvim";
        logAllRefUpdates = true;
        pager = "${pkgs.diff-so-fancy}/bin/diff-so-fancy | ${pkgs.less}/bin/less --tabs=4 -RFX";
        precomposeunicode = true;
        trustctime = false;
        whitespace = "trailing-space,space-before-tab";
      };

      init.defaultBranch = "master";

      branch.autosetupmerge = true;
      color.ui = "auto";
      commit.verbose = true;
      diff.submodule = "log";
      diff.tool = "nvim -d";
      difftool.prompt = false;
      http.sslCAinfo = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      http.sslverify = true;
      hub.protocol = "${pkgs.openssh}/bin/ssh";
      merge.tool = "nvim -d";
      mergetool.keepBackup = true;
      pull.rebase = true;
      push.default = "current";
      rebase.autosquash = true;
      rerere.enabled = true;
      status.submoduleSummary = true;

      url = {
        "https://gitlab.com/".insteadOf = [ "gl:" "gitlab:" ];
        "https://github.com/".insteadOf = [ "gh:" "github:" ];
      };
    };

    ignores = [
      "**/*.iml"
      "**/*.ipr"
      "**/*.iws"
      "**/.idea/"
      "*~"
      ".AppleDB"
      ".AppleDesktop"
      ".AppleDouble"
      ".DS_Store"
      ".DocumentRevisions-V100"
      ".LSOverride"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      "._*"
      ".apdisk"
      ".com.apple.timemachine.donotpresent"
      ".direnv/"
      ".envrc"
      ".fseventsd"
      ".netrwhist"
      ".vim"
      ".vscode"
      "Network Trash Folder"
      "Session.vim"
      "Sessionx.vim"
      "Temporary Items"
      "[._]*.s[a-v][a-z]"
      "[._]*.sw[a-p]"
      "[._]*.un~"
      "[._]s[a-rt-v][a-z]"
      "[._]ss[a-gi-z]"
      "[._]sw[a-p]"
      "__pycache__"
      "hie.yaml"
    ];
  };
}
