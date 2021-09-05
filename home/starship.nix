{ config, pkgs, lib, ... }: {
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      "nix_shell" = {
        format = "[$symbol$state($name)]($style) ";
        symbol = "❄️ ";
        impure_msg = "";
      };
    };
  };
}
