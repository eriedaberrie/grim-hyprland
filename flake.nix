{
  description = "Grab images from a Wayland compositor (Hyprland fork)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  }: let
    inherit (nixpkgs) lib;
    forSystems = f:
      lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
  in {
    overlays = {
      default = _: prev: rec {
        grim = prev.grim.overrideAttrs (old: {
          pname = "grim-hyprland";
          version = self.rev or "dirty";
          src = lib.cleanSource ./.;
          patches = [];
          buildInputs =
            old.buildInputs ++ [prev.wayland-scanner];
        });

        grim-hyprland = grim;
      };
    };

    packages = forSystems (pkgs: {
      inherit (self.overlays.default pkgs pkgs) grim grim-hyprland;
      default = self.packages.${pkgs.stdenv.system}.grim;
    });

    devShells = forSystems (pkgs: {
      default = pkgs.mkShell {
        inputsFrom = [self.packages.${pkgs.stdenv.system}.grim];
        packages = [pkgs.clang-tools];
      };
    });

    formatter = forSystems (pkgs: pkgs.alejandra);
  };
}
