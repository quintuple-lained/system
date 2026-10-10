{ pkgs, ... }:
{
  home.packages = with pkgs; [
    imhex
    (writeShellScriptBin "envrc" ''
      echo \"use flake\" > .envrc
      echo \".direnv\" >> .gitignore
      direnv allow
    '')
    delta
  ];
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
