{ inputs, config, ... }:
{
  
  imports = [
    inputs.noctalia.homeModules.default
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
        default.path = "${config.home.homeDirectory}/wallpapers/wallpaper.png";
      };
    };
  };
  home.file."wallpapers/wallpaper.png".source = ../../assets/wallpaper.png;
}
