{ pkgs, ...}:
{
  imports = [
    ../art
    ../emacs 
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";

  home.username = "zoe";

}
