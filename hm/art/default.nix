{ pkgs, ... }:
{
  home.packages = with pkgs; [
    krita
    inkscape
    gimp
    blender
  ];

  services.flatpak.packages = [
    {
      appId = "com.github.flxzt.rnote";
      origin = "flathub";
    }
  ];
}
