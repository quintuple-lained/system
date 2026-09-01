{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      emacs-pgtk
      fish
      ruff
      nixd
      clojure-lsp
      nerd-fonts.anonymice
    ];
    file.".emacs.d" = {
      source = ./config;
      recursive = true;
    };
  };
}
