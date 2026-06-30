{ pkgs, ...}:
{
  imports = [
    ../art
    ../emacs
    ../desktop
    ../fish
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = "25.05";
    username = "zoe";
  };

}
