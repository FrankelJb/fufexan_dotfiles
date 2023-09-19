{
  inputs,
  sharedModules,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
  in {
    helium = nixosSystem {
      modules =
        [
          ./helium
          ../modules/bluetooth.nix
          # ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          {home-manager.users.beans.imports = homeImports."beans@helium";}
        ]
        ++ sharedModules;
    };
  };
}
