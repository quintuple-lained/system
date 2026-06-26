{ pkgs, ...}:
{
  imports = [
    ../art
    ../emacs
    ../desktop
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = "25.05";
    username = "zoe";
    homeDirectory = "/home/zoe/";
  };

}
