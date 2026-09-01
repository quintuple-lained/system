{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libgdiplus
    gamescope
    protontricks
    wineWow64Packages.full
    (steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          gtk3
          zlib
          dbus
          vulkan-tools
          freetype
          glib
          atk
          cairo
          gdk-pixbuf
          pango
          python3
          fontconfig
          libxcb
          libpng
        ];
    })
    steam-run
  ];
}
