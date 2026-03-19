{
   description = "NixOS + Homemanager";

   inputs = {
      nixpkgs = {
         url = "github:NixOS/nixpkgs/nixos-25.11";
      };
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
   };

   outputs = { nixpkgs, home-manager, stylix, nix-vscode-extensions, ...}:
     let
        systemSettings = {
           system = "x86_64-linux";
           hostname = "castitas";
           timezone = "Europe/Copenhagen";
           defaultLocale = "en_GB.UTF-8";
           secondaryLocale = "da_DK.UTF-8";
        };
        userSettings = {
           username = "frisch";
           name = "Andreas Frisch";
           email = "andreas.frisch@gmail.com";
           theme = "pinkish"; # options: gruvbox, solarized, pinkish (see /themes)
           wm = "sway"; # options: sway
           browser = "firefox"; # options: chromium, firefox
           terminal = "alacritty";
           editor = "vim";
           font = "JetBrainsMono Nerd Font";
           fontPkg = pkgs.nerd-fonts.jetbrains-mono;
           iconTheme = "Papirus";
           templateRepository = "andreasfrisch/nix-environments";
        };

        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
          system = systemSettings.system;
          config = {
            allowUnfree = true;
          };
          overlays = [ nix-vscode-extensions.overlays.default ];
        };
     in {
     nixosConfigurations = {
        castitas = lib.nixosSystem {
           system = systemSettings.system;
           modules = [
             ./configuration.nix
           ];
           specialArgs = {
              inherit systemSettings;
              inherit userSettings;
           };
        };
     };
    homeConfigurations = {
       frisch = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
          ];
          extraSpecialArgs = {
             inherit systemSettings;
             inherit userSettings;
             inherit stylix;
          };
       };
    };
  };
}
