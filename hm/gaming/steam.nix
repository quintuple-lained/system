{ pkgs, ...}:
{
  home.packages = with pkgs; [
    (steam.override {
      extraPkgs = pkgs: with pkgs;[
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
