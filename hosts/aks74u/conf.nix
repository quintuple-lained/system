{ pkgs, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../modules/system/interactive.nix
    ../../modules/nixvim
  ];

  home-manager.users.zoe.imports = [
    ../../hm/aks74u/home.nix
    inputs.noctalia.homeModules.default
    inputs.flatpaks.homeManagerModules.nix-flatpak
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.11";
}
