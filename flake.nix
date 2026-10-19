{
   description = "NixOS + Homemanager";

   inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager = {
         url = "github:nix-community/home-manager/release-26.05";
         inputs.nixpkgs.follows = "nixpkgs";
      };
      stylix = {
        url = "github:danth/stylix/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
   };

   outputs = { nixpkgs, nixpkgs-unstable, home-manager, stylix, disko, nixos-hardware, ... }:
     let
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };

        # Shared user settings — override per host if needed
        userSettings = {
           username = "frisch";
           name = "Andreas Frisch";
           email = "andreas.frisch@gmail.com";
           theme = "gruvbox";
           wm = "sway";
           browser = "firefox";
           terminal = "alacritty";
           editor = "vim";
           font = "JetBrainsMono Nerd Font";
           iconTheme = "Papirus";
           templateRepository = "andreasfrisch/nix-environments";
           fontPkg = pkgs.nerd-fonts.jetbrains-mono;
        };

        mkHost = { hostname, system, extraModules ? [] }:
          let
            systemSettings = {
              inherit hostname system;
              timezone = "Europe/Copenhagen";
              defaultLocale = "en_GB.UTF-8";
              secondaryLocale = "da_DK.UTF-8";
            };
          in lib.nixosSystem {
            inherit system;
            modules = [
              ./hosts/${hostname}/system.nix
              disko.nixosModules.disko
            ] ++ extraModules;
            specialArgs = {
              inherit systemSettings userSettings;
            };
          };

        mkHome = { hostname, system, username ? userSettings.username }:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          in home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./hosts/${hostname}/home.nix ];
            extraSpecialArgs = {
              inherit userSettings stylix;
              pkgsUnstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
              systemSettings = { inherit system hostname; };
            };
          };

     in {
        nixosConfigurations = {
          castitas = mkHost {
            hostname = "castitas";
            system = "x86_64-linux";
            extraModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen ];
          };
        };

        homeConfigurations = {
          "${userSettings.username}@castitas" = mkHome {
            hostname = "castitas";
            system = "x86_64-linux";
          };
        };
     };
}
