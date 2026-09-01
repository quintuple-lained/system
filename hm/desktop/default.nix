{ pkgs, ... }:
{
  imports = [
    ../noctalia
  ];

  home.packages = with pkgs; [
    hyfetch
    fastfetch
    discord
    weechat
    libreoffice
    thunderbird
    google-chrome
    kdePackages.dolphin
    xwayland-satellite
    drawio
    nix-index
    comma
    wireguard-tools
  ];
}
