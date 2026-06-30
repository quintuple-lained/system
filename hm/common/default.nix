{ ... }:
{
  imports = [
    ../fish
    ../git
  ];

  programs.home-manager.enable = true;

  home.username = "zoe";
}
