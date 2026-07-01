{ pkgs, ...}:
{
  imports = [
    ../noctalia
  ];

  home.packages = with pkgs; [
    discord
    weechat
    libreoffice
    thunderbird
    google-chrome
    kdePackages.dolphin
    xwayland-satellite
    drawio
  ];
}
