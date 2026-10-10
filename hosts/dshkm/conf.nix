{ pkgs, inputs, ... }:
{
  imports = [ 
    ../../modules/system/interactive.nix
    ../../modules/nixvim
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager.users.zoe.imports = [
    ../../hm/dshkm/home.nix
    inputs.noctalia.homeModules.default
    inputs.flatpaks.homeManagerModules.nix-flatpak
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "dshkm";

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services={
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    printing.enable = true;
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      settings.gui = {
        user = "user";
        password = "password";
      };
    };
  };
	hardware={
    nitrokey.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.Policy.Autoenable = true;
    };
    steam-hardware.enable = true;
  };
  users.users.zoe.extraGroups = ["dialout" "audio"];
  programs = {
    localsend = {
      enable = true;
      openFirewall = true;
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    gamemode.enable = true;
  };

  system.stateVersion = "25.11";
}
