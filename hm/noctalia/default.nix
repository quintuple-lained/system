{ inputs, ... }:
{
  home-manager.users.zoe = {
    imports = [
      inputs.noctalia.homeModdules.default
    ];

    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "catppuccin";
        };
        wallpaper = {
          enabled = true;
          default.path = "/path/to/wallpapers/wallpaper.png";
          
        };
      };
    };
  };
  }
