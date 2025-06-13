{
   description = "NixOS + Homemanager";

   inputs = {
      nixpkgs = {
         url = "github:NixOS/nixpkgs/nixos-25.05";
      };
      home-manager = {
         url = "github:nix-community/home-manager/release-25.05";
         inputs.nixpkgs.follows = "nixpkgs";
      };
      stylix = {
        url = "github:danth/stylix/release-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
   };

   outputs = { self, nixpkgs, home-manager, stylix, ...}:
     let
        systemSettings = {
           system = "x86_64-linux";
           hostname = "castitas";
           timezone = "Europe/Copenhagen";
           defaultLocale = "en_GB.utf-8";
           secondaryLocale = "da_DK.utf-8";
        };
        userSettings = {
           username = "frisch";
           theme = "pinkish"; # options: gruvbox, solarized, pinkish (see /themes)
           wm = "sway"; # options: sway
           browser = "chromium"; # options: chromium
           terminal = "alacritty";
           editor = "vim";
           font = "JetBrainsMono Nerd Font";
           fontPkg = pkgs.nerd-fonts.jetbrains-mono;
        };

        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.${systemSettings.system};
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
