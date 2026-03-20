{
   description = "NixOS + Homemanager";

   inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
      home-manager = {
         url = "github:nix-community/home-manager/release-25.11";
         inputs.nixpkgs.follows = "nixpkgs";
      };
      stylix = {
        url = "github:danth/stylix/release-25.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nix-vscode-extensions = {
        url = "github:nix-community/nix-vscode-extensions";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      sops-nix.url = "github:Mic92/sops-nix";
   };

   outputs = { nixpkgs, home-manager, stylix, nix-vscode-extensions, disko, nixos-hardware, sops-nix, ... }:
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
              ./hosts/${hostname}/default.nix
              disko.nixosModules.disko
              sops-nix.nixosModules.sops
              {
                nixpkgs.config.allowUnfree = true;
                nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
              }
            ] ++ extraModules;
            specialArgs = {
              inherit systemSettings userSettings;
            };
          };

        mkHome = { system, username ? userSettings.username }:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [ nix-vscode-extensions.overlays.default ];
            };
          in home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home.nix ];
            extraSpecialArgs = {
              inherit userSettings stylix;
              systemSettings = { inherit system; };
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
          ${userSettings.username} = mkHome {
            system = "x86_64-linux";
          };
        };
     };
}
