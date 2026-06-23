{ pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      emacs-pgtk
      fish
      ruff
      nixd
      clojure-lsp
    ];
    file.".emacs.d" = {
      source = ./config;
      recursive = true;
    };
  };
}
