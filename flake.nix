{
  description = "Grab images from a Wayland compositor (Hyprland fork)";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    forSystems = f:
      lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: f nixpkgs.legacyPackages.${system});
  in {
    overlays = {
      default = _: prev: rec {
        grim = prev.grim.overrideAttrs (old: {
          pname = "grim-hyprland";
          version = self.rev or "dirty";
          src = prev.lib.cleanSource ./.;
          patches = [];
        });

        grim-hyprland = grim;
      };
    };

    packages = forSystems (pkgs: {
      inherit (pkgs.extend self.overlays.default) grim grim-hyprland;
      default = self.packages.${pkgs.system}.grim;
    });

    formatter = forSystems (pkgs: pkgs.alejandra);
  };
}
