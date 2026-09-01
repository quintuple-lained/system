{ pkgs, ... }:
{
  imports = [
    ../fish
  ];

  programs.home-manager.enable = true;

  home.username = "zoe";

  home.packages = with pkgs; [
    p7zip
    unzip
    zip
    efibootmgr
    tldr
    exfatprogs
    whois
    caligula
    wakeonlan
    firefox
  ];
}
