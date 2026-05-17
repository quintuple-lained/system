{
  description = "Phlake - The Phoenix from the flake ashes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware = {
      url = "github:nixos/nixos-hardware";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      catppuccin,
      emacs-overlay,
      nix-index-database,
      microvm,
      hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      machines = [
        "dshkm"
        #  "p90"
        #  "aks74u"
        #  "mp5"
        #  "m249"
      ];

      pkgs = import nixpkgs {
        inherit system overlays;

        config = {
          allowUnfree = true;
        };
      };

      overlays = [
        emacs-overlay.overlay
      ];
    in
    with nixpkgs.lib;
    {
      nixosConfigurations = genAttrs machines (
        machine:
        nixosSystem {
          inherit pkgs system;
          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./modules/system/generic.nix 
            ./hosts/${machine}/conf.nix 
            ./hosts/${machine}/hw-conf.nix
          ];
        }
      );
    };
}
