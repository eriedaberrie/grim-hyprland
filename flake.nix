{
  description = "Grab images from a Wayland compositor (Hyprland fork)";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    genSystems = lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    pkgsFor = system: import nixpkgs {inherit system;};
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

    packages = genSystems (system:
      (self.overlays.default null (pkgsFor system))
      // {default = self.packages.${system}.grim;});

    formatter = genSystems (system: (pkgsFor system).alejandra);
  };
}
