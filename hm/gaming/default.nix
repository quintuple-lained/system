{ pkgs, ...}:
{
  imports = [
    ./steam.nix
    ./minceraft.nix
  ];

  home.packages = with pkgs; [
    libgdiplus
    moonlight-qt
    protontricks
    wineWow64Packages.full
    pcsx2
  ];
}
