{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (prismlauncher.override {
      jdks = [
        jdk8
        temurin-bin-8
        temurin-bin-11
        temurin-bin-17
        temurin-bin-21
        temurin-bin-25
        temurin-bin-26
      ];
    })
  ];
}
